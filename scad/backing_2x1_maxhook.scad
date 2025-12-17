// === Pegboard Backing Maxhook: 2x1 ===
// 2 columns, 1 row - ALL pegs, entire back row = hooks

include <../pegboard_library.scad>

$fn = 64;

cols = 2;
rows = 1;

pegboard_backing(cols, rows, "grid");
