// Simple Hook - 1x1 Standard Backing
// Hook extends INTO THE ROOM (in -Z direction)
//
// ORIENTATION WHEN MOUNTED ON PEGBOARD:
//   - Z+ face (with pegs) is AGAINST the pegboard wall
//   - Z=0 face is the FRONT, facing into the room
//   - Low Y = TOP (plain cylinder pegs)
//   - High Y = BOTTOM (hook pegs catch on pegboard)
//   - Accessories attach to Z=0 face, extend in -Z direction

include <../pegboard_library.scad>

// === Parameters ===
cols = 1;
rows = 1;

// Hook dimensions
hook_diameter = 8;
hook_length = 30;       // How far hook extends into room (-Z)
hook_drop = 25;         // Vertical drop (toward floor, +Y when mounted)
curve_segments = 12;

// Mounting base
base_width = 15;
base_height = 12;       // Extends in Y direction
base_depth = 6;         // Extends in -Z direction (into room)

$fn = 64;

// === Modules ===
module curved_hook() {
    r = hook_diameter / 2;
    bend_r = hook_diameter;

    // 1. Horizontal section - extends in -Z direction (into room)
    hull() {
        sphere(r = r);
        translate([0, 0, -hook_length]) sphere(r = r);
    }

    // 2. 90-degree bend (curves downward, which is +Y when mounted)
    for (i = [0 : curve_segments - 1]) {
        angle1 = 90 * i / curve_segments;
        angle2 = 90 * (i + 1) / curve_segments;

        hull() {
            translate([0, bend_r - cos(angle1) * bend_r, -hook_length - sin(angle1) * bend_r])
                sphere(r = r);
            translate([0, bend_r - cos(angle2) * bend_r, -hook_length - sin(angle2) * bend_r])
                sphere(r = r);
        }
    }

    // 3. Vertical drop section (going down = +Y)
    hull() {
        translate([0, bend_r, -hook_length - bend_r]) sphere(r = r);
        translate([0, bend_r + hook_drop, -hook_length - bend_r]) sphere(r = r);
    }

    // 4. Small upturn at tip (curves back in -Y to hold items)
    tip_bend_r = hook_diameter / 2;
    for (i = [0 : curve_segments/2 - 1]) {
        angle1 = 90 * i / (curve_segments/2);
        angle2 = 90 * (i + 1) / (curve_segments/2);

        hull() {
            translate([0,
                       bend_r + hook_drop + tip_bend_r - cos(angle1) * tip_bend_r,
                       -hook_length - bend_r + sin(angle1) * tip_bend_r])
                sphere(r = r);
            translate([0,
                       bend_r + hook_drop + tip_bend_r - cos(angle2) * tip_bend_r,
                       -hook_length - bend_r + sin(angle2) * tip_bend_r])
                sphere(r = r);
        }
    }
}

module mounting_base() {
    // Base connects hook to the Z=0 face of backing
    hull() {
        // Back edge - flush against Z=0 face of backing
        translate([-base_width/2, 0, 0])
            cube([base_width, base_height, 0.1]);
        // Front edge - rounds into hook
        translate([0, base_height/2, -base_depth + hook_diameter/2])
            rotate([0, 90, 0])
                cylinder(h = base_width, d = hook_diameter, center = true);
    }
}

// === Assembly ===

// Pegboard backing (1x1 standard)
pegboard_backing(cols, rows, "corners");

// Hook with mounting base - attached to Z=0 face (front when mounted)
// Centered on backing
translate([backing_center_x(cols), backing_center_y(rows), 0])
    rotate([0, 0, 180])  // Rotate so hook curves correctly when mounted
        translate([0, -base_height/2, 0]) {
            // Mounting base
            mounting_base();

            // Hook extends from base into room
            translate([0, base_height/2, -base_depth + hook_diameter/2])
                curved_hook();
        }
