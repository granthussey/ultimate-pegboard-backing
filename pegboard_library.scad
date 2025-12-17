// ============================================================================
// PEGBOARD LIBRARY - Tiled Backing System with Smart Beveling
// ============================================================================
// For 1" x 1" pegboards with 1/4" holes
// Supports 1D and 2D tiling with adaptive peg placement
// ============================================================================
//
// QUICK REFERENCE - Peg Patterns for pegboard_backing(cols, rows, pattern):
//   "corners"          - 4 pegs at corners only (default)
//   "perimeter"        - Pegs around all edges at tile boundaries
//   "grid"             - All pegs, back row ALL hooks (_maxhook)
//   "grid_corner_hooks"- All pegs, only corner hooks (_grid)
//   "none"             - No pegs (backing plate only)
//
// IMPORTANT: Multi-tile backings share pegs at boundaries!
//   1x1 = 31.75mm, 2x1 = 58mm (NOT 63.5mm), 3x1 = 84.25mm (NOT 95.25mm)
//
// See README.md for full documentation
// ============================================================================

// === Base Parameters (from UNIVERSAL_BASE_DESIGN.scad - DO NOT CHANGE) ===
TILE_SIZE = 31.75;          // Single tile dimension (mm)
PEG_DIAMETER = 5.5;         // Peg diameter (mm)
BACKING_THICKNESS = 4;      // Backing plate thickness (mm)

// === Derived Spacing (CRITICAL for multi-tile backings) ===
// Adjacent tiles SHARE a peg hole, so spacing between pegs is TILE_SIZE - PEG_DIAMETER
PEG_SPACING = TILE_SIZE - PEG_DIAMETER;  // 26.25mm - actual distance between holes

// === Peg Parameters ===
FRONT_PEG_HEIGHT = 4;       // Plain cylinders (front/top edge)
BACK_PEG_HEIGHT = 3;        // Hook pegs (back/bottom edge)
BEND_RADIUS = 6;            // Hook curve radius
PEG_TO_END = 6;             // Hook extension length
TAPER_END = 4;              // Diameter at hook tip
EDGE_OFFSET = PEG_DIAMETER / 2;  // Distance from edge to peg center (2.75mm)
BEVEL_RADIUS = EDGE_OFFSET;      // Corner rounding radius (2.75mm)

// === Resolution ===
$fn = 32;
CURVE_SEGMENTS = 16;

// ============================================================================
// UTILITY FUNCTIONS - Correct tiled dimensions
// ============================================================================

// Returns the total width of a tiled backing (accounts for shared pegs)
function backing_width(cols) = TILE_SIZE + (cols - 1) * PEG_SPACING;

// Returns the total height of a tiled backing (accounts for shared pegs)
function backing_height(rows) = TILE_SIZE + (rows - 1) * PEG_SPACING;

// Returns the center X position for centering objects
function backing_center_x(cols) = backing_width(cols) / 2;

// Returns the center Y position for centering objects
function backing_center_y(rows) = backing_height(rows) / 2;

// Returns peg X position for column index i (0 to cols)
function peg_x(i, cols) = EDGE_OFFSET + i * PEG_SPACING;

// Returns peg Y position for row index j (0 to rows)
function peg_y(j, rows) = EDGE_OFFSET + j * PEG_SPACING;

// ============================================================================
// CORE MODULES - Backing Plates
// ============================================================================

// Creates a backing plate with correct tiled dimensions and selective corner rounding
module tiled_backing_plate(cols, rows, bevel_all = true) {
    w = backing_width(cols);
    h = backing_height(rows);
    z = BACKING_THICKNESS;
    r = bevel_all ? BEVEL_RADIUS : 0.01;

    hull() {
        // Four corners
        translate([r, r, 0])
            cylinder(h = z, r = r);
        translate([w - r, r, 0])
            cylinder(h = z, r = r);
        translate([r, h - r, 0])
            cylinder(h = z, r = r);
        translate([w - r, h - r, 0])
            cylinder(h = z, r = r);
    }
}

// ============================================================================
// CORE MODULES - Pegs
// ============================================================================

// Plain cylindrical peg (for front edge)
module plain_peg(height = FRONT_PEG_HEIGHT) {
    cylinder(h = height, d = PEG_DIAMETER);
}

// Tapered peg with hook (for back edge)
module tapered_peg_and_hook(peg_height = BACK_PEG_HEIGHT) {
    total_segments = CURVE_SEGMENTS + 8;

    // Tapered peg (vertical portion)
    for (i = [0 : 7]) {
        z1 = peg_height * i / 8;
        z2 = peg_height * (i + 1) / 8;
        d1 = PEG_DIAMETER - (PEG_DIAMETER - TAPER_END) * i / total_segments;
        d2 = PEG_DIAMETER - (PEG_DIAMETER - TAPER_END) * (i + 1) / total_segments;

        hull() {
            translate([0, 0, z1]) cylinder(h = 0.01, d = d1);
            translate([0, 0, z2]) cylinder(h = 0.01, d = d2);
        }
    }

