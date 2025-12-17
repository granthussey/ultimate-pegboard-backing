// === Pegboard Backing Maxhook Lite: 3x1 ===
// 3 columns, 1 row - all pegs, all back hooks, lightweight

include <../pegboard_library.scad>

$fn = 64;

cols = 3;
rows = 1;

pegboard_backing_lite(cols, rows, "grid");
