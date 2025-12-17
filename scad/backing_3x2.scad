// === Pegboard Backing Test: 3x2 Grid ===
// 3 columns, 2 rows
// Total size: 95.25mm wide x 63.5mm tall

include <../pegboard_library.scad>

$fn = 64;

// Grid configuration
cols = 3;
rows = 2;

// Create backing with corner pegs
pegboard_backing(cols, rows, "corners");
