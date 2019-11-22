#!/usr/bin/perl
use strict;
use warnings;

########################################################################
# Print in the tiles_list file the list of all tiles, in the respect
# of the srtm3 naming convention, that match the area described below.
########################################################################

########################################################################
# CONFIG

# limits of the area in the order: n lat, w long, e long, s lat.
# For latitude:    neg value = south,      pos value = north
# For longitude:   neg value = east,       pos value = west
my ($N_LAT, $W_LONG, $E_LONG, $S_LAT) = qw(
         36
      -113     -111 
         36
);

# seattle
#         48
#      -124     -121 
#         47

# lake tahoe
#         39
#      -121     -120 
#         38

# grand canyon
#         36
#      -113     -111 
#         36

# honolulu
#         22
#      -159     -157 
#         21

# corsica:
#         43
#      8     10 
#         41

# greece
#         41
#      19    29 
#         34

# greece (4 parts)
#
#         42              42
#      19    25        25    31 
#         38              38
#
#         38              38
#      19    25        25    31
#         34              34

# roman empire:
#         60
#     -11    45
#         24

########################################################################


die "*** longitude error ***\n" unless $W_LONG <= $E_LONG;
die "*** latitude error ***\n" unless $S_LAT <= $N_LAT;

open my $fh, '>tiles_list' or die "*** can't close file ***\n";

for my $lat ($S_LAT..$N_LAT) {

   my $lat_type = ($lat >= 0 ? 'N' : 'S');
   my $lat_value = abs($lat);

   for my $long ($W_LONG..$E_LONG) {

      my $long_type = ($long >= 0 ? 'E' : 'W');
      my $long_value = abs($long);

      my $tilename = sprintf('%s%02d%s%03d', $lat_type,
         $lat_value, $long_type, $long_value);

      print $fh $tilename, "\n";

   }

}

close $fh or die "*** can't close file ***\n";

#/* vim: set tabstop=3 shiftwidth=3 expandtab: */
