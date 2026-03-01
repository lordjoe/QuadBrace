// MainBox.scad
include <common_params.scad>;
include <geom_helpers.scad>;

module corner_nuts(t ) {
    for (sx = [-1, 1])
        for (sy = [-1, 1])
            translate([sx*hole_offset_x, sy*hole_offset_y,0.5 * t])
                screw("#6",  length=1.05 * t + eps );
               // cylinder(h=t+2*eps, d=d, center=false);
}

module top_screws() {
    length = 12;
    union() {
        translate([0.05 * length -20,plate_y /2 - screw_inset,(main_thick + top_thick)/2])  
            rotate([0,90,0])
               screw("#6", length = length);
          translate([0.05 * length -20,-plate_y /2 + screw_inset,(main_thick + top_thick) /2])  
            rotate([0,90,0])
               screw("#6", length = length);
      }
        
 
}

// do the box but add pegs on the next step
module MainBox_NoPegs() {
    // Base + grooves (cutouts)
    difference() {
             rr_prism(plate_x, plate_y, main_thick, corner_r);
            // Corner holes
            corner_nuts(main_thick);
            top_screws();
      
        // Grooves cut from TOP
             gy_len = plate_y - grooveY_y_start_stop - grooveY_y_end_stop;
            gy_x0  = grooveY_x_center - grooveY_x_width/2;
            gy_y0  = -plate_y/2 + grooveY_y_start_stop;
            gy_z0  = main_thick - groove_depth;
            translate([gy_x0, gy_y0, gy_z0])
                cube([grooveY_x_width, gy_len, groove_depth + eps], center=false);
   
             gx_len = plate_x - grooveX_x_start_stop - grooveX_x_end_stop;
            gx_x0  = -plate_x/2 + grooveX_x_start_stop;
            gx_y0  = grooveX_y_center - grooveX_y_width/2;
            gx_z0  = main_thick - groove_depth;
            translate([gx_x0, gx_y0, gx_z0])
                cube([gx_len, grooveX_y_width, groove_depth + eps], center=false);
    }
}

module MainBox() {
    union() {
    MainBox_NoPegs();
    // ----- End-wall pegs for every sealed slot end -----
    floor_z = main_thick - groove_depth;

    // GrooveY sealed ends (along Y)
        gy_y2 = -plate_y/2 + grooveY_y_start_stop;   // start wall
        gy_y1 =  plate_y/2 - grooveY_y_end_stop;     // end wall

        if (grooveY_y_start_stop > 0.5)
            end_wall_pegs("Y", gy_y2, +1, grooveY_x_center, grooveY_x_width, floor_z); // points +Y
        if (grooveY_y_end_stop > 0.5)
            end_wall_pegs("Y", gy_y1, -1, grooveY_x_center, grooveY_x_width, floor_z); // points -Y

    // GrooveX sealed ends (along X)
        gx_x2 = -plate_x/2 + grooveX_x_start_stop;   // start wall
        gx_x1 =  plate_x/2 - grooveX_x_end_stop;     // end wall

       if (grooveX_x_start_stop > 0.5)
            end_wall_pegs("X", gx_x2, +1, grooveX_y_center, grooveX_y_width, floor_z); // points +X
        if (grooveX_x_end_stop > 0.5)
            end_wall_pegs("X", gx_x1, -1, grooveX_y_center, grooveX_y_width, floor_z); // points -X
   }
}

// Default render
MainBox();
//translate([-20,0,0])
 // top_screws();
 
