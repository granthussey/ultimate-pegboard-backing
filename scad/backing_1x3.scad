// === Pegboard Backing Test: 1x3 Grid ===
// 1 column, 3 rows
// Total size: 31.75mm wide x 95.25mm tall

include <../pegboard_library.scad>

$fn = 64;

// Grid configuration
cols = 1;
rows = 3;

// Create backing with corner pegs
pegboard_backing(cols, rows, "corners");
