// === Pegboard Backing Grid: 3x2 ===
// 3 columns, 2 rows - ALL pegs at every tile intersection, hooks only at corners

include <../pegboard_library.scad>

$fn = 64;

cols = 3;
rows = 2;

pegboard_backing(cols, rows, "grid_corner_hooks");
