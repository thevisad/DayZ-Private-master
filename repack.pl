#!/usr/bin/perl

use File::Copy;
use File::Path qw(make_path);
use Digest::SHA1 qw(sha1_hex);
use Time::HiRes qw(time);
use List::Util qw(max min);

# Ensure required directories exist
make_path(
	'./deploy/@Bliss/addons',
	'./deploy/@BlissLingor/addons',
	'./deploy/MPMissions'
);

my $deployDir = "./deploy";
my $missionDir = "./bliss/missions";
my @profiles = ('Bliss', 'BlissLingor');

# Set OS-specific options
my $repackCmd = "wine util/cpbo.exe";
if ($^O eq "MSWin32") {
	$repackCmd =~ s/wine\s//;
}

# Copy blisshive.dll into place
foreach $profile (@profiles) {
	$cmd = "cp ./util/blisshive.dll $deployDir/\@$profile";
	if ($^O eq "MSWin32") {
		$cmd =~ s/cp/copy/;
		$cmd =~ s/\//\\/g;
	}
	system($cmd);
}

# Obfuscate unmodified profile directories
foreach $profile (@profiles) {
	my $dir = "$deployDir/$profile";	
	if (-d $deployDir && -f "$dir/basic.cfg" && -f "$dir/config.cfg") {
		my $start = int(rand(32));
		my $hash = substr(sha1_hex(time()), $start, 8);
		print "INFO: Suffixing key $hash for $dir\n";

		# Insert hash as default admin password
		replaceText("s/passwordAdmin\\s=\\s\\\"\\\"/passwordAdmin = \\\"$hash\\\"/", "$dir/config.cfg");
		replaceText("s/RConPassword\\sCHANGEME/RConPassword $hash/", "$dir/BattlEye/BEServer.cfg");

		# Rename config file and update related .bat file
		rename("$dir/config.cfg", "$dir/config_$hash.cfg");
		replaceText(
			"s/config=$profile\\\\config_[0-9a-fA-F]{8}\\.cfg/config=$profile\\\\config_${hash}.cfg/",
			(($dir =~ /Lingor/) ? "$deployDir/server_lingor.bat" : "$deployDir/server.bat")
		);
	}
}

# Pack the server files
system("$repackCmd -y -p ./bliss/dayz_server $deployDir/\@Bliss/addons/dayz_server.pbo");
system("$repackCmd -y -p ./bliss/dayz_lingor $deployDir/\@BlissLingor/addons/dayz_server.pbo");

# Find our mission directories
opendir(my $dh, $missionDir) or die ("Could not open ${missionDir}!");
@missions = grep { !/^\.\.?$/ } readdir($dh);
closedir($dh);

# Replace the instance ID dynamically
foreach my $dir (@missions) {
	my $path = "${missionDir}/${dir}";
	if (-d $path) {
		# If directory has valid instance ID, replace it in init.sqf	
		if ($dir =~ /dayz_([0-9]{1,}).*/) {
			replaceText("s/dayZ_instance\\s=\\s[0-9]*/dayZ_instance = $1/", "$path/init.sqf");
			print "Set instance id to $1 for $path/init.sqf\n";
		}
		# Pack the mission files
		system("$repackCmd -y -p $path $deployDir/MPMissions/$dir.pbo");
	}
}

# Cross-platform replacement of text using system()
sub replaceText {
	system("perl -pi" . (($^O eq "MSWin32") ? '.bak' : '') . " -e \"$_[0]\" $_[1]");
	# Clean up .bak file in Windows only
	if ($^O eq "MSWin32") {
		(my $winPath = $_[1]) =~ s/\//\\/g;
		system("del \"$winPath.bak\"");
	}
}
