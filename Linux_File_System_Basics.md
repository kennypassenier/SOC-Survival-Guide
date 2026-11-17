# Linux File System Basics
## 1. Overzicht van Relevante Commando's

### A. Mappenstructuur & Pakketbeheer

#### `tree`
* **Doel:** Toont de mappenstructuur visueel in een boomdiagram.
* **Parameters & Opties:**
  * `-L <niveau>` (`L` = **L**evel): Beperkt de weergave tot een opgegeven diepte in mappeniveaus (bijv. `-L 1`, `-L 2`, `-L 3`).
* **Praktijkgebruik & Permutaties:**
  ```bash
  # Toon alleen het eerste niveau onder de root-directory
  tree / -L 1

  # Inspecteer de home-directories met verhoogde rechten
  sudo tree /home

  # Bekijk de submapstructuur onder /usr
  tree /usr -L 1
  ```
* **[Aanvullend] Installatie, Extra Opties & OS-verschillen (Debian vs. Arch):**
  * `tree` is niet standaard op elk Linux-systeem geïnstalleerd:
    * **Debian / Ubuntu:** `sudo apt install tree -y`
    * **Arch Linux:** `sudo pacman -S tree`
  * **Nuttige opties:** `-a` (`a` = **a**ll, toont ook verborgen bestanden), `-d` (`d` = **d**irectories only, toont alleen mappen), `-p` (`p` = **p**ermissions, toont rechten per object).

#### `apt`
* **Doel:** De standaard pakketbeheerder op Debian- en Ubuntu-gebaseerde Linux-distributies voor het installeren, bijwerken en verwijderen van softwarepakketten.
* **Parameters & Opties:**
  * `install`: Subcommando om één of meer pakketten te installeren.
  * `-y` (`y` = **y**es): Beantwoordt bevestigingsvragen automatisch met *ja* zodat installaties zonder interactie doorlopen.
* **Praktijkgebruik:**
  ```bash
  # Installeer het tree-pakket zonder handmatige bevestiging
  sudo apt install tree -y
  ```
* **[Aanvullend] OS-verschillen (Debian/Ubuntu vs. Arch Linux & Windows):**
  * **Debian / Ubuntu:** Gebruik vooraf altijd `sudo apt update` om de lokale pakketindex te verversen voordat je software installeert (`sudo apt update && sudo apt install <pakket> -y`).
  * **Arch Linux:** Gebruikt `pacman` (`sudo pacman -S tree`, waarbij `-S` staat voor **S**ync/install; volledige systeemupdate via `sudo pacman -Syu`).
  * **Windows:** Moderne equivalenten zijn `winget install <pakket>` (Windows Package Manager) of `choco install <pakket>` (Chocolatey).

---

### B. Gebruikersbeheer, Privileges & Loganalyse

#### `sudo`
* **Doel:** *Superuser Do* — voert een opgegeven commando uit met verhoogde beheerdersrechten (`root`) voor dat ene commando.
* **Praktijkgebruik & Permutaties:**
  ```bash
  # Bekijk de inhoud van /home met root-rechten
  sudo tree /home

  # Bekijk de inhoud van de afgeschermde /root-directory
  sudo ls /root
  ```
* **Tips, Best Practices & Valkuilen:**
  * Gebruik `sudo` alleen wanneer een commando anders faalt of `Permission denied` geeft. Voer niet standaard je hele sessie uit als `root` om onbedoelde systeemschade te beperken.
  * **[Aanvullend]:** Elke `sudo`-actie wordt gelogd (op Debian/Ubuntu in `/var/log/auth.log`, op Arch Linux in `journalctl`), wat voor SOC-analisten een belangrijk auditspoor vormt. Met `sudo -l` (`l` = **l**ist) controleer je welke commando's de huidige gebruiker via `sudo` mag uitvoeren.

#### `adduser`
* **Doel:** Interactief hulpmiddel (op Debian/Ubuntu) om een nieuw gebruikersaccount aan te maken, inclusief home-directory, wachtwoord en gebruikersgegevens.
* **Praktijkgebruik:**
  ```bash
  # Maak interactief een nieuwe gebruiker 'michael' aan
  sudo adduser michael
  ```
* **Tips, Valkuilen & OS-verschillen:**
  * Bij het intypen van het wachtwoord in Linux verschijnen er **geen tekens of sterretjes** op het scherm; dit is normaal beveiligingsgedrag.
  * De standaard submappen in een nieuwe home-directory (zoals `Desktop`, `Documents`, `Downloads`) worden pas gegenereerd zodra de gebruiker voor het eerst inlogt.
  * **[Aanvullend] Debian vs. Arch Linux:** `adduser` is een interactief Perl-script specifiek voor Debian/Ubuntu. Op **Arch Linux** (en RHEL/Fedora) bestaat `adduser` niet en gebruik je het universele low-level commando `useradd`:
