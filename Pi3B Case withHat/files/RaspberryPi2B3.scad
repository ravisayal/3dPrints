$fn=100;

module RaspberryPi3() {
    // Circuit board with mounting holes
    difference() {
        cube([85,56.5,1.5]);
        translate([3.4,3.4,-1])cylinder(d=3,h=5);
        translate([3.4,53.1,-1])cylinder(d=3,h=5);
        translate([61.5,3.4,-1])cylinder(d=3,h=5);
        translate([61.5,53.1,-1])cylinder(d=3,h=5);
    }
    // LAN connector
    translate([66,2.5,1.5])cube([23.5,16,14]);
    // Left USB port
    translate([70,21.5,1.5])cube([19,15.5,16]);
    // Right USB port
    translate([70,39.5,1.5])cube([19,15.5,16]);
    // pin header
    translate([7,49.5,1.5])cube([51,5.5,8.5]);
    // Display-Port
    translate([2,16,1.5])cube([4,22.5,5.5]);
    // Micro USB port
    translate([6.5,-3,1.5])cube([8,6,3.5]);
    minkowski() {
        translate([6.5,-3,1.5])cube([8,1.25,3.5]);
        rotate([90, 0, 0]) cylinder(0.1, d=1.25);
    }
    // HDMI
    translate([24.25,-3,1.5])cube([15.5,12,6.5]);
    // Camera-Port
    translate([43.5,0,1.5])cube([4,22.5,5.5]);
    // Audio Port
    translate([49.75,-3,1.5])cube([7.5,15,6.5]);
    // SD Slot
    translate([-3,21.5,-2])cube([16.5,12.5,2]);
}

RaspberryPi3();