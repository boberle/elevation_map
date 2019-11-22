#!/usr/bin/perl

use strict;
use warnings;

########################################################################
# Downloads the srtm3 hgt files if there are not already in the
# hgt_files dir.  The tiles to download are read from the tiles_list
# file.  The zip file are unzip and the zip files are removed.
#
# Note that a tile without any land has no corresponding file, so
# nothing can be downloaded...
########################################################################

########################################################################
# CONFIG

#my $URL = 'http://dds.cr.usgs.gov/srtm/version2_1/SRTM3/';
my $URL = 'http://dds.cr.usgs.gov/srtm/version2_1/SRTM1/';

# all these continents will be testes (because tiles are distributed
# in dirs according to the continent, but we can't deduced the
# continent from the tile name)
#my @CONTINENTS = qw(Eurasia Africa Islands North_America
#   South_America);
my @CONTINENTS = qw(
Region_01
Region_02
Region_03
Region_04
Region_05
Region_06
Region_07
);

my $DRY = 0;

########################################################################

# counters
my $success = 0;
my $already = 0;
my $failure = 0;

die "*** no hgt_files dir ***\n" unless -d 'hgt_files';

open my $fh, 'tiles_list' or die "*** can't open tiles_list ***\n";

while (my $tile = <$fh>) {

	chomp $tile;

   if (-f "hgt_files/$tile.hgt") {
      
      print "Tile $tile already here...\n";
      $already++;
      next;
   }

   print "Downloading $tile...\n";

   my $ok = 0;

   for (@CONTINENTS) {

      my $url = "$URL/$_/$tile.hgt.zip";
      my $zip = "$tile.hgt.zip";
      my $hgt = "$tile.hgt";

      print "Trying continent $_ at $url...\n";

      my $cmd = "wget '$url' && unzip $zip && rm $zip "
         ."&& mv $hgt hgt_files";

		print "The command is: $cmd\n";

      if ($DRY or !system($cmd)) {
         $success++;
         print "Tile $tile: successfully downloaded ($url)\n";
         $ok = 1;
         last;
      }

   } # for continents

   unless ($ok) {
      print "/!\\  Tile $tile: FAILED TO DOWNLOAD!\n";
      $failure++;
   }

} # while


print "STATS:\n";
printf " -- Success: %d\n", $success;
printf " -- Already in data: %d\n", $already;
printf " -- Failure: %d\n", $failure;

close $fh or die "*** can't close tiles_list ***\n";

#/* vim: set tabstop=3 shiftwidth=3 expandtab: */
