#!perl

package DBIx::Migration::Directories::Base;

use strict;
use warnings;
use Carp qw(croak);
use DBIx::Migration::Directories::Database;

our $number = qr{[0-9]+(?:\.[0-9]+)?};

return 1;

sub new {
  my($class, %args) = @_;
  ($class, %args) = ($class->set_preinit_defaults(%args));
  if(ref($class)) {
    $class = ref($class);
  }
  if(my $self = $class->driver_new(%args)) {
    $self->set_postinit_defaults();
    return $self;
  } else {
    return;
  }
}

sub set_preinit_defaults {
  return(@_);
}

sub set_postinit_defaults {
  my $self = shift;
  my $db = DBIx::Migration::Directories::Database->new(dbh => $self->{dbh});
  $self->{db} = $db;
  return $self;
}

sub db {
  my $self = shift;
  return $self->{db};
}

sub driver_new {
  my($class, %args) = @_;
  my $self = bless \%args, $class;
  return $self;
}

sub read_file {
    my($self, $file) = @_;
    if(open(my $fh, '<', $file)) {
        my $data = join('', <$fh>);
        close($fh);
        return $data;
    } else {
        croak qq{open("$file") failed: $!};
    }
}

sub direction {
    my($self, $from, $to) = @_;
    return $to <=> $from;
}

sub version_as_number {
    my($self, $version) = @_;
    return ($version || 0) + 0;
}

sub versions {
    my($self, $string) = @_;
    if($string =~ m{^($number)$}) {
        return($self->version_as_number(0), $self->version_as_number($1));
    } elsif($string =~ m{^($number)-($number)$}) {
        return($self->version_as_number($1), $self->version_as_number($2));
    } else {
        return;
    }
}

sub run_sql {
    my($self, @sql) = @_;
    my $dbh = $self->{dbh};
    
    return $dbh->transaction(sub {
        my $marker = '';
        my $good = 1;
        my $qn = 0;
        
        while($good && (my $query = shift(@sql))) {
            if(ref($query)) {
                $marker = $$query;
                $qn = 0;
            } else {
                $qn++;
                eval { $good = $dbh->do($query); };
            
                if($@) {
                    die "[$marker#$qn]$@";
                } elsif(!$good) {
                    $dbh->set_err(undef, '');
                    $dbh->set_err(
                        $dbh->err,
                        join('', "[$marker#$qn] ", $dbh->errstr || ''),
                        $dbh->state
                    );
                }
            }
        }
        
        return $good;
    });
}

sub require_schema {
    my($self, $schema, $version) = @_;
    my $schemas = $self->schemas;
    die qq{Schema "$schema" not installed!\n}
        unless($schemas->{$schema});
    if($version) {
        die qq{Schema "$schema" is version $schemas->{$schema}{version}, we want $version.\n}
            unless($schemas->{$schema}{version} == $version);
    }
    return 1;
}

sub schemas {
  my $self = shift;
  return $self->db->db_schemas;
}

sub schema_version_log {
  my $self = shift;
  my $myschema = shift || $self->{schema} ||
    croak "schema_version_log() called without a schema name";
  return $self->db->db_schema_version_log($myschema);
}


__END__

=pod

=head1 NAME

DBIx::Migration::Directories::Base - Schema-independant migration operations

=head1 SYNOPSIS

  my $object = DBIx::Migration::Directories::Base->new(
    $dbh => $some_database_handle
  );

  my $schemas = $object->schemas;
  
  if(my $schema = $schemas->{'Foo-Schema'}) {
     print "Foo-Schema is installed at version #$schema->{version}.\n";
  }

=head1 DESCRIPTION

C<DBIx::Migration::Directories::Base> is the base class to
C<DBIx::Migration::Directories>.

The methods in this class do not care if you are currently operating on
a schema, or if you have a valid schema directory to work with.

The main reason to create C<DBIx::Migration::Directories::Base> object
on it's own is to obtain general information about migrations, such as
currently installed schemas and their version history.

=head1 METHODS

=head2 Constructor

=over

=item new(%args)

Creates a new DBIx::Migration::Directories::Base object. C<%args> is a
hash of properties to set on the object; the following properties are
used by C<DBIx::Migration::Directories::Base>:

=over

=item dbh

B<Required.> The C<DBIx::Transaction> database handle to use for queries.
This handle should already be connected to the database that you wish to manage.

=item schema

The schema we wish to operate on. This option is only ever used by the
L<schema_version_log|/item_schema_version_log> method, and only if you
do not send that method a schema argument.

=back

=back

=head2 High-Level Methods

=over

=item schemas

Queries the migration schema, and returns a hash reference containing
all of the schemas currently registered in this database. The keys in
this hash are the schemas' names, and the values are hash references,
containing the contents of that schema's row in the database as key/value
pairs:

=over

=item name

The schema's name, again.

=item version

The current version of this schema.

=back

=item schema_version_log($schema)

Queries the migration schema, and returns an array reference containing
the specified schema's version history. If a schema is not specified,
defaults to the "schema" property if it has been set, otherwise an
exception is raised.

Each entry in the array reference returned is a hash reference,
containing the contents of that schema's log rows in the database as
key/value pairs:

=over

=item schema_name

Schema this log entry refers to.

=item event_time

Time this migration action took place.

=item old_version

Schema version before this migration action took place.

=item new_version

Schema version after this migration took place.

=back

=head2 Low-Level Methods

=over

=item direction($from, $to)

Given two version numbers, determine whether this is an upgrade or a
downgrade. All this does is:

   $to <=> $from

=item versions($string)

Given the name of a directory, determine what versions it is migrating
from and to. Returns an array of two numbers: the "from" version and the
"two" version.

If this directory has two version numbers in it, you'll get those two
(normalized) version numbers back. If this directory only has one version
number in it, you'll get C<0> as the "from" version, and the (normalized)
version number in the directory name as the "to" version.

=item run_sql(@sql)

Begin a transaction, and run all of the SQL statements specified in @sql.
If any of them fail, roll the transaction back and return 0. If they all
succeed, commit the transaction and return 1.

=item read_file($path)

Reads a file on the filesystem and returns it's contents as a scalar.
Raises an exception if the file could not be read. Exciting, huh?

=item version_as_number($version)

Normalize a version number. Currently, this is just equivalent to:

  return $version + 0
  
But in future releases it may do fancier stuff, like dealing with "double-dot"
version numbers or the like.

=back

=head1 AUTHOR

Tyler "Crackerjack" MacDonald <japh@crackerjack.net>

=head1 LICENSE

Copyright 2009 Tyler "Crackerjack" MacDonald <japh@crackerjack.net>

This is free software; You may distribute it under the same terms as perl
itself.

=head1 SEE ALSO

L<DBIx::Migration::Directories>

=cut


