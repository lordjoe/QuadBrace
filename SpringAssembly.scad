// SpringAssembly.scad
// Illustrates how the parts fit together:
//   • Slider (Part5) sits in the Y-groove, wide end toward the sealed +Y wall
//   • TopSpringSlider sits in the X-groove at the closed -X end
//   • Two coil springs per slot connect each slider's pegs to the end-wall pegs

include <common_params.scad>;
include <params_quadbrace.scad>;

use <MainBox.scad>;
use <Slider.scad>;
use <TopSpringSlider.scad>;

$fn = 32;

// ── Coil-spring primitives ────────────────────────────────────────────────────

// Spring along the Y axis, starting at the caller's origin.
// cx,cz = XZ centre of the coil helix.
module coil_Y(cx, cz, len, r=1.6, coils=6, wd=0.6) {
    steps = coils * 18;
    for (i = [0:steps-2]) {
        t1 = i       / steps;
        t2 = (i + 1) / steps;
        a1 = t1 * 360 * coils;
        a2 = t2 * 360 * coils;
        hull() {
            translate([cx + r*cos(a1), t1*len, cz + r*sin(a1)]) sphere(d=wd, $fn=6);
            translate([cx + r*cos(a2), t2*len, cz + r*sin(a2)]) sphere(d=wd, $fn=6);
        }
    }
}

// Spring along the X axis, starting at the caller's origin.
module coil_X(cy, cz, len, r=1.6, coils=6, wd=0.6) {
    steps = coils * 18;
    for (i = [0:steps-2]) {
        t1 = i       / steps;
        t2 = (i + 1) / steps;
        a1 = t1 * 360 * coils;
        a2 = t2 * 360 * coils;
        hull() {
            translate([t1*len, cy + r*cos(a1), cz + r*sin(a1)]) sphere(d=wd, $fn=6);
            translate([t2*len, cy + r*cos(a2), cz + r*sin(a2)]) sphere(d=wd, $fn=6);
        }
    }
}

// ── Derived geometry constants ────────────────────────────────────────────────

floor_z      = main_thick - groove_depth;          // 2.0  — groove floor in Z
wall_peg_z   = floor_z + peg_z_from_floor;         // 6.0  — peg centre height (world Z)

// ─── Y-groove sealed end wall (+Y side) ──────────────────────────────────────
gy_wall_y    = plate_y/2 - grooveY_y_end_stop;     // 30.0
gy_peg_y     = gy_wall_y  - peg_len/2;             // 28.75 — wall peg face centre

// Two wall pegs, spaced ±3 mm from groove X-centre
gy_peg_x1    = grooveY_x_center - peg_spacing/2;   // -1.918
gy_peg_x2    = grooveY_x_center + peg_spacing/2;   //  4.082

// ─── Slider in Y-groove ───────────────────────────────────────────────────────
// Wide end (+Y face of slider polygon) faces the sealed wall.
// Leave ~14 mm of spring space between slider peg face and wall peg face.
sl_wide_y    = gy_peg_y - peg_len/2 - 14;          // ~13.0
sl_min_y     = sl_wide_y - slider_w_y;              //  ~7.5

sl_min_x     = grooveY_x_center - grooveY_x_width/2 + part5_clearance_x;  // -5.168
sl_bot_z     = floor_z + part5_clearance_z;                                 //  2.25

// Slider peg positions (peg_on_max_y → at local y = slider_w_y)
//   peg_x_spacing (params_quadbrace) = slider_len_x/2 = 6.5
sl_peg_x1    = sl_min_x + slider_len_x/2 - peg_x_spacing/2;  // ≈ -1.92
sl_peg_x2    = sl_min_x + slider_len_x/2 + peg_x_spacing/2;  // ≈  4.58
sl_peg_z     = sl_bot_z + peg_z_center * slider_h_z;          // ≈  6.75

spring_Y_len = gy_peg_y - sl_wide_y;               // ≈ 8.75 mm

// ─── X-groove sealed end wall (-X side) ──────────────────────────────────────
gx_wall_x    = -plate_x/2 + grooveX_x_start_stop;  // -22.0
gx_peg_x     = gx_wall_x  + peg_len/2;             // -20.75  — wall peg face centre

// Two wall pegs, spaced ±3 mm from groove Y-centre
gx_peg_y1    = grooveX_y_center - peg_spacing/2;   // -3.0
gx_peg_y2    = grooveX_y_center + peg_spacing/2;   //  3.0

// ─── TopSpringSlider in X-groove ─────────────────────────────────────────────
// After rotate([0,90,0]) inside topSpringSlider(), the piece spans
//   x=[0..groove_depth], y=[0..grooveX_y_width], z=[0..slider_thickness].
// Place it at the closed end of the groove; spring hooks face the +X direction.
tss_x        = gx_wall_x;                          // -22.0
tss_y        = grooveX_y_center - grooveX_y_width/2; // -6.0
tss_z        = floor_z;                             //  2.0

// Approximate peg anchor on the TopSpringSlider (7 mm into the groove from wall)
tss_peg_x    = gx_wall_x + groove_depth * 0.55;    // ≈ -16.5
spring_X_len = tss_peg_x - gx_peg_x;               // ≈  4.25 mm  (from wall out to piece anchor)

// ── Assembly ──────────────────────────────────────────────────────────────────

// Main housing — semi-transparent so springs inside grooves are visible
color("SandyBrown", 0.45)
    MainBox();

// Slider — translate so its local origin (min-x, min-y, 0) lands at world position
color("CornflowerBlue", 0.90)
    translate([sl_min_x, sl_min_y, sl_bot_z])
        Slider();

// TopSpringSlider — placed at closed end of X-groove
color("MediumSeaGreen", 0.90)
    translate([tss_x, tss_y, tss_z])
        topSpringSlider();

// ── Springs ───────────────────────────────────────────────────────────────────

// Y-groove: two springs from slider's wide-end pegs → end-wall pegs
color("Crimson")
    translate([0, sl_wide_y, 0]) {
        coil_Y(gy_peg_x1, wall_peg_z, spring_Y_len);
        coil_Y(gy_peg_x2, wall_peg_z, spring_Y_len);
    }

// X-groove: two springs from end-wall pegs → TopSpringSlider peg anchors
color("OrangeRed")
    translate([gx_peg_x, 0, wall_peg_z]) {
        coil_X(gx_peg_y1, 0, spring_X_len);
        coil_X(gx_peg_y2, 0, spring_X_len);
    }
