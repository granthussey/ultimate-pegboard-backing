// === Pegboard Backing Lite: 1x3 ===
// 1 column, 3 rows - lightweight with center cutout

include <../pegboard_library.scad>

$fn = 64;

cols = 1;
rows = 3;

pegboard_backing_lite(cols, rows, "corners");
