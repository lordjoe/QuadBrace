// MainBox.scad
include <common_params.scad>;
include <geom_helpers.scad>;


slider_thickness = 1.2;
slider_length  = 6;
slider_height = groove_depth;

module test_screws() {
     delta = 12;
    del = delta / 2;
    x = delta / 2;
    y = delta / 2;
    height = 4;
    h = 2;
    union() {
        cube([3 * delta,2  * delta,h]);
            
   

        translate([del,2 * del,h])
            screw("m2",  length=height );
        translate([2 * del,2 * del,h])
            screw("m3",  length=height );
         translate([3 * del,2 * del,h])
            screw("m4",  length=height );
         translate([4 * del,2 * del,h])
            screw("m5",  length=height );
         translate([5 * del,2 * del,h])
            screw("m6",  length=height );

        translate([del,del,h])
            screw("#4",  length=height );
        translate([2 * del,del,h])
            screw("#6",  length=height );
         translate([3 * del,del,h])
            screw("#8",  length=height );
         translate([4 * del,del,h])
            screw("#10",  length=height );
    }
    
}

//test_screws();

module topSpringSliderX() {
    l = 0.95 *  grooveX_y_width;
    translate([-slider_thickness,0,0])
    // Base + grooves (cutouts)
    difference() {
        union() {
            cube([slider_thickness,grooveX_y_width,slider_height ]);
            rotate([0,0,90])
               cube([slider_thickness,slider_length,slider_height]);
           translate([0,grooveX_y_width - slider_thickness,0])
               rotate([0,0,90])
                 cube([slider_thickness,slider_length,slider_height]);
        }
        scale([1,1,1])
            translate([-slider_height , slider_length, 0.80 * slider_length  ])
                rotate([0,90,0])
                    cylinder(h = slider_height, d = l, $fn = 100);
     }
   
}

module topSpringSlider( ) {
    rotate([0,90,0]) {
       union() {
            topSpringSliderX();
            translate([ -0.98 * peg_len,0,0])
                end_wall_holders("X", slider_thickness, -1, grooveX_y_width / 2, slider_height, slider_thickness);
      }
    }   
}
// Default render
 
 topSpringSlider( );
