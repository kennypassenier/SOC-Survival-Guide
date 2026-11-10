# Linux (Bash) Cheat Sheet

Een overzichtelijke naslaggids met veelgebruikte commando's voor bestandsbeheer, tekstverwerking, systeembeheer en netwerkdiagnostiek in een Linux Bash-omgeving.

---

## 1. Navigatie en Bestandsbeheer

| Commando | Beschrijving | Voorbeeld |
| :--- | :--- | :--- |
| `pwd` | Toont het absolute pad van de huidige werkmap (Print Working Directory). | `pwd` |
| `cd` | Wisselt van map (`cd ~` of `cd` gaat naar home, `cd -` naar de vorige map). | `cd /var/log` |
| `ls -la` | Toont alle bestanden en mappen in lijstvorm (`-l`), inclusief verborgen bestanden (`-a`). | `ls -lah` |
| `ls -lhS` | Sorteert bestanden op bestandsgrootte met leesbare eenheden (`-h`: KB, MB, GB). | `ls -lhS /var/log` |
| `tree -C` | Toont de mappenstructuur als een gekleurde boom (`-L 2` beperkt de diepte tot 2 niveaus). | `tree -L 2 /etc` |
| `mkdir -p` | Maakt een map aan, inclusief alle ontbrekende bovenliggende mappen. | `mkdir -p project/src/tests` |
| `rmdir` | Verwijdert uitsluitend lege mappen. | `rmdir lege_map` |
| `rm -rf` | Verwijdert bestanden of mappen recursief (`-r`) en geforceerd (`-f`) zonder bevestiging. | `rm -rf ./oude_build` |
| `cp -r` | Kopieert bestanden of complete mappen recursief naar een doelbestemming. | `cp -r src/ backup/` |
| `mv` | Verplaatst of hernoemt bestanden en mappen. | `mv app.log archive/` |
| `find` | Krachtige zoekmachine voor het bestandssysteem op basis van naam, type, tijd of grootte. | `find /var/log -type f -name "*.log" -mtime -7` |
| `rsync -avz` | Snelle en flexibele bestandsoverdracht met behoud van permissies en compressie. | `rsync -avz /bron/ /doel/` |

---

## 2. Tekst Doorzoeken, Filteren en Pipelining

| Commando / Techniek | Beschrijving | Voorbeeld |
| :--- | :--- | :--- |
| `grep -rnI` | Zoekt recursief (`-r`), toont regelnummers (`-n`) en negeert binaire bestanden (`-I`). | `grep -rnI "DB_PASSWORD" /etc/` |
| `grep -i` | Voert een hoofdletterongevoelige zoekopdracht uit. | `grep -i "error" /var/log/syslog` |
| `grep -v` | Filtert omgekeerd: toont alleen regels die het patroon **niet** bevatten. | `grep -v "^#" /etc/hosts` |
| `wc -l` | Telt het aantal regels in een bestand of vanuit een pipe (Word Count). | `grep -c "404" access.log` of `grep "404" access.log \| wc -l` |
| `awk` | Krachtig hulpprogramma voor tekstverwerking en patroonfiltering per kolom. | `awk '{print $1, $9}' access.log` |
| `sed` | Stream editor voor het filteren en inline vervangen van tekst via regex. | `sed -i 's/poort=80/poort=443/g' config.ini` |
| `cut -d` | Knipt specifieke velden uit regels op basis van een scheidingsteken (bijvoorbeeld `:`). | `cut -d: -f1,7 /etc/passwd` |
| `sort` & `uniq -c` | Sorteert invoer en telt unieke opeenvolgende voorkomens. | `cat ip.txt \| sort \| uniq -c \| sort -nr` |
| Pipe (`\|`) | Verbindt de standaarduitvoer (stdout) van het eerste proces aan de invoer (stdin) van het tweede. | `cat access.log \| grep "POST" \| wc -l` |
| Redirect (`>` en `>>`) | `>` overschrijft een bestand; `>>` voegt regels toe aan het einde; `2>&1` combineert stderr met stdout. | `command > output.log 2>&1` |
| `xargs` | Converteert regels uit de invoer naar commandline-argumenten voor een ander commando. | `find . -name "*.tmp" \| xargs rm -f` |

---

## 3. Systeembeheer en Processen

*Gebruik `sudo` vóór commando's waarvoor root-privileges vereist zijn.*

| Commando | Beschrijving | Voorbeeld |
| :--- | :--- | :--- |
| `uname -a` | Toont kernelversie, architectuur en hostnaam van het besturingssysteem. | `uname -a` |
| `hostnamectl` | Toont gedetailleerde systeem- en OS-informatie (distributie, kernel, hardware). | `hostnamectl` |
| `top` / `htop` | Realtime overzicht van actieve processen, CPU-, geheugen- en swapgebruik. | `htop` |
| `ps aux` | Geeft een momentopname van alle actieve processen op het systeem. | `ps aux \| grep nginx` |
| `kill` / `killall` | Stuurt een signaal naar een proces (`-9` voor SIGKILL om direct te forceren). | `kill -9 1234` |
| `systemctl status` | Controleert de actieve status van een systemd-service. | `systemctl status nginx` |
| `systemctl restart` | Herstart of herlaadt een service (`systemctl reload` laadt enkel config). | `sudo systemctl restart docker` |
| `journalctl -u` | Bekijkt logs van een specifieke service (`-f` volgt realtime output; `-xe` voor context). | `journalctl -u nginx -f` |
| `df -h` | Toont het vrije en gebruikte schijfvolume per partitie in leesbare eenheden (G/M). | `df -h` |
| `du -sh` | Berekent het totale schijfgebruik van een specifieke map (`*` toont alle items). | `du -sh /var/log/* \| sort -h` |
| `free -h` | Geeft direct inzicht in het vrije, gebruikte en gecachte RAM- en swapgeheugen. | `free -h` |
| `history` | Toont de geschiedenis van eerder ingevoerde Bash-commando's (zoeken met Ctrl+R). | `history \| grep ssh` |

---

## 4. Gebruikers, Rechten en Context

| Commando | Beschrijving | Voorbeeld |
| :--- | :--- | :--- |
| `whoami` | Toont de actieve gebruikersnaam in de huidige shell-sessie. | `whoami` |
| `id` | Geeft de gebruikers-ID (UID), primaire groeps-ID (GID) en alle neven-groepen weer. | `id` |
| `cat /etc/passwd` | Bevat alle lokale gebruikersaccounts en hun default shells en thuismappen. | `cat /etc/passwd \| grep bash` |
| `cat /etc/group` | Geeft een overzicht van alle groepen en de bijbehorende gebruikers. | `getent group sudo` |
| `useradd` / `adduser` | Maakt een nieuwe gebruiker aan (`-m` genereert direct een thuismap). | `sudo useradd -m -s /bin/bash devuser` |
| `usermod -aG` | Voegt een bestaande gebruiker toe aan een aanvullende groep (zoals sudo of docker). | `sudo usermod -aG sudo devuser` |
| `passwd [user]` | Wijzigt het wachtwoord van een specifiek account of de huidige gebruiker. | `sudo passwd devuser` |
| `chmod` | Wijzigt bestandsrechten via octale notatie of symbolen (`chmod +
