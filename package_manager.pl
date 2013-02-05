#!/usr/bin/perl -w
# Reality package manager
# forked from Bliss by ayan4m1, updated by Thevisad

use Getopt::Long qw(:config pass_through);

use File::Slurp qw(read_file);
use File::Path qw(make_path remove_tree);
use File::Basename;

use URI::Escape;
use Archive::Extract;
use Digest::SHA qw(sha1_hex);
use JSON;

use Data::Dumper;

our %args;
GetOptions(
	\%args,
	'mirror=s',
	'help'
);

$args{'mirror'} = 'http://www.realityrepo.com' unless (defined $args{'mirror'});

# Initialize paths
our $base_dir = dirname(__FILE__);
our $pkg_dir  = "$base_dir/pkg";

if ($args{'help'}) {
	print "usage: package_manager.pl <command> [<arg> ...]\n";
	print "    install\n";
	print "    search\n";
	exit;
}

my $cmd = shift(@ARGV);
die "FATAL: No command supplied, try --help for usage information\n" unless defined $cmd;

our $pkg_name = shift(@ARGV);
die "FATAL: Invalid package name\n" unless (defined $pkg_name && $pkg_name =~ m/[a-zA-Z0-9_]+/);
$pkg_name = lc($pkg_name);

if ($cmd eq 'install') {
	install();
} else { 
	die "FATAL: Unrecognized command.\n";
}

print "INFO: Done working\n";
exit;

# Subroutines follow

sub installed {
	#return (-d "$pkg_dir/$pkg_name");
	return 0;
}

sub install {
	die "FATAL: Package $pkg_name already installed\n" if installed();

	my $metadata = get_json("$args{'mirror'}/package/metadata/" . uri_escape($pkg_name));
	die "FATAL: Did not get a valid response from server\n" unless (defined $metadata);
	$metadata = $metadata->{payload}[0];
	die "FATAL: Invalid response from server\n" unless (defined $metadata->{file_name});
	$metadata->{file_name} = "$metadata->{file_name}.tgz";
	get_uri("$args{'mirror'}/file/fetch/$metadata->{file_hash}", $metadata->{file_name});
	unlink($metadata->{file_name}) if (-f $metadata->{file_name} && !-s $metadata->{file_name});
	die "FATAL: Package was not downloaded\n" unless (-s $metadata->{file_name});

	my $file = Archive::Extract->new(archive => $metadata->{file_name});
	my $sha1sum = sha1_hex(read_file($metadata->{file_name}, binmode => ':raw'));
	die "FATAL: Package file is corrupt or invalid - bad sha1sum $sha1sum\n" unless ($file->is_tgz && $sha1sum eq $metadata->{file_hash});

	$file->extract(to => $base_dir) or die "FATAL: Could not extract the package\n";
	unlink($metadata->{file_name});

	print "INFO: Installed package $pkg_name\n";
}

sub get_json {
	return decode_json(get_uri(shift(@_), 0));
}

sub get_uri {
	my ($uri, $path) = @_;
	my $cmd = (($^O =~ m/MSWin32/) ? 'util/wget' : 'wget');
	$cmd = "$cmd -qO" . ((!$path) ? '-' : " $path") . " \"$uri\"";

	if ($path) {
		my $result = system($cmd);
		if (!$result) {
			print "INFO: Fetched $uri\n";
		} else {
			print "ERROR: Could not fetch $uri ($result)\n";
		}
	} else {
		return `$cmd`;
	}
}

sub copy_dir {
	my ($src, $dst) = @_;
	my $cmd = (($^O =~ m/MSWin32/) ? 'xcopy /s /q /y' : 'cp -r');
	my $path = "\"$src\" \"$dst\/\"";
	$path =~ s/\//\\/g if ($^O =~ m/MSWin32/);
	system("$cmd $path");
}
