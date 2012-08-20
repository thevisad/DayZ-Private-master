use 5.006;
use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.

our %test_opts;
my $has_sqlite;

eval q{use DBD::SQLite2; 1;} && $has_sqlite++;

# if we have SQLite2 installed, or we're in AUTOMATED_TESTING,
# use it for as our default DSN for unit tests.

$test_opts{dsn} =
    exists($ENV{DBI_DSN}) ? $ENV{DBI_DSN} : (
        ($has_sqlite || $ENV{AUTOMATED_TESTING}) ? 'DBI:SQLite2:test_db' : ''
    );

WriteMakefile(
    NAME              => 'DBIx::Transaction',
    VERSION_FROM      => 'lib/DBIx/Transaction.pm', # finds $VERSION
    PREREQ_PM         => {
        'DBI'           =>      '1.38',
        #'Test::CPANpm'  =>      '0.008',
        ($ENV{AUTOMATED_TESTING} ? ('DBD::SQLite2' => 0.32) : ()),
	}, 
    NO_META		=> 1,
    ($] >= 5.005 ?     ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM  => 'lib/DBIx/Transaction.pod', # retrieve abstract from module
       AUTHOR         => 'Tyler MacDonald <japh@crackerjack.net>') : ()),
    clean             => { FILES => 'test_opts.ph test_db' },
);

use Data::Dumper;
if(open(my $fh, ">test_opts.ph")) {
     print $fh "my " . Data::Dumper->Dump([\%test_opts], ['test_opts']);
} else {
     die "Saving unit test options failed: $!";
}
