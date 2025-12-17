// === Pegboard Backing Lite: 2x1 ===
// 2 columns, 1 row - lightweight with center cutout

include <../pegboard_library.scad>

$fn = 64;

cols = 2;
rows = 1;

pegboard_backing_lite(cols, rows, "corners");
