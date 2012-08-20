package DBIx::Transaction::st;

use DBI;
use base q(DBI::st);
use strict;
use warnings (FATAL => 'all');
use Carp qw(croak);

return 1;

sub execute {
    my $self = shift;
    my $rv = eval { DBI::st::execute($self, @_); };
    if($@) {
        $self->{Database}->inc_transaction_error(caller, $self->errstr);
        croak "$@\n";
    }
    if(!$rv) {
        $self->{Database}->inc_transaction_error(caller, $self->errstr);
    }
    return $rv;
}

=pod

=head1 NAME

DBIx::Transaction::st - Statement handle when running under DBIx::Transaction

=head1 DESCRIPTION

When you connect to a database using DBIx::Transaction, your statement handles
will be C<DBIx::Transaction::st> objects. When these statement handles are
executed, C<DBIx::Transaction::st> will notice when query errors occur, and
let the database handle know. See
L<the commit() method in DBIx::Transaction::db|DBIx::Transaction::db/item_commit>
for more information.

=head1 METHODS

C<DBIx::Transaction::st> only overrides one standard L<DBI::st|DBI> method:

=over

=item execute

Calls C<execute> on the underlying database layer. If an error
occurs, this is recorded and you will not be able to issue a C<commit>
for the current transaction.

=back

=head1 SEE ALSO

L<DBI>, L<DBIx::Transaction>

=cut
