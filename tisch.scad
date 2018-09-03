include <lib.scad>;
$thickness=3;
$spiel=0;
radius=30;
tischhoehe=50;
rand=5;
zahn=5;

//platte();

module platte()
{
    difference()
    {
    circle(radius);
        translate([radius-rand,-0.5*$thickness])rotate(90)platte_y(false);
                translate([-0.5*$thickness,-radius+rand])platte_x(false);

    }
}
gesammt();
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
         translate([tischhoehe-$thickness,0])   platte_x(true);

}
//ybein();
module ybein()
{
    difference()
    {
    square([2*(radius-rand),tischhoehe-$thickness]);
           translate([radius-rand+0.5*$thickness,0])
        rotate(90)x_y(false);
    }
     translate([2*(radius-rand),tischhoehe-$thickness])rotate(90)platte_y(true);

}

module x_y(geschlecht=true)
{
    steckung(tischhoehe-$thickness,geschlecht);
    
}
//platte_x();

module platte_x(geschlecht)
{
        for(k=[0,radius-rand]) translate([0,k])verzahnung((radius-rand),geschlecht,zahn );

}

module platte_y(geschlecht)
{
        verzahnung(2*(radius-rand),geschlecht,zahn );

}