#!perl

package DBIx::Transaction::Test;

use strict;
use warnings;
use base q(Exporter);
use Test::More;

our @EXPORT = qw(
    q_create_foo q_add_foo q_change_foo q_delete_foo q_drop_foo
    run_sql
    do_check_foo do_and_check_foo
);

return 1;

sub q_create_foo {
    return('CREATE TABLE foo (name VARCHAR(128) PRIMARY KEY)');
}

sub q_add_foo {
    my($dbh, $foo) = @_;
    return('INSERT INTO foo (name) VALUES (' . $dbh->quote($foo) . ')');
}

sub q_change_foo {
    my($dbh, $foo, $newfoo) = @_;
    return(
        'UPDATE foo SET name = ' .
        $dbh->quote($newfoo) .
        ' WHERE name = ' .
        $dbh->quote($foo)
    ); 
}

sub q_delete_foo {
    my($dbh, $foo) = @_;
    return('DELETE FROM foo WHERE name = ' . $dbh->quote($foo));
}

sub q_drop_foo {
    return('DROP TABLE foo');
}

sub run_sql {
    my($dbh, @sql) = @_;
    my $err;
    $dbh->begin_work;

    foreach my $i (@sql) {
        unless($dbh->do($i)) {
            diag($dbh->errstr);
            $err++;
        }
    }
    
    return ! $dbh->transaction_error;
}


sub do_check_foo {
    my $dbh = shift;
    return $dbh->transaction(sub {
        if(my $sth = $dbh->prepare("SELECT * FROM foo ORDER BY name")) {
            if($sth->execute) {
                my $result = $sth->fetchall_arrayref();
                $sth->finish;
                note(explain($result));
                return $result;
            } else {
                diag($dbh->errstr);
                return 0;
            }
        } else {
            return;
        }
    });
}

sub do_and_check_foo {
    my($dbh, $do) = @_;
    
    my $rv = eval { run_sql($dbh, @$do); };
    
    if($@) {
        $dbh->rollback;
        diag($@);
        return;
    } elsif($rv) {
        $rv = do_check_foo($dbh);
        if($rv) {
            $dbh->commit;
            return $rv;
        } else {
            $dbh->rollback;
            return 0;
        }
    } else {
        $dbh->rollback;
        diag('Execution returned false.');
        return 0;
    }
}


