// Das Modul verzahnugn() macht die form, für eine Reihe von Zähnen (true) beziehungsweise Löcher (false) für dies Zähne. Die laenge gibt an, über welche Strecke verzahnt werden soll, wobei darauf geachtet ist, dass dafor und dahinter genügend Platz bleibt. z gibt an, ob die form für den Zapfen oder für den Stollen gemacht werden soll. Und die zahnlaenge, wie  groß die Zähne werden.
// Es benutzt die Module Zapfen (Zähne) und Stollen (Löcher). Ausserdem hängt es von den Besonderen Variablen $thickness und $spiel ab.

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
//Das Modul aufbau gibt eine Animationssystematik. Die mit ihm aufgerufenen Module erscheinen in der Reihenfolge des aufrufes.
module aufbau()
{
    x=1/$children;
    for(n=[0:$children-1])if($t>=x*n)children(n);
}

