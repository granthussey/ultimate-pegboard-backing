// === Pegboard Backing Lite: 3x1 ===
// 3 columns, 1 row - lightweight with center cutout

include <../pegboard_library.scad>

$fn = 64;

cols = 3;
rows = 1;

pegboard_backing_lite(cols, rows, "corners");
