// === Pegboard Backing Lite: 1x2 ===
// 1 column, 2 rows - lightweight with center cutout

include <../pegboard_library.scad>

$fn = 64;

cols = 1;
rows = 2;

pegboard_backing_lite(cols, rows, "corners");
