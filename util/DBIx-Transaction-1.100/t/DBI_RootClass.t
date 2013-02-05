# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl DBIx-Transaction.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Test::More;
use lib "t/tlib";
use strict;
use warnings (FATAL => 'all');
use DBI;
use DBIx::Transaction::Test;

our %test_opts = %{ do "test_opts.ph" }
    or die "Failed to read test options: $@";

if(!$test_opts{dsn}) {
    Test::More->import(skip_all => 'No database driver specified for testing');
    exit;
}

plan tests => 52;

my $dsn = $test_opts{dsn};

my $ac = DBI->connect(
    $test_opts{dsn}, $test_opts{dsn_user}, $test_opts{dsn_pass},
    { RaiseError => 1, PrintError => 0, PrintWarn => 0, AutoCommit => 1, RootClass => 'DBIx::Transaction', }
);

if($ac) {
    pass('Database Connection (AutoCommit = 1, RaiseError => 1)');
} else {
    fail('Database Connection (AutoCommit = 1, RaiseError => 1)');
    exit;
}

run_tests($ac, undef);

$ac->disconnect;

my $noac = DBI->connect_cached(
    $test_opts{dsn}, $test_opts{dsn_user}, $test_opts{dsn_pass},
    { RaiseError => 0, PrintError => 0, PrintWarn => 0, AutoCommit => 0, RootClass => 'DBIx::Transaction', }
);
    
if($noac) {
    pass('Database Connection (AutoCommit = 0, RaiseError => 0)');
} else {
    fail('Database Connection (AutoCommit = 0, RaiseError => 0)');
    exit;
}

run_tests($noac, 0);

$noac->disconnect;


exit;

# core tests

sub run_tests {
    my($dbh, $expect_error) = @_;

    my @setup = (q_create_foo);
    my @teardown = (q_drop_foo);

    my @foo_one_two = (
        q_add_foo($dbh, 'one'), q_add_foo($dbh, 'three'),
        q_change_foo($dbh, 'three', 'two')
    );

    my @foo_three_four = (q_add_foo($dbh, 'three'), q_add_foo($dbh, 'four'));

    my @no_one_two = (
        q_delete_foo($dbh, 'one'), q_delete_foo($dbh, 'two')
    );

    my @no_three_four = (
        q_delete_foo($dbh, 'three'), q_delete_foo($dbh, 'four')
    );

    my @foo_five = (q_add_foo($dbh, 'five'));

    ok(run_sql($dbh, @setup), 'Setup test table');
    is($dbh->transaction_level, 1, 'Need to close transaction');
    ok($dbh->commit, 'Commit test table');

    is_deeply(
        do_and_check_foo($dbh, [ @foo_one_two, @foo_three_four ]),
        [ [ 'four' ], [ 'one' ], [ 'three' ], [ 'two' ] ],
        'Simple add'
    );

    is_deeply(
        do_and_check_foo($dbh, \@no_one_two),
        [ [ 'four' ], [ 'three' ] ],
        'Remove parts'
    );

    diag('Expect some duplicate key / transaction state errors below:');

    is(do_and_check_foo($dbh, [ @foo_one_two ]), $expect_error, 'Aborted Transaction');

    is($dbh->transaction_level, 0, 'Not in a transaction');

    is_deeply(
        do_check_foo($dbh),
        [ [ 'four' ], [ 'three' ] ],
        'Aborted transaction had no effect'
    );

    ok($dbh->begin_work, 'Start a transaction');
    is($dbh->transaction_level, 1, 'In a transaction');

    is_deeply(
        do_and_check_foo($dbh, \@foo_five),
        [ [ 'five' ], [ 'four' ], [ 'three' ] ],
        'Add in sub-transaction'
    );

    ok($dbh->begin_work, 'Start a sub-transaction');
    is($dbh->transaction_level, 2, 'In a sub-transaction');
    is_deeply(
        do_check_foo($dbh),
        [ [ 'five' ], [ 'four' ], [ 'three' ] ],
        'Still good in sub-transaction'
    );
    my($line, $file) = (__LINE__, __FILE__);
    ok($dbh->rollback, 'Roll back a sub-transaction');
    $line++;
    eval { $dbh->commit; };
    my $err = ($expect_error ? $@ : $dbh->errstr);
    like($err, qr/called after a transaction error or rollback/,
        'Commit failed because of a previous rollback');
    like($err, qr/\QError or rollback at: $file line $line\E/,
        'Commit failure found correct line number for error');
    is($dbh->transaction_level, 1, 'Still in a transaction');
    ok($dbh->rollback, 'Roll back transaction');
    is($dbh->transaction_level, 0, 'Not in a transaction');

    is_deeply(
        do_check_foo($dbh),
        [ [ 'four' ], [ 'three' ] ],
        'Sub-transaction had no effect (rolled back)'
    );

    ok(run_sql($dbh, @teardown), 'Teardown test table');
    ok($dbh->commit, 'Commit teardown');
    
    eval { $dbh->commit; };
    
    like($@, qr/Asked to decrement transaction level below zero/,
        'Commit fails outside of a transaction'
    );
    
    diag('Expect a non-existant table warning here');
    if(defined $expect_error) {
        ok(!do_check_foo($dbh), 'Got a query error back');
    } else {
        eval { do_check_foo($dbh); };
        ok($@, 'Got a query exception back');
    }
}
