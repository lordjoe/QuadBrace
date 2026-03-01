// holder.scad
// tool holder - first is foa a fork
// also a rest which can be screwed to aboard
include <geom_helpers.scad>;
include <params_quadbrace.scad>;

 
holder_diameter = 21;
holder_minimum_height  = 6;
holder_thick = 3;
holder_length = 60;
screwdriver_hole_d = 6;
screw_head_d = 11;
screw_head_inset  = 3;
outer_diameter = holder_diameter + 2 * holder_thick;
rest_width = 50;
rest_height = 25;


// squeezed cylender = chanber for the fork
module rod(scale_factor) {
    scale([ 1,scale_factor,1])
      cylinder( d = holder_diameter, h = holder_length, $fn = 100);
}


module holder(degrees,scale_factor) {
    difference() {
        cylinder( d = outer_diameter, h = holder_length, $fn = 100);
        rotate([ 0, 0,degrees])
            rod(scale_factor);
    }
}

// piece with hols for ousher and threaded holes for screws to hold fork
module holder_with_holes(degrees,scale_factor) {
    difference() {
           holder(degrees,scale_factor);
        
          // pusher hole
           rotate([ 0, 0,90]) 
             translate([25,0, holder_length /2])
               rotate([90,00,00]) 
                rr_box(stem_len,stem_w, stem_h, 0);
           
       // hole to screw in pusher 
           translate([0,outer_diameter/3,holder_length /2]) {
            rotate([90,0,0]) 
                cylinder( d = screwdriver_hole_d, h =   outer_diameter, $fn = 100);
            translate([0,-outer_diameter /3,0 ])
                rotate([90,0,0]) 
                    cylinder( d = 1.5 *screwdriver_hole_d, h =   outer_diameter /2 , $fn = 100);
           }
            
        translate([0,outer_diameter ,holder_length /2])
            rotate([90,0,0]) 
                cylinder( d = screwdriver_hole_d /2, h =   2 * outer_diameter, $fn = 100);
        
        rotate([ 0, 0,degrees]) {
            // holder screw and head
            translate([0,-outer_diameter /2 ,holder_length /4])
                rotate([90,0,0]) 
                    screw("#8",  length =outer_diameter );
           translate([0,screw_head_inset -outer_diameter /2 ,holder_length /4])
                rotate([90,0,0]) 
                      cylinder( d = screw_head_d, h =   10, $fn = 100);

          // holder screw and head
             translate([0,-outer_diameter /2 ,3 * holder_length /4])
                rotate([90,0,0]) 
                     screw("#8",  length =outer_diameter );
            translate([0,screw_head_inset -outer_diameter /2 , 3 * holder_length /4])
                rotate([90,0,0]) 
                    cylinder( d = screw_head_d, h =   10, $fn = 100);
        }
    }
}

module fork_holder() {
    holder_with_holes(0,holder_minimum_height / holder_diameter);
}

module knife_holder() {
    holder_with_holes(90,holder_minimum_height / holder_diameter);
}

// piece for the above to rest on when released 
 module fork_rest1() {
     width = rest_width;
     height = rest_height;
     screw_hole = 6;
     offset = 5;
    difference() { 
     cube([holder_length,width,height]);
        
       // space for the holder
       translate([0,width / 2,height ])
            rotate([ 0,90,0]) 
                 cylinder( d = outer_diameter, h = holder_length, $fn = 100);
        
        // holes on the corner for screws
        translate([offset,offset,0 ])
            rotate([ 0,0,0]) 
                 cylinder(d = screw_hole, h = 2 * height, $fn=100); 
        translate([holder_length - offset,offset,0 ])
            rotate([ 0,0,0]) 
                 cylinder(d = screw_hole, h = 2 * height, $fn=100); 
        translate([offset,  width - offset,0 ])
            rotate([ 0,0,0]) 
                 cylinder(d = screw_hole, h = 2 * height, $fn=100); 
        translate([holder_length - offset, width - offset,0 ])
            rotate([ 0,0,0]) 
                 cylinder(d = screw_hole, h = 2 * height, $fn=100); 
        
   }
}

 module fork_rest() {
     width = rest_width;
     height = rest_height;
     end_width = 4;
     union() {
         fork_rest1();
         // barriers for the ends
         translate([-2 * end_width,0,0 ])
             cube([end_width,width,0.6 * height ]);
         translate([-end_width,0,0 ])
             cube([end_width,width,0.4 * height ]);
        translate([rest_width + 2.5 * end_width,0,0 ])
             cube([end_width,width, 0.4 * height  ]);
          translate([rest_width + 3.5 * end_width,0,0 ])
             cube([60,width, 0.6 * height  ]);
       
         // peg to go in the screw hole
         translate([holder_length /2,width/2,0]) 
            cylinder(d = 1.3 * screwdriver_hole_d , h =  0.65 * height , $fn = 100);
   }
      
 }

 

  intersection() {
       translate([-30,-25,0]) {
      fork_rest(); 
       }
      cylinder(r=1200, h=60, center=true, $fn=128);
  }
 
 