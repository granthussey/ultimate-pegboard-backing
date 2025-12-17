// === Pegboard Backing Grid: 1x3 ===
// 1 column, 3 rows - ALL pegs at every tile intersection, hooks only at corners

include <../pegboard_library.scad>

$fn = 64;

cols = 1;
rows = 3;

pegboard_backing(cols, rows, "grid_corner_hooks");
