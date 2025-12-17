// === Pegboard Backing Test: 2x2 Grid ===
// 2 columns, 2 rows
// Total size: 63.5mm wide x 63.5mm tall

include <../pegboard_library.scad>

$fn = 64;

// Grid configuration
cols = 2;
rows = 2;

// Create backing with corner pegs
pegboard_backing(cols, rows, "corners");
