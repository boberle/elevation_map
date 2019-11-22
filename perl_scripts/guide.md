# How to create an elevation map?

This is the procedure to follow to get an combined shaded relief of several srtm tiles.

(1) Determine the part you need (coordinates), but be aware that the file must not be too big.  You can split it and combine it in Gimp later (prepare some overlapping for the shaded relief).

(2) Use `get_tiles_list.pl` to produce the `tiles_list` file which contains all the tiles coordinates.

(3) Download using `download_hgt_files.pl`.  The resulting hgt are in `hgt_files`.

(4) Run `convert_to_srf.pl` to get a `ls_scripts/convert_to_srf.lsc` to be executed in the [LandScript Editor](http://www.staff.city.ac.uk/~jwo/landserf/download/)

(5) Run a `combine_srf_files.pl` to get a `ls_scripts/combine_srf_files.lsc` to be executed.  DO NOT FORGET TO CHANGE THE NAME OF THE COMBINED IMAGE TO PREVENT SOME OVERWRITING!  This will save the combined image in `combined_files`.

(6) Now, restart for an other set of tiles, that is for an other part of the big final image.  (If there is only one part, skip this.) Save all the parts in the `combined_files`.

(7) Run `get_min_max.pl` to get a `ls_scripts/get_min_max.lsc` to be executed.  This will show the min and max height of all the `combined_files/*` files.  Pick the lowest and the highest.

(8) Then open the `export_to_png.lsc` (no perl script here).  Edit the source and target files, the vertical exageration and the min and max height (this is used to calculate the range of color).  Execute the script manually for each combined part.

(9) In Gimp, merge all the part to get the final image.  If there is a some overlapping, the shaded relief will be fine.

# Example with Greece


(1) You must divide the map into four parts, with the following coordinates:

```
     NORTH-EAST      NORTH-WEST
         42              42
      19    25        25    31 
         38              38

     SOUTH-EAST      SOUTH-WEST
         38              38
      19    25        25    31
         34              34
```

(2) For each part, make a combined `.srf` file, as indicated above, and then make a png, using the following parameters:

- min height: -70
- max height: 3060
- vExag: 3 (for example)

(3) Combine all the parts.  A SRTM tile has a size of 1201x1201 pixels, with one overlapping each other at the edge.  Our map has 13 x 9 tiles, so:

- width  = 13 tiles = 12 * 1200 + 1201 = 15601 pixels
- height =  9 tiles =  9 * 1200 + 1201 = 10801 pixels

(4) Note that the SW part will have a little problem: the wester srtm tile is not here, because it's only sea.  So, open this part in Gimp, resize the canvas by defining the new total width to 8401 pixels, setting the backgroun to transparent, and request an x-offset for the image at 1200.

(5) In Gimp, create a 15601*10801 pixels image. Importe the four parts.  Use the alignement tool, and dispath the parts in their correct coins of the final image byt just clicking on the arrows in the tool bar.

(6)  There is an overlapping.  It's important to understand that, for the shaded relief, the sun at NE, and so there is no problem for the SW part of each part (because there is information at NE to correctly calculate the shaded relief).  So, you must use the overlapping in this manner:

- Set the order of the layer/parts in this order:
   - 4: NW (top)
   - 3: NE
   - 2: SW
   - 1: SE (bottom)
Use the eraser tool (with a smooth shape) to remove the edge of the upper layer.  That is:
   - 4: NW: erase the S and E edges
   - 3: NE: erase the S       edge
   - 2: SW: erase the       E edge
   - 1: SE: erase nothing

