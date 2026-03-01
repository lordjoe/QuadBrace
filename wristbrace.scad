include <common_params.scad>;
include <geom_helpers.scad>;

// ============================================
// Sweep a cube along a sine wave
// OpenSCAD 2021 compatible
// ============================================

$fn = 64;

brace_width = 40;
brace_height = 15;
strap_height = 3;
strap_width = 30;

// ---- Parameters ----
cube_size = [6, brace_height, brace_width];   // size of swept cube
length = 120;            // total length of sweep (X direction)
amplitude = 4;          // sine wave height
wavelength = 120;         // sine wavelength
steps = 50;              // number of segments (higher = smoother)
cutout_thick = 1.06 * (main_thick + top_thick);
cutout_length = plate_y;
cutout_height = 15; 
module sweep() {
    // ---- Main ----
    union() {

        for (i = [0 : steps-1]) {

            t1 = i / steps;
            t2 = (i + 1) / steps;

            x1 = t1 * length;
            x2 = t2 * length;

            y1 = amplitude * sin(360 * x1 / wavelength);
            y2 = amplitude * sin(360 * x2 / wavelength);

            // angle of segment
            angle = atan2(y2 - y1, x2 - x1);

            // place cube aligned with local tangent
            translate([x1, y1, 0])
                rotate([0, 0, angle])
                    cube(cube_size, center=true);
        }
    }
}



module strap_hole() {
    cube([strap_width ,strap_height, brace_width]);
}

module brace_end() {
    scale([0.5,1,1])
    rotate([0,90,90])
    cylinder(d = brace_width,  h= brace_height, $fn= 100);
}

module whole_brace1() {
    union() {
    sweep();
    translate([0,-brace_height /2,0])
       brace_end();
    translate([length,-brace_height /2,,0])
       brace_end();
    }
}
 
module whole_brace2 () {
   difference() {
     whole_brace1();  
    translate([8,5,-brace_width /2])
       strap_hole();
    translate([length -  1.2 * strap_width ,-1,-brace_width /2])
       strap_hole();
    }
}

module whole_brace  () {
   difference() {
     whole_brace2();  
    translate([0,brace_height,0])
       whole_brace2();
    translate([0,-brace_height,0])
       whole_brace2();
    }
}

module hole_cutout() {
    h1 = 10;
    h2 = 3;
    h3 = 20;
    d1 = 4;
   d2 = 7;
    union() {
        cylinder(d= d1, h = h1, $fn=30);
        translate([0,0,h1])
            cylinder(r1=d1 / 2, r2= d2 /2, h = h2, $fn=30);
        translate([0,0,h1 + h2 ])
            cylinder(d=d2, h = h3, $fn=30);
    }
}    

module box_cutout() {
             translate([length/2, -cutout_height/2  ,  0]) 
         rotate([  270, 0,0])
            union() {
                rotate([ 0,0,90]) {
               cube([cutout_thick,cutout_length,cutout_thick], center = true);
                
                 translate([ 0 ,cutout_length /2 - screw_inset,0 ])
                     hole_cutout();
                
                 translate([ 0 ,-cutout_length /2 + screw_inset,0 ])
                     hole_cutout();
                        }
            }
     

}

module brace() {
    difference() {
        whole_brace();
        rotate([ 0,0,-4])
        box_cutout();
    }
}

 brace();
//box_cutout();
 
