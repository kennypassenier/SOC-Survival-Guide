# Linux (Bash) Cheat Sheet - SysAdmin & SOC Analyst Edition

Een uitgebreide naslaggids met essentiële commando's voor systeembeheer, gebruikerscontext, live triage, forensisch logonderzoek, procesinspectie en netwerkanalyses in een Linux-omgeving.

---

## 1. Navigatie en Bestandsbeheer

| Commando | Beschrijving | Voorbeeld |
| :--- | :--- | :--- |
| `pwd` | Toont het absolute pad van de huidige werkmap (Print Working Directory). | `pwd` |
| `cd` | Wisselt van map (`cd ~` gaat naar home, `cd -` wisselt terug naar de vorige map). | `cd /var/log` |
| `ls -la` | Toont alle bestanden en mappen in lijstvorm (`-l`), inclusief verborgen bestanden (`-a`). | `ls -lah` |
| `ls -lhS` | Sorteert bestanden op bestandsgrootte met leesbare eenheden (`-h`: KB, MB, GB). | `ls -lhS /var/log` |
| `tree -C` | Toont de mappenstructuur als een gekleurde boom (`-L 2` beperkt de diepte tot 2 niveaus). | `tree -L 2 /etc` |
| `mkdir -p` | Maakt een map aan, inclusief alle ontbrekende bovenliggende mappen. | `mkdir -p project/src/tests` |
| `rmdir` | Verwijdert uitsluitend lege mappen. | `rmdir lege_map` |
| `rm -rf` | Verwijdert bestanden of mappen recursief (`-r`) en geforceerd (`-f`) zonder bevestiging. | `rm -rf ./oude_build` |
| `cp -r` | Kopieert bestanden of mappen recursief naar een doelbestemming. | `cp -r src/ backup/` |
| `mv` | Verplaatst of hernoemt bestanden en mappen. | `mv app.log archive/` |
| `find` | Zoekt bestanden op basis van naam, type, permissies, tijd of grootte. | `find /var/log -type f -name "*.log" -mtime -7` |
| `rsync -avz` | Snelle en flexibele bestandsoverdracht met behoud van rechten en compressie. | `rsync -avz /bron/ /doel/` |

---

## 2. Tekst Doorzoeken, Filteren en Pipelining

| Commando / Techniek | Beschrijving | Voorbeeld |
| :--- | :--- | :--- |
| `grep -rnI` | Zoekt recursief (`-r`), toont regelnummers (`-n`) en negeert binaire bestanden (`-I`). | `grep -rnI "DB_PASSWORD" /etc/` |
| `grep -i` | Voert een hoofdletterongevoelige zoekopdracht uit. | `grep -i "failed" /var/log/auth.log` |
| `grep -v` | Filtert omgekeerd: toont alleen regels die het patroon **niet** bevatten. | `grep -v "^#" /etc/hosts` |
| `wc -l` | Telt het aantal regels in een bestand of vanuit een pipe (Word Count). | `grep -c "404" access.log` of `grep "404" access.log \| wc -l` |
| `awk` | Krachtig hulpprogramma voor tekstverwerking en patroonfiltering per kolom. | `awk '{print $1, $9}' access.log` |
| `sed` | Stream editor voor het filteren en inline vervangen van tekst via regex. | `sed -i 's/poort=80/poort=443/g' config.ini` |
| `cut -d` | Knipt specifieke velden uit regels op basis van een scheidingsteken (bijvoorbeeld `:`). | `cut -d: -f1,7 /etc/passwd` |
| `sort` & `uniq -c` | Sorteert invoer en telt unieke opeenvolgende voorkomens. | `cat ip.txt \| sort \| uniq -c \| sort -nr` |
| Pipe (`\|`) | Verbindt de standaarduitvoer (stdout) van het eerste proces aan de invoer (stdin) van het tweede. | `cat access.log \| grep "POST" \| wc -l` |
| Redirect (`>` en `>>`) | `>` overschrijft een bestand; `>>` voegt toe; `2>&1` combineert stderr met stdout. | `command > output.log 2>&1` |
| `xargs` | Converteert regels uit de invoer naar commandline-argumenten voor een ander commando. | `find . -name "*.tmp" \| xargs rm -f` |

---

## 3. Gebruikerscontext, Rechten en Sessies

