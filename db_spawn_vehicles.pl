#!/usr/bin/perl -w

use warnings;

use POSIX;
use DBI;
use DBD::mysql;
use Getopt::Long;

print "INFO: Started vehicle insertion.\n";

my %args = ();

GetOptions(
	\%args,
	'instance|index|i=s',
	'hostname|host|dbhost|h=s',
	'username|user|dbuser|u=s',
	'password|pass|dbpass|p=s',
	'database|name|dbname|d=s',
	'port|dbport=s',
	'world|map|w|m=s',
	'limit|l=s',
	'cleanup',
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
	'world' => $args{'world'} ? $args{'world'} : 'chernarus'
);

if ($args{'help'}) {
	print "usage: db_spawn_vehicles.pl [--instance <id>] [--world <chernarus|lingor>] [--limit <limit>] [--host <hostname>] [--user <username>] [--pass <password>] [--name <dbname>] [--port <port>]\n";
	exit;
}

print "INFO: Connecting to $db{'host'}:$db{'name'} as user $db{'user'}\n";
print "INFO: Instance name dayz_$db{'instance'}.$db{'world'} \n";

# Connect to MySQL
my $dbh = DBI->connect(
	"dbi:mysql:$db{'name'}:$db{'host'}:$db{'port'}",
	$db{'user'},
	$db{'pass'}
) or die "FATAL: Could not connect to MySQL -  " . DBI->errstr . "\n";

print "INFO: Cleaning up damaged vehicles\n";
# Clean up damaged vehicles and old objects
my $sth = $dbh->prepare(<<EndSQL
DELETE FROM
  objects
WHERE
  damage >= 0.95
  OR (otype = 'Wire_cat1' and lastupdate < now() - interval 3 day)
  OR (otype = 'Hedgehog_DZ' and lastupdate < now() - interval 4 day)
  OR (otype = 'TrapBear' and lastupdate < now() - interval 5 day)
  OR (otype = 'Sandbag1_DZ' and lastupdate < now() - interval 8 day)
EndSQL
) or die "FATAL: SQL Error - " . DBI->errstr . "\n";
$sth->execute() or die "FATAL: Could not clean up damaged/old objects - " . $sth->errstr . "\n";

$sth = $dbh->prepare(<<EndSQL
DELETE FROM
  objects USING objects
  INNER JOIN survivor on objects.oid = survivor.id and survivor.is_dead = 1
WHERE
  objects.otype = 'TentStorage'
  AND objects.lastupdate < now() - interval 4 day
EndSQL
) or die "FATAL: SQL Error - " . DBI->errstr . "\n";
$sth->execute() or die "FATAL: Could not clean up damaged/old objects - " . $sth->errstr . "\n";

#Remove out-of-bounds vehicles
if ($args{'cleanup'}) {
	print "INFO: Starting boundary check for objects\n";
	$sth = $dbh->prepare("select id,pos from objects");
	$sth->execute() or die "Couldn't get list of object positions\n";
	while (my $row = $sth->fetchrow_hashref()) {
		$row->{pos} =~ s/[\[\]\s]//g;
		$row->{pos} =~ s/\|/,/g;
		my @pos = split(',', $row->{pos});
		my $valid = 1;
		if ($db{'world'} eq 'chernarus') {
			if ($pos[1] < 0 || $pos[2] < 0 || $pos[1] > 14700 || $pos[2] > 15360) {
				$valid = 0;
			}
		} elsif ($db{'world'} eq 'lingor') {
			if ($pos[1] < 0 || $pos[2] < 0 || $pos[1] > 10000 || $pos[2] > 10000) {
				$valid = 0;
			}
		} else {
			print "Cannot check valid bounds for the world $db{'world'}\n";
		}

		if ($valid == 0) {
			$delSth = $dbh->prepare("delete from objects where id = $row->{id}");
			$delSth->execute() or die "Failed while deleting an out-of-bounds object";
			print "Vehicle at $pos[1], $pos[2] was OUT OF BOUNDS and was deleted\n";
		}
	}
}

