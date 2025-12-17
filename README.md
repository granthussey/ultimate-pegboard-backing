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
| `_lite` | Corner pegs, center cutout | Light items, fast printing |
| `_grid_lite` | Grid + center cutout | Medium items, fast printing |
| `_maxhook_lite` | Maxhook + center cutout | Heavy items, fast printing |
| `_support_lite` | Support + center cutout | Medium-light items, fast printing |

### Lite Variants
The `_lite` variants have a rectangular cutout in the center, reducing material by ~40-50% and printing ~40-50% faster. A 6mm frame around the edges preserves structural integrity at the peg locations.

**Important:** For lite variants, pegs are only placed on the outer frame where material exists. Grid and maxhook patterns become perimeter patterns (no interior pegs since there's no backing material to support them).

Available lite versions:
- `backing_*_lite.stl` - Corner pegs only, lightweight
- `backing_*_grid_lite.stl` - Perimeter pegs, corner hooks, lightweight
- `backing_*_maxhook_lite.stl` - Perimeter pegs, all back hooks, lightweight
- `backing_*_support_lite.stl` - Corner pegs + middle hook, lightweight (3x1, 3x2 only)

### Grid vs Maxhook Equivalence

For **1-column backings** (1x2, 1x3), the `_grid` and `_maxhook` variants are **identical**. This is because the back row only has 2 peg positions (both corners), so "all back hooks" and "corner hooks" produce the same result. Use `_grid` for these sizes.

## Dimensions

| Grid | Size (mm) | Size (inches) |
|------|-----------|---------------|
| 1x1 | 31.75 x 31.75 | 1.25" x 1.25" |
| 2x1 | 57.15 x 31.75 | 2.25" x 1.25" |
| 3x1 | 82.55 x 31.75 | 3.25" x 1.25" |
| 2x2 | 57.15 x 57.15 | 2.25" x 2.25" |
| 3x2 | 82.55 x 57.15 | 3.25" x 2.25" |

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

// Or use lite variants for faster printing:
pegboard_backing_lite(cols, rows, "corners");           // Standard lite
pegboard_backing_lite(cols, rows, "grid");              // Maxhook lite
pegboard_backing_lite(cols, rows, "grid_corner_hooks"); // Grid lite
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
| `PEG_SPACING` | 25.4mm (1") | Pegboard hole spacing |
| `BACKING_THICKNESS` | 4mm | Backing plate thickness |

### Why PEG_SPACING = 25.4mm

Standard pegboards have holes spaced exactly **1 inch (25.4mm)** apart, center-to-center. Multi-tile backings use this spacing:

```
width = TILE_SIZE + (cols - 1) × PEG_SPACING
      = 31.75 + (cols - 1) × 25.4
```

This is why a 2x1 backing is 57.15mm wide, not 63.5mm.

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
