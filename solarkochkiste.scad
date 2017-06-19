include <lib.scad>;
$thickness=5;
$spiel=0;

breite=600;
tiefe=500;
hoehe=400;
rand=10;

glasbreite=400;
glastiefe=400;
spiegelbreite=400;
spiegeltiefe=400;

innenbreite=300;
innentiefe=200;
innenhoehe=200;

rippenabstand=50; 

resthoehe=hoehe-($thickness+rand);
restbreite=breite-2*$thickness;

resttiefe=tiefe-2*($thickness+rand);


module unterseite()
{
    square([resttiefe,restbreite]);
   
}
module vorderseite()
{
    square([hoehe,restbreite]);
}
module rueckseite()
{
    square([hoehe,restbreite]);
}
module seite()
{
    square([tiefe,hoehe]);
}

module tiefe_rippe(pos)
{
    difference()
    {
        square([resttiefe,resthoehe]);
    if  ( pos>=(breite-innenbreite)/2
         &&
         pos<= (breite+innenbreite)/2)
           
            translate([(resttiefe-innentiefe)/2,resthoehe-innenhoehe]) 
                square ([innentiefe,innenhoehe]);
    }
}
module breite_rippe(pos)
{
    difference()
    {
        square([resthoehe,restbreite]);
            if  ( pos>=(resttiefe-innentiefe)/2
                 &&
                 pos<=(resttiefe+innentiefe)/2+$thickness)
           
    translate([resthoehe-innenhoehe,(restbreite-innenbreite)/2]) square ([innenhoehe,innenbreite]);
    }
}

module assemble()
{
   translate([rand,$thickness,rand]) linear_extrude($thickness) unterseite();
   translate([rand,$thickness,0]) rotate(-90,[0,1,0]) linear_extrude($thickness) vorderseite();
    translate([tiefe-(rand+$thickness),$thickness,0]) rotate(-90,[0,1,0]) linear_extrude($thickness) rueckseite();
   for(k=[[0,$thickness,0],[0,breite,0]]) translate(k) rotate(90,[1,0,0]) linear_extrude($thickness) seite();
   translate([rand,$thickness,rand+$thickness])
    {   
       for(k=[rippenabstand:rippenabstand:restbreite]) translate([0,k,0]) 
      
              rotate(90,[1,0,0]) linear_extrude($thickness) tiefe_rippe(k);
       
            #     for(k=[rippenabstand:rippenabstand:resttiefe])  translate([k,0,0]) rotate(-90,[0,1,0]) linear_extrude($thickness) breite_rippe(k);
                 }


}
 assemble();