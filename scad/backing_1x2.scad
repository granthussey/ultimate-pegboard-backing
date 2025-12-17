// === Pegboard Backing Test: 1x2 Grid ===
// 1 column, 2 rows
// Total size: 31.75mm wide x 63.5mm tall

include <../pegboard_library.scad>

$fn = 64;

// Grid configuration
cols = 1;
rows = 2;

// Create backing with corner pegs
pegboard_backing(cols, rows, "corners");
