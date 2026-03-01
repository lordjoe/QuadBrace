// params_quadbrace.scad
// Shared parameters for pusher/sleeve(part2)/slider(part5)/pyramids/wristbrace demos
// Units: mm. OpenSCAD 2021.01 compatible.

$fn = 64;
eps = 0.02;

// --- Part 9 / pusher ---
stem_len = 35;
stem_w   = 11;
stem_h   = 9;

stem_ext_len = 10;
stem_ext_w   = 7;
stem_ext_h   = 5;

head_attach_scale = 0.75;

// "header" outer block style (solid, no hole)
sleeve_t = 4.9;
sleeve_w = 12;
sleeve_h = 10;
sleeve_r = 1.0;

// --- Sleeve hole sizing (Part 2 slider-with-hole) ---
fit_clearance = 0.7;
head_w = 7;
head_h = 5;

hole_w_y = head_w + 2*fit_clearance;
hole_h_z = head_h + 2*fit_clearance;
hole_r   = 0.8;

// --- Part 5 slider (faceted) ---
slider_len_x = 13.0;
slider_w_y   = 11.54376125;
slider_h_z   = 9.0;
xy_clearance = 0.0;

enable_pegs  = true;
peg_d        = 2.2;
peg_len_y    = 2.5;
peg_z_center = 0.5;
peg_x_spacing = slider_len_x/2;
peg_on_max_y  = true;

// --- Pyramid defaults ---
pyr_height_x = 4.91014528;
pyr_width_y  = 12.0;
pyr_depth_z  = 10.0;
pyr_slope_deg = 45;

// --- Wristbrace sine sweep demo ---
sine_length = 120;
sine_amplitude = 15;
sine_wavelength = 40;
sine_steps = 80;
sweep_cube_size = [4,4,4];
