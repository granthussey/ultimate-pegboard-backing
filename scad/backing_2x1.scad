// === Pegboard Backing Test: 2x1 Grid ===
// 2 columns, 1 row
// Total size: 63.5mm wide x 31.75mm tall

include <../pegboard_library.scad>

$fn = 64;

// Grid configuration
cols = 2;
rows = 1;

// Create backing with corner pegs
pegboard_backing(cols, rows, "corners");
