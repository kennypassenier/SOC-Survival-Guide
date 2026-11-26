---
outline: [2, 3]
---

# BASH Referentie <Badge type="info" text="Linux" /> <Badge type="tip" text="macOS & WSL" />

Alle BASH-commando's uit de kennisbank, met parameters.

::: info Gerelateerd
Windows-tegenhangers staan in de [PowerShell-](/scripting/powershell) en [CMD-referentie](/scripting/cmd).
:::

## Identiteit & privileges

### whoami, id & sudo {#sh-whoami}

Controleer wie je bent en voer beheertaken uit met `sudo`.

| Parameter | Betekenis |
| :--- | :--- |
| `whoami` | Toont de huidige gebruikersnaam. |
| `id` | Toont UID, GID en alle groepen. |
| `sudo <commando>` | Voert een commando uit met root-rechten. |
| `su - <gebruiker>` | Wisselt naar een andere gebruiker met een volledige login-shell (`-`). Sluit af met `exit`. |

<<< @/snippets/bash/system.sh#identity{bash}

<<< @/snippets/bash/system.sh#sudo{bash}

::: tip Ubuntu en Arch
Op systemen waar het root-account vergrendeld is, zoals Ubuntu, gebruik je `sudo -i` of `sudo su - <gebruiker>` in plaats van `su -`. Het Windows-equivalent is `runas`.
:::

### Gebruikers & groepen beheren {#sh-gebruikers}

| Parameter | Betekenis |
| :--- | :--- |
| `adduser <naam>` | Debian/Ubuntu: interactief gebruiker aanmaken inclusief home-map. |
| `useradd -m <naam>` | Universeel equivalent. `-m` maakt de home-map aan. |
| `passwd <naam>` | Stelt het wachtwoord in. |
| `groupadd <groep>` | Maakt een groep aan. |
| `usermod -aG <groep> <naam>` | Voegt een gebruiker toe aan een groep. `-a` = toevoegen, `-G` = aanvullende groepen. |
| `getent group <groep>` | Toont de leden van een groep. |

<<< @/snippets/bash/system.sh#users{bash}

## Navigatie & bestanden

### pwd, cd, ls & tree {#sh-navigatie}

| Parameter | Betekenis |
| :--- | :--- |
| `pwd` | Toont de huidige map. |
| `cd <pad>` | Wisselt van map. `..` is omhoog, `~` is je home-map. |
| `ls -l` / `-a` / `-R` | Lijst met details, inclusief verborgen bestanden, recursief. |
| `ls -latr` | Sorteert op wijzigingstijd (`-t`), oudste eerst (`-r`). De nieuwste bestanden staan onderaan. |
| `ls -lh` / `ls -lS` | Groottes leesbaar (`-h`), of gesorteerd op grootte met de grootste eerst (`-S`). |
| `tree <pad> -L <n>` | Mappenstructuur tot *n* niveaus diep. |

<<< @/snippets/bash/file.sh#navigation{bash}

<<< @/snippets/bash/file.sh#ls{bash}

<<< @/snippets/bash/file.sh#structure{bash}

### mkdir, touch, cp, mv & rm {#sh-bestandsbeheer}

| Parameter | Betekenis |
| :--- | :--- |
| `mkdir -p <pad>` | Maakt ook ontbrekende bovenliggende mappen aan. |
| `touch <bestand>` | Maakt een leeg bestand of werkt de tijdstempel bij. |
| `cp -p` | Kopieert en behoudt rechten en tijdstempels. |
| `mv` | Verplaatst of hernoemt. |
| `rm -i` | Vraagt bevestiging voor verwijderen. |
| `file <bestand>` | Bepaalt het echte bestandstype op basis van de inhoud. |

<<< @/snippets/bash/file.sh#creation{bash}

<<< @/snippets/bash/file.sh#manipulation{bash}

### chmod, chown & getfacl {#sh-permissies}

