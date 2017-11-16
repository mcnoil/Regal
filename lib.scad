// Das Modul verzahnugn() macht die form, für eine Reihe von Zähnen (true) beziehungsweise Löcher (false) für dies Zähne. Die laenge gibt an, über welche Strecke verzahnt werden soll, wobei darauf geachtet ist, dass dafor und dahinter genügend Platz bleibt. z gibt an, ob die form für den Zapfen oder für den Stollen gemacht werden soll. Und die zahnlaenge, wie  groß die Zähne werden.
// Es benutzt die Module Zapfen (Zähne) und Stollen (Löcher). Ausserdem hängt es von den Besonderen Variablen $thickness und $spiel ab.
$thickness= 3;
$spiel=0;
module verzahnung(laenge, z = true,zahnlaenge=10)
{
   
    positionen=[for (k = [zahnlaenge : 2*zahnlaenge : laenge-2*zahnlaenge])k];
    if (!(len(positionen)>0)) echo("<font color='red'>verzahnungsfehler</font>");
    if (len(positionen)==1) echo("<font color='red'>reicht dir ein Zahn?</font>");

    rest=laenge-(positionen[len(positionen)-1]+zahnlaenge);
    translate([0,(rest-zahnlaenge)/2])
    {
        for (k = positionen)
        {
               translate([0,k]) 
		{ 
                if (z) zapfen(zahnlaenge);
                else stollen (zahnlaenge);
                }
         }
     }
}

//Das Modul stollen() macht die Form für ein einzelnes Loch passend zum dazugehörigen Zapfen.

module stollen(zahnlaenge=10)
{
    translate([-0.5*$spiel, 0]) square([$thickness+$spiel, zahnlaenge]);
}

//Das Modul zapfen() macht die Form für einen einzelnen Zahn, passend zum dazugehörigen Stollen.

module zapfen(zahnlaenge=10)
{
    wurzel=0.1;  
    //gibt an, wie weit sich der Zapfen mit seinem ursrpung überschneidet hierdurch wird verhindert, dass kleine rechenfehler dazu führen, dass er abgeschnitten wird.
    translate([-wurzel, 0.5*$spiel]) square([$thickness+wurzel, zahnlaenge - $spiel]);
}

 function tensor (z)
	=(
	z ? 1
	:
	!z ? 0
    : false
	);

 module steckung(laenge,z=true)
{
	
translate([laenge*tensor(z)/2,-0.5*$spiel])square([laenge/2+$spiel/2,$thickness+$spiel]);

}


module querriegelzapfen(zahnlaenge=10)
{
     wurzel=0.1;  
    //gibt an, wie weit sich der Zapfen mit seinem ursrpung überschneidet hierdurch wird verhindert, dass kleine rechenfehler dazu führen, dass er abgeschnitten wird.
    translate([-wurzel, 0.5*$spiel]) difference()
    {
        square([3*$thickness+wurzel, 3*zahnlaenge - $spiel]);

        translate([$thickness,zahnlaenge]) stollen(zahnlaenge);
    }
}
//querriegelzapfen(zahnlaenge=20);
module querriegelstollen(zahnlaenge=10)
{
    stollen(3*zahnlaenge);
}

//querriegel(200);
module querriegel(laenge=30,zahnlaenge=10,rand=$thickness)
{
    translate([-rand,0])square([rand,laenge]);
    querriegelpositionen(laenge,zahnlaenge) translate([0,zahnlaenge])square([$thickness+rand,zahnlaenge]);
    
}
module verquerriegelung(laenge, z = true,zahnlaenge=10)
{
    querriegelpositionen(laenge,zahnlaenge)
		{ 
                if (z)  querriegelzapfen(zahnlaenge);
                else  querriegelstollen(zahnlaenge);
         }
 }
     
module querriegelpositionen(laenge,zahnlaenge=10)
{
   
    positionen=[for (k = [3*zahnlaenge : 6*zahnlaenge : laenge-2*zahnlaenge])k];
    if (!(len(positionen)>0)) echo("<font color='red'>verzahnungsfehler</font>");
    if (len(positionen)==1) echo("<font color='red'>reicht dir ein Zahn?</font>");

    rest=laenge-(positionen[len(positionen)-1]+3*zahnlaenge);
    translate([0,(rest-3*zahnlaenge)/2])
    {
        for (k = positionen)
        
               translate([0,k]) children();

     }
}


//Das Modul aufbau gibt eine Animationssystematik. Die mit ihm aufgerufenen Module erscheinen in der Reihenfolge des aufrufes.
module aufbau()
{
    for(n=[0:$children-1])if($t*$children>=n)children(n);
}

verschluss();
module verschluss (z=true)
{
                wurzel=0.1;  

    if(z)
        {
            translate([-wurzel,0]) square([2*$thickness+wurzel, 10]);
            translate([-wurzel,-5+0.5*$spiel]) square([$thickness+wurzel, 20]);

            
            translate([2*$thickness, -5+0.5*$spiel]) square([5,20-$spiel]);
            
    }
    else
    {
            translate([-0.5*$spiel, -5]) square([$thickness+$spiel, 20]);
    }


}

module scheibe()
{
    difference()
    {
        circle(15);
        circle(norm([5,$thickness/2])+$spiel);
        square([$thickness+$spiel,20],center=true);
        
    }
}