| Commando | Beschrijving | Voorbeeld |
| :--- | :--- | :--- |
| `su - [user]` | Schakelt over naar een andere gebruiker en laadt de volledige login-omgeving (environment en PATH). | `su - devuser` |
| `su [user]` | Schakelt over naar een gebruiker maar **behoudt** de omgevingsvariabelen van de oorspronkelijke sessie. | `su devuser` |
| `sudo -i` | Opent een interactieve root-shell met het root-profiel (vergelijkbaar met `su -`). | `sudo -i` |
| `sudo -u [user]` | Voert een enkel commando uit als een specifieke gebruiker zonder van sessie te wisselen. | `sudo -u www-data whoami` |
| `whoami` | Toont de actieve gebruikersnaam in de huidige shell-sessie. | `whoami` |
| `id` | Geeft de gebruikers-ID (UID), primaire groeps-ID (GID) en alle neven-groepen weer. | `id` |
| `w` of `who` | Toont welke accounts momenteel ingelogd zijn, vanaf welk IP/TTY en wat ze uitvoeren. | `w` |
| `last` | Leest `/var/log/wtmp` uit en toont eerdere logins, reboots en sessieduur. | `last -n 20` |
| `lastb` | Leest `/var/log/btmp` uit en toont alle mislukte inlogpogingen (nuttig voor brute-force checks). | `sudo lastb -n 25` |
| `passwd [user]` | Wijzigt het wachtwoord van een specifiek account (`passwd -l` lockt het account). | `sudo passwd -l suspect_user` |
| `usermod -aG` | Voegt een bestaande gebruiker toe aan een aanvullende groep (bijvoorbeeld sudo of docker). | `sudo usermod -aG sudo devuser` |
| `chmod` | Wijzigt bestandsrechten (`chmod +x` maakt uitvoerbaar, `chmod 4755` stelt SUID in). | `chmod 750 /opt/scripts/*.sh` |
| `chown` | Wijzigt de eigenaar en groep van bestanden (`-R` voor recursieve mappen). | `sudo chown -R www-data:www-data /var/www` |

---

## 4. Systeembeheer, Processen en Services

*Gebruik `sudo` voor commando's waarvoor administratieve rechten vereist zijn.*

| Commando | Beschrijving | Voorbeeld |
| :--- | :--- | :--- |
| `uname -a` | Toont kernelversie, architectuur en hostnaam van het besturingssysteem. | `uname -a` |
| `hostnamectl` | Toont gedetailleerde systeem- en OS-informatie (distributie, kernel, hardware). | `hostnamectl` |
| `top` / `htop` | Realtime overzicht van actieve processen, CPU-, geheugen- en swapgebruik. | `htop` |
| `ps aux` | Geeft een momentopname van alle actieve processen op het systeem. | `ps aux \| grep nginx` |
| `ps -ef --forest` | Toont een boomstructuur van processen zodat parent/child-relaties direct zichtbaar zijn. | `ps -ef --forest` |
| `kill` / `killall` | Stuurt een signaal naar een proces (`-9` voor SIGKILL om direct te forceren, `-15` voor SIGTERM). | `kill -9 1234` |
| `systemctl status` | Controleert de actieve status van een systemd-service. | `systemctl status nginx` |
| `systemctl restart` | Herstart of herlaadt een service (`systemctl reload` laadt enkel config opnieuw). | `sudo systemctl restart docker` |
| `systemctl list-units` | Geeft een overzicht van actieve of gefaalde units (`--failed` toont fouten direct). | `systemctl --failed` |
| `df -h` | Toont het vrije en gebruikte schijfvolume per partitie in leesbare eenheden (G/M). | `df -h` |
| `du -sh` | Berekent het totale schijfgebruik van een specifieke map (`*` toont alle items). | `du -sh /var/log/* \| sort -h` |
| `free -h` | Geeft direct inzicht in het vrije, gebruikte en gecachte RAM- en swapgeheugen. | `free -h` |
| `history` | Toont de geschiedenis van ingevoerde opdrachten (zoek realtime via Ctrl+R). | `history \| grep ssh` |

---

## 5. SOC & Forensisch: Logboeken, Audit en Triage

| Commando / Locatie | Beschrijving | Voorbeeld |
| :--- | :--- | :--- |
| `journalctl -u` | Bekijkt systemd-logs van een specifieke unit (`-f` volgt realtime, `-xe` toont context). | `journalctl -u ssh -f` |
| `journalctl --since` | Filtert logbestanden op een exact tijdsbestek (cruciaal bij incident response). | `journalctl --since "2026-11-10 08:00:00" --until "2026-11-10 09:00:00"` |
| `/var/log/auth.log` | Debian/Ubuntu authenticatielog (SSH-logins, sudo-gebruik, failures). | `grep "Failed password" /var/log/auth.log` |
| `/var/log/secure` | RHEL/CentOS equivalent van authenticatielogs. | `grep "Accepted publickey" /var/log/secure` |
| `ausearch` / `aureport` | Doorzoekt Linux Audit Daemon (auditd) logs op syscalls, SELinux denials en binaire executies. | `sudo aureport --auth` |
| `dmesg -T` | Toont kernel-ringbufferberichten voorzien van leesbare timestamps (bijvoorbeeld geheugenfouten of crashes). | `dmesg -T \| grep -i "segfault"` |
| `lsof -p [PID]` | Toont alle geopende bestanden, sockets en dynamische bibliotheken van een proces. | `sudo lsof -p 1337` |
| `ls -l /proc/[PID]/exe` | Toont het werkelijke binaire bestand dat een draaiend proces heeft gestart (handig als binary gewist is). | `ls -l /proc/1337/exe` |
| `cat /proc/[PID]/cmdline` | Toont de volledige commandline inclusief parameters waarmee een proces gestart is. | `tr '\0' ' ' < /proc/1337/cmdline` |
| `sha256sum` | Berekent de cryptografische hash van een verdacht bestand voor vergelijking met threat intelligence. | `sha256sum /tmp/suspicious.bin` |

