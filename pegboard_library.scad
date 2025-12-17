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
//   1x1 = 31.75mm, 2x1 = 57.15mm, 3x1 = 82.55mm
//
// See README.md for full documentation
// ============================================================================

// === Base Parameters (from UNIVERSAL_BASE_DESIGN.scad - DO NOT CHANGE) ===
TILE_SIZE = 31.75;          // Single tile dimension (mm)
PEG_DIAMETER = 5.5;         // Peg diameter (mm)
BACKING_THICKNESS = 4;      // Backing plate thickness (mm)

// === Peg Spacing (CRITICAL for multi-tile backings) ===
// Standard pegboard hole spacing is exactly 1 inch (25.4mm) center-to-center
PEG_SPACING = 25.4;  // 1 inch - actual pegboard hole spacing

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
// Uses peg_x/peg_y to ensure alignment with actual pegboard holes
module place_pegs_corners(cols, rows) {
    // Corner positions using actual pegboard hole spacing
    x_left = peg_x(0, cols);
    x_right = peg_x(cols, cols);
    y_front = peg_y(0, rows);
    y_back = peg_y(rows, rows);

    // Front corners (plain pegs)
    translate([x_left, y_front, BACKING_THICKNESS])
        plain_peg();
    translate([x_right, y_front, BACKING_THICKNESS])
        plain_peg();

    // Back corners (hook pegs)
    translate([x_left, y_back, BACKING_THICKNESS])
        tapered_peg_and_hook();
    translate([x_right, y_back, BACKING_THICKNESS])
        tapered_peg_and_hook();
}

// Places pegs around the perimeter at each peg position
// Front edge: plain pegs, Back edge: hook pegs
// Uses peg_x/peg_y to ensure alignment with actual pegboard holes
module place_pegs_perimeter(cols, rows) {
    // Edge positions using actual pegboard hole spacing
    x_left = peg_x(0, cols);
    x_right = peg_x(cols, cols);
    y_front = peg_y(0, rows);
    y_back = peg_y(rows, rows);

    // Front edge (plain pegs at each position)
    for (i = [0 : cols]) {
        x = peg_x(i, cols);
        translate([x, y_front, BACKING_THICKNESS])
            plain_peg();
    }

    // Back edge (hook pegs at each position)
    for (i = [0 : cols]) {
        x = peg_x(i, cols);
        translate([x, y_back, BACKING_THICKNESS])
            tapered_peg_and_hook();
    }

    // Left edge (intermediate rows only)
    for (j = [1 : rows - 1]) {
        y = peg_y(j, rows);
        translate([x_left, y, BACKING_THICKNESS])
            plain_peg();
    }

    // Right edge (intermediate rows only)
    for (j = [1 : rows - 1]) {
        y = peg_y(j, rows);
        translate([x_right, y, BACKING_THICKNESS])
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
// LITE BACKING PLATES (with lightening holes for faster printing)
// ============================================================================

// Frame width for lite backings - must cover peg bases
LITE_FRAME_WIDTH = 6;  // 6mm frame around edges
LITE_CUTOUT_RADIUS = 2;  // Corner radius on cutouts

// Creates a backing plate with center cutout for faster printing
// For corner-only patterns, use a single large cutout
module tiled_backing_plate_lite(cols, rows) {
    w = backing_width(cols);
    h = backing_height(rows);
    z = BACKING_THICKNESS;
    frame = LITE_FRAME_WIDTH;
    cr = LITE_CUTOUT_RADIUS;

    // Cutout dimensions
    cut_w = w - 2 * frame;
    cut_h = h - 2 * frame;

    // Only add cutout if there's room (backing must be large enough)
    if (cut_w > 2 * cr && cut_h > 2 * cr) {
        difference() {
            tiled_backing_plate(cols, rows);

            // Center cutout with rounded corners
            translate([frame, frame, -0.1])
                hull() {
                    translate([cr, cr, 0])
                        cylinder(h = z + 0.2, r = cr);
                    translate([cut_w - cr, cr, 0])
                        cylinder(h = z + 0.2, r = cr);
                    translate([cr, cut_h - cr, 0])
                        cylinder(h = z + 0.2, r = cr);
                    translate([cut_w - cr, cut_h - cr, 0])
                        cylinder(h = z + 0.2, r = cr);
                }
        }
    } else {
        // Too small for cutout, use solid plate
        tiled_backing_plate(cols, rows);
    }
}

// Peg base radius - enough to support peg plus some margin
PEG_BASE_RADIUS = PEG_DIAMETER / 2 + 2;  // 4.75mm radius

// Creates a backing plate with cutout BUT preserves material under all peg positions
// Use this for grid patterns where interior pegs exist
module tiled_backing_plate_lite_with_peg_bases(cols, rows) {
    w = backing_width(cols);
    h = backing_height(rows);
    z = BACKING_THICKNESS;
    frame = LITE_FRAME_WIDTH;
    cr = LITE_CUTOUT_RADIUS;

    // Cutout dimensions
    cut_w = w - 2 * frame;
    cut_h = h - 2 * frame;

    // Only add cutout if there's room
    if (cut_w > 2 * cr && cut_h > 2 * cr) {
        union() {
            difference() {
                tiled_backing_plate(cols, rows);

                // Center cutout with rounded corners
                translate([frame, frame, -0.1])
                    hull() {
                        translate([cr, cr, 0])
                            cylinder(h = z + 0.2, r = cr);
                        translate([cut_w - cr, cr, 0])
                            cylinder(h = z + 0.2, r = cr);
                        translate([cr, cut_h - cr, 0])
                            cylinder(h = z + 0.2, r = cr);
                        translate([cut_w - cr, cut_h - cr, 0])
                            cylinder(h = z + 0.2, r = cr);
                    }
            }

            // Add peg bases at all interior peg positions
            for (i = [0 : cols]) {
                for (j = [0 : rows]) {
                    x = peg_x(i, cols);
                    y = peg_y(j, rows);
                    // Check if this peg is in the cutout area (not on the frame)
                    if (x > frame && x < w - frame && y > frame && y < h - frame) {
                        translate([x, y, 0])
                            cylinder(h = z, r = PEG_BASE_RADIUS);
                    }
                }
            }
        }
    } else {
        // Too small for cutout, use solid plate
        tiled_backing_plate(cols, rows);
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

// Creates a lightweight pegboard backing with center cutout for faster printing
// For lite versions, pegs are only placed on the outer frame (no interior pegs)
// peg_pattern: "corners", "perimeter", "grid", "grid_corner_hooks", or "none"
// Note: "grid" and "grid_corner_hooks" become "perimeter" for lite (no interior material)
module pegboard_backing_lite(cols = 1, rows = 1, peg_pattern = "corners") {
    // Always use simple cutout - no interior pegs for lite versions
    tiled_backing_plate_lite(cols, rows);

    // Add pegs based on pattern
    // For lite versions, grid patterns become perimeter (only pegs where frame exists)
    if (peg_pattern == "corners") {
        place_pegs_corners(cols, rows);
    } else if (peg_pattern == "perimeter" || peg_pattern == "grid" || peg_pattern == "grid_corner_hooks") {
        // All grid-like patterns become perimeter for lite - only edge pegs
        place_pegs_perimeter(cols, rows);
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
