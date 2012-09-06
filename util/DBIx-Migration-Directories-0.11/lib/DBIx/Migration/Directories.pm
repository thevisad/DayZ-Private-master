package DBIx::Migration::Directories;

use 5.006;
use strict;
use warnings;
use Carp qw(carp croak);
use DBIx::Migration::Directories::Base;
use base q(DBIx::Migration::Directories::Base);
use DBIx::Migration::Directories::ConfigData;
use File::Basename::Object;

our $VERSION = '0.11';
our $SCHEMA_VERSION = '0.03';
our $schema = 'DBIx-Migration-Directories';

return 1;

sub set_preinit_defaults {
    my($class, %args) = @_;
    ($class, %args) = $class->SUPER::set_preinit_defaults(%args);

    if($args{desired_version_from} && !$args{schema}) {
        $args{schema} = $args{desired_version_from};
    }

    croak qq{$class\->new\() requires "schema" parameter}
        unless defined $args{schema};

    my $s = $args{schema};
    if($args{schema} =~ s{::}{-}g && !$args{desired_version_from}) {
        $args{desired_version_from} = $s;
    }
    
    return($class, %args);
}

sub set_postinit_defaults {
    my $self = shift;
    $self->SUPER::set_postinit_defaults(@_);

    $self->{base} =
        DBIx::Migration::Directories::ConfigData->config('schema_dir')
            unless($self->{base});

    $self->{schema_dir} = join('/', $self->{base}, $self->{schema})
        unless($self->{schema_dir});

    unless(exists $self->{dir}) {
        my $dir = $self->detect_dir;
        $self->{dir} = $dir if defined $dir;
    }
    
    unless(-d $self->{dir}) {
        croak "$self->{dir} is not a directory!";
    }
    
    if($self->{base} && $self->{schema} && !$self->{common_dir}) {
        my $common = join('/', @$self{'base', 'schema'}, '_common');
        if(-d $common) {
            $self->{common_dir} = $common;
        }
    }

    $self->refresh();
    
    $self->get_current_version() unless defined $self->{current_version};
    $self->set_desired_version() unless defined $self->{desired_version};
    
    return $self;
}

sub detect_dir {
  my $self = shift;
  if($self->{schema} && $self->{base}) {
    my $dir = join('/', $self->{schema_dir}, $self->db->driver);

    # if a driver-specific schema isn't available, but a _generic schema
    # is, use that instead. however, if _generic isn't available either,
    # we want to fail out on the original driver directory name.

    if(!-d $dir) {
      my $generic_dir = join('/', $self->{schema_dir}, '_generic');
      if(-d $generic_dir) {
        $dir = $generic_dir;
      }
    }
    
    return $dir;
  } else {
    return;
  } 
}

sub desired_version {
    my($self, $version) = @_;
    if(@_ == 2) {
        my $old = $self->{desired_version};
        $self->{desired_version} = $version;
        return $old;
    } else {
        return $self->{desired_version};
    }
}

