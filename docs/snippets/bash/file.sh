#region navigation
# Toon de huidige werkmap
pwd
# Ga naar de map met logbestanden
cd /var/log
# Toon de mappenstructuur van / op één niveau diep (-L 1)
tree / -L 1
# Toon de volledige structuur van /home; sudo omdat je andermans mappen niet mag lezen
sudo tree /home
#endregion navigation

#region ls
# -l: lange lijst met rechten, eigenaar, groep, grootte en datum
ls -l
# -a: toon ook verborgen bestanden (die beginnen met een punt); -la combineert beide
ls -la
# -R: ga recursief door alle submappen
ls -R
# -t: sorteer op wijzigingstijd, -r: omgekeerde volgorde. De nieuwste bestanden staan onderaan
ls -latr
# -h: toon groottes leesbaar (KB, MB) in plaats van bytes
ls -lh
# -S: sorteer op grootte, grootste eerst
ls -lS
#endregion ls

#region creation
# Maak twee mappen aan; -p maakt ook ontbrekende bovenliggende mappen aan en geeft geen fout als ze al bestaan
mkdir -p ~/labwork/blue ~/labwork/red
# Maak twee lege bestanden aan (of werk hun tijdstempel bij als ze al bestaan)
touch file1.txt file2.txt
# > schrijft naar het bestand en overschrijft de inhoud
echo "Eerste regel" > file1.txt
# >> voegt een regel toe aan het einde zonder de inhoud te wissen
echo "Extra regel" >> file1.txt
#endregion creation

#region manipulation
# Kopieer een bestand; -p behoudt rechten, eigenaar en tijdstempels
cp -p file1.txt ~/labwork/blue/
# Verplaats en hernoem tegelijk
mv file2.txt ~/labwork/red/renamed.txt
# Toon het echte bestandstype op basis van de inhoud, niet de extensie
file ~/labwork/red/renamed.txt
# Verwijder een bestand; -i vraagt eerst om bevestiging
rm -i file1.txt
#endregion manipulation

#region structure
# Mappenstructuur van / op één niveau diep
tree / -L 1
# Lijst van de inhoud van / met details
ls -l /
# -d toont de map zelf in plaats van de inhoud, handig om rechten van mappen te controleren
ls -ld /etc /var /home /tmp
#endregion structure

#region permissions
# +x maakt het script uitvoerbaar voor de eigenaar
chmod +x script.sh
# 600: alleen de eigenaar mag lezen en schrijven (vereist voor privé SSH-sleutels)
chmod 600 id_ed25519
# 750: eigenaar rwx, groep r-x, anderen niets; -R past dit recursief toe
chmod -R 750 /opt/app/

# Wijzig eigenaar en groep; -R werkt recursief
sudo chown -R root:analysts /opt/app/

# Toon de uitgebreide POSIX ACL's, naast de gewone rechten
getfacl /opt/app/
#endregion permissions

#region find
# -name zoekt op naam (hoofdlettergevoelig); -iname negeert hoofdletters. Aanhalingstekens voorkomen dat de shell het patroon uitbreidt
find /var/www -name "*.php"
# -type f: alleen bestanden. -mtime -1: gewijzigd in de laatste 24 uur (handig voor recente wijzigingen na een incident)
find /tmp -type f -mtime -1
# -perm -4000: bestanden met het SUID-bit, een bekende route voor privilege escalation. 2>/dev/null verbergt "Permission denied"
find / -perm -4000 -type f 2>/dev/null
# -size +100M: groter dan 100 MB. -user: alleen bestanden van deze eigenaar
find / -size +100M -user www-data 2>/dev/null
#endregion find
