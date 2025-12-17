// === Pegboard Backing Test: 3x1 Grid ===
// 3 columns, 1 row
// Total size: 95.25mm wide x 31.75mm tall

include <../pegboard_library.scad>

$fn = 64;

// Grid configuration
cols = 3;
rows = 1;

// Create backing with corner pegs
pegboard_backing(cols, rows, "corners");
