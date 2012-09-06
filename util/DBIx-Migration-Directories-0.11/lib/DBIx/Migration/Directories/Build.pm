#!perl

package DBIx::Migration::Directories::Build;

use strict;
use warnings;
use base qw(DBIx::Migration::Directories::Build::Base);

return 1;

sub autotest_with {
    my($self, $auto_reqs) = @_;
    if($ENV{AUTOMATED_TESTING}) {
        my $reqs = $self->build_requires;
        %{$reqs} = (%{$reqs}, %{$auto_reqs});
    }
}

sub new {
    my $class = shift;
    my $self = $class->SUPER::new(@_);
    my $schema_dir;
    
    eval {
        require DBIx::Migration::Directories::ConfigData;
        $schema_dir = DBIx::Migration::Directories::ConfigData->config(
            'schema_dir'
        );
    };

    
    if($@ || !$schema_dir) {
        $schema_dir = $self->default_install_dir(
            'site', 'schemas', 'share/schemas'
        );

        $schema_dir = $self->prompt(
            "Where should database schemas be installed?", $schema_dir
        );
    }

    $self->config_data('schema_dir', $schema_dir);
    
    if(-d "schema") {
        my $schema_name =
            $self->{properties}->{schema_name} ||
            $self->{properties}->{module_name};
            
        $schema_name =~ s{::}{-}g;
        $self->add_install_dir("schema", "$schema_dir/$schema_name");
    }
    
    if(-d "schemas") {
        $self->add_install_dir("schemas", $schema_dir);
    }

    return $self;
}

__END__

=pod

=head1 NAME

DBIx::Migration::Directories::Build - Build a package that includes a migration schema

=head1 SYNOPSIS

  our %opts = (
      module_name         =>  'Schema::RDBMS::MySchema',
      license             =>  'perl',
      requires            =>  {
          'DBIx::Migration::Directories'  =>  '0.01',
          'DBIx::Transaction'             =>  '0.005',
      },
      build_requires      =>  {
        'Module::Build'                 =>  '0.27_03',
        'Test::Exception'               =>  '0.21',
      },
      create_makefile_pl  =>  'passthrough',
  );

  eval { require DBIx::Migration::Directories::Build; };

  my $build;

  if($@) {
      warn "DBIx::Migration::Directories::Build is required to build this module!";
      # they don't have the build class, so the install won't work anyways.
      # set installdirs to an empty hash to ensure that the "install" action
      # can't run successfully.
      $build = Module::Build->new(%opts, installdirs => {});
  } else {
      $build = DBIx::Migration::Directories::Build->new(%opts);
  }
  
  $build->create_build_script;

=head1 DESCRIPTION

When C<DBIx::Migration::Directories> is installed, the user is asked where
they would like database migration schemas to live. (This usually defaults
to something like "/usr/local/share/schemas".) Packages that use
C<DBIx::Migration::Directories> should then install their schemas into
a sub-directory of this, named after their package or schema name. That way,
the migration code can find and use these schemas easily.

C<DBIx::Migration::Directories::Build> is a subclass of
L<Module::Build|Module::Build>, which ensures that your database schemas
are installed in this manner.

=head1 USAGE

If your package only supplies one schema, you can simply create a schema
directory structure (as described by
L<DBIx::Migration::Directories/DIRECTORY STRUCTURE>) in a "schema" directory
in the base of your package. When "Build install" is run, this schema will
be installed into the appropriate place.

If your package supplies multiple schemas, you can create a "schemas" directory
instead, and create sub-directories for each schema below that. (Eg;
C<schemas/My-Schema-Foo>, C<schemas/My-Schema-Bar>, etc.)

=head1 SCHEMA NAMING

When using the "schema" directory, by default, your schema will be named after
your package, with double-colons (C<::>) replaced by dashes, (C<->), as is the
perl way. For example, if the package "C<My::Package>" had a "schema" directory,
that would be installed as C</path/to/schemas/My-Package>.

If you want your schema to be named something else when it is installed,
you can override the default behaviour by passing the "C<schema_name>"
argument to the C<DBIx::Migration::Directories::Build> constructor. This
could be useful if it's a particular module inside your package that
defines/versions the schema (see
L<DBIx::Migration::Directories/desired_version_from>).

=head1 AUTHOR

Tyler "Crackerjack" MacDonald <japh@crackerjack.net>

=head1 LICENSE

Copyright 2006 Tyler "Crackerjack" MacDonald <japh@crackerjack.net>

This is free software; You may distribute it under the same terms as perl
itself.

=head1 SEE ALSO

L<DBIx::Migration::Directories>, L<Module::Build>

=cut
