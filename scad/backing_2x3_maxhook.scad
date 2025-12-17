// === Pegboard Backing Maxhook: 2x3 ===
// 2 columns, 3 rows - ALL pegs, entire back row = hooks

include <../pegboard_library.scad>

$fn = 64;

cols = 2;
rows = 3;

pegboard_backing(cols, rows, "grid");
