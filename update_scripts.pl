#!/usr/bin/perl -w

use Getopt::Long qw(:config pass_through);
use File::Path qw(make_path);

our %args;
GetOptions(
	\%args,
	'world|w=s',
	'help'
);

my ($dst) = @ARGV;

if ($args{'help'}) {
	print "usage: update_scripts.pl [--world <world>] <directory>\n";
	print "     This script downloads updated BE filters from the community list and then modifies them to make them compatible with Bliss optional features\n";
	exit;
}

$args{'world'} = 'chernarus' unless($args{'world'});

die "FATAL: Must supply destination directory\n" unless defined $dst;
die "FATAL: Destination directory $dst does not exist\n" unless (-d $dst);

my %lookups = (
	'global' => {
		"\\\"\\\""           => "!\\\"addMPEventHandler [\\\\\\\\\\\"MPHit\\\\\\\\\\\", {_this spawn fnc_plyrHit;}];\\\"",
		"\\\"spawn\\\""      => "!\\\"addMPEventHandler [\\\\\\\\\\\"MPHit\\\\\\\\\\\", {_this spawn fnc_plyrHit;}];\\\"",
		"\\\"this\\\""       => "!\\\"addMPEventHandler [\\\\\\\\\\\"MPHit\\\\\\\\\\\", {_this spawn fnc_plyrHit;}];\\\"",
		"addMPEventHandler"  => "!\\\"addMPEventHandler [\\\\\\\\\\\"MPHit\\\\\\\\\\\", {_this spawn fnc_plyrHit;}];\\\""
	},
	'namalsk' => {
		"createVehicle"      => "!\\\"_light = \\\"#LightPoint\\\" createVehicleLocal [4978.8086,6630.834,0];\\\"",
		"createVehicleLocal" => "!\\\"_light = \\\"#LightPoint\\\" createVehicleLocal [4978.8086,6630.834,0];\\\"",
		"\\\"box\\\""        => "!\\\"z_ru_soldier_light\\\" !\\\"z_us_soldier\\\" !\\\"z_us_soldier_light\\\" !\\\"z_ru_soldier\\\" !\\\"CamoWinter_DZN\\\""
	},
	'mbg_celle2' => {
		"createVehicleLocal" => "!\\\"createvehiclelocal getpos _house;\\\""
	}
);

my @scripts = (
	"scripts.txt",
	"remoteexec.txt",
	"createvehicle.txt",
	"publicvariable.txt",
	"publicvariableval.txt",
	"publicvariablevar.txt",
	"setpos.txt",
	"mpeventhandler.txt",
	"setdamage.txt",
	"addmagazinecargo.txt",
	"addweaponcargo.txt",
	"deleteVehicle.txt",
	"teamswitch.txt"
);

foreach my $script (@scripts) {
	my $uri = "https://dayz-community-banlist.googlecode.com/git/filters/$script";
	my $cmd = (($^O =~ m/MSWin32/) ? 'util/wget' : 'wget');
	$cmd = "$cmd --no-check-certificate -q -N -O $dst/$script $uri";

	print "INFO: Fetching URI $uri\n";
	my $ret = system($cmd);

	die "FATAL: Could not fetch URI!" unless ($ret == 0);

	while (($pattern, $exception) = each %{$lookups{'global'}}) {
		my $regex = "s/([0-9]{1})\\s$pattern\\s(.*)([\\\/]{2}.*)*/" . (($exception) ? "\\1 $pattern \\2 $exception\n/g" : "/g");
		replace_text($regex, "$dst/$script");
	}

	if (defined $lookups{$args{'world'}}) {
		while (($pattern, $exception) = each %{$lookups{$args{'world'}}}) {
			my $regex = "s/([0-9]{1})\\s$pattern\\s(.*)([\\\/]{2}.*)*/" . (($exception) ? "\\1 $pattern \\2 $exception\n/g" : "/g");
			replace_text($regex, "$dst/$script");
		}
	}

	replace_text("s#^//((?!new).*)\\\$##sg", "$dst/$script");
	replace_text("s/^\\n\$//", "$dst/$script");
}

print "INFO: Update complete. NOTE: You must reload the filters on a running server for changes to take effect!\n";

# Cross-platform system() helper
sub replace_text {
	#print "perl -pi" . (($^O eq "MSWin32") ? '.bak' : '') . " -e \"$_[0]\" $_[1]\n";
	system("perl -pi" . (($^O eq "MSWin32") ? '.bak' : '') . " -e \"$_[0]\" $_[1]");
	# Clean up .bak file in Windows only
	if ($^O eq "MSWin32") {
		(my $bakPath = $_[1]) =~ s/\//\\/g;
		system("del \"$bakPath.bak\"");
	}
}

