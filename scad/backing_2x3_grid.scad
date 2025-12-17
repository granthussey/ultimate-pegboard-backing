// === Pegboard Backing Grid: 2x3 ===
// 2 columns, 3 rows - ALL pegs at every tile intersection, hooks only at corners

include <../pegboard_library.scad>

$fn = 64;

cols = 2;
rows = 3;

pegboard_backing(cols, rows, "grid_corner_hooks");
