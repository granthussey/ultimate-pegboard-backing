# Pegboard Backing System

Modular pegboard backings with smart beveling and configurable peg placement patterns. Designed for 1" x 1" pegboards with 1/4" holes.

## Quick Start

**Just want to print?** Grab an STL from the `stl/` folder:
- `backing_2x1.stl` - 2-wide, 1-tall, corner pegs only
- `backing_2x2_grid.stl` - 2x2 with full grid of pegs
- `backing_3x2_maxhook.stl` - 3x2 with maximum hooks for heavy items

**Want to customize?** Use the OpenSCAD files in `scad/` with `pegboard_library.scad`.

## Print Settings

- **Layer height:** 0.2mm recommended
- **Infill:** 20-30% for light items, 50%+ for heavy items
- **Supports:** None needed
- **Orientation:** Print flat (pegs pointing up)

## Backing Variants

| Suffix | Pattern | Best For |
|--------|---------|----------|
| (none) | Corner pegs only | Light items |
| `_grid` | All pegs, corner hooks | Medium items |
| `_maxhook` | All pegs, all back hooks | Heavy items |
| `_support` | Corners + middle hook | Medium-light items |

## Dimensions

| Grid | Size (mm) | Size (inches) |
|------|-----------|---------------|
| 1x1 | 31.75 x 31.75 | 1.25" x 1.25" |
| 2x1 | 58 x 31.75 | 2.28" x 1.25" |
| 3x1 | 84.25 x 31.75 | 3.32" x 1.25" |
| 2x2 | 58 x 58 | 2.28" x 2.28" |
| 3x2 | 84.25 x 58 | 3.32" x 2.28" |

## Customization

Create your own backing sizes using OpenSCAD:

```openscad
include <pegboard_library.scad>

$fn = 64;
cols = 3;  // Width in tiles
rows = 2;  // Height in tiles

// Choose your pattern:
pegboard_backing(cols, rows, "corners");           // Standard
pegboard_backing(cols, rows, "grid");              // Maxhook (all hooks)
pegboard_backing(cols, rows, "grid_corner_hooks"); // Grid (corner hooks)
pegboard_backing(cols, rows, "perimeter");         // Edge pegs
```

### Adding Custom Geometry

```openscad
include <pegboard_library.scad>

$fn = 64;
cols = 2;
rows = 1;

pegboard_backing(cols, rows, "corners");

// Add your custom geometry on top
w = backing_width(cols);
h = backing_height(rows);

translate([w/2, h/2, BACKING_THICKNESS])
    your_custom_holder();
```

### Utility Functions

```openscad
backing_width(cols)    // Total width accounting for shared pegs
backing_height(rows)   // Total height accounting for shared pegs
peg_x(i, cols)         // X position for peg at column i
peg_y(j, rows)         // Y position for peg at row j
```

## Technical Details

### Core Parameters

| Parameter | Value | Description |
|-----------|-------|-------------|
| `TILE_SIZE` | 31.75mm (1.25") | Single tile dimension |
| `PEG_DIAMETER` | 5.5mm | Peg diameter |
| `PEG_SPACING` | 26.25mm | Distance between pegs |
| `BACKING_THICKNESS` | 4mm | Backing plate thickness |

### Why PEG_SPACING != TILE_SIZE

Adjacent tiles **share** a peg hole where they meet. The actual spacing between peg centers is:

```
PEG_SPACING = TILE_SIZE - PEG_DIAMETER = 31.75 - 5.5 = 26.25mm
```

This is why a 2x1 backing is 58mm wide, not 63.5mm.

## File Organization

```
pegboard_backing/
├── README.md              # This file
├── pegboard_library.scad  # Core library for customization
├── stl/                   # Ready-to-print STL files
│   ├── backing_*.stl
│   └── ...
└── scad/                  # OpenSCAD source files
    ├── backing_*.scad
    └── ...
```

## License

This work is licensed under [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/). You are free to share and adapt, with attribution.
