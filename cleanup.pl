#!/usr/bin/perl

use Filesys::Df;
use File::Path;
#use Data::Dumper;

# Folder to delete old rls from.
my $folder = "/home/tomme/Uploads/";
# Only delete if under $minimum GB free space
my $minimum = 30;
# Delete files that are over $days old
my $days = 60;

my $df = df("/");

if (defined($df)) {
	my $avail = $df->{'bavail'} / 1024 / 1024;
	#print $avail."\n";
	if ($avail < $minimum) { # Less than X GB free space
		opendir(my $DIR, $folder) or die($!);
		while (my $file = readdir($DIR)) {
			next if ($file =~ /^\.{1,2}$/);
			my $path = $folder.$file;
			if ((-M $path) > $days) {
				rmtree($path) if (-d $path);
				unlink($path) if (-f $path);
				print "FOLDER: ".$path."\n" if (-d $path);
				print "FILE: ".$path."\n" if (-f $path);
			}
		}
	}
} else {
	print STDERR "df not handeled!";
}