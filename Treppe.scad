use<lib.scad>
$thickness=3;
$spiel=0;
ueberwindungshoehe=170;
platz=280;
breite=50;
stufenbreite=30;
stege=15;
stufenzahl=(platz/stufenbreite)-1;
stufenhoehe=ueberwindungshoehe/stufenzahl;
staecker=stufenbreite-stege;

module loecher()
{
for(k=[1:stufenzahl]) translate(k*[stufenhoehe,stufenbreite]) translate([0,stege/2]) stollen(staecker);
}
module seitenteil()
{
difference()
{
polygon([[$thickness,0],[0,0],[0,stufenbreite],[ueberwindungshoehe,platz],[ueberwindungshoehe+$thickness,platz],[ueberwindungshoehe+$thickness,platz-stufenbreite]]);
*    intersection()
    {
    square([ueberwindungshoehe,platz]);
    translate([-stufenbreite,0])rotate(-atan2(stufenhoehe,stufenbreite)) 
        square([stufenbreite+stufenhoehe,ueberwindungshoehe+platz]);
    }
loecher();
}
mirror() zapfen(6);

}

module stufe()
{
    square([breite-4*$thickness,stufenbreite]);
    translate([breite-4*$thickness,stege/2]) zapfen(staecker, $thickness=2*$thickness);
    translate([0,stege/2])mirror() zapfen (staecker,$thickness=2*$thickness );
}
module gesammt()
{
for (k=[-$thickness,0,breite-3*$thickness,breite-2*$thickness]) translate([k,0,0])rotate(-90,[0,1,0])linear_extrude($thickness) seitenteil();
for(k=[1:stufenzahl]) translate(k*[0,stufenbreite,stufenhoehe])  linear_extrude($thickness) stufe();
}

//stufe();

gesammt();
//seitenteil();

//