    // Tapered curve (hook portion)
    for (i = [0 : CURVE_SEGMENTS - 1]) {
        angle1 = 90 * i / CURVE_SEGMENTS;
        angle2 = 90 * (i + 1) / CURVE_SEGMENTS;
        seg_index1 = 8 + i;
        seg_index2 = 8 + i + 1;
        d1 = PEG_DIAMETER - (PEG_DIAMETER - TAPER_END) * seg_index1 / total_segments;
        d2 = PEG_DIAMETER - (PEG_DIAMETER - TAPER_END) * seg_index2 / total_segments;

        translate([0, 0, peg_height])
            rotate([90, 0, -90])
                translate([-BEND_RADIUS, 0, 0])
                    hull() {
                        rotate([0, 0, angle1])
                            translate([BEND_RADIUS, 0, 0])
                                sphere(d = d1);
                        rotate([0, 0, angle2])
                            translate([BEND_RADIUS, 0, 0])
                                sphere(d = d2);
                    }
    }
}

// ============================================================================
// PEG PLACEMENT PATTERNS (using correct PEG_SPACING)
// ============================================================================

// Places pegs at all four corners of the tiled assembly
// Front corners get plain pegs, back corners get hooks
module place_pegs_corners(cols, rows) {
    w = backing_width(cols);
    h = backing_height(rows);

    // Front corners (plain pegs)
    translate([EDGE_OFFSET, EDGE_OFFSET, BACKING_THICKNESS])
        plain_peg();
    translate([w - EDGE_OFFSET, EDGE_OFFSET, BACKING_THICKNESS])
        plain_peg();

    // Back corners (hook pegs)
    translate([EDGE_OFFSET, h - EDGE_OFFSET, BACKING_THICKNESS])
        tapered_peg_and_hook();
    translate([w - EDGE_OFFSET, h - EDGE_OFFSET, BACKING_THICKNESS])
        tapered_peg_and_hook();
}

// Places pegs around the perimeter at each peg position
// Front edge: plain pegs, Back edge: hook pegs
module place_pegs_perimeter(cols, rows) {
    w = backing_width(cols);
    h = backing_height(rows);

    // Front edge (plain pegs at each position)
    for (i = [0 : cols]) {
        x = peg_x(i, cols);
        translate([x, EDGE_OFFSET, BACKING_THICKNESS])
            plain_peg();
    }

    // Back edge (hook pegs at each position)
    for (i = [0 : cols]) {
        x = peg_x(i, cols);
        translate([x, h - EDGE_OFFSET, BACKING_THICKNESS])
            tapered_peg_and_hook();
    }

    // Left edge (intermediate rows only)
    for (j = [1 : rows - 1]) {
        y = peg_y(j, rows);
        translate([EDGE_OFFSET, y, BACKING_THICKNESS])
            plain_peg();
    }

    // Right edge (intermediate rows only)
    for (j = [1 : rows - 1]) {
        y = peg_y(j, rows);
        translate([w - EDGE_OFFSET, y, BACKING_THICKNESS])
            plain_peg();
    }
}

// Places pegs in a grid pattern at each position
// Back row gets hooks, all others get plain pegs
module place_pegs_grid(cols, rows) {
    for (i = [0 : cols]) {
        for (j = [0 : rows]) {
            x = peg_x(i, cols);
            y = peg_y(j, rows);

            // Back row gets hooks, others get plain
            translate([x, y, BACKING_THICKNESS]) {
                if (j == rows) {
                    tapered_peg_and_hook();
                } else {
                    plain_peg();
                }
            }
        }
    }
}

// Places pegs in a grid pattern with hooks ONLY at the 4 corners
// Back corners get hooks, all other positions get plain pegs
module place_pegs_grid_corner_hooks(cols, rows) {
    for (i = [0 : cols]) {
        for (j = [0 : rows]) {
            x = peg_x(i, cols);
            y = peg_y(j, rows);

            // Only back row corners (j==rows AND (i==0 OR i==cols)) get hooks
            is_back_corner = (j == rows) && (i == 0 || i == cols);

            translate([x, y, BACKING_THICKNESS]) {
                if (is_back_corner) {
                    tapered_peg_and_hook();
                } else {
                    plain_peg();
                }
            }
        }
    }
}

// ============================================================================
// COMPLETE BACKING ASSEMBLIES
// ============================================================================

// Creates a complete pegboard backing with pegs
// peg_pattern: "corners", "perimeter", "grid", "grid_corner_hooks", or "none"
module pegboard_backing(cols = 1, rows = 1, peg_pattern = "corners") {
    // Backing plate with correct tiled dimensions
    tiled_backing_plate(cols, rows);

    // Add pegs based on pattern
    if (peg_pattern == "corners") {
        place_pegs_corners(cols, rows);
    } else if (peg_pattern == "perimeter") {
        place_pegs_perimeter(cols, rows);
    } else if (peg_pattern == "grid") {
        place_pegs_grid(cols, rows);
    } else if (peg_pattern == "grid_corner_hooks") {
        place_pegs_grid_corner_hooks(cols, rows);
    }
    // "none" adds no pegs
}

// ============================================================================
// EXAMPLE USAGE (uncomment to test)
// ============================================================================

// Single tile (1x1) - standard backing: 31.75 x 31.75mm
// pegboard_backing(1, 1, "corners");

// Wide backing (2x1): 58 x 31.75mm (NOT 63.5mm!)
// pegboard_backing(2, 1, "corners");

// Wide backing (3x1): 84.25 x 31.75mm
// pegboard_backing(3, 1, "perimeter");

// Tall backing (1x3): 31.75 x 84.25mm
// pegboard_backing(1, 3, "perimeter");

// Square backing (2x2): 58 x 58mm
// pegboard_backing(2, 2, "corners");

// Large grid (3x3) - maximum support: 84.25 x 84.25mm
// pegboard_backing(3, 3, "grid");