sub detect_package_version {
    my $self = shift;
    if($self->{desired_version_from}) {
        no strict 'refs';

        my $svar = join('::', $self->{desired_version_from}, 'SCHEMA_VERSION');
        my $vvar = join('::', $self->{desired_version_from}, 'VERSION');

        if(!defined(${$vvar})) {
            eval qq{require $self->{desired_version_from};};
        
            if($@) {
                croak qq{require $self->{desired_version_from} failed: $@};
            }
        }
        
        if(defined ${$svar}) {
            if(ref(${$svar}) && ${$svar}->can('numify')) {
                return ${$svar}->numify;
            } else {
                return ${$svar};
            }
        } elsif(defined ${$vvar}) {
            if(ref(${$vvar}) && ${$vvar}->can('numify')) {
                return ${$vvar}->numify;
            } else {
                return ${$vvar};
            }
        } else {
            croak qq{package "}, $self->{desired_version_from}, 
                qq{" did not define \$VERSION};
        }
        
        use strict 'refs';
    } else {
        return;
    }
}

sub detect_highest_version {
    my $self = shift;
    
    my @options = @{$self->{versions}};

    while(my $ver = shift(@options)) {
        eval { $self->migration_path($self->{current_version}, $ver); };
        
        if(!$@) {
            return $ver;
        }
    }

    return;
}

sub detect_desired_version {
    my $self = shift;
    return
        $self->detect_package_version ||
        $self->detect_highest_version ||
        undef;
}

sub set_desired_version {
    my $self = shift;
    my $version = $self->detect_desired_version
        or croak qq{Failed to detect the highest version in $self->{dir}!};
    $self->desired_version($version);
    return $version;
}

sub migration_map {
    my($self, @dirs) = @_;

    my @subs;
    foreach my $dir (grep {$_} @dirs) {
        my @s = do {
            opendir(my $dh, $dir) or croak qq{opendir("$dir") failed: $!};
            grep((!/^\./) && -d("$dir/$_"), readdir($dh));
        };
        push(@subs, \@s);
    }
    
    my %migration_map;
    my %versions;
    
    foreach my $major (@subs) {
        foreach my $i (@$major) {
            my($from, $to) = $self->versions($i);
            $versions{$self->version_as_number($to)} ||= $to;
            if(defined $to) {
                $migration_map{$from} ||= {};
                $migration_map{$from}{$to} ||= $i;
            }
        }
    }
    
    my $versions = [ @versions{(sort { $b <=> $a } (keys(%versions)))} ];
    return(\%migration_map, $versions);
}

sub refresh {
    my $self = shift;
    my $dh;
    
    my($migration_map, $versions) =
        $self->migration_map(@$self{'dir', 'common_dir'});
        
    $self->{migrations} = $migration_map;
    $self->{versions} = $versions;
    
    return $self->{migrations};
}

sub migration_path {
    my($self, $from_ver, $to_ver) = @_;
    my @rv = ();
    $from_ver = $self->version_as_number($from_ver);
    $to_ver = $self->version_as_number($to_ver);
    
    if($from_ver == $to_ver) {
        return @rv;
    }
    
    if(!$self->{migrations}{$from_ver}) {
        croak qq{No migrations available for $from_ver};
    }
    
    if($self->{migrations}{$from_ver}{$to_ver}) {
        return($self->{migrations}{$from_ver}{$to_ver});
    }
    
    my $direction = $self->direction($from_ver, $to_ver);
    
    my @candidates = sort { ($b * $direction) <=> ($a * $direction) } grep(
        $self->direction($from_ver, $_) == $direction,
        keys(%{$self->{migrations}{$from_ver}})
    );
    
    # never allow a schema to be dropped and re-created to switch versions
    # as this could destroy data!
    if($to_ver) {
        @candidates = grep($_, @candidates);
    }
        
    if(!@candidates) {
        croak qq{No migrations in direction $direction for $from_ver};
    }
    
    while((!@rv) && (@candidates)) {
        my $candidate = shift @candidates;
        my @path = eval { $self->migration_path($candidate, $to_ver) };
        
        if(@path) {
            @rv = ($self->{migrations}{$from_ver}{$candidate}, @path);
        }
    }
    
    if(!@rv) {
        croak qq{Failed to find a migration path from $from_ver to $to_ver};
    }
    
    return(@rv);
}

sub ls_overlay {
    my($self, $dir, $overlay) = @_;
    my %dir = map { $_->basename => $_ } $self->ls($dir);
    $dir{$_->basename} = $_
        foreach grep { !$dir{$_->basename} } $self->ls($overlay);
    return map { $dir{$_} } sort keys %dir;
}

sub ls {
    my($self, $dn) = @_;
    map { File::Basename::Object->new($_) }
        sort map { "$dn/$_" } grep { !/^\./ && !/\~$/ && -f "$dn/$_" } readdir do {
            my $d; opendir($d, $dn) ? $d : croak qq{opendir("$dn") failed: $!};
        };
}

sub read_sql_file {
    my($self, $file) = @_;
    \"$file", grep { m{\S}s } split(m{;\s*\n}s, $self->read_file($file));
}

sub dir_flat_sql {
    my($self, $dir) = @_;
    map { $self->read_sql_file($_) } $self->ls($dir);
}

sub dir_overlay_sql {
    my($self, $dir, $overlay) = @_;
    map { $self->read_sql_file($_) } $self->ls_overlay($dir, $overlay);
}

sub dir_sql {
    my($self, $dir) = @_;
    my $d1 = "$self->{dir}/$dir";
    if($self->{common_dir} && $dir ne $self->{common_dir}) {
        my $d2 = "$self->{common_dir}/$dir";
        if(-d $d1 && -d $d2) {
            $self->dir_overlay_sql($d1, $d2);
        } elsif (-d $d2) {
            $self->dir_flat_sql($d2);
        } else {
            $self->dir_flat_sql($d1);
        }
    } else {
        $self->dir_flat_sql($d1);
    }
}

sub version_update_sql {
    my($self, $from, $to) = @_;
    my $dbh = $self->{dbh};
    my $ver =
        exists($self->{_current_version}) ? '_current_version' :
        'current_version';
        
    my $ins = defined($self->{$ver}) ? 0 : 1;
    my @sql;
    
    if($ins) {
        push(@sql,
            $self->db->sql_insert_migration_schema_version($self->{schema}, $to)
        );
    } else {
        push(@sql,
            $self->db->sql_update_migration_schema_version($self->{schema}, $to)
        );
    }
    
    push(@sql,
        $self->db->sql_insert_migration_schema_log($self->{schema}, $from, $to)
    );
        
    return @sql;
}

sub dir_migration_sql {
    my($self, $dir) = @_;
    my($from, $to) = ($self->versions($dir));
    
    my @sql = ($self->dir_sql($dir));
    
    if(
        !$self->{schema} ||
        $self->{schema} ne $schema ||
        $self->version_as_number($to)
    ) {
        push(@sql, $self->version_update_sql($from, $to));
        $self->{_current_version} = $self->version_as_number($to);
    }
            
    return @sql;
}

sub migration_path_sql {
    my($self, @path) = @_;
    my @sql;
    
    $self->{_current_version} = $self->{current_version};
    
    foreach my $dir (@path) {
        push(@sql, $self->dir_migration_sql($dir));
    }
    
    delete $self->{_current_version};
    
    return @sql;
}

sub migrate_from_to {
    my($self, $from, $to) = @_;
    
    my @path = $self->migration_path($from, $to);
    my @sql = $self->migration_path_sql(@path);
    my $rv = $self->run_sql(@sql);
    if($self->{schema} eq $schema && !$self->version_as_number($to)) {
        delete $self->{current_version};
    } else {
        $self->get_current_version();
    }
    return $rv;
}

sub migrate_to {
    my($self, $to) = @_;
    my $from = $self->{current_version} || 0;
    return $self->migrate_from_to($from, $to);
}

sub migrate {
    my $self = shift;
    my $to;
    
    if(defined($self->{desired_version})) {
        $to = $self->{desired_version};
    } else {
        croak qq{migrate called without desired_version being set!};
    }
    
    return $self->migrate_to($to);
}

sub migration_schema {
    my($self, %args) = @_;
    return $self->new(
        dbh     =>  $self->{dbh},
        schema  =>  $schema,
        %args
    );
}

sub migrate_migration {
    my($self, %args) = @_;
    return $self->migration_schema(%args)->migrate();
}

sub delete_migration {
    my($self, %args) = @_;
    return $self->migration_schema(%args)->delete_schema();
}

sub full_migrate {
    my($self, %args) = @_;
    if($self->{schema} eq $schema) {
        return $self->migrate;
    } else {
        if($self->migrate_migration(%args)) {
            return $self->migrate;
        } else {
            return 0;
        }
    }
}


sub delete_schema {
    my $self = shift;
    my $dbh = $self->{dbh};
    $dbh->begin_work;
    my $rv;
    eval { $rv = $self->migrate_to(0); };

    if($@) {
        $dbh->rollback;
        croak $@;
    }

    if($rv) {
        if($self->{schema} ne $schema) {
            unless($self->delete_schema_record) {
                $dbh->rollback;
                return 0;
            }
        }
        
        $self->get_current_version;
        if($dbh->transaction_error) {
            $dbh->rollback;
            return 0;
        } else {
            $dbh->commit;
            return 1;
        }
    } else {
        $dbh->rollback;
        return 0;
    }
}

sub full_delete_schema {
    my($self, %args) = @_;
    
    if($self->{schema} eq $schema) {
        return $self->delete_schema;
    } else {
        my $schemas = $self->schemas;
        delete($schemas->{$schema});
        delete($schemas->{$self->{schema}});
        if(scalar keys %$schemas) {
            return $self->delete_schema;
        } else {
            my $dbh = $self->{dbh};
            $dbh->begin_work;
            my $rv = eval { $self->delete_schema; };
            
            if($@) {
                $dbh->rollback;
                croak $@;
            }
            
            if($rv) {
                $rv = eval { $self->delete_migration(%args); };
                
                if($@) {
                    $dbh->rollback;
                    croak $@;
                }
                
                if($rv) {
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
    }
}

sub delete_schema_record {
  my $self = shift;
  return $self->db->db_delete_schema_record($self->{schema});
}

sub get_current_version {
  my $self = shift;
  my $version;

  eval { $version = $self->db->db_get_current_version($self->{schema}); };

  if($@) {
    delete $self->{current_version};
    die $@;
  } elsif(!defined $version) {
    delete $self->{current_version};
    return;
  } else {
    $self->{current_version} = $version;
    return $version;
  }
}

