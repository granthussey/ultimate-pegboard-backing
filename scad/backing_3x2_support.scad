// === Pegboard Backing with Support: 3x2 Grid ===
// 3 columns, 2 rows - with extra middle hook peg for support
// Extra peg at middle column on back edge

include <../pegboard_library.scad>

$fn = 64;

// Grid configuration
cols = 3;
rows = 2;

// Create backing with corner pegs
pegboard_backing(cols, rows, "corners");

// Add extra support peg at middle column on back edge
// Middle peg uses peg_x(1, cols) = EDGE_OFFSET + 1 * PEG_SPACING = 29mm
// Back edge uses backing_height(rows) - EDGE_OFFSET
translate([peg_x(1, cols), backing_height(rows) - EDGE_OFFSET, BACKING_THICKNESS])
    tapered_peg_and_hook();
