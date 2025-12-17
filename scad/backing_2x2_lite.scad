// === Pegboard Backing Lite: 2x2 ===
// 2 columns, 2 rows - lightweight with center cutout

include <../pegboard_library.scad>

$fn = 64;

cols = 2;
rows = 2;

pegboard_backing_lite(cols, rows, "corners");
