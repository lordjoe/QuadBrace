// PrintAll.scad
// Renders any combination of QuadBrace parts, arranged on the print bed
// without overlap.
//
// USAGE
//   • Set  print_all = true   to render every part at once.
//   • Set  print_all = false  and flip individual flags to render a subset.
//   • Increase  gap  if parts still touch after slicing.
//
// Layout: three rows
//   Row 0 — MainBox | Top | Brace
//   Row 1 — Holder  | Pusher
//   Row 2 — Slider  | TopSpringSlider

include <common_params.scad>;
include <params_quadbrace.scad>;

use <MainBox.scad>;
use <Top.scad>;
use <wristbrace.scad>;
use <holder.scad>;
use <pusher2.scad>;
use <Slider.scad>;
use <TopSpringSlider.scad>;

// ── Selection ────────────────────────────────────────────────────────────────
// Set print_all = true  → every part renders.
// Set print_all = false → only parts whose flag is true render.

print_all        = true;

print_main_box   = false;
print_top        = false;
print_brace      = false;
print_holder     = false;
print_pusher     = false;
print_slider     = false;
print_top_slider = false;

// ── Spacing ──────────────────────────────────────────────────────────────────
gap = 5;   // mm between parts on the bed

// ── Estimated footprints (X × Y) for layout calculations ─────────────────────
// These are conservative; widen fp_*_x / fp_*_y if parts overlap in the slicer.

fp_mainbox_x   = plate_x;      // 49
fp_mainbox_y   = plate_y;      // 65
fp_top_x       = plate_x;      // 49
fp_top_y       = plate_y;      // 65
fp_brace_x     = 125;          // sine sweep 120 + end caps
fp_brace_y     = 50;           // brace_width 40 + clearance
fp_holder_x    = 165;          // holder_length 60 + end barriers ~100
fp_holder_y    = 55;           // rest_width 50 + clearance
fp_pusher_x    = 95;           // shell + end_cap spread
fp_pusher_y    = 70;
fp_slider_x    = 35;           // two sliders side-by-side
fp_slider_y    = 15;
fp_topslider_x = 22;
fp_topslider_y = 15;

// ── Part wrappers ─────────────────────────────────────────────────────────────
// Each module renders its part.  The translate inside each wrapper brings the
// part into the positive-XY / Z≥0 region before the layout translate is applied.

module part_MainBox() {
    // rr_prism is centred in XY; shift to first quadrant
    translate([fp_mainbox_x/2, fp_mainbox_y/2, 0])
        MainBox();
}

module part_Top() {
    translate([fp_top_x/2, fp_top_y/2, 0])
        Top();
}

module part_Brace() {
    // brace() sweeps X 0→120, centred in Y and Z.
    // Translate +20 in Z so the part sits on the bed (brace_width/2 = 20).
    translate([0, fp_brace_y/2, 20])
        brace();
}

module part_Holder() {
    // Replicates the top-level intersection from holder.scad.
    // fork_rest origin is at (-30,-25,0) relative to the part min corner;
    // shift forward so everything stays in positive XY.
    translate([40, 27, 0])
        intersection() {
            fork_rest();
            cylinder(r=1200, h=60, center=true, $fn=128);
        }
}

module part_Pusher() {
    // cluster() places shell at (-32,20,0) and end_cap at (27.6,-20,33).
    // Shift to keep geometry in positive XY.
    translate([55, 35, 0])
        cluster();
}

module part_Slider() {
    // Slider.scad renders two sliders at the same origin (one flipped).
    // Separate them side-by-side for independent printing.
    Slider();
    translate([slider_len_x + gap, 0, 0])
        Slider();
}

module part_TopSpringSlider() {
    topSpringSlider();
}


// ── Layout positions ──────────────────────────────────────────────────────────

// Row 0 — large flat parts
x_mainbox = 0;
x_top     = x_mainbox + fp_mainbox_x + gap;
x_brace   = x_top     + fp_top_x     + gap;
y_row0    = 0;

// Row 1 — medium parts
y_row1   = fp_mainbox_y + gap;
x_holder = 0;
x_pusher = x_holder + fp_holder_x + gap;

// Row 2 — small parts
y_row2      = y_row1    + fp_holder_y    + gap;
x_slider    = 0;
x_topslider = x_slider + fp_slider_x + gap;

// ── Conditional render ────────────────────────────────────────────────────────
module show_if(flag) { if (print_all || flag) children(); }

show_if(print_main_box)
    translate([x_mainbox, y_row0, 0]) part_MainBox();

show_if(print_top)
    translate([x_top, y_row0, 0]) part_Top();

show_if(print_brace)
    translate([x_brace, y_row0, 0]) part_Brace();

show_if(print_holder)
    translate([x_holder, y_row1, 0]) part_Holder();

show_if(print_pusher)
    translate([x_pusher, y_row1, 0]) part_Pusher();

show_if(print_slider)
    translate([x_slider, y_row2, 0]) part_Slider();

show_if(print_top_slider)
    translate([x_topslider, y_row2, 0]) part_TopSpringSlider();
