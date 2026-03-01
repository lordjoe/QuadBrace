// pusher.scad
// Part 9 geometry (bulk + stem extension + attachment) from your working version.
// Uses shared params in params_quadbrace.scad
include <common_params.scad>;
include <geom_helpers.scad>;
include <params_quadbrace.scad>;

// --- Parameters ---
base_x = stem_h;      // Length of the base in X direction
base_y = stem_w;      // Length of the base in Y direction
height = 4;      // Vertical height
angle_x = 30;     // Inward angle from the X-axis (degrees)
angle_y = 20;     // Inward angle from the Y-axis (degrees)
max_h = max(stem_h, max(stem_ext_h, sleeve_h*head_attach_scale));
hole_depth = 15;
tab_len = 4; // length of tab for enfcap attachment

// --- Parameters ---
offset = 1.0;
thick = 0.5;     // Wall thickness
bwidth1 =  stem_w;  // Bottom width X
bwidth2 = stem_h;  // Bottom width Y
twidth1 = stem_ext_w + thick + offset;  // Top width X
twidth2 = stem_ext_h + thick + offset;  // Top width Y
pheight = 6;  // Height



// --- Module to define the base shape ---
module truncated_pyramid2(bw1, bw2, tw1, tw2, h) {
    hull() {
        // Bottom face (centered)
        translate([-bw1/2, -bw2/2, 0])
            cube([bw1, bw2, 0.01]);
            
        // Top face (centered)
        translate([-tw1/2, -tw2/2, h - 0.01])
            cube([tw1, tw2, 0.01]);
    }
}

module shell(fraction = 1.05,hfraction = 1.25 ) {
    height = pheight * hfraction;
    // --- The Shell ---
    difference( ) {
        // Outer Pyramid
        truncated_pyramid2( fraction *bwidth1,  fraction *bwidth2, twidth1, twidth2, height);
        
        // Inner Pyramid (Subtracting this)
        // We lift it slightly and make it taller to ensure a clean cut //through the top
        translate([0, 0, -0.1]) 
            truncated_pyramid2(
                fraction *bwidth1 - 2*thick, 
                fraction * bwidth2 - 2*thick, 
                twidth1 - 2*thick, 
                twidth2 - 2*thick, 
                height + 0.2
            );
    }
}





// Rounded-rectangle solid by minkowski (matches earlier style)
module rr_box(x, y, z, r=0) {
    if (r <= 0) cube([x,y,z], center=true);
    else minkowski() {
        cube([max(0.001, x-2*r), max(0.001, y-2*r), max(0.001, z-2*r)], center=true);
        sphere(r=r);
    }
}

module sleeve_outer() {
    rr_box(sleeve_t, sleeve_w, sleeve_h, sleeve_r);
}


// --- Calculations ---
// We use trigonometry to find the "shrinkage" at the top
// offset = height * tan(angle)
offset_x = height * tan(angle_x);
offset_y = height * tan(angle_y);

// Calculate top dimensions
top_x = base_x - (2 * offset_x);
top_y = base_y - (2 * offset_y);

// --- Geometry Generation ---
module truncated_pyramid() {
    if (top_x <= 0 || top_y <= 0) {
        echo("ERROR: Angles are too steep for this height/base. Top dimensions are negative.");
    } else {
        polyhedron(
            points = [
                [0, 0, 0], [base_x, 0, 0], [base_x, base_y, 0], [0, base_y, 0], // Base (0-3)
                [offset_x, offset_y, height],                                  // Top (4)
                [base_x - offset_x, offset_y, height],                         // Top (5)
                [base_x - offset_x, base_y - offset_y, height],                // Top (6)
                [offset_x, base_y - offset_y, height]                          // Top (7)
            ],
            faces = [
                [0, 1, 2, 3],    // Bottom
                [4, 5, 6, 7],    // Top
                [0, 1, 5, 4],    // Front side
                [1, 2, 6, 5],    // Right side
                [2, 3, 7, 6],    // Back side
                [3, 0, 4, 7]     // Left side
            ]
        );
    }
}

