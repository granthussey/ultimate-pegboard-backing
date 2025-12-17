// === Pegboard Backing Grid Lite: 1x2 ===
// 1 column, 2 rows - grid pegs with corner hooks, lightweight
// NOTE: Identical to 1x2_maxhook_lite (1-column backings have same hooks)

include <../pegboard_library.scad>

$fn = 64;

cols = 1;
rows = 2;

pegboard_backing_lite(cols, rows, "grid_corner_hooks");
