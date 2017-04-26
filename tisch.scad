include <lib.scad>;
$thickness=3;
$spiel=0;
radius=25;
tischhoehe=50;
rand=10;

//platte();

module platte()
{
    circle(radius);
}
//gesammt();
module gesammt()
{
    translate ([0,0,tischhoehe-$thickness])linear_extrude($thickness)platte();
   translate ([0.5*$thickness,-radius+rand,0])rotate(-90,[0,1,0])linear_extrude ($thickness)xbein();
        translate ([-radius+rand,0.5*$thickness,0])rotate(90,[1,0,0])linear_extrude ($thickness)ybein();

}
//xbein();
module xbein()
{
    difference()
    {
        square([tischhoehe-$thickness,2*(radius-rand)]);
       translate([0,radius-rand-0.5*$thickness]) x_y(true);
    }
}
//ybein();
module ybein()
{
    difference()
    {
    square([2*(radius-rand),tischhoehe-$thickness]);
           translate([radius-rand+0.5*$thickness,0])
        #rotate(90)x_y(false);
    }

}

module x_y(z=true)
{
    steckung(tischhoehe-$thickness,z);
    
}
module platte_x()
{
    verzahnung(radius-2*rand );
}