module attachment() { 
    translate([-(stem_len/2 + stem_ext_len/2), 0, 0])
                mirror([0,1,0])
                    scale([head_attach_scale, head_attach_scale, head_attach_scale])
                        sleeve_outer();

}

module end_cap(bFactor = 1,tFactor = 1,hFactor = 1) {
     translate([-(stem_len/2 + stem_ext_len),0 ,0])
     rotate([ 0,-90, 0])
        truncated_pyramid2(bFactor * bwidth1, bFactor * bwidth2, tFactor * twidth1,tFactor * twidth2, hFactor * pheight);

}

module end_cap_with_hole(bFactor = 1,tFactor = 1,hFactor = 1) {
    rotate([0,270,0])
       difference() {
          end_cap(bFactor ,tFactor ,hFactor );
          translate([-tab_len/2 -(stem_len/2 + stem_ext_len ), 0, 0])
             rr_box(0.6 * stem_ext_len, 0.6 * stem_ext_w, tab_len, 0);

      }
      

}

module long_stem_with_thread() {
     offset = 2;
      difference() {
           rr_box(stem_len,stem_w, stem_h, 0);
         translate([offset , 0, 0])
           rotate([0,90,00])
            screw("#6",  length=stem_len - offset   );
 
      }
}

module long_stem() {
      union() {
        // stem extension (must remain connected)
        long_stem_with_thread()
         translate([-(stem_len/2 + stem_ext_len/2), 0, 0])
            rr_box(stem_ext_len, stem_ext_w, stem_ext_h, 0);
        translate([-hole_depth/2,0,0])
            end_cap();
      }
}

module large_stem_with_tab() {
      union() {
         long_stem_with_thread(); 
     //    rr_box(stem_len, stem_w, stem_h, 0);
 
        // stem extension (must remain connected)
        translate([-(stem_len/2 + stem_ext_len/2), 0, 0])
            rr_box(stem_ext_len, stem_ext_w, stem_ext_h, 0);
         translate([-(stem_len/2 + stem_ext_len ), 0, 0])
             rr_box(0.6 * stem_ext_len, 0.6 * stem_ext_w, tab_len, 0);
      }
}

module large_stem_with_hole() {
        difference() {
            rr_box(stem_len, stem_w, stem_h, 0);
            long_stem();
        }
}


// Part 9 (what you called pusher earlier): bulk + stem extension + attachment
module part_09_with_stem1( ) {
    union() {
        rr_box(stem_len, stem_w, stem_h, 0);

        end_cap();

        // stem extension (must remain connected)
        translate([-(stem_len/2 + stem_ext_len/2), 0, 0])
            rr_box(stem_ext_len, stem_ext_w, stem_ext_h, 0);
 
    }
}

// Part 9 (what you called pusher earlier): bulk + stem extension + attachment
module part_09_with_stem( ) {
    union() {
        part_09_with_stem1();

        end_cap();
        
        translate([-22,00,0])
            rotate([0,90,0])
                 shell();
    }
}

module pusher() {
    translate([0,0,max_h/2]) 
        part_09_with_stem();
}
 
module print_shell() {
    for(i = [0:5]) {
        for(j = [0:5]) {
            fraction = 1.02 + 0.02 * i;
             hfraction = 1.10 + 0.05 * j;
            translate([15 * i, 15 * j,0])
                shell(fraction, hfraction);
        }
    }
}

 
module print_endcap() {
    for(i = [0:3]) {
        for(j = [0:3]) {
            fraction = 0.98 + 0.02 * i;
             hfraction = 0.98 + 0.05 * j;
            translate([15 * i, 15 * j,0])
                end_cap_with_hole(fraction, hfraction);
        }
    }
}

// Print on bed (lift by max Z extent of connected part)

module cluster() {
     translate([-32,20,0])
        shell();
    rotate([ 0,0,0])
        translate([27.6,-20,33])
          end_cap_with_hole();
//    translate([0,0, stem_h/2])
//        large_stem_with_tab();
}

//print_shell();
cluster();
//pusher();
//mirror([0,1,0])
//truncated_pyramid();
//cluster();

//long_stem_with_thread();