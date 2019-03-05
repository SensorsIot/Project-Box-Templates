// Qick and dirty example for a simple box with lid
//

// set box parameters
box_length = 35;
box_width = 20;
box_height = 10;
box_corner_radius = 5;
box_wall_thickness = 1;

$fn=200;

 
box_and_lid(box_length, box_width, box_height, box_corner_radius, box_wall_thickness);


module box_and_lid(length, width, height, cornerRadius, thick){
    box(length, width, height, cornerRadius, thick);
    lid(length, width, height, cornerRadius, thick);
}

module box(length, width, height, cornerRadius, thick){
    difference() {
        roundBox(length+2*thick, width+2*thick, height, cornerRadius);     
        translate([thick,thick,thick]) {
            roundBox(length, width, height,                 cornerRadius); 
         }
    }
}

module lid(length, width, height, cornerRadius, thick){
    translate([width*2, 0, 0]){
        union() {
            roundBox(length+2*thick, width+2*thick, thick, cornerRadius);
            difference(){
                    difference() {
                        translate([thick,thick,0]) {
                            roundBox(length,width,2*thick,cornerRadius);
                        }
                       translate([2*thick,2*thick,0]) {
                            roundBox(length-2*thick,width-2*thick,2*thick,cornerRadius);
                        }    
                    }
                }
        }
    }
}

module roundBox(length, width, height, radius)
{
    Rad = 2*radius;
    //base rounded shape
    minkowski() {
            cube(size=[width-Rad,length-Rad, height]);
            cylinder(r=radius, h=0.01);
    }
    
}