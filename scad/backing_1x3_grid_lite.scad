// === Pegboard Backing Grid Lite: 1x3 ===
// 1 column, 3 rows - grid pegs with corner hooks, lightweight
// NOTE: Identical to 1x3_maxhook_lite (1-column backings have same hooks)

include <../pegboard_library.scad>

$fn = 64;

cols = 1;
rows = 3;

pegboard_backing_lite(cols, rows, "grid_corner_hooks");