| Parameter | Betekenis |
| :--- | :--- |
| `chmod <modus> <bestand>` | Wijzigt rechten, bijvoorbeeld `750` of `+x`. `-R` werkt recursief. |
| `chown -R <gebruiker>:<groep>` | Wijzigt eigenaar en groep recursief. |
| `getfacl <pad>` | Toont POSIX ACL's. |

<<< @/snippets/bash/file.sh#permissions{bash}

### find {#sh-find}

Zoekt bestanden op naam, tijd, rechten, grootte of eigenaar. Onmisbaar om na een incident recent gewijzigde bestanden en SUID-programma's te vinden.

| Parameter | Betekenis |
| :--- | :--- |
| `-name` / `-iname <patroon>` | Zoekt op naam, `-iname` negeert hoofdletters. |
| `-type f` / `-type d` | Alleen bestanden of alleen mappen. |
| `-mtime -1` | Gewijzigd in de laatste 24 uur. `+7` betekent ouder dan 7 dagen. |
| `-perm -4000` | Bestanden met het SUID-bit. |
| `-size +100M` | Groter dan 100 MB. |
| `-user <naam>` | Bestanden van één eigenaar. |
| `2>/dev/null` | Verbergt foutmeldingen zoals "Permission denied". |

<<< @/snippets/bash/file.sh#find{bash}

## Tekstverwerking & analyse

### cat, less & tail {#sh-cat}

| Parameter | Betekenis |
| :--- | :--- |
| `cat <bestand>` | Toont een bestand. |
| `less -SN <bestand>` | Pager. `-S` kapt lange regels af, `-N` toont regelnummers. |
| `head -n <n>` / `tail -f` | Eerste regels, of live meelezen met een groeiend bestand. |
| `>` / `>>` | Overschrijft of voegt toe aan een bestand. |

<<< @/snippets/bash/processing.sh#cat{bash}

<<< @/snippets/bash/processing.sh#viewing{bash}

### grep & zgrep {#sh-grep}

| Parameter | Betekenis |
| :--- | :--- |
| `grep -i` | Hoofdletterongevoelig zoeken. |
| `grep -v` | Keert de match om: toont regels zonder het patroon. |
| `zgrep` | Doorzoekt ook gecomprimeerde (`.gz`) logbestanden. |

<<< @/snippets/bash/processing.sh#grep{bash}

### base64 & tr {#sh-base64}

Codeert binaire data naar tekst voor overdracht. Dit is encoding, geen encryptie.

| Parameter | Betekenis |
| :--- | :--- |
| `base64 <bestand>` | Codeert naar Base64. |
| `base64 -d` | Decodeert terug naar de oorspronkelijke data. |
| `tr 'A-Za-z' 'F-ZA-Ef-za-e'` | Vervangt tekens, hier een Caesar-shift van +5. |

<<< @/snippets/bash/processing.sh#encoding{bash}

