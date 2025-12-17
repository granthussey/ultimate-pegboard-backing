// === Pegboard Backing Grid: 3x1 ===
// 3 columns, 1 row - ALL pegs at every tile intersection, hooks only at corners

include <../pegboard_library.scad>

$fn = 64;

cols = 3;
rows = 1;

pegboard_backing(cols, rows, "grid_corner_hooks");
