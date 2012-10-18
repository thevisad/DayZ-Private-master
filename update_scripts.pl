use File::Path qw(make_path);

my ($dst) = @ARGV;

die "FATAL: Must supply destination directory\n" unless defined $dst;
die "FATAL: Destination directory $dst does not exist\n" unless (-d $dst);

my %lookups = (
	"spawn" => "!\\\"_this spawn fnc_plyrHit\\\" !\\\"_this spawn fnc_plyrDeath\\\"",
	"set"   => "!\\\"_this spawn fnc_plyrHit\\\" !\\\"_this spawn fnc_plyrDeath\\\"",
	"this"  => "!\\\"_this spawn fnc_plyrHit\\\" !\\\"_this spawn fnc_plyrDeath\\\""
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
	"setdamage.txt"
);

foreach my $script (@scripts) {
	my $uri = "https://dayz-community-banlist.googlecode.com/git/filters/$script";
	my $cmd = (($^O =~ m/MSWin32/) ? 'util/wget' : 'wget');
	my $cmd = "$cmd --no-check-certificate -q -N -O $dst/$script $uri";

	print "INFO: Fetching URI $uri\n";
	my $ret = system($cmd);

	die "FATAL: Could not fetch URI!" unless ($ret == 0);

	while (($pattern, $exception) = each %lookups) {
		my $regex = "s/([0-9]{1})\\s$pattern\\s(.*)([\\\/]{2}.*)*/" . (($exception) ? "\\\$1 $pattern \\\$2 $exception/g" : "/g");
		replace_text($regex, "$dst/$script");
	}
	replace_text("s#^//.*\\\$##sg", "$dst/$script");
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