```bash
# Arch Linux & universeel Linux-equivalent (-m = make home directory)
sudo useradd -m michael
sudo passwd michael
```

#### `last`
* **Doel:** Leest het binaire logbestand `/var/log/lastlog` (en `/var/log/wtmp`) om een overzicht te tonen van recente en historische logins op het systeem.
* **Praktijkgebruik:**
  ```bash
  # Toon het overzicht van systeemlogins
  sudo last
  ```
* **Valkuilen & Aanvullende SOC-tips:**
  * Bestanden zoals `/var/log/lastlog` en `/var/log/wtmp` zijn **binaire bestanden** en kunnen niet met `cat` of een teksteditor worden geopend.
  * **[Aanvullend]:** Gebruik `last -n 20` (`n` = **n**umber) om de laatste 20 logins te bekijken, `last -a` (`a` = **a**ddress) om de herkomst-IP/hostnaam in de laatste kolom te plaatsen, en `lastb` (`b` = **b**ad logins, leest `/var/log/btmp`) om mislukte inlogpogingen te onderzoeken tijdens een brute-force-analyse.

#### `who`
* **Doel:** Leest `/var/log/wtmp` (en `/var/run/utmp`) om te tonen welke gebruikers op dit moment actief zijn ingelogd op het systeem.
* **Praktijkgebruik:**
  ```bash
  # Toon momenteel ingelogde gebruikers
  sudo who
  ```
* **[Aanvullend] Uitbreidingen & Alternatieven:**
  * `w`: Geeft een uitgebreider overzicht dan `who`, inclusief hoe lang gebruikers al inactief zijn (*idle time*) en welk commando ze op dat moment uitvoeren.
  * `users`: Print een compacte lijst van alleen de namen van ingelogde gebruikers.

#### `tail`
* **Doel:** Toont het onderste deel (standaard de laatste 10 regels) van een bestand of datastroom (het tegenovergestelde van `head`).
* **Parameters & Opties:**
  * `-f` (`f` = **f**ollow): Blijft het bestand live volgen en toont nieuwe logregels direct zodra ze worden weggeschreven. Stop met `Ctrl + C`.
* **Praktijkgebruik:**
  ```bash
  # Volg live nieuwe systeemmeldingen in syslog
  sudo tail -f /var/log/syslog
  ```
* **[Aanvullend] Extra Opties & OS-verschillen (Debian vs. Arch):**
  * **Parameters:** `-n <aantal>` (`n` = **n**umber of lines, bijv. `tail -n 50 /var/log/auth.log`) en `-F` (`F` = **F**ollow by name/retry, blijft volgen zelfs als het logbestand tussentijds wordt geroteerd naar `.gz`).
  * **Debian vs. Arch Linux:** Waar Debian/Ubuntu klassieke tekstlogs in `/var/log/syslog` en `/var/log/auth.log` gebruikt, werkt Arch Linux standaard met `systemd-journald`. Het moderne equivalent op zowel Debian als Arch is `journalctl -f` (of `journalctl -u sshd -f` voor één specifieke dienst).

---

### C. Schijfbeheer, Partities & Procesinspectie

#### `fdisk`
* **Doel:** Partitioneringstool waarmee fysieke opslagapparaten en hun partitietabellen kunnen worden bekeken en beheerd.
* **Parameters & Opties:**
  * `-l` (`l` = **l**ist): Geeft een overzicht van alle gedetecteerde schijven en partities.
* **Praktijkgebruik:**
  ```bash
  # Toon alle schijfapparaten en filter virtuele loopback-devices weg
  sudo fdisk -l | grep dev | grep -v loop
  ```
* **Tips, Valkuilen & Moderne Equivalenten:**
  * Let in de uitvoer op het verschil tussen **GiB** (gibibyte, binair / 1024-gebaseerd) en **GB** (gigabyte, decimaal / 1000-gebaseerd). *(Opmerking: de cursustekst draait de getallen 1000 en 1024 per ongeluk om; technisch is 1 GiB = $1024^3$ bytes en 1 GB = $1000^3$ bytes **[Aanvullend]**).*
  * **[Aanvullend]:** Voor schijven groter dan 2 TB (GPT-partitietabellen) is `parted -l` of `gdisk -l` het moderne alternatief.

