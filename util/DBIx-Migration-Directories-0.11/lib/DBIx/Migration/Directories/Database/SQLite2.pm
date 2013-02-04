#!perl

package DBIx::Migration::Directories::Database::SQLite2;

use strict;
use warnings;
use DBIx::Migration::Directories::Database;
use base q(DBIx::Migration::Directories::Database);
use POSIX qw(strftime);

return 1;

sub driver { return "SQLite2"; }

sub sql_table_exists {
    my($self, $table) = @_;
    return sprintf(
        q{SELECT 1 FROM sqlite_master WHERE type ='table' AND name = %s},
        $self->{dbh}->quote($table)
    );
}

sub sql_insert_migration_schema_log {
    my($self, $myschema, $from, $to) = @_;
    my $now = strftime("%Y%m%dZ%H%M%S", gmtime);
    return sprintf(
        q{
            INSERT INTO migration_schema_log 
                (schema_name, event_time, old_version, new_version)
            VALUES (%s, %s, %f, %f)
        },
        $self->{dbh}->quote($myschema), $self->{dbh}->quote($now), $from, $to
    );
}

=pod

=head1 NAME

DBIx::Migration::Directories::Database::SQLite2 - Handle quirks with DBD::SQLite2

=head1 SYNOPSIS

  my $dbh = DBIx::Transaction->connect('DBI:SQLite2:my_database');

  my $migration = DBIx::Migration::Directories->new(
    dbh     => $dbh,
    schema  => 'MySchema',
    ...
  );

=head1 DESCRIPTION

The following methods had to be written differently
so that they behave properly under SQLite2:

=over

=item sql_table_exists($table)

See L<DBIx::Migration::Directories::Base/sql_table_exists>.

SQLite2 does not support the SQL standard "C<information_schema>".
This C<sql_table_exists> method instead uses SQLite2's custom
"C<sqlite_master>" meta-table to verify the existance of a table.

=item sql_insert_migration_schema_log()

See L<DBIx::Migration::Directories::Base/sql_insert_migration_schema_log>.

SQLite2 does not supply a now() function to retrieve the current time,
so this query has been modified to compensate.

=back

=head1 AUTHOR

Tyler "Crackerjack" MacDonald <japh@crackerjack.net>

=head1 LICENSE

Copyright 2009 Tyler "Crackerjack" MacDonald <japh@crackerjack.net>

This is free software; You may distribute it under the same terms as perl
itself.

=head1 SEE ALSO

L<DBIx::Migration::Directories>, L<DBD::mysql>

=cut
