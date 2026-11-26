#region script-counting
#!/bin/bash
# Toon alle bestanden en mappen met details
ls -la
# grep -v '^d' laat regels weg die met "d" beginnen: mappen beginnen in de ls-uitvoer met een d
ls -la | grep -v '^d'

# wc -l telt het aantal regels, dus het aantal bestanden
ls -la | grep -v '^d' | wc -l
# Zonder -v tel je juist de mappen
ls -la | grep '^d' | wc -l
#endregion script-counting

#region script-find-size
# Zoek bestanden (-type f) alleen in de huidige map (-maxdepth 1)
find . -maxdepth 1 -type f
# Voer voor elk gevonden bestand du -h uit (-exec ... {} \;); {} is de bestandsnaam
find . -maxdepth 1 -type f -exec du -h {} \;
# Sorteer aflopend (-r) en toon de top 5 (head -5)
find . -maxdepth 1 -type f -exec du -h {} \; | sort -r | head -5
#endregion script-find-size

#region script-loops
# C-stijl for-lus die 1 tot en met 10 telt; sort -r sorteert als tekst, dus 9 staat boven 10
for ((a=1; a<=10; a++)); do echo $a; done | sort -r
# -h sorteert als getal, dus 10 staat bovenaan
for ((a=1; a<=10; a++)); do echo $a; done | sort -rh

# Brace expansion maakt een reeks aan: 1 2 3 4 5
echo {1..5}
# Combinaties: a1 a2 a3 b1 b2 b3 c1 c2 c3
echo {a..c}{1..3}

# Eenvoudige ping sweep: één ping per adres op de achtergrond (&), alleen antwoorden worden getoond.
# Vervang X.X.X door het netwerkdeel, bijvoorbeeld 192.168.1
for a in {1..254}; do (ping -c 1 X.X.X.$a | grep "bytes from" &); done
#endregion script-loops

#region script-arrays
# Maak een array
names=('John' 'Fred' 'Sally' 'Billy' 'Charlie')
# Alle items
echo ${names[@]}
# Alleen de indices (0 tot en met 4)
echo ${!names[@]}
# Het aantal items
echo ${#names[@]}
# Doorloop alle items
for name in ${names[@]}; do echo $name; done
# Vervang het item op index 2
names[2]='Tom'
# Lees een bestand regel per regel in een array (-t verwijdert de regeleinden)
mapfile -t fruits < "fruits.txt"
#endregion script-arrays

#region script-if
# -d test of het pad een map is, ! keert dat om: maak de map alleen aan als hij nog niet bestaat
if [ ! -d "$backup" ]
then
  mkdir "$backup"
fi
#endregion script-if
