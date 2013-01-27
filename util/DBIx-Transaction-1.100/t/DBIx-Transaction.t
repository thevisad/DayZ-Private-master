#!/usr/bin/perl

select(STDERR);
$|=1;
select(STDOUT);
$|=1;

use Test::More;
use lib "t/tlib";
use strict;
use warnings (FATAL => 'all');
use DBIx::Transaction;
use DBIx::Transaction::Test;

our %test_opts = %{ do "test_opts.ph" }
    or die "Failed to read test options: $@";

if(!$test_opts{dsn}) {
    Test::More->import(skip_all => 'No database driver specified for testing');
    exit;
}

plan tests => 70;

my $dsn = $test_opts{dsn};

my $ac = DBIx::Transaction->connect(
    $test_opts{dsn}, $test_opts{dsn_user}, $test_opts{dsn_pass},
    { RaiseError => 1, PrintError => 0, PrintWarn => 0, AutoCommit => 1 }
);

if($ac) {
    pass('Database Connection (AutoCommit = 1, RaiseError => 1)');
} else {
    fail('Database Connection (AutoCommit = 1, RaiseError => 1)');
    exit;
}

run_tests($ac, undef);

$ac->disconnect;

my $noac = DBIx::Transaction->connect_cached(
    $test_opts{dsn}, $test_opts{dsn_user}, $test_opts{dsn_pass},
    { RaiseError => 0, PrintError => 0, PrintWarn => 0, AutoCommit => 0 }
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

    my @foo_six = (q_add_foo($dbh, 'six'));

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

    {
      diag("Retries");

      eval {
        $dbh->transaction(sub {
          $dbh->transaction(sub { 1 }, 3)
        });
      };

      my $err = $@;
      like(
        $err, qr/Transaction retry flow/,
        "Can't retry inside a nested transaction"
      );

      my $want_succ = 0;
      my $tried = 0;
      my $txn = sub {
        $dbh->do($_) foreach @foo_six;
        return $want_succ;
      };
    
      my $wanted_no_effect = sub {
        my $ddbh = shift;
        $tried++;
        return $ddbh->_when(@_);
      };

      my $wanted_effect = sub {
        my $ddbh = shift;
        $tried++;
        $want_succ = 1 if $tried >= 2;
        return $ddbh->_when(@_);
      };

      my $rv;
      eval { $rv = $dbh->transaction($txn, 5, $wanted_no_effect) };
      ok(!$rv, "Transaction did not complete");

      is($tried, 5, "Tried 5 times");
      is($dbh->transaction_level, 0, 'Not in a transaction');

      is_deeply(
          do_check_foo($dbh),
          [ [ 'four' ], [ 'three' ] ],
          'Transaction had no effect (rolled back)'
      );

      $tried = 0;
      eval { $rv = $dbh->transaction($txn, 5, $wanted_effect) };
      ok(!$@, "No exception raised");
      ok($rv, "Transaction did complete");
      is($tried, 3, "Tried 3 times");

      is_deeply(
          do_check_foo($dbh),
          [ [ 'four' ], [ 'six' ], [ 'three' ] ],
          'Transaction had effect'
      );
    }


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





