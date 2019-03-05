////////////////////////////////////////////////////////////////////////////////
//                                                                            //
//                            snap_box.scad                                   //
//                            =============                                   //
//                                                                            //
// Author:  Gavin Smalley                                                     //
// Link:    https://www.thingiverse.com/thing:3468464                         //
// Version: 0.2                                                               //
// Date:    5th March 2019                                                    //
//                                                                            //
// Customisable project box                                                   //
//  (inspired by https://www.youtube.com/watch?v=lBK0UBjVrYM).                //
//                                                                            //
// Latest working version can always be found at the Thingiverse link above.  //
// Thingiverse customiser can be used with this file.                         //
//                                                                            //
// Changelog                                                                  //
// =========                                                                  //
//                                                                            //
// v0.2 (5th March 2019)                                                      //
//  - Added support for holes in lid                                          //
//    Up to three rows/columns (choose and blank the other)                   //
//    Specify array of hole diameters for each row/column. Holes will be      //
//      equally spaced in the row/column of choosing.                         //
//                                                                            //
// v0.1 (4th March 2019)                                                      //
//  - Initial version                                                         //
//                                                                            //
////////////////////////////////////////////////////////////////////////////////

//Customisable parameters

$fn = 1 * 256;
// Interal width of box (x-axis)
width = 90;

// Internal depth of box (y-axis)
depth = 50;

// Internal height of box (z-axis)
height = 20;

// Wall thickness
wall_thickness = 2;

// Snap fit clearance (adjust based on printer accuracy)
snap_clearance = 0.5;

// Height of snap between lid and base
snap_depth = 2;

// Diameter of hole for power-jack (set to 0 to remove hole)
power_hole_diameter = 9;

// Proto-board width (x-axis) (set to 0 to disable proto-board mounts) [This should be the full width, the script automatically positions the center of the mounting pegs 1.75mm in from each edge]
proto_width = 70; //set to 0 to disable proto-board mounts

// Proto-board depth (y-axis) (set to 0 to disable proto-board mounts) [This should be the full depth, the script automatically positions the center of the mounting pegs 1.75mm in from each edge]
proto_depth = 30;

// Distance to offset protoboard from box edge (x-axis) (ignored if proto_width or proto_depth are 0)
proto_width_offset = 5;

// Distance to offset protoboard from box edge (y-axis) (ignored if proto_width or proto_depth are 0)
proto_depth_offset = 5;

// Distance to offset protoboard from inside base of box (z-axis) (ignored if proto_width or proto_depth are 0)
proto_height_offset = 5;

// Thickness of protoboard (ignored if proto_width or proto_depth are 0)
proto_thickness = 1.6;

// Diameter of holes in protoboard (ignored if proto_width or proto_depth are 0)
proto_hole_diameter = 2.5;

// Diameter of shaft of mounting screw (set to 0 to remove mounting holes)
screw_mount_diameter = 3;

// Distance from inside edge to top of mounting holes
screw_mount_offset = 5;

//Left row (x-axis) mounting holes holes (add diameter of holes in array eg "[6, 6, 6]" - they will be spaced equally, set to "[]" to disable.)
left_row_holes = [6, 6,];

//Centre row (x-axis) mounting holes holes (add diameter of holes in array eg "[6, 6, 6]" - they will be spaced equally, set to "[]" to disable.)
center_row_holes = [];

//Right row (x-axis) mounting holes holes (add diameter of holes in array eg "[6, 6, 6]" - they will be spaced equally, set to "[]" to disable.)
right_row_holes = [];

//Left column (y-axis) mounting holes holes (add diameter of holes in array eg "[6, 6, 6]" - they will be spaced equally, set to "[]" to disable.)
left_column_holes = [];

//Centre column (y-axis) mounting holes holes (add diameter of holes in array eg "[6, 6, 6]" - they will be spaced equally, set to "[]" to disable.)
center_column_holes = [8];

//Right column (y-axis) mounting holes holes (add diameter of holes in array eg "[6, 6, 6]" - they will be spaced equally, set to "[]" to disable.)
right_column_holes = [];

// Non-customisable parameters
// (The maths stops them showing up in Thingiverse's customizer app.

$fn = 1 * 256;
proto_pillar_diameter = 1.0 * 3.5;

box_body();
proto_mounts_base();
translate([0, depth + 20, 0]){
  box_top();
  proto_mounts_top();
}