#### `df`
* **Doel:** *Disk Free* — toont de totale, gebruikte en beschikbare schijfruimte van alle aangekoppelde (*mounted*) bestandssystemen.
* **Parameters & Opties:**
  * `-h` (`h` = **h**uman-readable): Toont groottes in leesbare eenheden (KB, MB, GB) in plaats van 1K-blokken.
* **Praktijkgebruik:**
  ```bash
  # Bekijk vrije en gebruikte schijfruimte per partitie
  sudo df -h
  ```
* **[Aanvullend] Extra Parameters & Verwante Tools:**
  * `-T` (`T` = **T**ype): Toont ook het type bestandssysteem per partitie (bijv. `ext4`, `xfs`, `vfat`, `tmpfs`).
  * `du -sh <map>` (*Disk Usage*, `-s` = **s**ummary, `-h` = **h**uman-readable): Gebruik `du` om te achterhalen welke specifieke map veel schijfruimte verbruikt.

#### `lsblk`
* **Doel:** *List Block Devices* — geeft een boomoverzicht van alle blokapparaten (fysieke schijven, SSD's, NVMe's, partities en hun koppelpunten).
* **Praktijkgebruik:**
  ```bash
  # Toon alle blokapparaten en partities in een overzichtelijke structuur
  lsblk
  ```
* **[Aanvullend] Extra Parameters:**
  * `-f` (`f` = **f**ilesystems): Toont bestandssysteemtypes (`EXT4`, `XFS`, `SWAP`), labels en unieke UUID's (handig bij het configureren van `/etc/fstab`).
  * `-p` (`p` = **p**aths): Toont het volledige apparaatpad (bijv. `/dev/sda1` of `/dev/nvme0n1p2`).

#### `ps`
* **Doel:** *Process Status* — geeft een momentopname van actieve processen op het systeem en hun Process ID (**PID**).
* **Parameters & Opties:**
  * `-e` (`e` = **e**very): Toont alle actieve processen op het systeem (niet alleen die van je eigen terminalsessie).
* **Praktijkgebruik:**
  ```bash
  # Toon alle actieve processen op het systeem
  ps -e
  ```
* **[Aanvullend] Veelgebruikte Permutaties & SOC-analyse:**
  * `ps aux` (BSD-stijl: `a` = **a**ll users, `u` = **u**ser-oriented format, `x` = processes without a controlling terminal) of `ps -ef` (`e` = **e**very, `f` = **f**ull-format listing): Toont ook de gebruiker, CPU/geheugengebruik en de volledige opstartopdracht inclusief argumenten.
  * **Forensische koppeling met `/proc`:** Elke PID uit `ps` heeft een eigen virtuele map `/proc/<PID>/` waarin je onder meer `cmdline` (exacte opdrachtregel), `exe` (symlink naar het uitvoerbare bestand) en `environ` (omgevingsvariabelen) kunt inspecteren.

---

## 2. Algemene Uitleg & Theorie

