// AssemblyPreview.scad
include <common_params.scad>;
include <geom_helpers.scad>;
include <MainBox.scad>;
include <Top.scad>;
include <Part5.scad>;

explode_z = 2.0;

translate([0,0,0]) MainBox();
translate([0,0,main_thick + explode_z]) Top();

// Optional Part5 preview positioned roughly over Groove A
show_part5 = true;
if (show_part5) {
    // Place on top surface near center; adjust as needed
    translate([0, 0, main_thick + explode_z + top_thick + 0.5])
        Part5();
}
