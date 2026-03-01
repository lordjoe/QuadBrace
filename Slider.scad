// Part5.scad
// Part 05 slider shape + optional pegs
include <common_params.scad>;
include <params_quadbrace.scad>;
include <geom_helpers.scad>;

// Simplified outline points extracted from STL (min corner at 0,0)
base_pts = [
  [0.583637238, 0.089041233],
  [0.936556339, 0.000000000],
  [1.318463325, 0.050049782],
  [13.000000000, 4.541954990],
  [13.000000000, 11.541954040],
  [0.000000000, 11.541954040],
  [0.000926971, 0.954932213],
  [0.176318645, 0.430931091]
];

base_span_x = 13.0;
base_span_y = 11.541954040;

sx = slider_len_x / base_span_x;
sy = slider_w_y   / base_span_y;

module slider_2d() {
  offset(delta=xy_clearance)
    scale([sx, sy])
      polygon(points=base_pts);
}

module Part5_body() {
  linear_extrude(height=slider_h_z)
    slider_2d();
}

module Part5_pegs() {
    if (enable_pegs) {
        y_face = peg_on_max_y ? slider_w_y : 0;
        x_mid = slider_len_x/2;
        x1 = x_mid - peg_x_spacing/2;
        x2 = x_mid + peg_x_spacing/2;
        zc = peg_z_center * slider_h_z;

        // Cylinders pointing out of the Y face
        translate([x1, y_face, zc]) rotate([-90,0,0]) screw("#8",  length=2 * peg_len_y );
        translate([x2, y_face, zc]) rotate([-90,0,0]) screw("#8",  length=2 * peg_len_y );
    }
}

module Slider() {
    union() {
        Part5_body();
        Part5_pegs();
    }
}

// Default render
Slider();

translate([0,0,0])
rotate([180,180,00])
    Slider();
