#!/usr/bin/perl -w
# Bliss database manipulation utility
# by ayan4m1

use strict;
use warnings;

use List::Util qw(min);
use Getopt::Long qw(:config pass_through);
use DBIx::Transaction;
use DBI;

our %args;
GetOptions(
	\%args,
	'hostname|host|h=s',
	'username|user|u=s',
	'password|pass|p=s',
	'database|name|dbname|d=s',
	'instance|index|i=s',
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
	print "  itemdistr             - look at all live player inventories and show counts of each item in descending order\n";
	print "  cleanitem <classname> - remove comma-separated list of classnames from all survivor inventories\n";
	print "  cleandead <days>      - delete dead survivors who were last updated more than <days> days ago\n";
	print "  loadout <inventory> <backpack> - set default loadout to <inventory> and <backpack> (default is [], [\"DZ_Patrol_Pack_EP1\",[[],[]],[[],[]]])\n";
	print "  messages <subcommand> - manage the optional messaging system\n";
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

my $cmd = shift(@ARGV);
defined $cmd or die "FATAL: No command supplied, try --help for usage information\n";
if ($cmd eq 'messages') {
	my $sth = $dbh->prepare("select count(*) from message") or die "FATAL: Could not prepare SQL statement";
	my $valid = $sth->execute();
	$sth->finish();
	die "FATAL: No message table found. Ensure you have run db_migrate.pl --schema BlissMessaging --version 0.01\n" unless defined $valid;

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
			$row->{'state'} =~ s/\["$classname","amovpknlmstpsraswrfldnon",42\]/["","aidlpercmstpsnonwnondnon_player_idlesteady04",36]/;
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
} elsif ($cmd eq 'loadout') {
	my $inventory = shift(@ARGV);
	die "FATAL: Invalid inventory\n" unless ($inventory =~ /\[(\[.+?\],{0,1})+\]/);
	my $backpack = shift(@ARGV);
	$backpack = '["DZ_Patrol_Pack_EP1",[[],[]],[[],[]]]' if (!defined $backpack);
	die "FATAL: Invalid backpack\n" unless ($backpack =~ /\[(\[.+?\],{0,1})+\]/);
	$dbh->do("update instance set inventory = ?, backpack = ? where id = ?", undef, ($inventory, $backpack, $db{'instance'}));
	print "INFO: Set inventory to $inventory, backpack $backpack for instance $db{'instance'}\n";
} else {
	die "FATAL: Unrecognized command.\n";
}

$dbh->commit();
$dbh->disconnect();
