#!/usr/bin/perl
#
# Download community banlist and optionally merge with local bans file
#

use strict;
use warnings;
use Getopt::Long;
use Pod::Usage;
use LWP::Simple;
use List::MoreUtils qw/uniq/;

my ($verbose, $save, $mybans, $banz, $cbl, $dwarden);
my $result = GetOptions(
	"verbose" => \$verbose,
	"save=s" => \$save,
	"mybans=s" => \$mybans,
	"banz" => \$banz,
	"cbl" => \$cbl,
	"dwarden" => \$dwarden
);
usage() unless $result;

sub usage
{
	print "update_bans.pl [options]\n";
	print "Required\n";
	print "    --save       File in which to save bans\n";
	print "Optional\n";
	print "    --mybans     Your local bans file\n";
	print "    --banz       Also download bans from BanZ Union\n";
	print "    --cbl        Also download bans from CBL\n";
	print "    --dwarden    Also download bans from Dwarden\n";
	print "    --verbose    Be verbose\n";
	exit(1);
}

sub debug
{
	my $string = shift;
	defined($verbose) and printf("DEBUG: %s\n", $string);
}

usage unless defined($save);

debug("Downloading bans from community site...");
my $url = "http://dayz-community-banlist.googlecode.com/git/bans/bans.txt";
my $content = get($url);
die("Could not fetch bans from $url\n") unless defined($content);
my @lines = split(/\n/, $content);
debug("  fetched " . scalar(@lines) . " bans");

if($banz)
{
	debug("Downloading bans from BanZ Union...");
	my $url = "http://www.banzunion.com/downloads/?do=download";
	my $content = get($url);
	die("Could not fetch bans from $url\n") unless defined($content);
	my @linesURL = split(/\n+/, $content);
	debug("  fetched " . scalar(@linesURL) . " bans");
	foreach my $lineURL (@linesURL)
	{
		$lineURL =~ s/\r//g;
		length($lineURL) > 10 and push(@lines, $lineURL);
	}
}

if($cbl)
{
    debug("Downloading bans from CBL...");
    my $url = "http://dayz-community-banlist.googlecode.com/git/bans/bans.txt";
    my $content = get($url);
    die("Could not fetch bans from $url\n") unless defined($content);
    my @linesURL = split(/\n+/, $content);
    debug("  fetched " . scalar(@linesURL) . " bans");
    foreach my $lineURL (@linesURL)
    {
		$lineURL =~ s/\r//g;
        length($lineURL) > 10 and push(@lines, $lineURL);
    }
}

if($dwarden)
{
    debug("Downloading bans from Dwarden...");
    my $url = "http://dayz-community-banlist.googlecode.com/git/bans/dwbans.txt";
    my $content = get($url);
    die("Could not fetch bans from $url\n") unless defined($content);
    my @linesURL = split(/\n+/, $content);
    debug("  fetched " . scalar(@linesURL) . " bans");
    foreach my $lineURL (@linesURL)
    {
		$lineURL =~ s/\r//g;
        length($lineURL) > 10 and push(@lines, $lineURL);
    }
}

if($mybans)
{
	debug("Reading bans from $mybans...");
	open(INFILE, $mybans) or die("Unable to open $mybans: $!");
	my $count = 0;
	while(<INFILE>)
	{
		my $line = $_;
		chomp $line;
		$line =~ s/\r//g;
		length($line) > 10 and push(@lines, $line);
		$count++;
	}
	close(INFILE);
	debug("  added $count bans from $mybans");
}

debug("Removing duplicate GUIDs/IPs from list...");
@lines = uniq(sort(@lines));

debug("Writing bans to $save...");
open(OUTFILE, ">$save") or die("Could not open $save for writing: $!");
my $count = 0;
foreach my $line (@lines)
{
	print OUTFILE "$line\n";
	$count++;
}
close(OUTFILE);

debug("  wrote $count bans to $save");
