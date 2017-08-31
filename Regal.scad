//$thickness=3; 
//$spiel=0;  //wie sehr solls Wackeln






//Das Modul regal Baut ein einfaches Regal nach festgelegbaren Außenmaßen her. Es stellt sowohl eine Ansicht des vertigen Regals zur verfügung als auch Schnittmuster für alle Bauteile. Als auch eine Anleitung zum zusammenbau.
//Es sind 6 Modies zur auswahl:
//assemble gibt die ansicht des vertig zusammengebauten Regals aus.
//teile gibt ein schnittmuster aus, das alle EinzelTeile des Regals enthällt.
//rueckwand, deckel, bord und seitenwand geben jeweils ein Schnittmuster des entsprechenden Teils aus, wobei daran zu denken ist, dass für das fertige Regal von deckel und Seitenwänden jeweils 2 und von bord eines weniger als man fächer hat benötigt werden
//animation gibt eine animierte Bauanleitung des Zusammenbaus aus. Denke daran, im menuepunkt view animate auszuwählen steps mindestens 10 und FPS etwa 1/10 der steps sind gute Einstellungen um für diese animation
//regal hat 5 EingabeWerte der reihenfolge nach:
// tiefe, breite, hoehe stellen jeweils die entsprechenden Außenmaße da.

//Offene Diskussion: ist die Reihenfolg "tiefe, breite, hoehe" intuitiv? Die im Handwerk übliche reihenfolge "breit, hoehe, tiefe" ist offenkundig Kacke. Die Reheinfolge muss der Coordinatenreihenfolge der Achsen folgen "x,y,z" und die z-Achse bleibt zu kompatibilitätszwecken der hoehe zugeordnet. Wie herrum breite und tiefe der x, und y Achse zugeordnet werden kann diskutiert werden. Das Rational für die gewählte Reihenfolge ist, dass "Länge, Breite, Höhe" eine übliche Reihenfolge ist. hier steht die Breite an zweiter stelle, somit bleibt für die Tiefe nur noch der erste Platz. Sie ist sozusagten ein Synnonym für Länge


// die Variable faecher ....
// Der modus gibt den oben angegebenen Modus an
// Der Rand gibt an, wie weit Deckel und Boden überstehen
// Das Modul Regal  Greift auf das Modul verzahnung zurück und ist daher von den Modulenh verzahnung, stollen so wie zapfen abhängig. 
//Die besonderen Variablen $thickness und $spiel beeinflussen es. Man sehe also zu, dass diese gesetzt sind




assemble=0;
teile=1;
rueckwand=2;
deckel=3;
bord=4;
seitenwand=5;
animation=6;


