// Top.scad
include <common_params.scad>;
include <geom_helpers.scad>;

module Top() {
    difference() {
        rr_prism(plate_x, plate_y, top_thick, corner_r);

        corner_holes(top_thick, hole_d);

        if (top_counterbore_enable) {
            for (sx = [-1, 1])
                for (sy = [-1, 1])
                    translate([sx*hole_offset_x, sy*hole_offset_y,
                               top_thick - top_counterbore_depth - eps])
                        cylinder(h=top_counterbore_depth + 2*eps,
                                 d=top_counterbore_d, center=false);
        }
    }
}

Top();
