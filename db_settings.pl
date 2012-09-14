#!/usr/bin/perl -w

use strict;
use warnings;

use Getopt::Long;
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
	print "usage: db_settings.pl [--instance <id>] [--host <hostname>] [--user <username>] [--pass <password>] [--name <database-name>] [--port <port>] [command]\n";
	print "  command is one of:\n";
	print "    cleandead <days>    - delete dead survivors who were last updated more than <days> days ago\n";
	print "    tzoffset <offset> - set server time to system time minus <offset> hours\n";
	print "    loadout <value>   - set loadout to <value> (default is [])\n";
	print "    whitelist [on|off|add|rem] [<profile_id>] - turns the whitelist protection on/off, or adds/removes a profile ID from the whitelist\n";
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

my $command = shift(@ARGV);
defined $command or die "FATAL: No command supplied\n";
if ($command eq 'cleandead') {
	my $days = shift(@ARGV);
	defined $days or die "FATAL: Invalid arguments\n";
	my $sth = $dbh->prepare("delete from survivor where is_dead = 1 and last_update < now() - interval ? day");
	$sth->execute($days);
	print "INFO: Removed " . $sth->rows . " rows from the survivor table\n";
	$sth->finish();
} elsif ($command eq 'tzoffset') {
	my $offset = shift(@ARGV);
	defined $offset or die "FATAL: Invalid arguments\n";
	$dbh->do("update instances set offset = ? where instance = ?", undef, ($offset, $db{'instance'}));
	my ($date, $time) = $dbh->selectrow_array("call proc_getInstanceTime(?)", undef, $db{'instance'});
	print "INFO: Set timezone offset to ${offset} for instance $db{'instance'}, game time will be $date $time after a restart\n";
} elsif ($command eq 'loadout') {
	my $loadout = shift(@ARGV);
	die "FATAL: Invalid loadout\n" unless ($loadout =~ /\[(\[.+?\],{0,1})+\]/);
	$dbh->do("update instances set loadout = ? where instance = ?", undef, ($loadout, $db{'instance'}));
	print "INFO: Set loadout to \"${loadout}\" for instance $db{'instance'}\n";
} elsif ($command eq 'whitelist') {
	my $switch = shift(@ARGV);
	defined $switch or die "FATAL: Invalid arguments\n";
	my $unique_id = shift(@ARGV);
	
	my $sql = '';
	my @params = ();
	if ($switch eq 'on' || $switch eq 'off') {
		$sql = "update instances set whitelist = " . (($switch eq 'on') ? 1 : 0) . " where instance = ?";
		@params = ($db{'instance'});
		print "INFO: Set whitelist ${switch} for instance $db{'instance'}\n";
	} elsif ($switch eq 'add') {
		defined $unique_id or die "FATAL: Invalid arguments\n";
		my $count = $dbh->selectrow_array("select count(*) from profile where unique_id = ?", undef, $unique_id);
		if ($count == 0) {
			$sql = "insert ignore into profile (unique_id, is_whitelisted) values (?, 1)";
			print "INFO: Inserting profile ID ${unique_id} and whitelisting it\n";
		} else {
			$sql = "update profile set is_whitelisted = 1 where unique_id = ?";
			print "INFO: Added profile ID ${unique_id} to whitelist\n";
		}
		@params = ($unique_id);
	} elsif ($switch eq 'rem') {
		defined $unique_id or die "FATAL: Invalid arguments\n";
		$sql = "update profile set is_whitelisted = 0 where unique_id = ?";
		@params = ($unique_id);
		print "INFO: Removed profile ID ${unique_id} from whitelist\n";
	} else {
		die "FATAL: Invalid arguments\n";
	}

	$dbh->do($sql, undef, @params);
} else {
	die "FATAL: Unrecognized command.\n";
}

$dbh->commit();
$dbh->disconnect();
