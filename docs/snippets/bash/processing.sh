#region cat
# Schrijf tekst naar een bestand (overschrijft)
echo "This is file 1" > file1.txt
# Voeg een regel toe aan het einde
echo "Appended line" >> file1.txt
# Toon de volledige inhoud van het bestand
cat file1.txt
# Lees een lang bestand met een pager; -S kapt lange regels af, -N toont regelnummers
less -SN /var/log/syslog
# Volg een logbestand live (-f = follow); stop met Ctrl+C
sudo tail -f /var/log/syslog
#endregion cat

#region viewing
# Lees een bestand per pagina; spatie = volgende pagina, q = afsluiten
less -SN /var/log/syslog
# Toon de eerste 20 regels (-n bepaalt het aantal)
head -n 20 /var/log/syslog
# Toon een bestand als Base64-tekst
base64 message.enc
#endregion viewing

#region grep
# Toon partities (fdisk -l), houd regels met "dev" over en laat regels met "loop" vallen (-v = omgekeerd)
sudo fdisk -l | grep dev | grep -v loop

# -i: hoofdletterongevoelig. Zoekt mislukte SSH-aanmeldingen in het actuele log
sudo grep -i "failed password" /var/log/auth.log
# zgrep doorzoekt ook de gecomprimeerde, geroteerde logs (.gz)
sudo zgrep -i "failed password" /var/log/auth.log*.gz
#endregion grep

#region encoding
# Codeer een binair bestand naar Base64-tekst
base64 message.enc > message.base64
# -d: decodeer Base64 terug naar het originele bestand
base64 -d message.base64 > message.enc

# tr vervangt tekens: elke letter wordt 5 posities opgeschoven (Caesar-cipher)
echo "Bring Caesar a Salad!" | tr 'A-Za-z' 'F-ZA-Ef-za-e'
#endregion encoding

#region log-analysis
# -r: doorzoek mappen recursief. -n: toon het regelnummer. 2>/dev/null verbergt fouten over onleesbare bestanden
grep -rn "password" /etc/ 2>/dev/null
# -E: uitgebreide regex, zodat | "of" betekent
grep -E "Failed|Invalid" /var/log/auth.log
# -c: toon alleen het aantal overeenkomsten
grep -c "Failed password" /var/log/auth.log
# -l: toon alleen de bestandsnamen die overeenkomen. Zoekt hier naar verdachte PHP-functies
grep -rl "eval(" /var/www
# -w: alleen hele woorden, dus "root" matcht niet in "rooted"
grep -w "root" /var/log/auth.log
# -B 2 en -A 2: toon 2 regels vóór en na elke overeenkomst, voor context
grep -B 2 -A 2 "Accepted" /var/log/auth.log

# Top 10 IP-adressen met mislukte aanmeldingen:
# -o toont alleen het deel dat overeenkomt (het IP), sort groepeert, uniq -c telt, sort -rn sorteert aflopend, head -10 neemt de top
grep "Failed password" /var/log/auth.log | grep -oE '([0-9]{1,3}\.){3}[0-9]{1,3}' | sort | uniq -c | sort -rn | head -10

# cut -d: -f1 splitst elke regel op ":" en toont veld 1: alle gebruikersnamen uit /etc/passwd
cut -d: -f1 /etc/passwd
# -n 100: de laatste 100 regels van een log
tail -n 100 /var/log/syslog
# wc -l telt het aantal regels
wc -l /var/log/auth.log
#endregion log-analysis
