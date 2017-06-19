include <lib.scad>;
$thickness=5;
$spiel=0;

breite=600;
tiefe=500;
hoehe=400;
rand=5;

glasbreite=400;
glastiefe=400;
spiegelbreite=400;
spiegeltiefe=400;

innenbreite=300;
innentiefe=200;
innenhoehe=200;

rippenabstand=100; 

module unterseite()
{
    square([tiefe,breite]);
   
}
module vorderseite()
{
    square([hoehe,breite]);
}
module rueckseite()
{
    square([hoehe,breite]);
}
module seite()
{
    square([tiefe,hoehe]);
}

module tiefe_rippe()
{
    difference()
    {
    square([tiefe,hoehe]);
    translate([(tiefe-innentiefe)/2,hoehe-innenhoehe]) square ([innentiefe,innenhoehe]);
    }
}
module breite_rippe()
{
    difference()
    {
    square([hoehe,breite]);
    translate([hoehe-innenhoehe,(breite-innenbreite)/2]) square ([innenhoehe,innenbreite]);
    }
}

module assemble()
{
    linear_extrude($thickness) unterseite();
     rotate(-90,[0,1,0]) linear_extrude($thickness) vorderseite();
    translate([tiefe,0,0]) rotate(-90,[0,1,0]) linear_extrude($thickness) rueckseite();
   for(k=[[0,0,0],[0,breite,0]]) translate(k) rotate(90,[1,0,0]) linear_extrude($thickness) seite();
          for(k=[rippenabstand:rippenabstand:breite-rippenabstand]) translate([0,k,0]) 
   rotate(90,[1,0,0]) linear_extrude($thickness) tiefe_rippe();
             for(k=[rippenabstand:rippenabstand:tiefe-rippenabstand])  translate([k,0,0]) rotate(-90,[0,1,0]) linear_extrude($thickness) breite_rippe();



}
 assemble();