#!/usr/bin/perl -w
# Reality database manipulation utility
# forked from Bliss by ayan4m1, updated by Thevisad

use strict;
use warnings;

use List::Util qw(min);
use Getopt::Long qw(:config pass_through);
use DBIx::Transaction;
use DBI;
use POSIX;
use DBD::mysql;

our %args;
GetOptions(
	\%args,
	'hostname|host|h=s',
	'username|user|u=s',
	'password|pass|p=s',
	'database|name|dbname|d=s',
	'instance|index|i=s',
	'cleanup|c=s',
	'port=s',
	'help',
);

my %db = (
	'instance' => $args{'instance'} ? $args{'instance'} : '1',
	'host' => $args{'hostname'} ? $args{'hostname'} : 'localhost',
	'user' => $args{'username'} ? $args{'username'} : 'dayz',
	'pass' => $args{'password'} ? $args{'password'} : 'dayz',
	'name' => $args{'database'} ? $args{'database'} : 'dayz',
	'port' => $args{'port'} ? $args{'port'} : '3306'
);

if ($args{'help'}) {
	print "usage: db_utility.pl <command> [arguments] [--instance <id>] [--host <hostname>] [--user <username>] [--pass <password>] [--name <database-name>] [--port <port>]\n";
	print "command is one of:\n";
	print "  setworld <world_name>          - set the world for an instance\n";
	print "  addinstance <world_name>       - add an instance for a world\n";
	print "  deleteinstance <instance_id>   - delete an instance for a world\n";
	print "  itemdistr                      - look at all live player inventories and show counts of each item in descending order\n";
	print "  cleanup tents|bounds|all       - clean up of \n";
	print "  cleanitem <classname>          - remove comma-separated list of classnames from all survivor inventories\n";
	print "  cleandead <days>               - delete dead survivors who were last updated more than <days> days ago\n";
	print "  cleanvehicle [<vehicle_id>]    - deletes all spawned vehicles (only of <vehicle_id> if specified)\n";
	print "  cleandeploy [<deployable_id>]  - deletes all spawned deployables (only of type <deployable_id> if specified)\n";
	print "  loadout <inventory> <backpack> - set default loadout to <inventory> and <backpack> (default is [], [\"DZ_Patrol_Pack_EP1\",[[],[]],[[],[]]])\n";
	print "  messages <subcommand>          - manage the optional messaging system\n";
	print "    add <instance_id> <start_delay> <loop_interval> <message> - add a message for <instance_id> with body <message> that first prints <start_delay> seconds and then every <loop_interval> seconds thereafter (use 0 for <loop_interval> for a one-time message)\n";
	print "    edit <id> <instance_id> <start_delay> <loop_interval> <message> - set the message with <id> to the specified values\n";
	print "    del <id>\n - delete a message with <id> specified (use 'messages list' to find valid values).\n";
	print "    list [<search_phrase>]\n - lists current message information, optionally filtered by messages containing a phrase\n";
	exit;
}

print "INFO: Connecting to $db{'host'}:$db{'name'} as user $db{'user'}\n";

# Connect to MySQL
my $dbh = DBI->connect(
	"dbi:mysql:$db{'name'}:$db{'host'}:$db{'port'}",
	$db{'user'},
	$db{'pass'}
) or die "FATAL: Could not connect to MySQL -  " . DBI->errstr . "\n";

$dbh->{AutoCommit} = 0;


my $cleanup = ($args{'cleanup'}) ? $args{'cleanup'} : 'none';

if ($cleanup eq 'damaged' || $cleanup eq 'all') {
	print "INFO: Cleaning up damaged vehicles\n";
	my $sth = $dbh->prepare(<<EndSQL
delete from
  instance_vehicle 
where
  instance_id = ?
  and damage = 1
EndSQL
) or die "FATAL: SQL Error - " . DBI->errstr . "\n";
	$sth->execute($db{'instance'}) or die "FATAL: Could not clean up destroyed vehicles - " . $sth->errstr . "\n";

	print "INFO: Cleaning up old deployables\n";
	$sth = $dbh->prepare(<<EndSQL
delete from
  id using instance_deployable id
  inner join deployable d on id.deployable_id = d.id
where
  (d.class_name = 'Wire_cat1' and id.last_updated < now() - interval 3 day)
  or (d.class_name = 'Hedgehog_DZ' and id.last_updated < now() - interval 4 day)
  or (d.class_name = 'TrapBear' and id.last_updated < now() - interval 5 day)
  or (d.class_name = 'Sandbag1_DZ' and id.last_updated < now() - interval 8 day)
EndSQL
) or die "FATAL: SQL Error - " . DBI->errstr . "\n";
	$sth->execute() or die "FATAL: Could not clean up old deployables - " . $sth->errstr . "\n";
	if ($cleanup eq 'damaged') {goto END;}
}

