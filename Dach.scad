include<lib.scad>
$thickness=3;
$spiel=0;
dachhoehe=100;
dachlaenge =600;
dachbreite=300;
rand=5;
//halter=20;
 deckbreite=norm([dachhoehe,dachbreite/2]);
 dachwinkel=atan2(dachhoehe,dachbreite/2);
 module traeger()
 {
     dreieck(dachbreite,dachhoehe);
     translate([0,dachhoehe])rotate(90+dachwinkel) traeger_dachplatte(z=true);
      mirror()    translate([0,dachhoehe])rotate(90+dachwinkel) traeger_dachplatte(z=true);

 }
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
     for(k=[$thickness,dachlaenge])
     translate([0,k,0])rotate(90,[1,0,0])linear_extrude($thickness)traeger();
  
    translate([0,-rand,dachhoehe]) rotate(dachwinkel,[0,1,0])linear_extrude($thickness)dachplatte();
    mirror()translate([0,-rand,dachhoehe]) rotate(dachwinkel,[0,1,0])linear_extrude($thickness)dachplatte();

 }
 
 module traeger_dachplatte(z=true)
 {
     verzahnung(deckbreite,z);
 }
 
 
  module dreieck(grundseite=1,hoehe=1)
 {
 polygon([[grundseite/2,0],[0,hoehe],[-grundseite/2,0]]); 
 }
//dachplatte();
// traeger_dachplatte(z=true);
//         rotate(-90) traeger_dachplatte(false);
gesammt(); 
//traeger();