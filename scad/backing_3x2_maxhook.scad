// === Pegboard Backing Maxhook: 3x2 ===
// 3 columns, 2 rows - ALL pegs, entire back row = hooks

include <../pegboard_library.scad>

$fn = 64;

cols = 3;
rows = 2;

pegboard_backing(cols, rows, "grid");