module box_body() {
  translate([
      2 * wall_thickness,
      2 * wall_thickness,
      0]) {
    difference () {
      minkowski() {
        cube([
          width - (2 * wall_thickness),
          depth - (2 * wall_thickness),
          height / 2]
        );
        cylinder(
          h = height / 2,
          r = 2 * wall_thickness
        );
      }
      translate([0, 0, wall_thickness]) {
        minkowski() {
          cube([
            width - (2 * wall_thickness),
            depth - (2 * wall_thickness),
            height / 2]
          );
          cylinder(
            h = height / 2,
            r = wall_thickness
          );
        }
      }
      translate([0, 0, height - snap_depth]) {
        minkowski() {
          cube([
            width - (2 * wall_thickness),
            depth - (2 * wall_thickness),
            snap_depth
          ]);
          cylinder(
            h = snap_depth,
            r = wall_thickness + (wall_thickness / 2) + (snap_clearance / 2)
          );
        }
      }
      translate([
        width - (wall_thickness + (wall_thickness / 2)),
        (depth - (2 * wall_thickness)) / 2,
        height / 2]) {
          rotate([0, 90, 0])
            cylinder(
              h = 2 * wall_thickness,
              r = power_hole_diameter / 2
            );
      }
      notch_width = min(depth / 3, 12);
      translate([
        -(2 * wall_thickness + (wall_thickness / 2)),
        (depth - (2 * wall_thickness) - notch_width) / 2,
        height + snap_depth]) {
          rotate([0, 90, 0])
            cube([
              2 * wall_thickness,
              notch_width,
              2 * snap_depth
            ]);
      }
      if(screw_mount_diameter !=0) {
        screw_mounts();
      }
    }
  }
}

module box_top() {
  translate([2 * wall_thickness, 2 * wall_thickness, 0]) {
    difference() {
      union() {
        minkowski() {
          cube(
            [width - (2 * wall_thickness),
             depth - (2 * wall_thickness),
             wall_thickness / 2]
          );
          cylinder(
            h = wall_thickness / 2,
            r = 2 * wall_thickness
          );
        }
        minkowski() {
          cube(
            [width - (2 * wall_thickness),
             depth - (2 * wall_thickness),
             (wall_thickness + snap_depth) / 2]
          );
          cylinder(
            h = (wall_thickness + snap_depth) / 2,
            r = wall_thickness + (wall_thickness / 2)
          );
        }
      }
      translate([0, 0, wall_thickness]) {
        minkowski() {
          cube(
            [width - (2 * wall_thickness),
             depth - (2 * wall_thickness),
             height / 2]
          );
          cylinder(
            h = height / 2,
            r = wall_thickness
          );
        }
      }
      row_holes();
      column_holes();
    }
  }
}

module proto_mounts_base() {
  if(proto_width != 0 && proto_depth != 0) {
    translate([
      (wall_thickness + (proto_pillar_diameter / 2)) + proto_width_offset,
      (wall_thickness + (proto_pillar_diameter / 2)) + proto_depth_offset,
      wall_thickness]) {
        proto_pillars();
    }
  }
}

module proto_pillars() {
  proto_pillar();
  translate([proto_width - proto_pillar_diameter, 0, 0]) proto_pillar();
  translate([0, proto_depth - proto_pillar_diameter, 0]) proto_pillar();
  translate([proto_width - proto_pillar_diameter, proto_depth - proto_pillar_diameter, 0]) proto_pillar();
}

module proto_pillar() {
  union() {
      cylinder(
        h = proto_height_offset,
        r = proto_pillar_diameter / 2
      );
      cylinder(
        h = proto_height_offset + proto_thickness + snap_depth,
        r = (proto_hole_diameter - snap_clearance) / 2
      );
  }
}

module proto_mounts_top() {
  if(proto_width != 0 && proto_depth != 0) {
    translate([
      (wall_thickness + (proto_pillar_diameter / 2)) + proto_width_offset,
      (wall_thickness + depth +(proto_pillar_diameter / 2)) - (proto_depth_offset + proto_depth),
      wall_thickness]) {
        proto_clips();
    }
  }
}

module proto_clips() {
  proto_clip();
  translate([proto_width - proto_pillar_diameter, 0, 0]) proto_clip();
  translate([0, proto_depth - proto_pillar_diameter, 0]) proto_clip();
  translate([proto_width - proto_pillar_diameter, proto_depth - proto_pillar_diameter, 0]) proto_clip();
}

module proto_clip() {
  clip_height = height - proto_height_offset - proto_thickness - snap_clearance;
  hole_height = snap_depth + (2 * snap_clearance);
  difference() {
    cylinder(
      h = clip_height,
      r = proto_pillar_diameter / 2
    );
    translate([0, 0, clip_height - hole_height]) cylinder(
      h = hole_height + snap_clearance,
      r = proto_hole_diameter / 2
    );
  }
}

module screw_mounts() {
  union() {
    translate([
      screw_mount_diameter / 2  + snap_clearance - wall_thickness + screw_mount_offset,
      (depth / 2) - wall_thickness,
      0]) screw_mount();
    translate([
      (width / 4) - wall_thickness,
      depth - wall_thickness - (((screw_mount_diameter / 2) + (snap_clearance / 2)) + screw_mount_offset),
      0]) rotate([0, 0, -90]) screw_mount();
    translate([
      (3 * width / 4) - wall_thickness,
      depth - wall_thickness - (((screw_mount_diameter / 2) + (snap_clearance / 2)) + screw_mount_offset),
      0]) rotate([0, 0, -90]) screw_mount();
  }
}

