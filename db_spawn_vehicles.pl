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
	print "usage: db_spawn_vehicles.pl [--instance <id>] [--limit <limit>] [--host <hostname>] [--user <username>] [--pass <password>] [--name <dbname>] [--port <port>] [--cleanup tents|bounds|all]\n";
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


# Determine if we are over the vehicle limit
my $vehicleCount = $dbh->selectrow_array("select count(*) from instance_vehicle where instance_id = ?", undef, $db{'instance'});
die "FATAL: Count of $vehicleCount is greater than limit of $db{'limit'}\n" if ($vehicleCount > $db{'limit'});

print "INFO: Fetching spawn information\n";
my $spawns = $dbh->prepare(<<EndSQL
select
  wv.id world_vehicle_id,
  v.id vehicle_id,
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
  GROUP BY
wv.worldspace
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
	next unless ($count < $vehicle->{limit_max});

	# Generate parts damage
	my $health = "[" . join(',', map { (sprintf(rand(), "%.3f") > 0.85) ? "[\"$_\",1]" : () } split(/,/, $vehicle->{parts})) . "]";

	# Execute insert
	$spawnCount++;
	$insert->execute($vehicle->{world_vehicle_id}, $vehicle->{worldspace}, $vehicle->{inventory}, $health, $vehicle->{damage}, $vehicle->{fuel}, $db{'instance'});
	print "INFO: Called insert with ($vehicle->{world_vehicle_id}, $vehicle->{worldspace}, $vehicle->{inventory}, $health, $vehicle->{damage}, $vehicle->{fuel}, $db{'instance'})\n";
}

print "INFO: Spawned $spawnCount vehicles\n";

$spawns->finish();
$insert->finish();
$dbh->disconnect();
END:
