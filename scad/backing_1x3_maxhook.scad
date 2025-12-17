// === Pegboard Backing Maxhook: 1x3 ===
// 1 column, 3 rows - ALL pegs, entire back row = hooks

include <../pegboard_library.scad>

$fn = 64;

cols = 1;
rows = 3;

pegboard_backing(cols, rows, "grid");
