// === Pegboard Backing Test: 2x3 Grid ===
// 2 columns, 3 rows
// Total size: 63.5mm wide x 95.25mm tall

include <../pegboard_library.scad>

$fn = 64;

// Grid configuration
cols = 2;
rows = 3;

// Create backing with corner pegs
pegboard_backing(cols, rows, "corners");
