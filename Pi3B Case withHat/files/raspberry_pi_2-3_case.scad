use <RaspberryPi2B3.scad>;

fudge = 0.01;

pi_width = 56.5;
pi_length = 85;

case_thickness = 1.5;
case_inner_height = 40;
case_inner_offset = 1;

case_latch_height = 10;

mount_hole_spacing_x = 58.1;
mount_hole_spacing_y = 49.7;
mount_hole_edge_offset_x = 3.4;
mount_hole_edge_offset_y = 3.4;

pi_mounting_post_diameter = 8;
pi_mounting_post_height = 3.5;
pi_mounting_post_screw_diameter = 3.5;
pi_mounting_post_screw_head_diameter = 6;
pi_mounting_post_screw_head_recess = 2;

top_case();
//bottom_case();
//pi_case();
//translate([0, 0, (((case_thickness*2)+case_inner_height)/2)-5-(case_latch_height/4)]) case_latch();

module case_latch(offset=0) {
    difference() {
        //We'll difference a cube to draw the two uprights needed
        translate([case_thickness*2, case_thickness, 0]) cube([pi_length+(case_inner_offset*2)-(case_thickness*2),pi_width+(case_inner_offset*2),case_latch_height]);
        translate([case_thickness, case_thickness*2, -fudge/2]) cube([pi_length+(case_inner_offset*2),pi_width+(case_inner_offset*2)-(case_thickness*2),case_latch_height+fudge]);
    }
    //Now add the two angled latches
    translate([case_thickness*2-(offset/2), case_thickness+0.15, 0]) rotate([45, 0, 0]) cube([pi_length+(case_inner_offset*2)-(case_thickness*2)+offset, case_thickness, case_thickness]);
    translate([case_thickness*2-(offset/2), pi_width+(case_inner_offset*2)+case_thickness-0.15, 0]) rotate([45, 0, 0]) cube([pi_length+(case_inner_offset*2)-(case_thickness*2)+offset, case_thickness, case_thickness]);
}

module top_case() {
    difference() {
        //draw the case up side down
        translate([0, pi_width+(case_thickness*2)+(case_inner_offset*2), (case_thickness*2)+case_inner_height]) {
            rotate([180, 0, 0]) pi_case();
        }
        //Now cut off the bottom (which is now the top)
        translate([-fudge/2, -fudge/2, (((case_thickness*2)+case_inner_height)/2)+4]) {
            cube([pi_length+(case_thickness*2)+(case_inner_offset*2)+fudge,pi_width+(case_thickness*2)+(case_inner_offset*2)+fudge,(((case_thickness*2)+case_inner_height+fudge)/2)-4]);
        }
    }
    //Make a lip to keep the top and bottom from sliding
    difference() {
        translate([case_thickness/2, case_thickness, (((case_thickness*2)+case_inner_height)/2)+4]) {
            cube([pi_length+case_thickness+(case_inner_offset*2)+fudge,pi_width+(case_inner_offset*2)+fudge, 1]);
        }
        translate([case_thickness, case_thickness, (((case_thickness*2)+case_inner_height)/2)+4-(fudge/2)]) {
            cube([pi_length+(case_inner_offset*2)+fudge,pi_width+(case_inner_offset*2)+fudge, 1+fudge]);
        }
        translate([case_thickness, pi_width+case_thickness+case_inner_offset, case_inner_height]) {
            rotate([180, 0, 0]) RaspberryPi3();
        }
    }
    
    //Now create the latch
    translate([pi_length+(case_inner_offset*2)+(case_thickness*2), 0, (case_latch_height/4)+((((case_thickness*2)+case_inner_height)/2)+5)]) rotate([0, 180, 0]) case_latch();
}

module bottom_case() {
    difference() {
        //draw the case right side up
        pi_case();
        //Now cut off the top
        translate([-fudge/2, -fudge/2, (((case_thickness*2)+case_inner_height)/2)-4]) {
            cube([pi_length+(case_thickness*2)+(case_inner_offset*2)+fudge,pi_width+(case_thickness*2)+(case_inner_offset*2)+fudge,(((case_thickness*2)+case_inner_height)/2)+4+fudge]);
        }
        //Cut a small lip to keep the top and bottom from sliding
        translate([case_thickness/2, case_thickness, (((case_thickness*2)+case_inner_height)/2)-5]) {
            cube([pi_length+case_thickness+(case_inner_offset*2)+fudge,pi_width+(case_inner_offset*2)+fudge,(((case_thickness*2)+case_inner_height)/2)+4+fudge]);
        }
        //now cut the notch for the cover latch
        translate([0, 0, (((case_thickness*2)+case_inner_height)/2)-5-(case_latch_height/4)]) case_latch(0.5);
    }
}

module pi_case() {
    difference() {
        union() {
            difference() {
                //Create the plain outer case
                cube([pi_length+(case_thickness*2)+(case_inner_offset*2),pi_width+(case_thickness*2)+(case_inner_offset*2),case_thickness+case_inner_height]);
                //Now hollow it out
                translate([case_thickness, case_thickness, case_thickness]) cube([pi_length+(case_inner_offset*2),pi_width+(case_inner_offset*2),case_thickness+case_inner_height]);
            }
            //Add the 4 screw standoffs for the pi
            for(x=[0, 1]*mount_hole_spacing_x) {
                for(y=[0, 1]*mount_hole_spacing_y) {
                    translate([mount_hole_edge_offset_x+case_thickness+case_inner_offset+x, mount_hole_edge_offset_y+case_thickness+case_inner_offset+y, 0]) {
                        cylinder($fn=36, pi_mounting_post_height+case_thickness, d=pi_mounting_post_diameter);
                    }
                }
            }
        }
        //Hollow out for the screw shaft and the screw head
        for(x=[0, 1]*mount_hole_spacing_x) {
            for(y=[0, 1]*mount_hole_spacing_y) {
                translate([mount_hole_edge_offset_x+case_thickness+case_inner_offset+x, mount_hole_edge_offset_y+case_thickness+case_inner_offset+y, -(fudge/2)]) {
                    cylinder($fn=36, pi_mounting_post_height+case_thickness+fudge, d=pi_mounting_post_screw_diameter);
                    cylinder($fn=36, pi_mounting_post_screw_head_recess, d=pi_mounting_post_screw_head_diameter);
                }
            }
        }
        //Now, subtract the pi outline to get the port holes
        translate([case_thickness+case_inner_offset, case_thickness+case_inner_offset, case_thickness+pi_mounting_post_height]) RaspberryPi3();
    }
    //Put a top on it with vent holes for air flow
    difference() {
        translate([0, 0, case_thickness+case_inner_height]) {
            cube([pi_length+(case_thickness*2)+(case_inner_offset*2),pi_width+(case_thickness*2)+(case_inner_offset*2),case_thickness]);
        }
        for(i=[1:5:65]) {
            translate([11+i-0.75, 10, case_thickness+case_inner_height-fudge/2]) {
                rotate([0, 60, 0]) cube([1.5, pi_width-15, case_thickness*4]);
            }
        }
    }
}