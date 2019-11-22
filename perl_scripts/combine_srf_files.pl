#!/usr/bin/perl
use strict;
use warnings;

########################################################################
# Write a ls_scripts/combine_srf_file.lsc that creates a combined srf
# file with all the sfr files of srf_files that are in the tiles_list.
# File in srf_files that are not in the tiles_list are ignored.  If a
# file is in the tiles_list, but has no corresponding srf file, it
# will be ignored.
########################################################################

########################################################################
# CONFIG

# absolute path of dir that contain this script.
my $PATH = '/home/bruno/hgt';

# relative to $PATH
my $OUTPUT = 'combined_files/combine.srf';

########################################################################

die "*** the target file $PATH/$OUTPUT already exists! ***\n"
   if -e "$PATH/$OUTPUT";

open my $lsc, '>ls_scripts/combine_srf_files.lsc'
   or die "*** can't open the script ***\n";

open my $fh, 'tiles_list' or die "*** can't open tiles_list ***\n";

my $first = 1;

while (my $tile = <$fh>) {

   chomp $tile;

   print "Adding tile $tile...\n";

   unless (-f "srf_files/$tile.srf") {
      print "The .srf file doesn't exists...\n";
      next;
   }

   if ($first) {

      print $lsc <<"END";
version(1.0);

baseDir = "$PATH/srf_files/";
raster = open(baseDir & "$tile.srf");

END
      $first = 0;

   } else {

      print $lsc <<"END";
raster = combine(raster_,open(baseDir & "$tile.srf"));
END

   }

} # while

print $lsc <<"END";
save(raster,"$PATH/$OUTPUT");
END

close $lsc or die "*** can't open the script ***\n";

close $fh or die "*** can't close tiles_list ***\n";


#/* vim: set tabstop=3 shiftwidth=3 expandtab: */
