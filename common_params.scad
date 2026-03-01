include <BOSL2/std.scad>;
include <BOSL2/threading.scad>;
include <BOSL2/screws.scad>;
// common_params.scad
// Extracted (approx) from HolderAssembly.stl: MainBox = component 15, Top = component 8
// Units: mm. OpenSCAD 2021.01 compatible.

$fn = 72;
eps = 0.02;

// ---------- Overall footprint ----------
plate_x = 49.000;   // X size (short)
plate_y = 65.000;   // Y size (long)
corner_r = 3.0;
screw_inset = 10;  // insey of screws in main box from x edge

main_thick = 12.000;
top_thick  = 4.000;

// ---------- Fastener pattern ----------
hole_d = 4; // was 3.5;
hole_offset_x = 16.500;  // from center along X
hole_offset_y = 26.500;  // from center along Y

// Optional counterbore on Top
top_counterbore_enable = true;
top_counterbore_d = 6.6;
top_counterbore_depth = 2.5;

// ---------- MainBox grooves (from STL height-map) ----------
// Groove depth from top surface:
groove_depth = 10.000;

// Groove A: runs along Y (long direction). Width in X.
grooveY_enable = true;
grooveY_x_center = 1.082;
grooveY_x_width  = 13.000;
grooveY_y_start_stop = 2.000; // distance from -Y edge
grooveY_y_end_stop   = 2.500;   // distance from +Y edge

// Groove B: runs along X. Width in Y.
grooveX_enable = true;
grooveX_y_center = 0.0; //3.587;
grooveX_y_width  = 12.000;
grooveX_x_start_stop = 2.500; // distance from -X edge
grooveX_x_end_stop   = 0.000;   // distance from +X edge (0 => breaks out)

// ---------- Spring pins at grooveY end (you can tune) ----------

// ---------- End-wall pegs (spring pegs) ----------
// Pegs are on the END WALL of a slot, pointing INTO the slot along the slot axis.
pegs_enable = true;
peg_d   = 2.2;     // peg diameter
holder_ped_d = peg_d* 1.45;
peg_len = 2.5;     // how far peg protrudes into slot
peg_z_from_floor = 4.0;  // peg center height above groove floor
peg_count = 2;     // pegs per sealed end
peg_spacing = 6.0; // spacing across slot width (perpendicular to slot axis)
peg_edge_inset = 2.0; // inset from slot wall in the perpendicular direction (keeps pegs away from edges)

// ---------- Part 5 (slider block) ----------
// Dimensions extracted from original STL (component 0 / 5)
part5_stl_x = 13.000;   // across GrooveY width direction (X)
part5_stl_y = 11.544;   // along GrooveY travel direction (Y)
part5_stl_z = 9.000;   // height (Z)

// Fit tuning
part5_clearance_x = 0.25;  // per-side clearance in X vs groove
part5_clearance_y = 0.25;  // per-side clearance in Y vs groove walls/end pegs clearance
part5_clearance_z = 0.25;  // per-side clearance in Z vs groove depth

// Pegs on Part5: match MainBox pegs exactly
part5_pegs_enable = true;
part5_peg_end = "AUTO"; // "AUTO","PLUS_Y","MINUS_Y","BOTH" (AUTO picks sealed end)

// Part5 slant (leading ramp) - matches earlier prism-with-slant versions
part5_slant_enable = true;
part5_slant_end = "OPEN_END";   // "OPEN_END" or "SEALED_END"
part5_slant_len = 4.0;          // length of slanted region along Y
part5_slant_drop = 3.0;         // how much height is removed at the very end (Z)