# Determine if we are over the vehicle limit
$sth = $dbh->prepare(<<EndSQL
SELECT COUNT(*) AS count
FROM objects
WHERE
  instance = ?
  AND otype NOT IN ('TentStorage', 'Wire_cat1', 'Hedgehog_DZ', 'Sandbag1_DZ', 'Hedgehog_DZ', 'TrapBear')
EndSQL
) or die "FATAL: SQL Error - " . DBI->errstr . "\n";
$sth->execute($db{'instance'}) or die "FATAL: Could not count vehicles - " . $sth->errstr . "\n";
my $row = $sth->fetchrow_hashref;
my $vehicleCount = $row->{count};
if ($vehicleCount > $db{'limit'}) {
	die "FATAL: Count of $vehicleCount is greater than limit of $db{'limit'}\n";
}

print "INFO: Fetching spawn information\n";
my $spawns = $dbh->prepare(<<EndSQL
SELECT
  uuid,
  spawns.pos,
  spawns.otype,
  chance
FROM
  spawns
  LEFT JOIN objects on spawns.uuid = objects.uid and objects.instance = ?
WHERE
  world = ?
  AND objects.uid IS NULL
EndSQL
) or die "FATAL: SQL Error - " . DBI->errstr . "\n";
$spawns->execute($db{'instance'}, $db{'world'});

my $insert = $dbh->prepare(<<EndSQL
INSERT INTO
  objects (uid, pos, health, damage, otype, instance)
VALUES (?, ?, ?, ?, ?, ?)
EndSQL
) or die "FATAL: SQL Error - " . DBI->errstr . "\n";

my $spawnCount = 0;
# Loop through each spawn
while (my $vehicle = $spawns->fetchrow_hashref) {
	# If over the global limit, end prematurely
	if (($vehicleCount + $spawnCount) > $db{'limit'}) {
		last;
	}

	# Determine count for this vehicle type
	$sth = $dbh->prepare("SELECT COUNT(*) FROM objects WHERE otype LIKE ?") or die "FATAL - SQL Error " . DBI->errstr . "\n";
	$sth->execute($vehicle->{otype});
	my $count = $sth->fetchrow_hashref;

	# Skip this spawn if the spawn chance was not met
	if (int(rand(100)) > ($vehicle->{chance} * 100)) {
		next;
	}

	# Generate random damage value
	my $damage = rand(0.75);
	if ($damage <= 0.05) {
		$damage = 0;
	}

	# Generate random parts damage
	my $health = '';
	if($vehicle eq "Old_bike%") {
	} elsif($vehicle eq "TT650%"||$vehicle eq "%boat%"||$vehicle eq "PBX") {
		@parts = ('["motor",1]');
	} elsif($vehicle eq "UH1H%") {
		@parts = ('["motor",1]','["elektronika",1]','["mala vrtule",1]','["velka vrtule",1]');
	} else {
		@parts = ('["palivo",1]','["motor",1]','["karoserie",1]','["wheel_1_1_steering",1]','["wheel_1_2_steering",1]','["wheel_2_1_steering",1]','["wheel_2_2_steering",1]');
	}
	
	if (scalar(@parts) > 0) {
		$health = genDamage(@parts);
	}

	# Execute insert
	$spawnCount++;
	$insert->execute($vehicle->{uuid}, $vehicle->{pos}, $health, $damage, $vehicle->{otype}, $db{'instance'});
	print "Called insert with ($vehicle->{uuid}, $vehicle->{pos}, $health, $damage, $vehicle->{otype}, $db{'instance'})\n";
}

$sth->finish();
$dbh->disconnect();

print "INFO: Spawned $spawnCount vehicles!\n";

sub genDamage
{
	my $h="";
	my $damParts=0;
	my $damCount=0;
	my $random = rand();
	my $chance = 0.99;
	my $chanceFactor = 1.15;
	my @parts = @_;
	my @restricted;
	while($chance>$random && $damParts<scalar @parts)
	{
		$chance /= $chanceFactor;
		$chanceFactor += 0.15;
		$damParts++;
	}
	$damCount=0;
	while($damParts>$damCount)
	{
		$random = floor(rand(scalar @parts));
		my %restr = map {$_ => 1} @restricted;
		if(!exists($restr{$random}))
		{
			push (@restricted,$random);
			if($h eq ""){$h = $parts[$random];}
			else{$h .= ",".$parts[$random];}
			$damCount++;
		}
	}
	return "[${h}]";
}