### Opslag, Bestandssystemen & Metadata
* **Vluchtige vs. permanente opslag:** Een besturingssysteem verplaatst vluchtige data continu tussen de **CPU** en het werkgeheugen (**RAM**). Data die niet direct actief is, wordt opgeslagen op grotere, tragere permanente opslagmedia zoals HDD's, SSD's en NVMe-schijven.
* **Functie van een bestandssysteem:** Het bestandssysteem bepaalt hoe het OS bestanden, mappen, opslagmedia en randapparatuur organiseert en benadert.
* **Bestandssystemen per OS:**
  * **Windows:** `FAT`, `NTFS` (werkt hiërarchisch met schijfletters en volumes zoals `C:\`).
  * **macOS:** `HFS`, `APFS`.
  * **Linux:** `EXT` (`EXT2`, `EXT3`, `EXT4` — geïntroduceerd in 1992 en nog steeds de standaard), `XFS`.
* **Inodes & Metadata:** Het EXT-bestandssysteem gebruikt datastructuren genaamd **index nodes (inodes)** om bestandsinformatie op te slaan en te verwijzen naar de fysieke locatie op de schijf. Deze informatie — waaronder bestandsgrootte, attributen, locatie, aanmaak-/wijzigings-/toegangstijden, eigenaar en rechten — heet **metadata** en vormt een cruciale bron bij digitaal forensisch onderzoek (*Digital Forensics*).

### De Filesystem Hierarchy Standard (FHS)
In Linux begint alles onder één enkele **root-directory (`/`)**. Er bestaan geen mappen boven `/`. Zelfs fysieke hardware en apparaten worden in Linux als bestanden onder `/` weergegeven. Vrijwel alle distributies volgen de **Filesystem Hierarchy Standard (FHS)** van de Linux Foundation:

| Directory | Functie & Inhoud | Belangrijke Details & Submappen |
| :--- | :--- | :--- |
| **`/`** | **Root-directory** | Het hoogste niveau van de volledige mappenboom (niet te verwarren met `/root`). |
| **`/bin`** | **User Binaries** | Basiscommando's voor alle gebruikers (`ls`, `pwd`, `cat`, `cd`, `more`, `less`). Op moderne systemen is dit een **symbolische link (`l`)** naar `/usr/bin` voor FHS-compatibiliteit. |
| **`/sbin`** | **System Binaries** | Systeembeheertools die doorgaans verhoogde rechten vereisen (vaak een symlink naar `/usr/sbin`). |
| **`/boot`** | **Boot-bestanden** | Bevat de Linux-kernel en opstartbestanden die nodig zijn voordat user-mode programma's starten. |
| **`/dev`** | **Device Files** | Vertegenwoordigt hardware en virtuele apparaten als bestanden (niet leesbaar als platte tekst):<br>• `/dev/xvda` (of `sda` / `nvme0n1`): De fysieke harde schijf/SSD.<br>• `/dev/null`: Het "zwarte gat" om ongewenste uitvoer weg te gooien (`2>/dev/null`).<br>• `/dev/urandom`: Genereert willekeurige bytes/getallen. |
| **`/etc`** | **Configuratiebestanden** | Centrale systeemconfiguraties:<br>• `/etc/hosts`: Lokale IP-naar-hostnaam-koppelingen.<br>• `/etc/fstab`: Configuratie voor het automatisch aankoppelen (*mounten*) van bestandssystemen.<br>• `/etc/crontab`: Geplande taken (*cronjobs*).<br>• `/etc/rc0.d` – `rc5.d`: Scripts die tijdens verschillende runlevels/opstartfasen draaien.<br>• `/etc/netplan`: Netwerkconfiguratie op moderne Ubuntu/Debian-systemen. |
| **`/home`** | **Home-directories** | Persoonlijke mappen van standaardgebruikers (`/home/gebruikersnaam`). Gebruikers hebben geen schrijfrechten op `/home` zelf, maar wel volledige `rwx`-rechten op hun eigen submap. |
| **`/lib`** | **System Libraries** | Essentiële programmabibliotheken (op moderne systemen vaak een symlink naar `/usr/lib`). |
| **`/mnt` & `/media`** | **Mount Points** | Koppelpunten voor externe opslag. Volgens de FHS is `/media` bedoeld voor verwijderbare media (USB, CD-ROM) en `/mnt` voor tijdelijke of netwerkopslag (zoals NFS), al wordt `/mnt` in de praktijk ook vaak voor lokale schijven gebruikt. |
| **`/opt`** | **Optional Software** | Installatiemap voor losstaande (*unbundled*) softwarepakketten van derden (bijv. Oracle Database). |
| **`/proc`** | **Processes (Virtueel)** | Virtueel bestandssysteem dat bij opstarten wordt opgebouwd en bij afsluiten verdwijnt. Bevat genummerde mappen die overeenkomen met elke actieve **PID** uit `ps -e`. |
| **`/root`** | **Root Home** | De persoonlijke home-directory van de `root`-gebruiker (niet toegankelijk voor gewone gebruikers zonder `sudo`). |
| **`/tmp`** | **Temporary Files** | Tijdelijke bestanden van gebruikers en applicaties. |
| **`/usr`** | **Unix System Resources** | Uitvoerbare programma's en ondersteunende bestanden:<br>• `/usr/bin`: Gebruikerscommando's (doel van `/bin`).<br>• `/usr/sbin`: Beheertools (doel van `/sbin`).<br>• `/usr/lib`: Systeembibliotheken.<br>• `/usr/share`: Documentatie en handleidingen (`man`-pages).<br>• `/usr/local`: Locatie waar beheerders zelf gecompileerde tools (bijv. via `make`) plaatsen. |
| **`/var`** | **Variable Data** | Veranderlijke data zoals databases, spools en vooral logbestanden onder **`/var/log`**:<br>• `/var/log/syslog`: Algemene systeemmeldingen (eerste startpunt bij storingen).<br>• `/var/log/auth.log`: Authenticatie- en `sudo`-logs.<br>• `/var/log/dmesg`: Kernel-opstart- en hardwaremeldingen.<br>• `/var/log/lastlog` & `wtmp`: Binaire login-logs (uitlezen met `last` en `who`).<br>• `*.gz`: Automatisch gecomprimeerde oude logbestanden. |

### Objecttypes & Permissies in `ls -l`
* **Objecttypes (eerste teken):**
  * `d` (donkerblauw in terminal): **Directory** (map).
  * `-`: Regulier **bestand**.
  * `l` (lichtblauw in terminal): **Symbolic link** (*symlink*) — een snelkoppeling/verwijzing naar een ander bestand of map.
* **Rechtengroepen (`rwx`):** Rechten zijn opgedeeld in drie sets van drie tekens (`r` = *read*, `w` = *write*, `x` = *execute*, `-` = niet toegekend):
  1. **Owner** (eigenaar van het object)
  2. **Group** (de toegewezen groep)
  3. **Everyone else / Others** (alle overige gebruikers)
  * *Voorbeeld `/home`:* `drwxr-xr-x` betekent dat `root` (owner) volledige rechten heeft (`rwx`), terwijl de groep en overige gebruikers alleen mogen lezen en uitvoeren (`r-x`), maar geen mappen mogen aanmaken of verwijderen in `/home`.

---

## 3. Praktijkscenario's & Stappenplannen

### Scenario 1: Loganalyse & Gebruikersactiviteit Controleren na een Incident
**[Cursusmateriaal + Aanvullend SOC-stappenplan]**
Wanneer je verdachte activiteit op een Linux-server onderzoekt, combineer je tekstlogs met binaire login-logs:

1. **Controleer wie er momenteel is ingelogd en wie er recent heeft ingelogd:**
   ```bash
   sudo who
   sudo last
   ```
   * *Valkuil:* Probeer `/var/log/wtmp` of `/var/log/lastlog` nooit te openen met `cat`, `less` of `nano`; dit zijn binaire bestanden die alleen onleesbare tekens opleveren.
2. **Inspecteer het overzicht van beschikbare logbestanden:**
   ```bash
   ls -la /var/log
   ```
   * *Aandachtspunt:* Oudere logs worden automatisch gecomprimeerd met `gzip` (`.gz`). **[Aanvullend]:** Gebruik `zcat` of `zgrep` om gecomprimeerde `.gz`-logs te doorzoeken zonder ze eerst handmatig uit te pakken.
3. **Monitor systeem- en authenticatiemeldingen in real time:**
   ```bash
   sudo tail -f /var/log/syslog
   ```
   * *Aandachtspunt:* Sluit live monitoring af met `Ctrl + C`. (Gebruik op Arch Linux `journalctl -f` **[Aanvullend]**).

### Scenario 2: Schijfruimte, Partities & Actieve Processen Verifiëren
Een snelle gezondheidscontrole (*health check*) van opslag en actieve processen op een Linux-systeem:

1. **Vergelijk fysieke schijven met aangekoppelde partities:**
   ```bash
   sudo fdisk -l | grep dev | grep -v loop
   sudo df -h
   lsblk
   ```
   * *Aandachtspunt:* `fdisk` toont fysieke schijfcapaciteit in **GiB**, terwijl `df -h` de bruikbare capaciteit van aangekoppelde partities toont (inclusief het percentage dat in gebruik is).
2. **Koppel actieve processen aan hun runtime-informatie in `/proc`:**
   ```bash
   ps -e
   ls /proc
   ```
   * *Aandachtspunt:* Elke PID uit `ps -e` komt overeen met een map onder `/proc/<PID>`. Omdat `/proc` in het geheugen leeft, verdwijnt alle inhoud bij een herstart.

---

## 4. Aanvullende Bronnen & Referenties

* **Interne Commandoreferenties (SOC Analyst Map):**
  * Zie `BASH.md` voor het volledige, categorische overzicht van alle BASH-commando's, permutaties en distributieverschillen tussen Debian en Arch Linux.
  * Zie `CMD.md` en `PowerShell.md` voor de Windows-tegenhangers van schijf-, proces- en gebruikersbeheer.
* **[Aanvullend] Officiële Documentatie & Forensische Verdieping:**
  * [Linux Filesystem Hierarchy Standard (FHS 3.0)](https://refspecs.linuxfoundation.org/FHS_3.0/fhs/index.html) — De officiële specificatie van alle standaard Linux-directories.
  * [Linux Kernel Documentation: The /proc Filesystem](https://docs.kernel.org/filesystems/proc.html) — Diepgaande uitleg over proces- en kernelinformatie in `/proc`.
  * [ArchWiki: File Systems](https://wiki.archlinux.org/title/File_systems) & [ArchWiki: Users and Groups](https://wiki.archlinux.org/title/Users_and_groups) — Praktische referentie voor moderne Linux-systeembeheerders.