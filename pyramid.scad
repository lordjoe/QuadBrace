// pyramid.scad
// Truncated pyramid with 45° slope using shared defaults (matches STL extents)
include <params_quadbrace.scad>;

slope_deg = pyr_slope_deg;

shrink = 2 * pyr_height_x * tan(slope_deg);
top_width_y = pyr_width_y - shrink;
top_depth_z = pyr_depth_z - shrink;

eps2 = 0.01;

module frustum_45(height_x, width_y, depth_z, top_w, top_d) {
    hull() {
        // base at x=0
        translate([0,0,0]) cube([eps2, width_y, depth_z], center=true);
        // top at x=height
        translate([height_x,0,0]) cube([eps2, max(eps2,top_w), max(eps2,top_d)], center=true);
    }
}

frustum_45(pyr_height_x, pyr_width_y, pyr_depth_z, top_width_y, top_depth_z);
