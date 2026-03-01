module key() {
    union() {
        cylinder(d=3 , h= 30, $fn=100);
        translate([0,0,0]) 
            cube([2,10,10]);
         translate([ 0,00,30]) 
            cube([2,10,10]);
   }
}

key(); 