module regal(
            tiefe=100,
            breite=100,
            hoehe=350,
            faecher=5,
            modus=0,

            rand=5

            )
{
    //hier wird der Modus ausgeführt. die entsprechenden Module stehen weiter unten.
    if(modus==0) animation($t=1);
    if(modus==1) teile();
    if(modus==2) rueckwand();
    if(modus==3) deckel();
    if(modus==4) bord();
    if(modus==5) seitenwand();
    if(modus==6) animation();

   DELTA = 0.001; 
        //DELTA Produziert einen minimalen Abstand zwischen dein Teilen, damit hier überhaupt ein Schnitt stattfindet dieses findet im Modul teile() statt.
    

   
   //zwar sind in diesem Design der Rand an der Rückseite und an den seiten links und rechts als gleichgroß gesetzt. Ein zukünftiges anderes design könnte hier aber durchaus einen anderen Weg gehen.
    
    rueckrand = rand;
    seitenrand = rand;
    
    //hier werden ein paar maße ausrechnen, die wir später noch brauchen.
    innenhoehe = hoehe-2*$thickness;
    innenbreite = breite-2*($thickness+seitenrand);
    innentiefe = tiefe-($thickness+rueckrand);
    
    
    brettpositionen=aufteiler(); //die höhen der bretter gemessen am innenboden 
    echo(brettpositionen);
    brettanzahl=len(brettpositionen);
    
    // die folgende Funktion ermöglicht, dass für die Variable faecher sowohl eine Zahl (die anzahl der Fächer) als auch ein Vector(die positionen der Bretter) eingegeben werden können. Die DefaultWerte sind für diesen zweck eingestellt, in zukünftigen Designs könnte sie jedoch durchaus auch für andere ähnliche zwecke verwendet werden. Bekommt Sie einen Vektor (mit tatsächlichen einträgen) so gibt sie diesen wider aus. Bekommt sie eine Zahl und eine laenge, so gibt sie einen entsprechenden Vektor aus, der die Länge in eine entsprechende Anzahl von fächern unter einbeziehung der aktuellen $thickness aufteilt.
    
    function aufteiler(x=faecher,laenge=innenhoehe)
        =(
            len(x)>=1  ?   x   
            :
            let(zwischenraum=(laenge-(x-1)*$thickness)/x)        
            [for(k=[1:x-1]) k*(zwischenraum+$thickness)-$thickness]
         );

    // nun einige Fehlermeldungen, um schlechte übergabewerte für das Regal abzufangen
    if(!(innenhoehe>0&&innenbreite>0&&innentiefe>0)) echo("<font color='red'>  schlechte eingabewerte in regal()</font>");   
   //hier für die Brettpositionen
    for (k=[1:brettanzahl-1])
	{
		if(!(brettpositionen[k]-$thickness>brettpositionen[k-1])) echo("<font color='red'>  vehlerhafter Eingabewert in fächer </font>");   
	}     
    if (!(brettpositionen[0])>0&&(brettpositionen[brettanzahl-1])<innenhoehe-$thickness)cho("<font color='red'>  vehlerhafter Eingabewert in fächer </font>");   
   
 
  
    
    // Im folgenden werden die einzelteile als 2d formen definiert diese sind im wesentlichen Rechtecke (sqare(vektor)) zu denen Zähne hinzukommen bezihungsweise von denen Löcher abgezogen werden um verbindungen mit benachbarten Brettern herzustellen.  xx_xxx(); stellt dabei jeweils die verbindung zwischen den entsprechenden Modulen da, wobei die eingabe true die Form aufruft, die hinzuzufügen ist und die Eingabe false die entsprechende gegen Form.
    
    module bord()
    {
            square([innentiefe, innenbreite]); //hauptteil
            mirror() bord_rueckwand(true);
                    bord_seitenwand(true);
           translate( [0, innenbreite]) mirror([0,1]) bord_seitenwand(true);
        
    }
    
    
    
    module rueckwand()
    {
        difference()
        {
            square([innenhoehe, innenbreite]);  //hauptteil
            for (k = brettpositionen)
                translate([k, 0]) bord_rueckwand(false);
        }
        mirror() deckel_rueckwand(true);
        translate( [innenhoehe, 0]) deckel_rueckwand(true);
        rotate(-90) seitenwand_rueckwand();
        translate([0, innenbreite])
                rotate(-90) mirror() seitenwand_rueckwand();
    }
    
    
    
    
    module deckel()
    {
        difference()
        {
            square([tiefe, breite]);	//hauptteil
            translate([rueckrand, $thickness+seitenrand]) deckel_rueckwand(false);
            for (k = [$thickness+seitenrand, breite-seitenrand])
                translate([0, k, 0]) deckel_seitenwand(false);
        }
    }
    
    
    
    module seitenwand()
    {
        difference()
        {
            square([tiefe, innenhoehe]);	//hauptteil
            for (v = brettpositionen)
                translate([$thickness+rueckrand, v+$thickness]) 
                    bord_seitenwand(false);
            translate([rueckrand,0,0]) seitenwand_rueckwand(false);
        }
        deckel_seitenwand(true);
        translate([ 0,innenhoehe]) mirror([0,1]) deckel_seitenwand(true);
    }
    
    // hier folgt eine Liste der jeweiligen Verbindungen zwischen den Modulen. zwar wird hier zeweils nur die verbindung verzahnung() verwendete andere sind jedoch möglich. 
   //Man könnte sich nun Fragen, warum ich aus jedem der aufruf der verzahnung() ein eigenes Modul gemacht hab. es geht natürlich darum semantic und content zu trennen.
  //Sollten z.B. zu einem späteren Zeitpunkt weitere Konektoren hinzu kommen, so kann ein entsprechender fork dieses projektes diese in die zugehörigen module einschreiben und sie werden ihren Weg an die richtige Stelle in den jeweiligen Brettern finden.
    
    module seitenwand_rueckwand(z = true)
    {
        verzahnung(innenhoehe, z);
    }
     
    module bord_rueckwand(z = true)
    {
        verzahnung(innenbreite, z);
    }
    
    module deckel_rueckwand(z = true)
    {
        verzahnung(innenbreite, z);
    }
    module bord_seitenwand(z = true)
    {
        rotate(-90) verzahnung(innentiefe,z);
    }
    
    module deckel_seitenwand(z = true)
    {
        rotate(-90) verzahnung(tiefe, z);
    } 
       
    
    // Das folgende Code frakment wird eigendlich nicht mehr gebraucht, da sein ergebnis als spezialfall des Moduls animation() erzeugt werden kann. Zu anschauungszwecken lasse ich es aber ersteinmal da. Es diente das vertige objekt zu sehen. Dieses sollte immer eines der ersten Dinge sein, die man schreibt wenn. Man Schnittmuster für ein objekt macht.
    
    /*
    module assemble()
    {
        for (v = [[0, $thickness, $thickness], [0, breite, $thickness]])
            translate(v)
                rotate([90,0,0])
                    linear_extrude($thickness) seitenbrett();
        
        for (v=[[0,0,0],[0,0,hoehe-$thickness]])
            translate(v)
                linear_extrude($thickness) deckel();
    
        translate([$thickness, $thickness, $thickness]) 
            rotate([0,-90,0])
                linear_extrude($thickness) rueckwand();
    
        for (k = brettpositionen)
            translate([$thickness, $thickness, k+$thickness])
                linear_extrude($thickness) bord();
    }
    */
    

// Das Modul teile() Puzzeled die 2d formen so zusammen, das sie als gemeinsames schnittmuster ausgegeben werden können.


    module teile()
    {


        translate([$thickness, $thickness]) rueckwand();
        
        for (v = 
                [
                    [$thickness, innenbreite+2*$thickness+tiefe+DELTA], 
                    [$thickness, innenbreite+2*($thickness+tiefe+DELTA)]
                ])
            translate(v) 
                rotate(-90) seitenwand();
        
        for (k = [1 : brettanzahl])
            translate([hoehe+k*(innentiefe+$thickness+DELTA)-innentiefe, $thickness])
                bord();
        
        for (v = [[hoehe+DELTA, innenbreite+2*$thickness+tiefe+DELTA],
                [hoehe+DELTA, innenbreite+2*($thickness+tiefe+DELTA)]])
            translate(v)
                rotate(-90) deckel();
    }
    
    // Das Modul animation() erzeugt eine animierte Bauanleitung. Wobei animation($t=1) das vertige Modell zeigt.
    
    
    module animation()
    {
        aufbau()
        {
                 translate([$thickness+rueckrand, $thickness+seitenrand, $thickness])
                rotate([0,-90,0])
                    linear_extrude($thickness) rueckwand();

                for (k = brettpositionen)
                    translate([$thickness+rueckrand, $thickness+seitenrand, k+$thickness])
                        linear_extrude($thickness) bord();
        
                for (v = [[0, $thickness+seitenrand, $thickness], [0, breite-seitenrand, $thickness]])
                    translate(v)
                        rotate([90,0,0])
                            linear_extrude($thickness) seitenwand();
            
        

                for (v = [[0, 0, 0], [0, 0, hoehe-$thickness]])
                    translate(v)
                        linear_extrude($thickness) deckel();
            

            } 
    }
}


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

//Das Modul aufbau gibt eine Animationssystematik. Die mit ihm aufgerufenen Module erscheinen in der Reihenfolge des aufrufes.


module aufbau()
{
    for(n=[0:$children-1])if($t*$children>=n)children(n);
}

