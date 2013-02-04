#!perl

package DBIx::Migration::Directories::Build::Base;

use strict;
use warnings;
use Module::Build;
use base q(Module::Build);
use File::Spec;
use File::Path;

return 1;

sub default_install_dir {
    my($self, $type, $from, $to) = @_;
    my $install_dir;

    $to ||= $from;

    # File::Spec doesn't have an is_abs/is_rel method :-(
    if($to =~ m{^/}) {
        $install_dir = $to;
    } else {
        my $propt = ($type eq 'core') ? 'prefix' : "${type}prefix";
        my $dir =
            $self->{properties}->{install_base} ||
            $self->{config}->{$propt} ||
            $self->{config}->{siteprefix} ||
            $self->{properties}->{original_prefix}->{$type};

        $install_dir = File::Spec->catdir($dir, $to);
    }
    
    return $install_dir;
}

sub add_install_dir {
    my($self, $from, $to) = @_;
    $to ||= $from;
    my @keys = keys(%{$self->{properties}{install_sets}});
    
    foreach my $type (@keys) {
        my $install_dir = $self->default_install_dir($type, $from, $to);
        $self->{properties}{install_sets}{$type}{$from} = $install_dir;
    }
    
    $self->{properties}->{build_dirs} ||= [];
    push(@{$self->{properties}->{build_dirs}}, $from);
    
    $self->{properties}{install_path}->{$from} ||=
        $self->default_install_dir("site", $from, $to);
    
    return $to;
}

sub process_files_by_dir {
    my($self, $dir) = @_;
    my $blib = File::Spec->catdir($self->blib, $dir);
    File::Path::mkpath($blib);
    my $dir_files = $self->rscan_dir($dir, sub { -f($_) && !m{/CVS|\.svn/}});
    foreach my $i (@$dir_files) {
        $self->copy_if_modified(
            from    => $i,
            to      => File::Spec->catfile($self->blib, $i)
        );
    }
}

sub build_dirs {
    my $self = shift;
    my $dirs = $self->{properties}->{build_dirs} || [];

    foreach my $dir (@$dirs) {
        $self->process_files_by_dir($dir);
    }
}

sub ACTION_code {
    my $self = shift;
    $self->build_dirs();
    return $self->SUPER::ACTION_code(@_);
}
