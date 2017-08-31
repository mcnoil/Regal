$thickness=3; 
$spiel=0;  //wie sehr solls Wackeln

include <lib.scad>;
include<modiedef.scad>












Schrank(modus=animation );
module Schrank(
            breite=100,
            hoehe=350,
            faecher=5,
            modus=0,
            rand=3,
            gelenk=10,
            platz=0.1
            )
{
    //hier wird der Modus ausgeführt. die entsprechenden Module stehen weiter unten.
    if(modus==0) animation($t=1);
    if(modus==1) teile();
    if(modus==[1,0]) rueckwand();
    if(modus==[1,1]) deckel();
    if(modus==[1,2]) bord();
    if(modus==[1,3]) seitenwand();
    if(modus==2) animation();
    if(modus==[1,5]) tuer();  
        
    

   DELTA = 0.001; 
        //DELTA Produziert einen minimalen Abstand zwischen dein Teilen, damit hier überhaupt ein Schnitt stattfindet dieses findet im Modul teile() statt.
    

          tiefe=breite;
   gelenkradius= norm([0.5*gelenk,$thickness])+platz; 
    
    
    rueckrand = rand;
    seitenrand = gelenkradius +rand;
    vorderrand=seitenrand+5;
    
    //hier werden ein paar maße ausrechnen, die wir später noch brauchen.
    innenhoehe = hoehe-2*$thickness;
    innenbreite = breite-2*($thickness+seitenrand);
    innentiefe = tiefe-($thickness+rueckrand+vorderrand);
    wandtiefe = tiefe-vorderrand;
       tiefe=breite;
    drehpunkt= [wandtiefe,seitenrand-0.5*rand] ;
    tuerhoehe=innenhoehe-platz;
    tuerbreite=innenbreite+gelenk;
    
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

    // nun einige Fehlermeldungen, um schlechte übergabewerte für das Schrank abzufangen
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
                translate([0, k]) deckel_seitenwand(false);
           // translate([wandtiefe,breite-seitenrand+0.5*rand])fuehrung();
               translate(drehpunkt) mirror([0,1]) fuehrung();

        }
    }
    
    
    
    module seitenwand()
    {
        difference()
        {
            square([wandtiefe, innenhoehe]);	//hauptteil
            for (v = brettpositionen)
                translate([$thickness+rueckrand, v+$thickness]) 
                    bord_seitenwand(false);
            translate([rueckrand,0,0]) seitenwand_rueckwand(false);
        }
        deckel_seitenwand(true);
        translate([ 0,innenhoehe]) mirror([0,1]) deckel_seitenwand(true);
    }
    module tuer()
    {
        difference()
        {
            translate([0,-0.5*gelenk])
            {
                translate([$thickness,0])square([tuerhoehe,innenbreite+gelenk]);
                square([hoehe,gelenk]);
            }
          for(k=[2*$thickness,tuerhoehe-$thickness]) translate([k,-0.5*gelenk]) schiene_tuer();
        }
    }
    module fuehrung()
    {
        difference()
        {
            circle(gelenkradius);
            translate([-gelenkradius,-gelenkradius])square(gelenkradius);
        }
        translate([-innenbreite,0])square([innenbreite,$thickness+platz]);
        translate([0,-gelenk])square([$thickness,gelenk]);
    }
    module schiene()
    {
        difference()
        {
            square([3*$thickness,tuerbreite]);
             translate([$thickness,0]) schiene_tuer();
        }
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
    module schiene_tuer()
    {
       schichtlinie(tuerbreite);
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
        translate (  [0, innenbreite+2*($thickness+tiefe+DELTA)+0.5*gelenk+DELTA]) tuer();
        for(k=[hoehe+DELTA,hoehe+3*$thickness+2*DELTA]) translate (  [k, innenbreite+2*($thickness+tiefe+DELTA)+DELTA]) schiene();
            
      for(y=[0:2*$thickness:tuerbreite-$thickness])  translate([hoehe+6*DELTA+6*$thickness, innenbreite+2*($thickness+tiefe+DELTA+DELTA)+y])    fixierer(2);
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
            
             translate(drehpunkt)
            //    rotate(-90*$t)
                    translate([$thickness,0,0]) rotate(-90,[0,1,0]) 
               {
                  linear_extrude($thickness)tuer();
                 for(x=[$thickness,tuerhoehe-2*$thickness])  translate([x,-0.5*gelenk,-$thickness]) linear_extrude($thickness)schiene();
               }
        

                for (v = [[0, 0, 0], [0, 0, hoehe-$thickness]])
                    translate(v)
                        linear_extrude($thickness) deckel();
               
            

            } 
    }
}

module schichtlinie(l)
{
    d=4*$thickness;
    for(k=[d:d:l-d]) translate([0,k]) square($thickness+$spiel);
}

module fixierer(n)
{
    square([n*$thickness,$thickness]);
}
