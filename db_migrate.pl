#!/usr/bin/perl -w

use Getopt::Long;
use DBIx::Migration::Directories;
use DBIx::Transaction;
use DBI;

our %args;
GetOptions(
	\%args,
	'hostname|host|h=s',
	'username|user|u=s',
	'password|pass|p=s',
	'database|name|dbname|d=s',
	'port=s',
	'version|v=s',
	'help'
);

my %db = (
	'host' => $args{'hostname'} ? $args{'hostname'} : 'localhost',
	'user' => $args{'username'} ? $args{'username'} : 'dayz',
	'pass' => $args{'password'} ? $args{'password'} : 'dayz',
	'name' => $args{'database'} ? $args{'database'} : 'dayz',
	'port' => $args{'port'} ? $args{'port'} : '3306'
);

if ($args{'help'}) {
	print "usage: db_migrate.pl [--host <hostname>] [--user <username>] [--pass <password>] [--name <dbname>] [--port <port>] [--version <version>]\n";
	exit;
}

my $version = $args{'version'} ? $args{'version'} : "0.18";

print "INFO: Trying to connect to $db{'host'}, database $db{'name'} as $db{'user'}\n";

my $dbh = DBIx::Transaction->connect(
	"dbi:mysql:$db{'name'}:$db{'host'}:$db{'port'}",
	$db{'user'},
	$db{'pass'}
) or die "FATAL: Could not connect to MySQL - " . DBI->errstr . "\n";

my $m = DBIx::Migration::Directories->new(
	base                    => 'schema',
	schema                  => 'Bliss',
	desired_version   	=> $version,
	dbh                     => $dbh
);

if ($m->get_current_version()) {
	printf("INFO: Current schema version is %.2f\n", $m->get_current_version());
} else {
	print "INFO: Did not find an existing schema\n";
}

$m->migrate or die "FATAL: Database migration failed!\n";

print "INFO: Completed the migration to version $version\n";

