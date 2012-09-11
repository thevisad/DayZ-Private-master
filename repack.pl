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

my $baseDir = "./bliss/missions";

# Set OS-specific options and copy blisshive.dll into place
my $repackCmd, $copyCmd;
my $editOpts = "";
if ($^O eq "linux") {
	$repackCmd = "wine util/cpbo.exe";
	system("cp ./util/blisshive.dll ./deploy/\@Bliss");
	system("cp ./util/blisshive.dll ./deploy/\@BlissLingor");
} elsif ($^O eq "MSWin32") {
	$repackCmd = "util/cpbo.exe";
	system("copy .\\util\\blisshive.dll .\\deploy\\\@Bliss");
	system("copy .\\util\\blisshive.dll .\\deploy\\\@BlissLingor");
	$editOpts = ".bak";
}

# If the profile directories have not been obfuscated
my @profiles = ('./deploy/Bliss', './deploy/BlissLingor');
foreach $dir (@profiles) {
	if (-d $dir && -f "$dir/basic.cfg" && -f "$dir/config.cfg") {
		my $start = int(rand(32));
		my $hash = substr(sha1_hex(time()), $start, 8);
		rename("$dir/config.cfg", "${dir}/config_$hash.cfg");
		if ($dir =~ /Lingor/) {
			system("perl -pi${editOpts} -e 's/config=BlissLingor\\\\config_[0-9a-fA-F]{8}\\.cfg/config=BlissLingor\\\\config_${hash}.cfg/' ./deploy/server_lingor.bat\n");
		} else {
			system("perl -pi${editOpts} -e 's/config=Bliss\\\\config_[0-9a-fA-F]{8}\\.cfg/config=Bliss\\\\config_${hash}.cfg/' ./deploy/server.bat\n");
		}
		print "INFO: Suffixing key $hash for $dir\n";
	}
}

# Pack the server files
system("${repackCmd} -y -p ./bliss/dayz_server ./deploy/\@Bliss/addons/dayz_server.pbo");
system("${repackCmd} -y -p ./bliss/dayz_lingor ./deploy/\@BlissLingor/addons/dayz_server.pbo");

# Find our mission directories
opendir(my $dh, $baseDir) or die ('Could not open ./bliss/missions!');
@missions = grep { !/^\.\.?$/ } readdir($dh);
closedir($dh);

# Replace the instance ID dynamically
foreach my $dir (@missions) {
	my $path = "${baseDir}/${dir}";
	if (-d $path) {	
		if ($dir =~ /dayz_([0-9]{1,}).*/) {
			my $id = $1;
			system("perl -pi${editOpts} -e \"s/dayZ_instance\\s=\\s[0-9]*/dayZ_instance = ${id}/\" ${path}/init.sqf");
			print "Set instance id to ${id} for ${path}/init.sqf\n";
		}
		# Clean up init.sqf.bak in Windows only
		if ($^O eq "MSWin32") {
			(my $winPath = $path) =~ s/\//\\/g;
			system("del \"${winPath}\\init.sqf.bak\"");
		}
		system("${repackCmd} -y -p ${path} ./deploy/MPMissions/${dir}.pbo");
	}
}
