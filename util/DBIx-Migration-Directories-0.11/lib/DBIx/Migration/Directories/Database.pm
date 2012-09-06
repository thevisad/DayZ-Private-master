#!perl

package DBIx::Migration::Directories::Database;

use strict;
use warnings;
use Carp qw(croak);
use DBI;

return 1;

sub new {
  my($class, %args) = @_;
  ($class, %args) = ($class->set_preinit_defaults(%args));
  if(my $self = $class->driver_load($args{driver}, %args)) {
    $self->set_postinit_defaults();
    return $self;
  } else {
    return;
  }
}

sub set_postinit_defaults {
  return shift;
}

sub set_preinit_defaults {
  my($class, %args) = @_;
  $class = ref($class) if ref($class);
    
  croak qq{$class\->new\() requires "dbh" parameter}
    unless defined $args{dbh};

  $args{driver} = $args{dbh}->{Driver}->{Name}
    unless($args{driver});
        
  return($class, %args);
}

sub driver {
  my $self = shift;
  return $self->{driver};
}

sub driver_new {
  my($class, %args) = @_;
  my $self = bless \%args, $class;
  return $self;
}

sub driver_load {
  my($class, $driver, %args) = @_;
  my $pkg = __PACKAGE__ . "::$driver";
  eval "use $pkg; 1;";
  if($@) {
    my $err = $@;
    if($err =~ m{Can\'t locate}) {
      return $class->driver_new(%args);
    } else {
      die $err;
    }
  } else {
    return $pkg->driver_new(%args);
  }
}

sub sql_insert_migration_schema_version {
    my($self, $myschema, $to) = @_;
    return sprintf(
        q{INSERT INTO migration_schema_version (name, version) VALUES (%s, %f)},
        $self->{dbh}->quote($myschema), $to
    );
}

sub sql_update_migration_schema_version {
    my($self, $myschema, $to) = @_;
    return sprintf(
        q{UPDATE migration_schema_version SET version = %f WHERE name = %s},
        $to, $self->{dbh}->quote($myschema)
    )
}

sub sql_insert_migration_schema_log {
    my($self, $myschema, $from, $to) = @_;
    return sprintf(
        q{
            INSERT INTO migration_schema_log 
                (schema_name, event_time, old_version, new_version)
            VALUES (%s, now(), %f, %f)
        },
        $self->{dbh}->quote($myschema), $from, $to
    );
}

sub sql_table_exists {
    my($self, $table) = @_;
    return sprintf(
        q{SELECT 1 FROM information_schema.tables WHERE table_name = %s},
        $self->{dbh}->quote($table)
    );
}

sub db_schema_version_log {
  my($self, $schema) = @_;

  my $dbh = $self->{dbh};
  $dbh->begin_work;
  if($self->table_exists('migration_schema_log')) {
    if(my $sth = $dbh->prepare_cached(q{
     SELECT
       schema_name, event_time, old_version, new_version
     FROM
       migration_schema_log
     WHERE
       schema_name = ?
     ORDER BY
       event_time, new_version
    })) {
      if($sth->execute($schema)) {
        if(my $result = $sth->fetchall_arrayref({})) {
          $sth->finish();
          $dbh->commit();
          return $result;
        } else {
          $sth->finish();
          $dbh->rollback();
          return;
        }
      }
    } else {
      my $err = $dbh->errstr;
      $dbh->rollback();
      croak "query for versions of $schema failed: ", $err;
    }
  } else {
    $dbh->commit();
    return;
  }
}

sub db_schemas {
    my $self = shift;
    my $dbh = $self->{dbh};
    $dbh->begin_work;
    if($self->table_exists('migration_schema_version')) {
        if(my $sth = $dbh->prepare_cached(
            "SELECT * FROM migration_schema_version"
        )) {
            if($sth->execute()) {
                if(my $result = $sth->fetchall_hashref('name')) {
                    $sth->finish;
                    $dbh->commit;
                    return $result;
                } else {
                    $sth->finish;
                    $dbh->rollback;
                    return;
                }
            
            } else {
                my $err = $dbh->errstr;
                $dbh->rollback;
                croak "Failed to run query to obtain schemas: $err";
            }
        } else {
            my $err = $dbh->errstr;
            $dbh->rollback;
            croak "Failed to prepare query to obtain schemas: $err";
        }
    } else {
        $dbh->commit;
        return;
    }
}

sub db_delete_schema_record {
    my($self, $schema) = @_;
    my $dbh = $self->{dbh};
    
    $dbh->begin_work;

    my $sth = $dbh->prepare_cached(
        q{DELETE FROM migration_schema_log WHERE schema_name = ?}
    );
    
    if($sth->execute($schema)) {
        $sth->finish;
        $sth = $dbh->prepare_cached(
            q{DELETE FROM migration_schema_version WHERE name = ?}
        );
        if($sth->execute($schema)) {
            $sth->finish;
            $dbh->commit;
            return 1;
        } else {
            $dbh->rollback;
            return 0;
        }
    } else {
        $dbh->rollback;
        return 0;
    }
}

sub db_get_current_version {
  my($self, $schema) = @_;
  my $rv;
    
  my $dbh = $self->{dbh};

  if($self->table_exists('migration_schema_version')) {
    $dbh->begin_work;
    my $sth = $dbh->prepare(
      "SELECT version FROM migration_schema_version WHERE name = ?"
    );

    if($sth->execute($schema)) {
      if(my $row = $sth->fetchrow_arrayref()) {
        $rv = $row->[0];
      } else {
        $rv = undef;
      }
      $sth->finish();
      if($dbh->transaction_error) {
        $dbh->rollback();
      } else {
        $dbh->commit();
      }
    } else {
      my $err = $dbh->errstr;
      $dbh->rollback();
      croak "querying migration version table failed: $err";
    }
  } else {
    $rv = undef;
  }
    
  return $rv;
}

sub table_exists {
    my($self, $table) = @_;
    
    my $dbh = $self->{dbh};
    my $rv;
    $dbh->begin_work;
    my $query = $self->sql_table_exists($table);
    my $sth = $dbh->prepare($query);
    if($sth->execute()) {
        if($sth->fetchrow_arrayref()) {
            $rv = 1;
        } else {
            $rv = 0;
        }
        $sth->finish();
        if($dbh->transaction_error) {
            $dbh->rollback();
        } else {
            $dbh->commit();
        }
    } else {
        my $err = $dbh->errstr;
        $dbh->rollback();
        warn "table_exists query $query failed: $err";
        $rv = undef;
    }
    return $rv;
}

