// === Pegboard Backing Maxhook: 1x2 ===
// 1 column, 2 rows - ALL pegs, entire back row = hooks

include <../pegboard_library.scad>

$fn = 64;

cols = 1;
rows = 2;

pegboard_backing(cols, rows, "grid");
