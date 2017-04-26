include<lib.scad>
$thickness=3;
$spiel=0;
dachhoehe=250;
dachlaenge =600-18;
dachbreite=300;
rand=9;
halter=10;
 deckbreite=norm([dachhoehe,dachbreite/2]);
 dachwinkel=atan2(dachhoehe,dachbreite/2);
 module traeger()
 {
     dreieck(dachbreite,dachhoehe);
     translate([0,dachhoehe])rotate(90+dachwinkel) traeger_dachplatte(z=true);
      mirror()    translate([0,dachhoehe])rotate(90+dachwinkel) traeger_dachplatte(z=true);

 }
 //traeger();
 //dachplatte();
 module dachplatte()
 {
     difference()
     {
     square([deckbreite,dachlaenge+2*rand]);
        for(k=[$thickness+rand,dachlaenge+rand])translate([0,k])rotate(-90) traeger_dachplatte(false);
     }
     
 }

//gesammt();
 module gesammt()
 {
    # for(k=[$thickness,dachlaenge])
     translate([0,k,0])rotate(90,[1,0,0])linear_extrude($thickness)traeger();
  
    translate([dachbreite/2,-rand,0]) rotate(dachwinkel,[0,1,0])linear_extrude($thickness)
          mirror() Dachplatte_mit_Fenster([deckbreite-60-60,60],60,60,0); 

        

    mirror()translate([0,-rand,dachhoehe]) rotate(dachwinkel,[0,1,0])linear_extrude($thickness) dachplatte();
 }
 
 module traeger_dachplatte(z=true)
 {
     verzahnung(deckbreite,z,halter);
 }
 
 
  module dreieck(grundseite=1,hoehe=1)
 {
 polygon([[grundseite/2,0],[0,hoehe],[-grundseite/2,0]]); 
 }
 
 module fenster(position,breite,hoehe,rundung)
 {
             translate(position+[rundung,rundung]) 
{
     difference()
    {
            minkowski()
                {
                     square([hoehe-rundung,breite]);
                    sphere(rundung);
                }
         for(k=[1/4*breite,3/4*breite]) translate([hoehe-7,k]) square([3,5]);
     }
 }
 }                                  
    Dachplatte_mit_Fenster([deckbreite-60-60,60],60,60,0);     
     
 
 module Dachplatte_mit_Fenster(position,breite,hoehe,rundung)
 {
     difference ()
     {
         dachplatte();
         fenster(position=position,breite=breite,hoehe=hoehe,rundung=rundung);
         translate(position)
                  for(k=[1/4*breite,3/4*breite]) translate([hoehe+5,k]) square([3,5]);
         translate([0,180]) square([deckbreite-60,dachlaenge-180-120]);

     }
 }
       
 
//dachplatte();
// traeger_dachplatte(z=true);
//         rotate(-90) traeger_dachplatte(false);
//traeger();