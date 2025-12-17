// === Pegboard Backing Grid Lite: 3x1 ===
// 3 columns, 1 row - grid pegs with corner hooks, lightweight

include <../pegboard_library.scad>

$fn = 64;

cols = 3;
rows = 1;

pegboard_backing_lite(cols, rows, "grid_corner_hooks");
