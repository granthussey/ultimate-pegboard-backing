// === Pegboard Backing Grid Lite: 2x2 ===
// 2 columns, 2 rows - grid pegs with corner hooks, lightweight

include <../pegboard_library.scad>

$fn = 64;

cols = 2;
rows = 2;

pegboard_backing_lite(cols, rows, "grid_corner_hooks");
