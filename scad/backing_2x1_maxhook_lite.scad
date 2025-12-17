// === Pegboard Backing Maxhook Lite: 2x1 ===
// 2 columns, 1 row - all pegs, all back hooks, lightweight

include <../pegboard_library.scad>

$fn = 64;

cols = 2;
rows = 1;

pegboard_backing_lite(cols, rows, "grid");
