# Regal
Das Modul regal Baut ein einfaches Regal nach festlegbaren Außenmaßen her. Es stellt sowohl eine Ansicht des fertigen Regals zur Verfügung als auch Schnittmuster für alle Bauteile. Als auch eine Anleitung zum zusammenbau.//Es sind 6 Modies zur auswahl:
assemble gibt die ansicht des vertig zusammengebauten Regals aus.
teile gibt ein schnittmuster aus, das alle EinzelTeile des Regals enthällt.
rueckwand, deckel, bord und seitenbrett geben jeweils ein Schnittmuster des entsprechenden Teils aus, wobei daran zu denken ist, dass für das fertige Regal von deckel und Seitenwänden jeweils 2 und von bord eines weniger als man fächer hat benötigt werden
animation gibt eine animierte Bauanleitung des Zusammenbaus aus. Denke daran, im menuepunkt view animate auszuwählen steps mindestens 10 und FPS etwa 1/10 der steps sind gute Einstellungen um für diese animation
regal hat 5 EingabeWerte der reihenfolge nach:
 tiefe, breite, hoehe stellen jeweils die entsprechenden Außenmaße da.
 die Variable faecher ....
 Der modus gibt den oben angegebenen Modus an
 Der Rand gibt an, wie weit Deckel und Boden überstehen
 Das Modul Regal  Greift auf das Modul verzahnung zurück und ist daher von den Modulenh verzahnung, stollen so wie zapfen abhängig. Die besonderen Variablen $thickness und $spiel beeinflussen es.


