#!perl

package DBIx::Migration::Directories::Database::mysql;

use strict;
use warnings;
use DBIx::Migration::Directories::Database;
use base q(DBIx::Migration::Directories::Database);

return 1;

sub driver { return "mysql"; }

sub sql_table_exists {
    my($self, $table) = @_;
    return sprintf(q{SHOW TABLES LIKE %s}, $self->{dbh}->quote($table));
}

=pod

=head1 NAME

DBIx::Migration::Directories::Database::mysql - Handle quirks with DBD::mysql

=head1 SYNOPSIS

  my $dbh = DBIx::Transaction->connect('DBI:mysql:database=test');

  my $migration = DBIx::Migration::Directories->new(
    dbh     => $dbh,
    schema  => 'MySchema',
    ...
  );

=head1 DESCRIPTION

The following methods had to be written differently
so that they behave properly under MySQL:

=over

=item sql_table_exists($table)

See L<DBIx::Migration::Directories::Base/sql_table_exists>.

MySQL 4.x does not support the SQL standard "C<information_schema>".
This C<sql_table_exists> method instead uses MySQL's custom
"C<SHOW TABLES>" syntax to verify the existance of a table.

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
