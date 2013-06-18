#!/usr/bin/perl -w

use Getopt::Long qw(:config pass_through);

use File::Slurp;
use File::Path qw(make_path);

use JSON;

our %args;
GetOptions(
	\%args,
	'world|w=s',
	'help'
);

my $dst = shift(@ARGV);
my $filter_dir = './filter';

print "WARNING: The command syntax changed! The parameter --world has been removed.\n" if ($args{'world'});
if ($args{'help'}||$args{'world'}) {
	print "usage: update_scripts.pl <directory> [--with-<exception ...]\n";
	print "     This script downloads updated BE filters from the community list and then modifies them to make them compatible with Reality optional features.\n";
	print "     If you are using certain worlds or features you must add in special sets of BE exceptions. To do this, consult your filter directory and add in --with-<exception> options for each exception set required.\n";
	exit;
}

die "FATAL: Filter directory does not exist\n" unless (-d $filter_dir);
die "FATAL: Must supply destination directory\n" unless defined $dst;
die "FATAL: Destination directory $dst does not exist\n" unless (-d $dst);

my %lookups = ();

opendir (my $dh, $filter_dir);
my @filters = readdir $dh;
closedir $dh;

foreach my $filter (@filters) {
	next unless (-f "$filter_dir/$filter");

	my $json = read_file("$filter_dir/$filter");
	my $json_data = decode_json($json);

	next if defined $lookups{$filter};
	$lookups{$filter} = $json_data;
}

my @scripts = (
	"addbackpackcargo.txt",
	"addmagazinecargo.txt",
	"addweaponcargo.txt",
	"attachto.txt",
	"createvehicle.txt",
	"deleteVehicle.txt",
	"mpeventhandler.txt",
	"publicvariable.txt",
	"publicvariableval.txt",
	"remotecontrol.txt",
	"remoteexec.txt",
	"scripts.txt",
	"selectplayer.txt",
	"setdamage.txt",
	"setpos.txt",
	"setvariable.txt",
	"setvariableval.txt",
	"teamswitch.txt",
	"waypointcondition.txt",
	"waypointstatement.txt"
);

foreach my $script (@scripts) {
	my $uri = "https://raw.github.com/DayZMod/Battleye-Filters/1.7.7/$script";
	#my $uri = "https://dayz-community-banlist.googlecode.com/git/filters/$script";
	my $cmd = (($^O =~ m/MSWin32/) ? 'util/wget' : 'wget');
	$cmd = "$cmd --no-check-certificate -q -N -O \"$dst/$script\" $uri";

	print "INFO: Fetching URI $uri\n";
	my $ret = system($cmd);

	print "FATAL: Could not fetch URI!" unless ($ret == 0);

	while (($pattern, $exception) = each %{$lookups{'global'}}) {
		my $regex = "s/([0-9]{1})\\s$pattern\\s(.*)([\\\/]{2}.*)*/" . (($exception) ? "\\1 $pattern \\2 $exception\n/g" : "/g");
		replace_text($regex, "$dst/$script");
	}

	# For each --with-<exception> option, attempt to find an exception set
	while (my $option = shift(@ARGV)) {
		next unless ($option =~ m/with-([-\w.]+)/);
		next unless (defined $lookups{$1});

		while (($pattern, $exception) = each %{$lookups{$1}}) {
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
	#print "perl -pi" . (($^O eq "MSWin32") ? '.bak' : '') . " -e \"$_[0]\" \"$_[1]\"\n";
	system("perl -pi" . (($^O eq "MSWin32") ? '.bak' : '') . " -e \"$_[0]\" \"$_[1]\"");
	# Clean up .bak file in Windows only
	if ($^O eq "MSWin32") {
		(my $bakPath = $_[1]) =~ s/\//\\/g;
		system("del \"$bakPath.bak\"");
	}
}

