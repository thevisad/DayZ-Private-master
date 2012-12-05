#!/usr/bin/perl -w
# Bliss schema migration utility 
# by ayan4m1

use Getopt::Long;
use File::Basename;
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
	'schema|s=s',
	'version|v=s',
	'check',
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
	print "usage: db_migrate.pl [--host <hostname>] [--user <username>] [--pass <password>] [--name <dbname>] [--port <port>] [--schema <schema>] [--version <version>]\n";
	print "\n";
	print "Use --schema to specify an optional schema (the name should be a directory in schema\\) which has custom schema changes to apply instead of the default \"Bliss\" schema.\n";
	print "If you specify --schema, you must specify a --version for that schema as well. The starting schema version is always 0.01 for official optional schemas.\n";
	exit;
}

die "FATAL: Schema version must be specified for non-standard schema!\n" if ($args{'schema'} && !defined $args{'version'});

my $schema  = $args{'schema'} ? $args{'schema'} : "Bliss";
my $version = $args{'version'} ? $args{'version'} : "0.35";

print "INFO: Trying to connect to $db{'host'}, database $db{'name'} as $db{'user'}\n";

my $dbh = DBIx::Transaction->connect(
	"dbi:mysql:$db{'name'}:$db{'host'}:$db{'port'}",
	$db{'user'},
	$db{'pass'}
) or die "FATAL: Could not connect to MySQL - " . DBI->errstr . "\n";

my $m = DBIx::Migration::Directories->new(
	base                    => dirname(__FILE__) . '/schema',
	schema                  => $schema,
	desired_version   	=> $version,
	dbh                     => $dbh
);

my $cur_version = $m->get_current_version();
if ($cur_version) {
	printf("INFO: Current $schema version is %.2f\n", $cur_version);
} else {
	print "INFO: Did not find an existing schema for $schema\n";
}

print "INFO: Latest schema version is $version\n" if (defined $args{'check'});
die "INFO: Exiting\n" if (defined $args{'check'});
print "INFO: Attempting migration to $version\n";
$m->migrate or die "FATAL: Database migration failed!\n";
printf("INFO: Completed the migration from %.2f to version %.2f\n", (($cur_version) ? $cur_version : 0), $m->get_current_version());