---

## 6. Netwerkdiagnostiek en Socketinspectie

| Commando | Beschrijving | Voorbeeld |
| :--- | :--- | :--- |
| `ip a` of `ip addr` | Toont netwerkinterfaces, actieve IP-adressen (IPv4/IPv6) en netmaskers. | `ip a` |
| `ip route` | Toont de lokale routeringstabel en de standaard gateway (vervanger van `route`). | `ip route show` |
| `ping -c [aantal]` | Verzendt ICMP-pakketten om bereikbaarheid en latentie te controleren. | `ping -c 4 1.1.1.1` |
| `traceroute` | Brengt alle tussenliggende hops en vertragingen naar het doelnetwerk in kaart. | `traceroute 8.8.8.8` |
| `dig` | DNS-lookup tool voor domeinquery's (`+short` toont uitsluitend het IP-adres). | `dig +short example.com A` |
| `ss -tulpn` | Toont alle luisterende TCP/UDP-sockets met bijbehorende procesnamen en PID's. | `sudo ss -tulpn` |
| `ss -tanp` | Toont alle actieve en gevestigde verbindingen (ESTAB, SYN-SENT, TIME-WAIT) met processen. | `sudo ss -tanp state established` |
| `lsof -i :[poort]` | Geeft direct weer welk proces luistert of verbonden is op een specifieke poort. | `sudo lsof -i :22` |
| `curl -I` | Haalt enkel de HTTP-responsheaders op van een webserver voor debugging. | `curl -I https://example.com` |
| `tcpdump` | Vangt pakketten realtime af op de interface voor netwerkforensiek (`-w` slaat op als pcap). | `sudo tcpdump -i any port 53 -nn` |

---

## 7. Handige One-Liners voor SysAdmins & SOC Analisten

*   **Top 10 IP-adressen met mislukte SSH-inlogpogingen (Debian/Ubuntu):**
    Haalt alle failed attempts uit `auth.log`, telt het aantal pogingen per bron-IP en sorteert op frequentie:
    ```bash
    grep "Failed password" /var/log/auth.log | awk '{print $(NF-3)}' | sort | uniq -c | sort -nr | head -n 10
    ```

*   **Identificeer processen die draaien vanuit tijdelijke mappen (`/tmp`, `/dev/shm`):**
    Vaak gebruikt door malware en drop-scripts om detectie te omzeilen:
    ```bash
    ls -l /proc/*/exe 2>/dev/null | grep -E '/tmp|/dev/shm|/var/tmp'
    ```

*   **Zoeken naar verborgen bestanden met SUID-permissies (Privilege Escalation check):**
    Zoekt bestanden die uitgevoerd worden met de rechten van de eigenaar (zoals root):
    ```bash
    find / -perm -4000 -type f 2>/dev/null
    ```

*   **Controleer recent gewijzigde uitvoerbare bestanden in systeemmappen:**
    Toont bestanden in `/bin`, `/sbin` en `/usr` die de afgelopen 48 uur zijn aangepast:
    ```bash
    find /bin /sbin /usr/bin /usr/sbin -type f -mtime -2 -ls
    ```

*   **Actieve netwerkconnecties direct correleren aan binary en working directory:**
    Toont direct welk executable path en poort een verbinding met buitenaf onderhoudt:
    ```bash
    sudo lsof -iTCP -sTCP:ESTABLISHED -n -P
    ```

*   **Ping sweep over een lokaal /24 subnet:**
    Scant een IP-reeks (`192.168.1.1` tot `192.168.1.254`) met een timeout van 1 seconde en print actieve IP's:
    ```bash
    for ip in {1..254}; do
        ping -c 1 -W 1 192.168.1.$ip > /dev/null 2>&1 && echo "192.168.1.$ip is online" &
    done; wait
    ```
