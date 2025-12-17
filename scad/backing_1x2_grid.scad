// === Pegboard Backing Grid: 1x2 ===
// 1 column, 2 rows - ALL pegs at every tile intersection, hooks only at corners

include <../pegboard_library.scad>

$fn = 64;

cols = 1;
rows = 2;

pegboard_backing(cols, rows, "grid_corner_hooks");
