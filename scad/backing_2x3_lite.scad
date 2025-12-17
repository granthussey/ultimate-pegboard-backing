// === Pegboard Backing Lite: 2x3 ===
// 2 columns, 3 rows - lightweight with center cutout

include <../pegboard_library.scad>

$fn = 64;

cols = 2;
rows = 3;

pegboard_backing_lite(cols, rows, "corners");