if ($cleanup eq 'tents' || $cleanup eq 'all') {
	print "INFO: Cleaning up tents with dead owners older than four days\n";
	my $sth = $dbh->prepare(<<EndSQL
delete from
  id using instance_deployable id
  inner join deployable d on id.deployable_id = d.id
  inner join survivor s on id.owner_id = s.id and s.is_dead = 1
where
  d.class_name = 'TentStorage'
  and id.last_updated < now() - interval 4 day
EndSQL
) or die "FATAL: SQL Error - " . DBI->errstr . "\n";
	$sth->execute() or die "FATAL: Could not clean up orphaned tents - " . $sth->errstr . "\n";
	if ($cleanup eq 'tents')
	{ goto END;}
}

if ($cleanup eq 'bounds' || $cleanup eq 'all') {
	print "INFO: Starting boundary check for objects\n";
	my $sth = $dbh->prepare(<<EndSQL
select
  id.id dep_id,
  0 veh_id,
  id.worldspace,
  w.max_x,
  w.max_y
from
  instance_deployable id
  inner join instance i on id.instance_id = i.id
  inner join world w on i.world_id = w.id
union
select
  0 dep_id,
  iv.id veh_id,
  iv.worldspace,
  w.max_x,
  w.max_y
from
  instance_vehicle iv
  join instance i on iv.instance_id = i.id
  join world_vehicle wv on iv.world_vehicle_id = wv.id
  join vehicle v on wv.vehicle_id = v.id
  join world w on i.world_id = w.id
EndSQL
);
	$sth->execute() or die "FATAL: Couldn't get list of object positions\n";
	my $depDelSth = $dbh->prepare("delete from instance_deployable where id = ?");
	my $vehDelSth = $dbh->prepare("delete from instance_vehicle where id = ?");
	while (my $row = $sth->fetchrow_hashref()) {
		$row->{worldspace} =~ s/[\[\]\s]//g;
		$row->{worldspace} =~ s/\|/,/g;
		my @pos = split(',', $row->{worldspace});

		# Skip valid positions
		next unless ($pos[1] < 0 || $pos[2] < 0 || $pos[1] > $row->{max_x} || $pos[2] > $row->{max_y});

		if ($row->{veh_id} == 0) {
			$depDelSth->execute($row->{dep_id}) or die "FATAL: Error deleting out-of-bounds deployable\n";
		} else {
			$vehDelSth->execute($row->{veh_id}) or die "FATAL: Error deleting out-of-bounds vehicle\n";
		}
		print "INFO: Object at $pos[1], $pos[2] was OUT OF BOUNDS and was deleted\n";
	}
	$depDelSth->finish();
	$vehDelSth->finish();
	if ($cleanup eq 'bounds' || $cleanup eq 'all')
	{ goto END;}
}

