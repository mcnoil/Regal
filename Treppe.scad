use<lib.scad>
$thickness=3;
$spiel=0 ;
ueberwindungshoehe=170;
platz=280;
breite=50;
stufenbreite=30;
stufenzahl=platz/stufenbreite;
stufenhoehe=ueberwindungshoehe/stufenzahl;
staecker=stufenbreite-4;

module loecher()
{
for(k=[1:stufenzahl]) translate(k*[stufenhoehe,stufenbreite]) translate([0,2]) stollen(staecker);
}
module seitenteil()
{
difference()
{
//polygon([[0,-5],[0,stufenbreite],[ueberwindungshoehe,platz+stufenbreite],[ueberwindungshoehe,platz-5]]);
    intersection()
    {
    square([ueberwindungshoehe,platz]);
    translate([-stufenbreite,0])rotate(-atan2(stufenhoehe,stufenbreite)) 
        square([stufenbreite+stufenhoehe,ueberwindungshoehe+platz]);
    }
loecher();
}
}

module stufe()
{
    square([breite-2*$thickness,stufenbreite]);
    translate([breite-2*$thickness,2]) stollen(staecker);
    translate([0,2])mirror() stollen(staecker);
}
module gesammt()
{
for (k=[0,breite-$thickness]) translate([k,0,0])rotate(-90,[0,1,0])linear_extrude($thickness) seitenteil();
for(k=[1:stufenzahl-1]) translate(k*[0,stufenbreite,stufenhoehe])  linear_extrude($thickness) stufe();
}

//stufe();

gesammt();
//seitenteil();

//