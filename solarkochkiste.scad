include <lib.scad>;
$thickness=5;
$spiel=0;

breite=600;
tiefe=300;
hoehe=300;
rand=10;

glasbreite=550;
glastiefe=250;
fensterrundung=50;

spiegelbreite=400;
spiegeltiefe=400;

innenbreite=400;
innentiefe=100;
innenhoehe=100;

rippenabstand=150; 

resthoehe=hoehe-($thickness+rand);
restbreite=breite-2*($thickness+rand);

resttiefe=tiefe-2*($thickness);


module unterseite()
{
    square([resttiefe,restbreite]);
   
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
    square([resttiefe,hoehe]);
}

module tiefe_rippe(pos)
{
    difference()
    {
        square([resttiefe,resthoehe]);
    if  ( pos>=(restbreite-innenbreite)/2
         &&
         pos<= (restbreite+innenbreite)/2+$thickness)
           
            translate([(resttiefe-innentiefe)/2,resthoehe-innenhoehe]) 
                square ([innentiefe,innenhoehe]);
    }
}
module breite_rippe(pos)
{
    difference()
    {
        square([resthoehe,restbreite]);
            if  ( pos>=(tiefe-innentiefe)/2-$thickness
                 &&
                 pos<=(tiefe+innentiefe)/2)
           
    translate([resthoehe-innenhoehe,(restbreite-innenbreite)/2]) square ([innenhoehe,innenbreite]);
    }
}

module deckplate()
{
    difference()
    {
        square([tiefe,breite]);
        translate([(tiefe-innentiefe)/2,(breite-innenbreite)/2])square([innentiefe,innenbreite]);
    }
}

module glasrahmenmitte()
{
     difference()
     {
         square([tiefe,breite]);
         translate([(tiefe-glastiefe)/2,(breite-glasbreite)/2]) square([glastiefe,glasbreite]);
     }   
}
module fenster()
{
    minkowski()
    {
        square([innentiefe,innenbreite]);
        circle(fensterrundung);
    }
}
module glasrahmenoben()
{
    difference()
    {
        square([tiefe,breite]);
            translate([(tiefe-innentiefe)/2,(breite-innenbreite)/2])fenster();
    }
    
}
module glasrahmen()
{
    for(k=[[0,0,0],[0,0,2*$thickness]])
        translate(k)linear_extrude($thickness)glasrahmenoben();
    translate([0,0,$thickness])linear_extrude($thickness) glasrahmenmitte();
}
module sockel()
{
    difference()
    {
        fenster();
        square([innentiefe,innenbreite]);
    }
}
module assemble()
{
   translate([$thickness,rand+$thickness,rand]) linear_extrude($thickness) unterseite();
   translate([$thickness,0,0]) rotate(-90,[0,1,0]) linear_extrude($thickness) vorderseite();
    translate([tiefe,0,0]) rotate(-90,[0,1,0]) linear_extrude($thickness) rueckseite();
   for(k=[[$thickness,$thickness+rand,0],[$thickness,breite-rand,0]]) translate(k) rotate(90,[1,0,0]) linear_extrude($thickness) seite();
   translate([$thickness,rand+$thickness,rand+$thickness])
    {   
       for(k=[rippenabstand:rippenabstand:restbreite]) translate([0,k,0]) 
      
              rotate(90,[1,0,0]) linear_extrude($thickness) tiefe_rippe(k);
       
                 for(k=[rippenabstand:rippenabstand:resttiefe])  translate([k,0,0]) rotate(-90,[0,1,0]) linear_extrude($thickness) breite_rippe(k);
                 }
                 translate([0,0,hoehe])linear_extrude($thickness)deckplate();


}
 //assemble();
//glasrahmenoben();
//glasrahmen();
sockel();