module screw_mount() {
  translate([0, 0, -(wall_thickness / 2)]) union() {
    hull() {
      cylinder(
        h = wall_thickness * 2,
        r = (screw_mount_diameter / 2) + (snap_clearance / 2)
      );
      translate([2 * screw_mount_diameter, 0 , 0]) cylinder(
        h = wall_thickness * 2,
        r = (screw_mount_diameter / 2) + (snap_clearance / 2)
      );
    }
    translate([2 * screw_mount_diameter, 0 , 0]) cylinder(
      h = wall_thickness * 2,
      r = screw_mount_diameter
    );
  }
}

module row_holes() {
  if (len(left_row_holes) > 0) {
    left_row_num = len(left_row_holes);
    left_row_spacing = (width + (2 * wall_thickness)) / (left_row_num + 1);
    left_row_y = (depth + (2 * wall_thickness)) * (3 / 4);
    translate([
      -(2 * wall_thickness),
      left_row_y - (2 * wall_thickness),
      -(wall_thickness / 2)
      ]) union () {
      for (i =[0 : 1: (left_row_num -1)]) {
        translate ([(left_row_spacing * (i + 1)), 0, 0])
          cylinder(
            h = wall_thickness * 2,
            r = left_row_holes[i] / 2
        );
      }
    }
  }
  if (len(center_row_holes) > 0) {
    center_row_num = len(center_row_holes);
    center_row_spacing = (width + (2 * wall_thickness)) / (center_row_num + 1);
    center_row_y = (depth + (2 * wall_thickness)) * (1 / 2);
    translate([
      -(2 * wall_thickness),
      center_row_y - (2 * wall_thickness),
      -(wall_thickness / 2)
      ]) union () {
      for (i =[0 : 1: (center_row_num -1)]) {
        translate ([(center_row_spacing * (i + 1)), 0, 0])
          cylinder(
            h = wall_thickness * 2,
            r = center_row_holes[i] / 2
        );
      }
    }
  }
  if (len(right_row_holes) > 0) {
    right_row_num = len(right_row_holes);
    right_row_spacing = (width + (2 * wall_thickness)) / (right_row_num + 1);
    right_row_y = (depth + (2 * wall_thickness)) * (1 / 4);
    translate([
      -(2 * wall_thickness),
      right_row_y - (2 * wall_thickness),
      -(wall_thickness / 2)
      ]) union () {
      for (i =[0 : 1: (right_row_num -1)]) {
        translate ([(right_row_spacing * (i + 1)), 0, 0])
          cylinder(
            h = wall_thickness * 2,
            r = right_row_holes[i] / 2
        );
      }
    }
  }
}

*column_holes();

module column_holes() {
  if (len(left_column_holes) > 0) {
    left_column_num = len(left_column_holes);
    left_column_spacing = (depth + (2 * wall_thickness)) / (left_column_num + 1);
    left_column_x = (width + (2 * wall_thickness)) * (1 / 4);
    translate([
      left_column_x - (2 * wall_thickness),
      -(2 * wall_thickness),
      -(wall_thickness / 2)
      ]) union () {
      for (i =[0 : 1: (left_column_num -1)]) {
        translate ([0, (left_column_spacing * (i + 1)), 0])
          cylinder(
            h = wall_thickness * 2,
            r = left_column_holes[i] / 2
        );
      }
    }
  }
  if (len(center_column_holes) > 0) {
    center_column_num = len(center_column_holes);
    center_column_spacing = (depth + (2 * wall_thickness)) / (center_column_num + 1);
    center_column_x = (width + (2 * wall_thickness)) * (1 / 2);
    translate([
      center_column_x - (2 * wall_thickness),
      -(2 * wall_thickness),
      -(wall_thickness / 2)
      ]) union () {
      for (i =[0 : 1: (center_column_num -1)]) {
        translate ([0, (center_column_spacing * (i + 1)), 0])
          cylinder(
            h = wall_thickness * 2,
            r = center_column_holes[i] / 2
        );
      }
    }
  }
  if (len(right_column_holes) > 0) {
    right_column_num = len(right_column_holes);
    right_column_spacing = (depth + (2 * wall_thickness)) / (right_column_num + 1);
    right_column_x = (width + (2 * wall_thickness)) * (3 / 4);
    translate([
      right_column_x - (2 * wall_thickness),
      -(2 * wall_thickness),
      -(wall_thickness / 2)
      ]) union () {
      for (i =[0 : 1: (right_column_num -1)]) {
        translate ([0, (right_column_spacing * (i + 1)), 0])
          cylinder(
            h = wall_thickness * 2,
            r = right_column_holes[i] / 2
        );
      }
    }
  }
}