::: details Windows-equivalenten
CMD: `certutil -encode` en `-decode`, zie [certutil](/scripting/cmd#cmd-certutil). PowerShell: `[Convert]::ToBase64String()`, zie [Versleutelen & Base64](/scripting/powershell#ps-versleutelen-base64).
:::

### Logs analyseren (grep, cut, sort, uniq) {#sh-log-analysis}

Combineer commando's met een pipe (`|`) om een log te filteren, te tellen en te rangschikken. Het bekendste patroon: filter, extraheer, `sort`, `uniq -c`, `sort -rn`.

| Parameter | Betekenis |
| :--- | :--- |
| `grep -r` | Zoekt recursief door mappen. |
| `grep -n` | Toont het regelnummer. |
| `grep -E "a\|b"` | Uitgebreide regex waarin `\|` "of" betekent. |
| `grep -c` | Telt het aantal overeenkomsten. |
| `grep -l` | Toont alleen de bestandsnamen. |
| `grep -w` | Alleen hele woorden. |
| `grep -A <n>` / `-B <n>` | Toont *n* regels na of vóór een overeenkomst. |
| `grep -o` | Toont alleen het deel dat overeenkomt. |
| `cut -d: -f1` | Splitst op `:` en toont veld 1. |
| `sort` / `uniq -c` / `sort -rn` | Groepeert, telt en sorteert aflopend op aantal. |
| `tail -n <n>` / `wc -l` | Laatste regels, of het aantal regels. |

<<< @/snippets/bash/processing.sh#log-analysis{bash}

## Systeembeheer

### Logs & aanmeldingen {#sh-logs}

| Parameter | Betekenis |
| :--- | :--- |
| `who` / `last` / `lastb` | Huidige aanmeldingen, aanmeldgeschiedenis en mislukte pogingen. |
| `last -n <n> -a` | Beperkt het aantal regels en toont het hostadres als laatste kolom. |
| `journalctl -f` | Volgt het systemd-journal live. |
| `journalctl -u <service>` | Toont logs van één service. |

<<< @/snippets/bash/os-management.sh#logs{bash}

### Processen & services {#sh-processen}

| Parameter | Betekenis |
| :--- | :--- |
| `ps -e` / `ps aux` | Alle processen, met gebruiker en resourcegebruik. |
| `/proc/<pid>` | Live informatie per proces. |
| `systemctl list-units --type=service` | Toont services. |
| `systemctl status\|start\|stop\|restart <service>` | Beheert een service. |

<<< @/snippets/bash/os-management.sh#process{bash}

<<< @/snippets/bash/os-management.sh#systemctl{bash}

### Schijven {#sh-schijven}

| Parameter | Betekenis |
| :--- | :--- |
| `fdisk -l` | Toont partities. |
| `df -h` | Vrije ruimte in leesbare eenheden. |
| `lsblk -f` | Blokapparaten met bestandssysteem. |
| `du -sh <pad>` | Totale grootte van een map. |

<<< @/snippets/bash/os-management.sh#disk{bash}

### Geavanceerde logs & processen {#sh-logs-extended}

| Parameter | Betekenis |
| :--- | :--- |
| `journalctl --since "<tijd>"` | Beperkt tot een tijdvenster, bijvoorbeeld `"1 hour ago"` of `today`. |
| `journalctl -p err -b` | Alleen fouten en erger (`-p`), sinds de laatste boot (`-b`). |
| `journalctl --no-pager` | Schrijft de uitvoer direct naar de terminal, handig om door te pipen. |
| `last -x` | Toont ook herstarts en afsluitingen. |
| `ps aux --sort=-%mem` | Sorteert processen aflopend op geheugengebruik. |
| `ps -eo pid,ppid,user,cmd --forest` | Kies kolommen en toon de procesboom, zodat je ouder en kind ziet. |
| `lsof -i -P -n` | Open netwerkverbindingen per proces, zonder naamopzoeking. |

<<< @/snippets/bash/os-management.sh#logs-extended{bash}

### Persistence-checks {#sh-persistence}

Plekken waar een aanvaller op Linux toegang behoudt na een herstart.

| Parameter | Betekenis |
| :--- | :--- |
| `crontab -l` | Cron-taken van de huidige gebruiker. |
| `/etc/cron.d`, `/etc/cron.daily` | Systeembrede cron-taken. |
| `systemctl list-timers --all` | Alle systemd-timers, ook inactieve. |
| `systemctl list-unit-files --state=enabled` | Services die bij het opstarten starten. |
| `~/.ssh/authorized_keys` | Sleutels die zonder wachtwoord mogen aanmelden. |

<<< @/snippets/bash/os-management.sh#persistence{bash}

## Netwerk & security

### Interfaces, routering & ARP {#sh-netwerk}

| Parameter | Betekenis |
| :--- | :--- |
| `ip a` / `ip -br a` | Interfaces en adressen, compact met `-br`. |
| `ip addr add <ip/prefix> dev <interface>` | Voegt tijdelijk een adres toe. |
| `ip route` / `netstat -r` | Routeringstabel. |
| `ss -tulnp` | Luisterende sockets: `-t` TCP, `-u` UDP, `-l` listening, `-n` numeriek, `-p` proces. |
| `arp -a` | ARP-tabel. |

<<< @/snippets/bash/network.sh#network-config{bash}

### Connectiviteit, DNS & poorten {#sh-dns}

| Parameter | Betekenis |
| :--- | :--- |
| `ping -c <n>` | Stuurt *n* pakketten. |
| `traceroute -n` | Route zonder DNS-opzoeking. |
| `dig <naam> [type]` | Vraagt DNS-records op. |
| `nc -zv <host> <poort>` | Test een poort: `-z` zonder data, `-v` verbose. |
| `/etc/resolv.conf`, `/etc/hosts` | DNS-servers en statische hostnamen. |

<<< @/snippets/bash/network.sh#dns{bash}

<<< @/snippets/bash/network.sh#connections{bash}

### iptables & VPN {#sh-iptables}

| Parameter | Betekenis |
| :--- | :--- |
| `iptables -L` | Toont regels. |
| `iptables -A INPUT -s <bron> -p tcp --dport <poort> -j <ACCEPT\|DROP>` | Voegt een regel toe aan de INPUT-chain. |
| `iptables -F` | Wist alle regels. |
| `ipsec statusall` / `ip xfrm state` | IPsec Security Associations. |
| `openvpn --config <bestand>` | Start een OpenVPN-client. |

<<< @/snippets/bash/firewall.sh#iptables{bash}

<<< @/snippets/bash/firewall.sh#vpn{bash}

### Extra network commands {#sh-network-extra}

| Parameter | Betekenis |
| :--- | :--- |
| `ss -s` | Samenvatting van het aantal sockets per status. |
| `ss -tn state established` | Alleen bestaande TCP-verbindingen, numeriek. |
| `ip neigh` | ARP/neighbor-tabel met het moderne commando. |
| `ip -s link show <interface>` | Statistieken per interface, zoals fouten en gedropte pakketten. |
| `curl -I <url>` | Haalt alleen de HTTP-headers op. |
| `dig +short <naam>` | Toont alleen het antwoord. |
| `dig @<server> <naam>` | Vraagt een specifieke DNS-server. |
| `host <naam>` | Eenvoudige DNS-opzoeking. |

<<< @/snippets/bash/network.sh#network-extra{bash}

## Recon & packet capture

### nmap {#sh-nmap}

| Parameter | Betekenis |
| :--- | :--- |
| `-sn` | Host discovery zonder port scan. |
| `-Pn` | Slaat host discovery over. |
| `-F` / `-p-` / `-p <lijst>` | Top 100 poorten, alle poorten, of specifieke poorten. |
| `-sV` | Serviceversie. |
| `-O --osscan-guess` | OS-detectie. |
| `-T<0-5>` | Timing: `T1` traag en stil, `T5` snel en luid. |

<<< @/snippets/bash/recon.sh#nmap_basic{bash}

<<< @/snippets/bash/recon.sh#nmap_advanced{bash}

<<< @/snippets/bash/recon.sh#nmap_os{bash}

### tcpdump, tshark, nc & Wireshark {#sh-capture}

| Parameter | Betekenis |
| :--- | :--- |
| `tcpdump -i <interface> -w <bestand>` | Legt verkeer vast naar een `.pcap`. |
| `tshark -i <interface> -Y "<filter>"` | Display filter in de terminal. |
| `nc -klvp <poort>` | Simuleert een luisterende poort. |

<<< @/snippets/bash/recon.sh#capture{bash}

### smbclient, ftp & telnet {#sh-smb}

Onversleutelde protocollen: gebruik ze alleen in een lab.

<<< @/snippets/bash/recon.sh#smb{bash}

### openssl {#sh-openssl}

Sleutels genereren, versleutelen, hashen en ondertekenen.

| Parameter | Betekenis |
| :--- | :--- |
| `genpkey -algorithm rsa -out <bestand>` | Genereert een private sleutel. Moderne vervanger van `genrsa`. |
| `rsa -pubout` | Leidt de publieke sleutel af. |
| `pkeyutl -encrypt` / `-decrypt` | Versleutelt of ontsleutelt met `-inkey <sleutel> -in <in> -out <uit>`. `-pubin` voor een publieke sleutel. |
| `enc -aes-256-cbc -salt -pbkdf2` | Symmetrische versleuteling. `-d` ontsleutelt. |
| `dgst -sha256` | Berekent een hash. Met `-sign` en `-verify` ook handtekeningen. |
| `rand -hex 32` | Genereert een willekeurige 256-bit sleutel. |

<<< @/snippets/bash/security.sh#openssl{bash}

### sha256sum {#sh-sha256sum}

| Parameter | Betekenis |
| :--- | :--- |
| `sha256sum <bestand>` | Berekent een hash. |
| `sha256sum -c <lijst>` | Controleert hashes tegen een lijst. |

<<< @/snippets/bash/security.sh#hashes{bash}

### mail {#sh-mail}

Klassieke CLI-mailclient voor lokale systeemberichten.

| Parameter | Betekenis |
| :--- | :--- |
| `mail -s "<onderwerp>" <gebruiker>` | Verstuurt een bericht. De inhoud komt via een pipe. |
| Prompt `?`: nummer, spatie, `exit` | Bericht lezen, scrollen en afsluiten. |

<<< @/snippets/bash/symmetric.sh#sym-mail{bash}

::: details Opslag en alternatieven
Lokale mail staat in `/var/mail/<gebruiker>`. `mail` is niet overal geïnstalleerd (`mailutils` of `s-nail`). Voor geautomatiseerde mail gebruik je `sendmail` of `msmtp`.
:::

## Patchbeheer & IDS

### apt & Docker {#sh-apt}

Simuleer een upgrade met `-s` voor je die uitvoert, en houd kritieke pakketten tegen met `apt-mark hold`. Een container patch je niet in place: haal een nieuw image op en start opnieuw met dezelfde volumes.

<<< @/snippets/bash/patching.sh#apt-patching{bash}

<<< @/snippets/bash/patching.sh#apt-hold{bash}

<<< @/snippets/bash/patching.sh#docker-patching{bash}

### Snort {#sh-snort}

| Parameter | Betekenis |
| :--- | :--- |
| `-T -c <config>` | Valideert de configuratie. |
| `-c <config>` | Intrusion detection-modus. |
| `-r <pcap>` | Analyseert een packet capture. |
| `-q -A console` | Stille modus met alerts op het scherm. |
| `-l <map>` | Schrijft logs naar een map. |
| `-i <interface>` | Luistert live op een interface. |
| `u2spewfoo <log>` | Leest `unified2`-logs uit. |

<<< @/snippets/bash/ids.sh#snort-run{bash}

<<< @/snippets/bash/ids.sh#snort-pcap{bash}

<<< @/snippets/bash/ids.sh#snort-rules{bash}

<<< @/snippets/bash/ids.sh#snort-u2spewfoo{bash}

## Scripting

Begin elk script met een shebang (`#!/bin/bash`), zodat het met de juiste shell draait.

<<< @/snippets/bash/scripting.sh#script-counting{bash}

<<< @/snippets/bash/scripting.sh#script-find-size{bash}

<<< @/snippets/bash/scripting.sh#script-loops{bash}

<<< @/snippets/bash/scripting.sh#script-arrays{bash}

<<< @/snippets/bash/scripting.sh#script-if{bash}

### Voorbeeldscript: sleutels uitproberen {#sh-keeper}

Probeert een reeks versleutelde bestanden te ontsleutelen met alle beschikbare sleutels.

<<< @/snippets/bash/cryptography-keeper.sh#keeper{bash}
