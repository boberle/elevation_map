#!/usr/bin/perl
use strict;
use warnings;

########################################################################
# Write a ls_scripts/get_min_max.lsc that displays the min and max
# height for each file in combined_files.
########################################################################

########################################################################
# CONFIG

# absolute path of dir that contain this script.
my $PATH = '/home/bruno/hgt';

########################################################################

open my $lsc, '>ls_scripts/get_min_max.lsc'
   or die "*** can't open the script ***\n";

print $lsc <<"END";
version(1.0);
END

for my $file (sort glob('combined_files/*.srf')) {

   print "Adding tile $file...\n";

	print $lsc <<"END";
raster = open("$PATH/$file");
echo("\\nmin is: " & info(raster,"min") & ", ");
echo("max is: " & info(raster,"max"));

END

} # for

close $lsc or die "*** can't open the script ***\n";

#/* vim: set tabstop=3 shiftwidth=3 expandtab: */
