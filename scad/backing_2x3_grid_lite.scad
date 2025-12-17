// === Pegboard Backing Grid Lite: 2x3 ===
// 2 columns, 3 rows - grid pegs with corner hooks, lightweight

include <../pegboard_library.scad>

$fn = 64;

cols = 2;
rows = 3;

pegboard_backing_lite(cols, rows, "grid_corner_hooks");
