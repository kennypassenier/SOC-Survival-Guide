# BASH.md — Linux BASH & CLI Referentie (Debian/Ubuntu & Arch Linux)

Centraal naslagwerk voor alle Linux BASH- en systeembeheercommando's, parameters, permutaties en distributieverschillen uit de Cybrary SOC Analyst-modules, aangevuld voor systeembeheerders en SOC-analisten.

> **Legenda:** Reguliere commando's en voorbeelden zijn rechtstreeks afkomstig uit het cursusmateriaal. Extra vlaggen, moderne opvolgers (zoals `ip`, `ss`, `journalctl`, `nftables`) en OS-verschillen tussen **Debian/Ubuntu**, **Arch Linux**, **Alpine** en **Windows** zijn gemarkeerd met **[Aanvullend]**.

## Inhoudsopgave
1. [Identiteit, Gebruikersbeheer & Privileges](#1-identiteit-gebruikersbeheer--privileges)
2. [Navigatie, Mappenstructuur & Bestandsbeheer](#2-navigatie-mappenstructuur--bestandsbeheer)
3. [Permissies, Eigenaarschap & ACL's](#3-permissies-eigenaarschap--acls)
4. [Bestandsinhoud, Zoeken, Tekstverwerking & Encoding](#4-bestandsinhoud-zoeken-tekstverwerking--encoding)
5. [Loganalyse, Processen, Services & Schijfbeheer](#5-loganalyse-processen-services--schijfbeheer)
6. [Pakketbeheer & Back-up / Disk Imaging](#6-pakketbeheer--back-up--disk-imaging)
7. [Netwerkconfiguratie, Routering, DNS & DHCP](#7-netwerkconfiguratie-routering-dns--dhcp)
8. [Firewalls (`iptables`, `ufw`, `nftables`) & VPN (`strongSwan`, `OpenVPN`)](#8-firewalls-iptables-ufw-nftables--vpn-strongswan-openvpn)
9. [Netwerkverkenning, Packet Capture & Cleartext Protocollen (`nmap`, `wireshark`, `tcpdump`)](#9-netwerkverkenning-packet-capture--cleartext-protocollen-nmap-wireshark-tcpdump)
10. [Scripting, Python & Cryptografie (`openssl`, `sha256sum`, `base64`)](#10-scripting-python--cryptografie-openssl-sha256sum-base64)

---

## 1. Identiteit, Gebruikersbeheer & Privileges

### `whoami` & `id`
* **Doel:**
  * `whoami`: Toont de gebruikersnaam van het huidige actieve account.
  * `id`: Toont de numerieke User ID (`uid`), primaire Group ID (`gid`) en alle groepslidmaatschappen (`groups`).
* **Parameters & Opties (`id`):**
  * `-u` **[Aanvullend]** (`u` = **u**ser): Print enkel de numerieke UID (`0` = `root`, `>= 1000` = reguliere gebruikers).
  * `-Gn` **[Aanvullend]** (`G` = all **G**roups, `n` = **n**ame): Toont de namen van alle groepen waartoe de gebruiker behoort.
* **Praktijkgebruik:**
  ```bash
  # Controleer huidige gebruikersnaam, UID, GID en groepen
  whoami
  id
  ```
* **[Aanvullend] OS-verschillen (Debian/Ubuntu vs. Arch Linux):**
  * Op **Debian/Ubuntu** geeft lidmaatschap van de groep `sudo` (GID 27) beheerdersrechten; op **Arch Linux** wordt hiervoor standaard de groep `wheel` gebruikt.

### `sudo` & `su`
* **Doel:**
  * `sudo`: *Superuser Do* — voert één specifiek commando uit met `root`-rechten (wordt gelogd in `/var/log/auth.log` op Debian of `journalctl` op Arch).
  * `su - <gebruiker>`: *Substitute User* — wisselt naar een ander gebruikersaccount inclusief volledige login-shell en omgevingsvariabelen (`-`).
* **Parameters & Opties:**
  * `-l` bij `sudo` **[Aanvullend]** (`l` = **l**ist): Toont welke commando's de huidige gebruiker via `sudo` mag uitvoeren (cruciaal bij privilege escalation-checks).
* **Praktijkgebruik:**
  ```bash
  # Voer een beheercommando uit met root-rechten
  sudo ls /root

  # Wissel naar een ander lokaal gebruikersaccount (afsluiten met exit)
  su - sally
  ```

### `adduser`, `useradd`, `passwd`, `groupadd` & `usermod`
* **Doel:** Aanmaken en beheren van lokale Linux-gebruikersaccounts, wachtwoorden en groepslidmaatschappen.
* **Parameters & Opties:**
  * `-m` bij `useradd` (`m` = **m**ake home): Maakt automatisch `/home/<gebruiker>` aan.
  * `-aG <groep>` bij `usermod` (`a` = **a**ppend, `G` = supplementary **G**roups): Voegt een gebruiker toe aan een extra groep zonder bestaande groepen te overschrijven.
* **Praktijkgebruik & OS-verschillen:**
  ```bash
  # Debian / Ubuntu: interactief gebruiker aanmaken inclusief home-map en wachtwoord
  sudo adduser michael

  # Arch Linux & universeel Linux-equivalent
  sudo useradd -m michael
  sudo passwd michael

  # [Aanvullend] Groep aanmaken, gebruiker toevoegen en controleren
  sudo groupadd analysts
  sudo usermod -aG analysts michael
  getent group analysts
  ```

---

## 2. Navigatie, Mappenstructuur & Bestandsbeheer

### `pwd`, `cd` & `tree`
* **Doel:**
  * `pwd`: *Print Working Directory* — toont het absolute pad van de huidige werkmap (`-P` **[Aanvullend]** lost symlinks op naar het fysieke pad).
  * `cd`: *Change Directory* — wisselt van werkmap (`cd ~` of `cd` gaat naar `$HOME`, `cd -` wisselt terug naar de vorige map).
  * `tree`: Toont de mappenstructuur visueel als boomdiagram.
* **Parameters & Opties (`tree`):**
  * `-L <niveau>` (`L` = **L**evel): Beperkt de weergave tot een opgegeven diepte (bijv. `-L 1`).
  * `-a` **[Aanvullend]** (`a` = **a**ll): Toont ook verborgen puntbestanden; `-d` toont alleen mappen.
* **Praktijkgebruik & OS-verschillen:**
  ```bash
  pwd
  cd /var/log
  tree / -L 1
  sudo tree /home
  ```
  * **[Aanvullend] Installatie van `tree`:** Debian/Ubuntu: `sudo apt install tree -y` | Arch Linux: `sudo pacman -S tree`.

### `ls`
* **Doel:** *List* — toont bestanden en mappen in de huidige of opgegeven directory.
* **Parameters & Opties:**
  * `-l` (`l` = **l**ong): Gedetailleerde lijstweergave met objecttype (`d` = directory, `-` = bestand, `l` = symlink), `rwx`-rechten, eigenaar, groep, grootte in bytes en wijzigingsdatum.
  * `-a` (`a` = **a**ll): Toont alle bestanden, inclusief verborgen bestanden die beginnen met een punt (`.`, zoals `.bashrc` en `.bash_history`).
  * `-R` (`R` = **R**ecursive): Toont recursief alle onderliggende submappen.
  * `-h`, `-t`, `-r` **[Aanvullend]**: `-h` = **h**uman-readable groottes, `-t` = sorteer op **t**ime, `-r` = **r**everse volgorde.
* **Praktijkgebruik & Permutaties:**
  ```bash
  ls -l
  ls -la
  ls -R
  ls -latr   # [Aanvullend] Nieuwste bestandswijzigingen onderaan de lijst (SOC-favoriet)
  ```

### `touch`, `mkdir`, `cp`, `mv`, `rm` & `file`
* **Doel:**
  * `touch`: Maakt een nieuw leeg bestand aan (of werkt de tijdstempel van een bestaand bestand bij).
  * `mkdir`: Maakt een nieuwe map aan (`-p` **[Aanvullend]** maakt ook ontbrekende bovenliggende mappen aan).
  * `cp`: Kopieert bestanden of mappen (`-r` = recursief voor mappen, `-p` **[Aanvullend]** = behoudt rechten en tijdstempels voor forensics).
  * `mv`: Verplaatst of hernoemt bestanden en mappen.
  * `rm`: Verwijdert bestanden of mappen definitief (zonder Prullenbak!).
  * `file`: Identificeert het werkelijke bestandstype op basis van *magic bytes* (onafhankelijk van de bestandsextensie).
* **Parameters & Opties (`rm`):**
  * `-i` (`i` = **i**nteractive): Vraagt voor elk bestand om bevestiging (`y/n`).
  * `-r` / `-f` **[Aanvullend]**: `-r` = **r**ecursive voor mappen, `-f` = **f**orce zonder vragen.
* **Praktijkgebruik & Permutaties:**
  ```bash
  mkdir -p ~/labwork/blue ~/labwork/red
  touch file1.txt file2.txt
  cp -p file1.txt ~/labwork/blue/
  mv file2.txt ~/labwork/red/renamed.txt
  file ~/labwork/red/renamed.txt
  rm -i file1.txt
  ```

---

## 3. Permissies, Eigenaarschap & ACL's

### `chmod`, `chown` & `getfacl` / `setfacl` **[Aanvullend]**
* **Doel:**
  * `chmod`: Wijzigt lees- (`r` = 4), schrijf- (`w` = 2) en uitvoerrechten (`x` = 1) voor *Owner*, *Group* en *Others*.
  * `chown`: Wijzigt de eigenaar en/of groep van een bestand of map.
  * `getfacl` / `setfacl`: Bekijkt en beheert uitgebreide POSIX Access Control Lists (Linux-equivalent van Windows `icacls`).
* **Praktijkgebruik & Permutaties:**
  ```bash
  # Maak een script uitvoerbaar voor de eigenaar (of stel 750 / 600 rechten in)
  chmod +x script.sh
  chmod 600 id_ed25519
  chmod -R 750 /opt/app/

  # Wijzig eigenaar en groep van een map recursief
  sudo chown -R root:analysts /opt/app/

  # Inspecteer gedetailleerde POSIX ACL's
  getfacl /opt/app/
  ```

---

## 4. Bestandsinhoud, Zoeken, Tekstverwerking & Encoding

### `cat`, `more`, `less`, `head`, `tail`, `echo` & Redirection (`>`, `>>`, `|`)
* **Doel:**
  * `cat`: *Concatenate* — print de volledige inhoud van één of meerdere bestanden naar de console.
  * `more` & `less`: Pagers om grote bestanden te lezen (`less` ondersteunt zowel voor- als achterwaarts scrollen met pijltjestoetsen, zoeken met `/` en afsluiten met `q`).
  * `head` & `tail`: Tonen het begin of het einde (standaard 10 regels) van een bestand.
  * `echo`: Print tekst of omgevingsvariabelen (bijv. `echo $PATH`).
* **Parameters & Opties:**
  * `-c <bytes>` bij `head` (`c` = **c**haracters/bytes): Leest een exact aantal bytes (bijv. `head -c 1M`).
  * `-f` bij `tail` (`f` = **f**ollow): Volgt live nieuwe logregels zodra ze worden weggeschreven (afbreken met `Ctrl + C`).
  * `-n <aantal>` bij `head` / `tail` **[Aanvullend]**: Specificeert exact het aantal regels.
  * `-S` & `-N` bij `less` **[Aanvullend]**: `-S` = kapt lange regels af zonder wrapping, `-N` = toont regelnummers.
* **Praktijkgebruik & Permutaties:**
  ```bash
  echo "This is file 1" > file1.txt
  echo "Appended line" >> file1.txt
  cat file1.txt
  less -SN /var/log/syslog
  sudo tail -f /var/log/syslog
  ```

### `grep`, `zcat` & `zgrep` **[Aanvullend]**
* **Doel:**
  * `grep`: Zoekt naar tekstpatronen in bestanden of gepipete uitvoer (`-v` = in**v**ert match / sluit patroon uit, `-i` = **i**gnore case, `-r` = **r**ecursive).
  * `zcat` & `zgrep` **[Aanvullend]**: Leest en doorzoekt `.gz`-gecomprimeerde logbestanden in `/var/log/` zonder ze eerst handmatig uit te pakken.
* **Praktijkgebruik:**
  ```bash
  # Filter loopback-devices weg uit schijfuitvoer
  sudo fdisk -l | grep dev | grep -v loop

  # [Aanvullend] Zoek naar mislukte SSH-logins in actieve en geroteerde .gz-logs
  sudo grep -i "failed password" /var/log/auth.log
  sudo zgrep -i "failed password" /var/log/auth.log*.gz
  ```

### `base64` & `tr`
* **Doel:**
  * `base64`: Zet binaire bestanden (zoals `.enc` of `.key`) om in veilige ASCII-tekst voor teksttransport en decodeert Base64-strings terug (`-d`).
  * `tr` **[Aanvullend]**: Vertaalt of verwijdert tekens in een datastroom (handig voor snelle ROT13/Caesar-transformaties).
* **Praktijkgebruik:**
  ```bash
  # Codeer een binair bestand naar Base64 en decodeer terug
  base64 message.enc > message.base64
  base64 -d message.base64 > message.enc

  # [Aanvullend] Voer een Caesar shift (+5) uit op tekst
  echo "Bring Caesar a Salad!" | tr 'A-Za-z' 'F-ZA-Ef-za-e'
  ```

---

## 5. Loganalyse, Processen, Services & Schijfbeheer

### `who`, `last`, `lastb` & `journalctl`
* **Doel:**
  * `who`: Leest `/var/run/utmp` / `/var/log/wtmp` om momenteel ingelogde gebruikers te tonen.
  * `last`: Leest het binaire logbestand `/var/log/lastlog` / `/var/log/wtmp` om recente en historische logins te bekijken.
  * `lastb` **[Aanvullend]**: Leest `/var/log/btmp` om mislukte inlogpogingen (*bad logins*) te onderzoeken.
  * `journalctl` **[Aanvullend]**: Bevraagt het `systemd`-logboek (standaard op Arch Linux en moderne Debian/Ubuntu-systemen).
* **Praktijkgebruik:**
  ```bash
  sudo who
  sudo last
  sudo last -n 20 -a        # [Aanvullend] Laatste 20 logins inclusief bron-IP/hostnaam
  sudo lastb                # [Aanvullend] Mislukte loginpogingen onderzoeken
  sudo journalctl -f        # [Aanvullend] Live systeemlogs volgen (Arch & Debian)
  sudo journalctl -u sshd   # [Aanvullend] Logs van één specifieke systemd-dienst
  ```

### `ps` & `/proc`
* **Doel:** *Process Status* — toont actieve processen op het systeem inclusief hun Process ID (`PID`). Elke actieve `PID` heeft een virtuele map `/proc/<PID>/` met runtime-details (`cmdline`, `exe`, `environ`).
* **Parameters & Opties:**
  * `-e` (`e` = **e**very): Toont alle processen op het systeem.
  * `aux` / `-ef` **[Aanvullend]**: Toont uitgebreide kolommen inclusief eigenaar (`USER`), CPU/RAM-verbruik en volledige opstartopdracht.
* **Praktijkgebruik:**
  ```bash
  ps -e
  ps aux | grep sshd
  ls -la /proc/1
  ```

### `systemctl` **[Aanvullend]** (Linux equivalent van Windows Services)
* **Doel:** Beheert `systemd`-services en daemons op moderne Debian/Ubuntu- en Arch Linux-systemen.
* **Praktijkgebruik:**
  ```bash
  systemctl list-units --type=service
  systemctl status sshd
  sudo systemctl start sshd
  sudo systemctl stop sshd
  sudo systemctl restart sshd
  ```

### `fdisk`, `df`, `lsblk` & `du`
* **Doel:**
  * `fdisk -l`: Toont fysieke schijfapparaten en partitietabellen (`-l` = **l**ist).
  * `df -h`: *Disk Free* — toont totale, gebruikte en vrije schijfruimte per aangekoppelde (*mounted*) partitie (`-h` = **h**uman-readable).
  * `lsblk`: *List Block Devices* — toont een boomoverzicht van alle blokapparaten, partities en mountpoints (`-f` **[Aanvullend]** toont bestandssystemen en UUID's).
  * `du -sh <map>` **[Aanvullend]**: *Disk Usage* — berekent de totale grootte van een specifieke map (`-s` = **s**ummary, `-h` = **h**uman-readable).
* **Praktijkgebruik:**
  ```bash
  sudo fdisk -l | grep dev | grep -v loop
  sudo df -h
  lsblk
  lsblk -f
  du -sh /var/log/*
  ```

---

## 6. Pakketbeheer & Back-up / Disk Imaging

### `apt`, `pacman` & `apk` (Pakketbeheerders per Linux-distributie)
* **Doel:** Installeert, verwijdert en werkt softwarepakketten bij per distributiefamilie:
  * **Debian / Ubuntu (`apt`):** `sudo apt update && sudo apt install <pakket> -y`
  * **Arch Linux (`pacman`) **[Aanvullend]**:** `sudo pacman -Syu` (systeemupdate) en `sudo pacman -S <pakket>`
  * **Alpine Linux (`apk`):** `apk add <pakket>` (bijv. `apk add samba-client`)
* **Praktijkgebruik:**
  ```bash
  # Alpine Linux (gebruikt in de Network Troubleshooting labomgeving)
  apk add samba-client
  smbclient --version
  ```

### `rsync`, `tar` & `dd` **[Aanvullend]** (Back-up & Forensische Disk Imaging)
* **Doel:** Linux-equivalenten voor bestandsback-up, archieven en block-level *Bare Metal* disk-imaging:
* **Praktijkgebruik:**
  ```bash
  # Incrementele bestandsback-up met behoud van rechten en eigenaarschap
  rsync -avh --delete /var/www/ /backup/www/

  # Gecomprimeerd tar.gz-archief aanmaken
  tar -czvf backup.tar.gz /etc/

  # Block-level disk image maken (Bare Metal / Forensics)
  sudo dd if=/dev/sda of=/mnt/backup/disk.img bs=4M status=progress
  ```

---

## 7. Netwerkconfiguratie, Routering, DNS & DHCP

### `ip`, `ifconfig`, `netstat`, `ss` & `arp`
* **Doel:**
  * `ip a` (en het oudere `ifconfig`): Inspecteert netwerkinterfaces, IPv4/IPv6-adressen en MAC-adressen; met `ip addr add` voeg je tijdelijk een secundair IP-adres toe.
  * `netstat -r` (en het modernere `ip route` / `ip r` **[Aanvullend]**): Toont de routeringstabel en default gateway.
  * `ss -tulnp` **[Aanvullend]**: Moderne opvolger van `netstat -antup` voor actieve sockets en luisterende TCP/UDP-poorten.
  * `arp -a`: Inspecteert de lokale ARP-cache (IP-naar-MAC-koppelingen op Layer 2).
* **Praktijkgebruik & Permutaties:**
  ```bash
  # Bekijk netwerkinterfaces (compact met ip -br a) en voeg een test-IP toe
  ip a
  ip -br a
  sudo ip addr add 10.10.10.10/24 dev ens5

  # Bekijk de routeringstabel, luisterende poorten en ARP-tabel
  netstat -r
  ip route
  ss -tulnp
  arp -a
  ```

### `ping`, `traceroute`, `dig`, `nslookup` & DNS-bestanden (`/etc/resolv.conf`, `/etc/hosts`)
* **Doel:**
  * `ping -c <aantal> <doel>`: Test ICMP-bereikbaarheid (`-c` = **c**ount; op Linux verplicht om een oneindige loop te voorkomen).
  * `traceroute <doel>`: Traceert alle routeringshops naar een doelhost (`-n` **[Aanvullend]** slaat reverse DNS over).
  * `dig` & `nslookup`: Bevragen DNS-servers op A-, AAAA-, MX-, NS- en PTR-records.
  * `/etc/resolv.conf` & `/etc/hosts`: Client-DNS-configuratie (`nameserver` en `search`-domein) en lokale statische host-mappings.
* **Praktijkgebruik & Permutaties:**
  ```bash
  # Test connectiviteit stapsgewijs: gateway -> extern IP -> domeinnaam
  ping -c 4 192.168.1.1
  ping -c 4 8.8.8.8
  ping -c 4 google.com

  # Traceer route en bevraag DNS-records
  traceroute -n 8.8.8.8
  dig FILESERVER.clab.local
  nslookup google.com

  # Configureer een interne DNS-server, een search-domein en een statische host-entry
  echo "nameserver 192.168.1.5" > /etc/resolv.conf
  echo "search clab.local" >> /etc/resolv.conf
  echo "192.168.1.20 FILESERVER" >> /etc/hosts
  ```

### `udhcpc`, `dhclient` & `dhcpcd` (DHCP-leases vernieuwen)
* **Doel:** Vraagt een nieuwe IP-configuratie op bij de lokale DHCP-server per distributie:
  * **Alpine Linux:** `udhcpc` (afbreken met `Ctrl + C`)
  * **Debian / Ubuntu **[Aanvullend]**:** `sudo dhclient -r && sudo dhclient`
  * **Arch Linux **[Aanvullend]**:** `sudo dhcpcd` of `networkctl renew <interface>`

---

## 8. Firewalls (`iptables`, `ufw`, `nftables`) & VPN (`strongSwan`, `OpenVPN`)

### `iptables` (Linux Host-Based Firewall)
* **Doel:** Beheert pakketfilterregels in de Linux-kernel via de policy chains `INPUT`, `FORWARD` en `OUTPUT`. Regels worden **top-down** verwerkt (*first match wins*); standaard staat het beleid op `ACCEPT`.
* **Parameters, Vlaggen & Acties:**
  * `-L` (`L` = **L**ist): Toont alle actieve regels per chain (`-n -v --line-numbers` **[Aanvullend]** voor numerieke weergave en regelnummers).
  * `-A <CHAIN>` (`A` = **A**ppend): Voegt een regel onderaan de chain toe.
  * `-I <CHAIN> <pos>` **[Aanvullend]** (`I` = **I**nsert): Voegt een regel in op een specifieke positie (bijv. bovenaan op `1`).
  * `-D <CHAIN> <pos>` **[Aanvullend]** (`D` = **D**elete): Verwijdert een regel op nummer.
  * `-s <bron>` (`s` = **s**ource): Bron-IP of subnet (bijv. `10.0.0.1` of `10.0.0.0/24`).
  * `-p <protocol>` (`p` = **p**rotocol): `tcp`, `udp`, `icmp`.
  * `--dport <poort>` (`dport` = **d**estination **port**): Bestemmingspoort (bijv. `22`, `21`, `80`).
  * `-j <actie>` (`j` = **j**ump): `ACCEPT` (toestaan) of `DROP` (stilzwijgend blokkeren).
  * `-F` (`F` = **F**lush): Wist alle geconfigureerde regels uit de firewall.
* **Praktijkgebruik & Permutaties:**
  ```bash
  # Bekijk de huidige firewallregels
  sudo iptables -L

  # Sta SSH (22) toe voor specifieke hosts, HTTP (80) voor het subnet, en blokkeer de rest
  sudo iptables -A INPUT -s 10.0.0.1 -p tcp --dport 22 -j ACCEPT
  sudo iptables -A INPUT -s 10.0.0.2 -p tcp --dport 22 -j ACCEPT
  sudo iptables -A INPUT -s 10.0.0.2 -p tcp --dport 21 -j ACCEPT
  sudo iptables -A INPUT -s 10.0.0.0/24 -p tcp --dport 80 -j ACCEPT
  sudo iptables -A INPUT -s 10.0.0.0/24 -j DROP

  # Wis alle firewallregels om een opgeschoonde regelset opnieuw in te laden
  sudo iptables -F
  ```
* **[Aanvullend] Modernere Linux Firewall-tools (Debian/Ubuntu & Arch):**
  * **`ufw`** (*Uncomplicated Firewall* — Debian/Ubuntu): `sudo ufw allow 22/tcp && sudo ufw enable`
  * **`nftables`** (moderne kernel-opvolger van `iptables` op Arch & Debian): `sudo nft list ruleset`

### VPN-beheer op Linux (`ipsec`, `ip xfrm`, `openvpn`) **[Aanvullend]**
* **Doel:** Inspecteert en beheert site-to-site IPsec-tunnels (**strongSwan**) en **OpenVPN**-verbindingen op Linux-servers.
* **Praktijkgebruik:**
  ```bash
  # Bekijk actieve IPsec Phase 1 en Phase 2 Security Associations (strongSwan)
  sudo ipsec statusall
  sudo ip xfrm state

  # Start een OpenVPN-clientverbinding vanaf de CLI
  sudo openvpn --config client.ovpn
  ```

---

## 9. Netwerkverkenning, Packet Capture & Cleartext Protocollen (`nmap`, `wireshark`, `tcpdump`)

### `nmap` (Network Mapper)
* **Doel:** Netwerkscanner voor Host Discovery, poortscanning, OS-fingerprinting en service-/versie-enumeratie.
* **Scan-types, Opties & Parameters:**
  * `-sT` (`s` = **s**can, `T` = **T**CP Connect): Volledige TCP 3-way handshake (*full-open*, standaard zonder `root`).
  * `-sS` (`S` = **S**YN Stealth): Half-open scan (`SYN` → `SYN/ACK` → `RST`, standaard met `sudo`).
  * `-sA` / `-sU`: **A**CK scan (firewall mapping) / **U**DP scan.
  * `-p <poorten>` & `-p-`: Scant opgegeven poorten (`-p 21`, `-p 80,443,8080`) of alle 65.535 poorten (`-p-`).
  * `--top-ports <n>` & `-F` (`F` = **F**ast): Scant de top `n` meest voorkomende poorten (`-F` = top 100).
  * `-sn` (*No port scan*): Voert uitsluitend Host Discovery (ping/ARP scan) uit.
  * `-Pn` (*No ping*): Slaat Host Discovery over en behandelt alle hosts als online (essentieel wanneer firewalls ICMP blokkeren).
  * `--reason`: Toont waarom Nmap een host of poort als *up/open/filtered* markeert.
  * `-O` & `--osscan-guess`: Detecteert het besturingssysteem (met agressieve schatting).
  * `-sV` (`V` = **V**ersion): Detecteert de exacte service en softwareversie op open poorten.
  * `-T<0-5>` (`T` = **T**iming): Scansnelheid van `0` (*Paranoid*), `1` (*Sneaky*), `2` (*Polite*), `3` (*Normal* — standaard), `4` (*Aggressive*) tot `5` (*Insane*).
  * `-sC`, `-A` & `-oA <naam>` **[Aanvullend]**: `-sC` = standaard NSE-scripts, `-A` = *Aggressive* (`-O -sV -sC --traceroute`), `-oA` = sla op in alle formaten (`.nmap`, `.gnmap`, `.xml`).
* **Praktijkgebruik & Permutaties:**
  ```bash
  # 1. Host Discovery op een subnet inclusief reden (ARP/ICMP)
  sudo nmap -sn --reason 192.168.0.0/24

  # 2. Snelle SYN-scan op de top 100 poorten (zonder ping-check)
  sudo nmap -Pn 192.168.0.2-100 -F

  # 3. Serviceversie- en OS-enumeratie op een doelhost
  sudo nmap -sV 192.168.0.20 -p 21
  sudo nmap -O --osscan-guess 192.168.0.20

  # 4. Scan alle 65.535 poorten op hoge snelheid (-T5)
  sudo nmap -Pn 192.168.0.20 -T5 -p-

  # 5. Trage TCP Connect-scan (-T1 zonder sudo) om rate-limiting/pakketfilters te omzeilen
  nmap -Pn 192.168.0.2 -T1 -p 22,25,1000,2099,8080,8888
  ```

### `wireshark`, `tshark`, `tcpdump`, `nc` & `gns3` / `clabnet`
* **Doel:**
  * `wireshark &`: Start de grafische packet analyzer op de achtergrond (`&`).
  * `tshark` & `tcpdump` **[Aanvullend]**: Command-line packet analyzers voor headless servers en `.pcap`-opnames.
  * `nc` (*Netcat*): Simuleert luisterende TCP/UDP-poorten of verbindt met netwerkdiensten.
  * `gns3 &` / `clabnet` / `xterm`: Start netwerksimulaties en opent virtuele host-terminals.
* **Praktijkgebruik & Permutaties:**
  ```bash
  # Start Wireshark of GNS3 op de achtergrond vanuit de terminal
  wireshark&
  gns3 &

  # Simuleer een luisterende TCP-poort met Netcat (-k = keep listening, -l = listen, -v = verbose, -p = port)
  sudo nc -klvp 80

  # [Aanvullend] Leg netwerkverkeer op interface eth0 vast naar een .pcap-bestand voor Wireshark
  sudo tcpdump -i eth0 -w capture.pcap
  sudo tshark -i eth0 -Y "http or dns"
  ```
* **Veelgebruikte Wireshark Display Filters:**
  * Protocollen: `icmp`, `arp`, `tcp`, `http`, `http.cookie`, `telnet`, `ftp`, `ftp-data`
  * IP/MAC/Poort: `ip.src == 192.168.0.1`, `ip.dst == 192.168.0.1`, `ip.addr == 192.168.0.1`, `ether.addr == 00:01:02:03:04:05`, `tcp.port == 22`
  * Logische operatoren: `icmp or arp`, `!(arp or icmp or dns)`

### `smbclient`, `ftp` & `telnet` (File Sharing & Cleartext Legacy-protocollen)
* **Doel:**
  * `smbclient`: Client om gedeelde Windows/Samba SMB-mappen op te vragen (`-L` = **L**ist, `-U` = **U**ser).
  * `ftp` & `telnet`: Onversleutelde (*cleartext*) protocollen voor bestandsoverdracht en remote shell (in productie vervangen door `sftp`/`scp` en `ssh`).
* **Praktijkgebruik:**
  ```bash
  # Inventariseer beschikbare SMB-shares op FILESERVER
  smbclient -L FILESERVER -U cybrary

  # Onversleutelde FTP- en Telnet-sessies (alleen voor lab/demonstratie)
  ftp fileserver
  telnet utilserver
  ```

---

## 10. Scripting, Python & Cryptografie (`openssl`, `sha256sum`, `base64`)

### `python3`
* **Doel:** Voert Python 3-scripts uit op Linux-systemen.
* **Praktijkgebruik & OS-verschillen:**
  ```bash
  # Voer een Python-script uit (op Arch Linux verwijst 'python' ook direct naar Python 3)
  python3 caesar.py
  ```

### `openssl` (`genpkey`, `rsa`, `pkeyutl`, `dgst`, `enc`)
* **Doel:** De standaard Linux CLI-toolkit voor asymmetrische sleutelgeneratie, public/private key encryptie, digitale handtekeningen, cryptografische hashes en symmetrische encryptie.
* **Parameters & Opties:**
  * `genpkey -algorithm rsa -out <key>`: Genereert een nieuwe private sleutel (modernere vervanger van `genrsa`).
  * `rsa -pubout -in <priv> -out <pub>`: Leidt de bijbehorende publieke sleutel af uit een RSA private sleutel (`openssl pkey -pubout` **[Aanvullend]** werkt voor alle sleuteltypen zoals RSA en Ed25519).
  * `pkeyutl -encrypt -inkey <pub> -pubin -in <in> -out <out>`: Versleutelt data met de publieke sleutel van de ontvanger (`-pubin` is verplicht bij een publieke sleutel).
  * `pkeyutl -decrypt -inkey <priv> -in <in> -out <out>`: Ontsleutelt binaire ciphertext met je eigen private sleutel.
  * `dgst -md5 <bestand>` / `dgst -sha256 <bestand>`: Berekent de MD5- of SHA-256-hashwaarde van een bestand.
* **Praktijkgebruik & Permutaties:**
  ```bash
  # 1. Genereer een RSA private key en leid de publieke sleutel af
  openssl genpkey -algorithm rsa -out cybraryprivate.key
  openssl rsa -pubout -in cybraryprivate.key -out cybrarypublic.key

  # 2. Versleutel een bericht met de publieke sleutel van de ontvanger (-pubin)
  openssl pkeyutl -encrypt -inkey sallypublic.key -pubin -in message.txt -out message.enc

  # 3. Ontsleutel het bericht met je eigen private sleutel
  openssl pkeyutl -decrypt -inkey sallyprivate.key -in message.enc -out message.txt

  # 4. Bereken MD5- en SHA-256-hashes van een bestand
  openssl dgst -md5 happypuppy.exe
  openssl dgst -sha256 happypuppy.exe

  # [Aanvullend] Symmetrische AES-256-CBC encryptie & decryptie met moderne PBKDF2-sleutelafleiding
  openssl enc -aes-256-cbc -salt -pbkdf2 -in geheim.txt -out geheim.enc
  openssl enc -d -aes-256-cbc -pbkdf2 -in geheim.enc -out geheim.txt

  # [Aanvullend] Digitale handtekening maken en verifiëren
  openssl dgst -sha256 -sign cybraryprivate.key -out message.sig message.txt
  openssl dgst -sha256 -verify cybrarypublic.key -signature message.sig message.txt
  ```

### `sha256sum` & `md5sum` **[Aanvullend]**
* **Doel:** Native GNU coreutils-commando's op Debian/Ubuntu en Arch Linux voor snelle hashberekening en automatische integriteitscontrole.
* **Praktijkgebruik:**
  ```bash
  # Bereken en verifieer SHA-256-hashes
  sha256sum happypuppy.exe
  sha256sum -c checksums.txt
  ```