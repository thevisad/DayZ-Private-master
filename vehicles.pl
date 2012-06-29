#!/usr/bin/perl -w
# Author: Guru Abdul
# Script generating vehicles for DayZ Arma mod
use v5.14;
use POSIX;
use DBI;
use DBD::mysql;
print "Vehicle generating script started!\n";
my $dbinstance=0;
my $dbuser = "dayz";
my $db = "dayz";
my $pw;
given (scalar(@ARGV))
{
	when(4) {$dbinstance = $ARGV[0];$db = $ARGV[1];$dbuser= $ARGV[2];$pw = $ARGV[3];}
	when(3) {$dbinstance = $ARGV[0];$dbuser= $ARGV[1];$pw = $ARGV[2];}
	when(2) {$dbinstance = $ARGV[0];$pw = $ARGV[1];}
	default {die "You can provide up to 4 arguments each separated by spaces in the following order:\n
				2 args: instance passToDB\n
				3 args: instance userDB passToDB\n
				4 args: instance database userDB passToDB\n";}
}
my $dsn = "dbi:mysql:$db:localhost:3306";
print "Generating vehicles for instance: ".$dbinstance." , with user: ".$dbuser."\n";
my $dbh = DBI->connect($dsn, $dbuser, $pw) or die "Couldn't connect to db: ".DBI->errstr;
my $sth = $dbh->prepare('DELETE FROM objects WHERE damage>=0.95 OR (lastupdate<DATE_SUB(NOW(),INTERVAL 5 DAY) AND NOT otype="TentStorage");') or die;
$sth->execute() or die "Couldn't execute statement" . $sth->errstr;#Clean dead vehicles
my $numGenerated=0;#counter for the number of generated vehicles
my @vehicles = ("UAZ%","ATV%","Skoda%","TT650%","Old_bike%","UH1H%","hilux%","Ikarus%","Tractor","S1203%","V3S_Gue","UralCivil","car%","%boat%","PBX","Volha%","SUV%");
my @vehicleLimits = (4,3,3,3,10,3,3,3,3,4,1,1,2,4,1,3,1);
my @chances = (0.65,0.75,0.65,0.7,0.95,0.25,0.55,0.55,0.75,0.55,0.55,0.55,0.55,0.75,0.55,0.55,0.45);
my $chanceFactor=1.5;
my $n=0;
my $do=0;
my $first=0;
$sth = $dbh->prepare('SELECT COUNT(*) FROM objects WHERE otype like ? AND instance=?') or die;
my $query = "INSERT INTO objects (uid,pos,health,damage,otype,instance) VALUES ";
for (my $i=0;$i<scalar @vehicles;$i++)
{
	my $vehicle = $vehicles[$i];
	$sth->execute($vehicle,$dbinstance) or die;
	my @data = $sth->fetchrow_array();
	my $vehicleCount = $data[0];
	my $spawnCount = 0;
	my $chance = $chances[$i];
	my $random = rand();
	print "Chance: ".$chance." Random: ".$random."\n";
	my $limit = $vehicleLimits[$i]-$vehicleCount;
	while($chance>$random && $spawnCount<$limit)
	{
		$chance /= $chanceFactor;
		$chanceFactor += 0.13;
		$spawnCount++;
		print "ModChance: ".$chance."\n";
	}
	print "Generating ".$spawnCount." vehicles of type: ".$vehicle."\n";
	print "Fetching random spawn points\n";
	my $sts = $dbh->prepare('SELECT * FROM spawns WHERE otype like ? AND NOT uuid IN (SELECT uid FROM objects) ORDER BY RAND() LIMIT ?') or die;
	$sts->execute($vehicle,$spawnCount) or die;
	while (@data = $sts->fetchrow_array())
	{
		print "Generating vehicle parts damage!\n";
		my $health="";
		my @parts;
		my $damage = rand(0.75);
		my @restricted;
		$damage = $damage<= 0.05 ? 0 : $damage;
		
		if($vehicle eq "Old_bike%"){}
		elsif($vehicle eq "TT650%"||$vehicle eq "%boat%"||$vehicle eq "PBX")
		{
			@parts = ('["motor",1]');
			$health = genDamage(@parts);
		}
		elsif($vehicle eq "UH1H%")
		{
			@parts = ('["motor",1]','["elektronika",1]','["mala vrtule",1]','["velka vrtule",1]]');
			$damage=rand(0.4);
			$health = genDamage(@parts);
		}
		else
		{
			@parts = ('["palivo",1]','["motor",1]','["karoserie",1]','["wheel_1_1_steering",1]','["wheel_1_2_steering",1]','["wheel_2_1_steering",1]','["wheel_2_2_steering",1]');
			$health = genDamage(@parts);
		}
		print "\t".$health."\n";
		#add
		#uid,pos,health,damage,otype,instance
		if($first==0)
		{
			$first=1;
			$query.="($data[3],'$data[1]','[$health]',$damage,'$data[2]',$dbinstance)";
		}
		else
		{
			$query.=",($data[3],'$data[1]','[$health]',$damage,'$data[2]',$dbinstance)";
		}
		$do=1;
		$n++;
	}
	
}
#send
print $query."\n";
$sth = $dbh->prepare($query);
if($do==1)
{
	$sth->execute() or die "Insert query failed";
}
print "ALL IS DONE! Spawed $n randomly damaged vehicles!";
sub genDamage
{
	
	my $h="";
	my $damParts=0;
	my $damCount=0;
	my $random = rand();
	my $chance = 0.95;
	my $chanceFactor = 1.2;
	my @parts = @_;
	my @restricted;
	print "Chance: ".$chance." Random: ".$random."\n";
	while($chance>$random && $damParts<scalar @parts)
	{
		$chance /= $chanceFactor;
		$chanceFactor += 0.15;
		$damParts++;
		print "ModChance: ".$chance."\n";
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
	return $h;
}