my $cmd = shift(@ARGV);
defined $cmd or die "FATAL: No command supplied, try --help for usage information\n";
if ($cmd eq 'messages') {
	my $sth = $dbh->prepare("select count(*) from message") or die "FATAL: Could not prepare SQL statement";
	my $valid = $sth->execute();
	$sth->finish();
	die "FATAL: No message table found. Ensure you have run db_migrate.pl --schema RealityMessaging --version 0.01\n" unless defined $valid;

	my $subcmd = shift(@ARGV);
	die "FATAL: No subcommand specified, try --help for more info\n" unless defined $subcmd;
	if ($subcmd eq 'add') {
		die "FATAL: Invalid argument count for add\n" unless scalar(@ARGV) == 4;
		$sth = $dbh->prepare('insert into message (instance_id, start_delay, loop_interval, payload) values (?, ?, ?, ?)');
		$sth->execute(@ARGV);
		print "INFO: Inserted message with parameters (" . join(', ', @ARGV) .  ")\n";
	} elsif ($subcmd eq 'edit') {
		die "FATAL: Invalid argument count for edit\n" unless scalar(@ARGV) == 5;
		push(@ARGV, shift(@ARGV));
		$sth = $dbh->prepare('update message set instance_id = ?, start_delay = ?, loop_interval = ?, payload = ? where id = ?');
		$sth->execute(@ARGV);
		print "INFO: Inserted message with parameters (" . join(', ', @ARGV) .  ")\n";
	} elsif ($subcmd eq 'del') {
		my $id = shift(@ARGV);
		die "FATAL: No id specified\n" unless defined $id;
		$dbh->do("delete from message where id = ?", undef, ($id));
		print "INFO: Deleted message with id $id";
	} elsif ($subcmd eq 'list') {
		my $phrase = shift(@ARGV);
		$phrase = '' unless defined $phrase;

		$sth = $dbh->prepare("select * from message where payload like CONCAT(?, '%')");
		$sth->execute($phrase);
		print "Found " . $sth->rows . " message" . (($sth->rows > 1) ? 's' : '') . "\n";
		print "ID    Instance Delay   Interval Payload\n";
		print "-----------------------------------------\n";
		while (my $row = $sth->fetchrow_hashref) {
			printf "%-6d%-9d%-8d%-9d%s\n", $row->{id}, $row->{instance_id}, $row->{start_delay}, $row->{loop_interval}, substr($row->{payload}, 0, min(length($row->{payload}), 50));
		}
	} else {
		die "FATAL: Invalid subcommand specified\n";
	}
} elsif ($cmd eq 'itemdistr') {
	my $sth = $dbh->prepare("select inventory, backpack from survivor where is_dead = 0");
	$sth->execute();
	my %counts = ();
	while (my $row = $sth->fetchrow_hashref()) {
		my $itemStr = $row->{'inventory'} . $row->{'backpack'};
		# Clean up partially filled magazines
		$itemStr =~ s/("[a-zA-Z0-9_]+"),[0-9]+/$1/g;
		# Remove all extraneous characters
		$itemStr =~ s/[\[\]"]//g;
		my @items = split(/,/, $itemStr);
		foreach my $item (@items) {
			# If the item is an empty string, skip it
			next unless $item;
			# Either set or increment the count for this item
			if (defined $counts{$item}) {
				$counts{$item}++;
			} else {
				$counts{$item} = 1;
			}
		}
	}

	print "Listing item counts\n";
	# Sort keys by value (descending) and print results
	foreach my $item (sort { $counts{$b} <=> $counts{$a} } keys %counts) {
		print "$counts{$item} - $item\n";
	}
} elsif ($cmd eq 'cleanitem') {
	my $classes = shift(@ARGV);
	defined $classes or die "FATAL: Invalid arguments\n";
	my @classnames = split(/,/, $classes);
	foreach my $classname (@classnames) {
		die "FATAL: Invalid classname" unless ($classname =~ m/^[a-zA-Z0-9_]+$/);
		# Fetch all player inventories and states
		my $sth = $dbh->prepare("select s.id, s.inventory, s.backpack, s.state, p.name from survivor s join profile p on s.unique_id = p.unique_id");
		my $updSth = $dbh->prepare("update survivor set inventory = ?, backpack = ?, state = ? where id = ?");
		my $rowCnt = 0, my $itemCnt = 0;
		$sth->execute();
		while (my $row = $sth->fetchrow_hashref()) {
			# Remove all instances of the current classname from inventory, backpack, and state
			my $changed = $row->{'inventory'} =~ s/,{0,1}"$classname",{0,1}//gi;
			$changed += $row->{'backpack'} =~ s/,{0,1}"$classname",{0,1}//gi;
			$row->{'state'} =~ s/\["$classname","\w*",\d+\]/["","aidlpercmstpsnonwnondnon_player_idlesteady04",36]/;
			# Iff an item was removed, update the row
			if ($changed > 0) {
				$rowCnt++;
				$itemCnt += $changed;
				$updSth->execute($row->{'inventory'}, $row->{'backpack'}, $row->{'state'}, $row->{'id'});
				print "WARN: Found an invalid item for survivor $row->{'id'} named \"$row->{'name'}\"\n";
			}
		}
		$sth->finish();
		$updSth->finish();
		print "INFO: Removed $itemCnt instances of $classname from $rowCnt players!\n";

		# Fetch all object inventories
		my @tables = ('instance_vehicle', 'instance_deployable');
		$rowCnt = 0, $itemCnt = 0;

		for my $table (@tables) {
			$sth = $dbh->prepare("select id, inventory from $table");
			$updSth = $dbh->prepare("update $table set inventory = ? where id = ?");
			$sth->execute();
			while (my $row = $sth->fetchrow_hashref()) {
				# Remove all instances of the current classname from inventory, backpack, and state
				my $changed = $row->{'inventory'} =~ s/,{0,1}"$classname",{0,1}//gi;
				# Iff an item was removed, update the row
				if ($changed > 0) {
					$rowCnt++;
					$itemCnt += $changed;
					$updSth->execute($row->{'inventory'}, $row->{'id'});
				}
			}
			$sth->finish();
			$updSth->finish();
		}
		print "INFO: Removed $itemCnt instances of $classname from $rowCnt objects!\n";
	}
} elsif ($cmd eq 'cleandead') {
	my $days = shift(@ARGV);
	defined $days or die "FATAL: Invalid arguments\n";
	$dbh->do(<<EndSQL
delete from
  id using instance_deployable id
  inner join survivor s on id.owner_id = s.id
where
  s.is_dead = 1
  and s.last_updated < now() - interval ? day
EndSQL
, undef, ($days));
	my $sth = $dbh->prepare("delete from survivor where is_dead = 1 and last_updated < now() - interval ? day");
	$sth->execute($days);
	print "INFO: Removed " . $sth->rows . " rows from the survivor table\n";
	$sth->finish();
} elsif ($cmd eq 'cleanvehicle') {
	my $vehicle_id = shift(@ARGV);
	my $sth = $dbh->prepare("delete from iv using instance_vehicle iv join world_vehicle wv on iv.world_vehicle_id = wv.id where iv.instance_id = ?" . ((defined $vehicle_id) ? ' and wv.vehicle_id = ?' : ''));
        if (defined $vehicle_id) {
		$sth->execute($db{'instance'}, $vehicle_id);
	} else {
		$sth->execute($db{'instance'});
	}
	print "INFO: Removed " . $sth->rows . " vehicles\n";
} elsif ($cmd eq 'cleandeploy') {
	my $deployable_id = shift(@ARGV);
	my $sth = $dbh->prepare("delete from id using instance_deployable id join deployable d on id.deployable_id = d.id where id.instance_id = ?" . ((defined $deployable_id) ? ' and d.id = ?' : ''));
	if (defined $deployable_id) {
		$sth->execute($db{'instance'}, $deployable_id);
	} else {
		$sth->execute($db{'instance'});
	}
	print "INFO: Removed " . $sth->rows . " deployables\n";
} elsif ($cmd eq 'loadout') {
	my $inventory = shift(@ARGV);
	die "FATAL: Invalid inventory\n" unless ($inventory =~ /\[(\[.+?\],{0,1})+\]/);
	my $backpack = shift(@ARGV);
	$backpack = '["DZ_Patrol_Pack_EP1",[[],[]],[[],[]]]' if (!defined $backpack);
	die "FATAL: Invalid backpack\n" unless ($backpack =~ /\[(\[.+?\],{0,1})+\]/);
	$dbh->do("update instance set inventory = ?, backpack = ? where id = ?", undef, ($inventory, $backpack, $db{'instance'}));
	print "INFO: Set inventory to $inventory, backpack $backpack for instance $db{'instance'}\n";
} elsif ($cmd eq 'setworld') {
	my $world = shift(@ARGV);
	defined $world or die "FATAL: Invalid arguments\n";
	$dbh->do("update instance set world_id = (select id from world where name = ?) where id = ?", undef, ($world, $db{'instance'}));
	print "INFO: Set world to $world for instance $db{'instance'}\n";

} elsif ($cmd eq 'addinstance') {
	my $world = shift(@ARGV);
	defined $world or die "FATAL: Invalid arguments\n";
	my $instance = $args{'instance'} ? $args{'instance'} : undef;
	$dbh->do("INSERT INTO instance (id, world_id, inventory, backpack ) 
	values ( ? , (select id from world where name = ?), \"[[],['ItemPainkiller','ItemBandage']]\", \"['DZ_Patrol_Pack_EP1',[[],[]],[[],[]]]\");" , undef, ($instance , $world));
	$instance = $dbh->last_insert_id(undef, undef, undef, undef);
	print "INFO: Added instance $instance for world $world.\n";

} elsif ($cmd eq 'deleteinstance') {
	my $instance = shift(@ARGV);
	defined $instance or die "FATAL: Invalid arguments\n";
	$dbh->do("delete from instance_vehicle where instance_id = ?", undef, ($instance));
	$dbh->do("delete from instance_building where instance_id = ?", undef, ($instance));
	$dbh->do("delete from instance_deployable where instance_id = ?", undef, ($instance));
	$dbh->do("delete from message where instance_id = ?", undef, ($instance));
	$dbh->do("delete from instance where id = ?", undef, ( $instance));
	print "INFO: Deleted instance $instance and all relevent data.\n";

} else {
	die "FATAL: Unrecognized command.\n";
}

END:
$dbh->commit();
$dbh->disconnect();

