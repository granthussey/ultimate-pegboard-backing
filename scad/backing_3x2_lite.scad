// === Pegboard Backing Lite: 3x2 ===
// 3 columns, 2 rows - lightweight with center cutout

include <../pegboard_library.scad>

$fn = 64;

cols = 3;
rows = 2;

pegboard_backing_lite(cols, rows, "corners");
