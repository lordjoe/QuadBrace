// geom_helpers.scad
include <common_params.scad>;
include <BOSL2/structs.scad>
include <BOSL2/threading.scad>
include <BOSL2/screw_drive.scad>
include <BOSL2/screws.scad>;

// Rounded-rectangle prism centered at origin
module rr_prism(w, h, t, r) {
    linear_extrude(height=t)
        offset(r=r)
            square([w-2*r, h-2*r], center=true);
}

module corner_holes(t, d) {
    for (sx = [-1, 1])
        for (sy = [-1, 1])
            translate([sx*hole_offset_x, sy*hole_offset_y, -eps])
                cylinder(h=t+2*eps, d=d, center=false);
}



// Place pegs on an end wall, pointing inward along the slot axis.
// axis = "X" or "Y"
// wall_pos: coordinate of the end wall along axis
// inward_dir: +1 or -1 direction into the slot along axis
// center_other: slot center coordinate on the perpendicular axis
// slot_width_other: slot width on the perpendicular axis
// floor_z: z of groove floor
module end_wall_pegs(axis, wall_pos, inward_dir, center_other, slot_width_other, floor_z ) {
  
        // compute peg center height
        peg_z = floor_z + peg_z_from_floor;

        // positions across the slot width (perpendicular direction)
        for (i=[0:peg_count-1]) {
            off = (peg_count==1) ? 0 : (-0.5*(peg_count-1) + i) * peg_spacing;

            // clamp off inside slot width
            max_off = max(0, slot_width_other/2 - peg_edge_inset);
            off2 = (abs(off) > max_off) ? (sign(off)*max_off) : off;

            if (axis == "Y") {
                // slot runs along Y, so pegs are cylinders along Y
                translate([center_other + off2, wall_pos + inward_dir*(peg_len/2), peg_z])
                    rotate([90,0,0])
                        cylinder(d=peg_d, h=peg_len, center=true);
            } else { // "X"
                // slot runs along X, pegs are cylinders along X
                translate([wall_pos + inward_dir*(peg_len/2), center_other + off2, peg_z])
                    rotate([0,90,0])
                        cylinder(d=peg_d, h=peg_len, center=true);
            }
        }
 
}

// Place spring holders on an end wall, pointing inward along the slot axis.
// axis = "X" or "Y"
// wall_pos: coordinate of the end wall along axis
// inward_dir: +1 or -1 direction into the slot along axis
// center_other: slot center coordinate on the perpendicular axis
// slot_width_other: slot width on the perpendicular axis
// floor_z: z of groove floor
module end_wall_holders(axis, wall_pos, inward_dir, center_other, slot_width_other, floor_z ) {
  
        // compute peg center height
        peg_z = floor_z + peg_z_from_floor;

        // positions across the slot width (perpendicular direction)
        for (i=[0:peg_count-1]) {
            off = (peg_count==1) ? 0 : (-0.5*(peg_count-1) + i) * peg_spacing;

            // clamp off inside slot width
            max_off = max(0, slot_width_other/2 - peg_edge_inset);
            off2 = (abs(off) > max_off) ? (sign(off)*max_off) : off;

            if (axis == "Y") {
                // slot runs along Y, so pegs are cylinders along Y
                translate([center_other + off2, wall_pos + inward_dir*(peg_len/2), peg_z])
                    rotate([90,0,0])
                        cylinder(d=peg_d, h=peg_len);
            } else { // "X"
                // slot runs along X, pegs are cylinders along X
                translate([wall_pos + inward_dir*(peg_len/2), center_other + off2, peg_z])
                    rotate([0,90,0])
                        screw("#8",  length=peg_len );
               }
        }
 
}