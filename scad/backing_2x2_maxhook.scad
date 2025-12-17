// === Pegboard Backing Maxhook: 2x2 ===
// 2 columns, 2 rows - ALL pegs, entire back row = hooks

include <../pegboard_library.scad>

$fn = 64;

cols = 2;
rows = 2;

pegboard_backing(cols, rows, "grid");
