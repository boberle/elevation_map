#!/usr/bin/perl
use strict;
use warnings;

########################################################################
# Create a ls_scripts/convert_to_srf.lsc that convert all hgt files for
# tiles in tiles_list to srf files.  Voids are removed.  After that,
# you must run the script in LS.
#
# If the hgt file doesn't exist, the command for that file won't be
# added.  If the srf file already exists, it will not be reconverted.
########################################################################

########################################################################
# CONFIG

# absolute path of dir that contain this script.
my $PATH = '/home/bruno/hgt';

# lsc template to convert one file (%t replaced by the tile name
my $FILE_TEMPLATE .= <<"END";
raster = open("$PATH/hgt_files/%t.hgt");
raster = removevoids(raster_);
save(raster,"$PATH/srf_files/%t.srf");

END

# preamble of the lsc
my $PREAMBLE = <<"END";
version(1.0);

END

########################################################################

open my $lsc, '>ls_scripts/convert_to_srf.lsc'
   or die "*** can't open the script ***\n";

open my $fh, 'tiles_list' or die "*** can't open tiles_list ***\n";

print $lsc $PREAMBLE;

while (my $tile = <$fh>) {

   chomp $tile;

   print "Adding tile $tile...\n";

   unless (-f "hgt_files/$tile.hgt") {
      print "The .hgt file doesn't exists...\n";
      next;
   }

   if (-f "srf_files/$tile.srf") {
      print "The .srf file already exists...\n";
      next;
   }

   (my $code = $FILE_TEMPLATE) =~ s/\%t/$tile/eg;

   print $lsc $code;

} # while

close $lsc or die "*** can't open the script ***\n";

close $fh or die "*** can't close tiles_list ***\n";


#/* vim: set tabstop=3 shiftwidth=3 expandtab: */
