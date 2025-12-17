// === Pegboard Backing with Support Lite: 3x1 Grid ===
// 3 columns, 1 row - with extra middle hook peg for support, lightweight
// Extra peg at middle column on back edge

include <../pegboard_library.scad>

$fn = 64;

// Grid configuration
cols = 3;
rows = 1;

// Create lite backing with corner pegs
pegboard_backing_lite(cols, rows, "corners");

// Add extra support peg at middle column on back edge
// Middle peg uses peg_x(1, cols) = EDGE_OFFSET + 1 * PEG_SPACING = 29mm
// Back edge uses backing_height(rows) - EDGE_OFFSET
translate([peg_x(1, cols), backing_height(rows) - EDGE_OFFSET, BACKING_THICKNESS])
    tapered_peg_and_hook();
