#!/usr/bin/perl -w
# Reality vehicle spawn script
# forked from Bliss by ayan4m1, updated by Thevisad

use warnings;

use POSIX;
use DBI;
use DBD::mysql;
use Getopt::Long;
use List::Util qw(min max);

my %args = ();
GetOptions(
	\%args,
	'instance|index|i=s',
	'hostname|host|dbhost|h=s',
	'username|user|dbuser|u=s',
	'password|pass|dbpass|p=s',
	'database|name|dbname|d=s',
	'port|dbport=s',
	'limit|l=s',
	'cleanup=s',
	'cleanonly',
	'help'
);

my %db = (
	'host' => $args{'hostname'} ? $args{'hostname'} : 'localhost',
	'instance' => $args{'instance'} ? $args{'instance'} : '1',
	'limit' => $args{'limit'} ? $args{'limit'} : '500',
	'user' => $args{'username'} ? $args{'username'} : 'dayz',
	'pass' => $args{'password'} ? $args{'password'} : 'dayz',
	'name' => $args{'database'} ? $args{'database'} : 'dayz',
	'port' => $args{'port'} ? $args{'port'} : '3306',
);

if ($args{'help'}) {
	print "usage: db_spawn_vehicles.pl [--instance <id>] [--limit <limit>] [--host <hostname>] [--user <username>] [--pass <password>] [--name <dbname>] [--port <port>] [--cleanup tents|bounds|all] [--cleanonly]\n";
	exit;
}

print "INFO: Connecting to $db{'host'}:$db{'name'} as user $db{'user'}\n";

# Connect to MySQL
my $dbh = DBI->connect(
	"dbi:mysql:$db{'name'}:$db{'host'}:$db{'port'}",
	$db{'user'},
	$db{'pass'}
) or die "FATAL: Could not connect to MySQL -  " . DBI->errstr . "\n";

my ($world_id, $world_name) = $dbh->selectrow_array("select w.id, w.name from instance i join world w on i.world_id = w.id where i.id = ?", undef, ($db{'instance'}));
die "FATAL: Invalid instance ID\n" unless (defined $world_id && defined $world_name);

print "INFO: Instance name dayz_$db{'instance'}.$world_name\n";

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
}

if ($cleanup eq 'tents' || $cleanup eq 'all') {
	print "INFO: Cleaning up tents with dead owners older than four days\n";
	$sth = $dbh->prepare(<<EndSQL
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
}

if ($cleanup eq 'bounds' || $cleanup eq 'all') {
	print "INFO: Starting boundary check for objects\n";
	$sth = $dbh->prepare(<<EndSQL
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
}

$sth->finish();
if($args{'cleanonly'}) { goto END; }

# Determine if we are over the vehicle limit
my $vehicleCount = $dbh->selectrow_array("select count(*) from instance_vehicle where instance_id = ?", undef, $db{'instance'});
die "FATAL: Count of $vehicleCount is greater than limit of $db{'limit'}\n" if ($vehicleCount > $db{'limit'});

print "INFO: Fetching spawn information\n";
my $spawns = $dbh->prepare(<<EndSQL
select
  wv.id world_vehicle_id,
  v.id vehicle_id,
  v.class_name class_name,
  wv.worldspace,
  v.inventory,
  coalesce(v.parts, '') parts,
  v.limit_max,
  round(least(greatest(rand(), v.damage_min), v.damage_max), 3) damage,
  round(least(greatest(rand(), v.fuel_min), v.fuel_max), 3) fuel
from
  world_vehicle wv 
  join vehicle v on wv.vehicle_id = v.id
  left join instance_vehicle iv on iv.world_vehicle_id = wv.id and iv.instance_id = ?
  left join (
    select
      count(iv.id) as count,
      wv.vehicle_id
    from
      instance_vehicle iv
      join world_vehicle wv on iv.world_vehicle_id = wv.id
    where instance_id = ?
    group by wv.vehicle_id
  ) vc on vc.vehicle_id = v.id
where
  wv.world_id = ?
  and iv.id is null
  and (round(rand(), 3) < wv.chance)
  and (vc.count is null or vc.count between v.limit_min and v.limit_max)
EndSQL
) or die "FATAL: SQL Error - " . DBI->errstr . "\n";
$spawns->execute($db{'instance'}, $db{'instance'}, $world_id);

my $insert = $dbh->prepare(<<EndSQL
insert into
  instance_vehicle (world_vehicle_id, worldspace, inventory, parts, damage, fuel, instance_id, created)
values (?, ?, ?, ?, ?, ?, ?, current_timestamp())
EndSQL
) or die "FATAL: SQL Error - " . DBI->errstr . "\n";

print "INFO: Fetched " . $spawns->rows . " vehicle spawns\n";

my $spawnCount = 0;
# Loop through each spawn
while (my $vehicle = $spawns->fetchrow_hashref) {
	# If over the global limit, end prematurely
	if (($vehicleCount + $spawnCount) > $db{'limit'}) {
		print "INFO: Exiting because global limit has been reached\n";
		last;
	}

	# If over the per-type limit, skip this spawn
	my $count = $dbh->selectrow_array("select count(iv.id) from instance_vehicle iv join world_vehicle wv on iv.world_vehicle_id = wv.id where iv.instance_id = ? and wv.vehicle_id = ?", undef, ($db{'instance'}, $vehicle->{vehicle_id}));
	if($count >= $vehicle->{limit_max}) {
		printf "INFO:   vehicle %s is at count %d which is at limit_max of %d\n", $vehicle->{class_name}, $count, $vehicle->{limit_max};
		next;
	}

	# Generate parts damage
	my $health = "[" . join(',', map { (sprintf(rand(), "%.3f") > 0.85) ? "[\"$_\",1]" : () } split(/,/, $vehicle->{parts})) . "]";

	# Execute insert
	$spawnCount++;
	$insert->execute($vehicle->{world_vehicle_id}, $vehicle->{worldspace}, $vehicle->{inventory}, $health, $vehicle->{damage}, $vehicle->{fuel}, $db{'instance'});
	print "INFO: Called insert for $vehicle->{class_name} with ($vehicle->{world_vehicle_id}, $vehicle->{worldspace}, $vehicle->{inventory}, $health, $vehicle->{damage}, $vehicle->{fuel}, $db{'instance'})\n";
}

print "INFO: Spawned $spawnCount vehicles\n";

$spawns->finish();
$insert->finish();
END:
$dbh->disconnect();
