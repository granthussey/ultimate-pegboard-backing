// === Pegboard Backing Maxhook: 3x1 ===
// 3 columns, 1 row - ALL pegs, entire back row = hooks

include <../pegboard_library.scad>

$fn = 64;

cols = 3;
rows = 1;

pegboard_backing(cols, rows, "grid");
