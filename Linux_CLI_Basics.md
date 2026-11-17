# Linux CLI Basics

## 1. Overzicht van Relevante Commando's

### A. Identiteit & Systeemcontext

#### `whoami`
* **Doel:** Toont de gebruikersnaam van de huidige ingelogde gebruiker.
* **Praktijkgebruik:**
  ```bash
  # Toont de actieve gebruikersnaam (bijv. cybrary)
  whoami
  ```
* **Tips, Best Practices & Valkuilen:**
  * Niet elke Linux-terminalprompt toont standaard wie je bent of waar je zit; gebruik `whoami` om je gebruikerscontext direct te verifiëren.
  * **[Aanvullend]:**
    * `--version`: Toont versiedetails van het GNU coreutils-hulpprogramma.
    * Tijdens incident response of privilege escalation-checks is `whoami` essentieel om te bevestigen onder welke gebruikerscontext een shell of proces draait.

#### `hostname`
* **Doel:** Toont de computernaam (hostnaam) van het Linux-systeem.
* **Praktijkgebruik:**
  ```bash
  # Toont de hostnaam (bijv. linux of ip-10-191-20-113)
  hostname
  ```
* **[Aanvullend] Extra Opties, Moderne Equivalenten & OS-verschillen:**
  * **Parameters:**
    * `-I` (`I` = **I**P-addresses): Toont alle toegewezen netwerk-IP-adressen van de machine (handig voor snelle netwerkanalyse: `hostname -I`).
    * `-f` (`f` = **f**qdn): Toont de volledige domeinnaam (*Fully Qualified Domain Name*).
  * **Moderne equivalenten & OS-verschillen (Debian vs. Arch):** Op moderne `systemd`-distributies (zowel Debian/Ubuntu als Arch Linux) is `hostnamectl` het moderne equivalent om de hostnaam uit te lezen of permanent te wijzigen. Op een minimale Arch Linux-installatie ontbreekt het klassieke `hostname`-commando soms als het pakket `inetutils` niet is geïnstalleerd; `hostnamectl` of `cat /etc/hostname` werkt daar altijd.

#### `id`
* **Doel:** Toont de User ID (`uid`), primaire Group ID (`gid`) en alle groepslidmaatschappen (`groups`) van de gebruiker.
* **Praktijkgebruik:**
  ```bash
  # Volledige uitvoer, bijv. uid=1001(cybrary) gid=1001(cybrary) groups=1001(cybrary),27(sudo)
  id
  ```
* **Tips, Best Practices & Context:**
  * Reguliere niet-systeemaccounts (standaardgebruikers) beginnen in Linux vanaf UID `1000` (de `root`-gebruiker heeft altijd UID `0`). Elke gebruiker krijgt standaard ook een eigen primaire groep met dezelfde naam.
  * **[Aanvullend] Parameters & OS-verschillen (Debian vs. Arch):**
    * `-u` (`u` = **u**ser): Print uitsluitend de numerieke User ID; `-un` (`n` = **n**ame) print de gebruikersnaam.
    * `-Gn` (`G` = all **G**roups, `n` = **n**ame): Toont de namen van alle groepen waartoe de gebruiker behoort (bijv. `id -Gn cybrary`).
    * **Debian vs. Arch:** Op Debian/Ubuntu geeft lidmaatschap van de groep `sudo` (zoals GID `27` in de cursus) beheerdersrechten. Op Arch Linux wordt hiervoor standaard de groep `wheel` gebruikt.

---

### B. Navigatie & Bestandsstructuur

#### `pwd`
* **Doel:** *Print Working Directory* — toont het volledige absolute pad van de huidige werkmap.
* **Praktijkgebruik:**
  ```bash
  # Bevestig je huidige locatie (bijv. /home/cybrary/Desktop)
  pwd
  ```
* **[Aanvullend] Extra Parameters:**
  * `-P` (`P` = **P**hysical): Toont het fysieke pad en lost symbolische links (*symlinks*) op.
  * `-L` (`L` = **L**ogical): Toont het logische pad inclusief symlinks (standaardgedrag).

#### `cd`
* **Doel:** *Change Directory* — wisselt van actieve werkmap in het bestandssysteem.
* **Parameters & Pad-notaties:**
  * `..`: Verwijst naar de bovenliggende map (*parent directory*).
  * `../..`: Gaat twee mappen omhoog in de hiërarchie.
  * `~`: Tilde — verwijst naar de home-directory van de huidige gebruiker (`/home/cybrary`).
  * `/`: Root-directory — het hoogste niveau van het Linux-bestandssysteem.
* **Praktijkgebruik & Permutaties:**
  ```bash
  # Eén map omhoog
  cd ..

  # Twee mappen omhoog (bijv. van /home/cybrary naar /)
  cd ../..

  # Terugkeren naar je home-directory (of via absoluut pad: cd /home/cybrary)
  cd ~
  ```
* **Valkuilen & Aanvullende Tips:**
  * Let op de verplichte spatie tussen `cd` en `..`. In tegenstelling tot Windows CMD werkt `cd..` zonder spatie niet in BASH.
  * Je kunt nooit hoger navigeren dan de root-directory (`/`). Zelfs als je `cd ../../../../..` uitvoert, blijf je op `/`.
  * **[Aanvullend]:** Gebruik `cd -` om direct heen en weer te schakelen naar de vorige werkmap waarin je zich bevond.

#### `ls`
* **Doel:** *List* — geeft een overzicht van bestanden en mappen in de huidige of opgegeven directory.
* **Parameters & Opties:**
  * `-l` (`l` = **l**ong): Gedetailleerde lijstweergave met objecttype (`d` = directory, `-` = bestand), `rwx`-rechten voor eigenaar/groep/overigen, aantal links, eigenaar, groep, grootte in bytes, wijzigingsdatum en naam.
  * `-a` (`a` = **a**ll): Toont alle bestanden, inclusief verborgen bestanden die beginnen met een punt (`.`, zoals `.bashrc` en `.bash_history`).
  * `-R` (`R` = **R**ecursive): Toont recursief de inhoud van de huidige map én alle onderliggende submappen.
* **Praktijkgebruik & Permutaties:**
  ```bash
  # Standaard overzicht van zichtbare bestanden en mappen
  ls

  # Gedetailleerde lijst met permissies en eigenaarschap
  ls -l

  # Gedetailleerde lijst inclusief verborgen puntbestanden
  ls -la

  # Recursieve weergave van alle submappen
  ls -R
  ```
* **[Aanvullend] Extra Parameters & Moderne Equivalenten:**
  * **Nuttige vlaggen:** `-h` (`h` = **h**uman-readable, toont groottes in KB/MB/GB), `-t` (`t` = **t**ime, sorteert op wijzigingstijdstip) en `-r` (`r` = **r**everse, keert de sorteervolgorde om). De combinatie `ls -latr` is een favoriet bij SOC-analisten om alle recente bestandswijzigingen onderaan de lijst te zien.
  * **Moderne equivalenten (Debian & Arch):** `eza` (opvolger van `exa`) of `lsd` bieden moderne kleurencodes, iconen en Git-statusweergave (`eza -la --git`).

---

### C. Bestandsbeheer, Redirection & Lees-tools

#### `mkdir`
* **Doel:** *Make Directory* — maakt één of meerdere nieuwe mappen aan.
* **Praktijkgebruik & Permutaties:**
  ```bash
  # Maak één nieuwe map aan
  mkdir labwork

  # Maak meerdere mappen tegelijk aan
  mkdir red blue green
  ```
* **[Aanvullend] Extra Parameters:**
  * `-p` (`p` = **p**arents): Maakt ontbrekende bovenliggende mappen automatisch aan en geeft geen foutmelding als de map al bestaat (`mkdir -p /tmp/onderzoek/logs/2026`).

#### `touch`
* **Doel:** Maakt één of meerdere lege bestanden aan, of werkt de toegang- en wijzigingstijdstempel van een bestaand bestand bij.
* **Praktijkgebruik:**
  ```bash
  # Maak drie lege tekstbestanden tegelijk aan
  touch file1.txt file2.txt file3.txt
  ```
* **[Aanvullend] Extra Parameters & SOC-context:**
  * `-t` (`t` = **t**imestamp): Stelt een specifieke datum/tijd in (`[[CC]YY]MMDDhhmm[.ss]`). Aanvallers gebruiken `touch -t` of `touch -r` soms voor *timestomping* (het vervalsen van tijdstempels om kwaadaardige bestanden te verbergen tussen legitieme systeembestanden).

#### `echo` & Output Redirection (`>`, `>>`)
* **Doel:** Schrijft een tekenreeks naar standaarduitvoer (*stdout*) of leidt deze om naar een bestand.
* **Operators:**
  * `>`: *Overwrite redirector* — schrijft uitvoer naar een bestand en **overschrijft** eventuele bestaande inhoud volledig.
  * `>>`: *Append redirector* — voegt uitvoer **achteraan toe** aan een bestaand bestand (of maakt het bestand aan als het nog niet bestaat).
* **Praktijkgebruik & Permutaties:**
  ```bash
  # Voeg tekst toe aan het einde van file1.txt (append)
  echo "This is file 1" >> file1.txt

  # Overschrijf file1.txt volledig met nieuwe tekst
  echo "This is file 1" > file1.txt
  ```
* **[Aanvullend] Extra Parameters:**
  * `-e` (`e` = **e**nable escapes): Interpreteert backslash-escape-tekens zoals `\n` (nieuwe regel) en `\t` (tab).

#### `cat`
* **Doel:** *Concatenate* — leest één of meerdere bestanden en print de volledige inhoud direct naar het scherm.
* **Praktijkgebruik:**
  ```bash
  # Toon de inhoud van file1.txt
  cat file1.txt
  ```
* **[Aanvullend] Extra Parameters & Moderne Equivalenten:**
  * **Parameters:** `-n` (`n` = **n**umber, nummert uitvoerregels) en `-A` (`A` = **A**ll, maakt verborgen stuurtekens, tabs `^I` en regeleindes `$` zichtbaar — ideaal bij het inspecteren van verdachte scripts: `cat -nA script.sh`).
  * **Moderne equivalenten (Debian & Arch):** `bat` (op Debian/Ubuntu vaak geïnstalleerd als `batcat`) biedt syntax-highlighting, regelnummers en automatische paging.

#### `file`
* **Doel:** Identificeert het werkelijke bestandstype op basis van de interne bestandsstructuur (*magic bytes*), ongeacht de bestandsnaam of extensie.
* **Praktijkgebruik:**
  ```bash
  # Controleer het werkelijke bestandstype (output: file1.txt: ASCII text)
  file file1.txt
  ```
* **Tips & Best Practices:**
  * Linux vereist geen bestandsextensies; extensies zoals `.txt` zijn puur een conventie voor gebruikers. Een uitvoerbaar bestand kan probleemloos `.txt` heten. Gebruik altijd `file` voordat je een onbekend bestand opent.
  * **[Aanvullend]:** Gebruik `file -i` (`i` = **i**nfo / MIME) om het exacte MIME-type en de tekenset op te vragen (bijv. `text/plain; charset=us-ascii`).

#### `cp`
* **Doel:** *Copy* — kopieert bestanden of mappen naar een nieuwe locatie terwijl het origineel behouden blijft.
* **Praktijkgebruik:**
  ```bash
  # Kopieer file1.txt naar de submap blue/
  cp file1.txt blue/
  ```
* **[Aanvullend] Extra Parameters & SOC-tips:**
  * `-r` / `-R` (`r` = **r**ecursive): Kopieert een volledige map inclusief alle submappen en bestanden.
  * `-p` (`p` = **p**reserve): Behoudt originele rechten, eigenaarschap en tijdstempels (essentieel bij het veiligstellen van logbestanden tijdens incident response: `cp -p /var/log/auth.log /tmp/backup_auth.log`).

#### `rm`
* **Doel:** *Remove* — verwijdert bestanden of mappen definitief uit het bestandssysteem.
* **Parameters & Opties:**
  * `-i` (`i` = **i**nteractive): Vraagt expliciet om bevestiging (`y`/`n`) vóór elk te verwijderen bestand.
* **Praktijkgebruik:**
  ```bash
  # Verwijder een bestand veilig met bevestigingsvraag
  rm -i file1.txt
  ```
* **Valkuilen & Aanvullende Parameters:**
  * De Linux CLI heeft **geen prullenbak** en negeert de GUI-prullenbak van je desktopomgeving. Wat met `rm` wordt verwijderd, is direct weg en kan alleen vanuit een back-up worden hersteld.
  * **[Aanvullend]:** `-r` (`r` = **r**ecursive) verwijdert mappen en inhoud recursief; `-f` (`f` = **f**orce) forceert verwijdering zonder bevestigingsvragen (`rm -rf` vereist uiterste voorzichtigheid).

#### `mv`
* **Doel:** *Move* — verplaatst bestanden of mappen naar een andere locatie, of hernoemt ze binnen dezelfde map (laat geen kopie achter).
* **Praktijkgebruik & Permutaties:**
  ```bash
  # Verplaats file2.txt naar de map green
  mv file2.txt green

  # Hernoem file3.txt naar happypumpkin.moo
  mv file3.txt happypumpkin.moo

  # Verplaats en hernoem in één beweging
  mv happypumpkin.moo red/file3.txt
  ```
* **[Aanvullend] Extra Parameters:**
  * `-i` (`i` = **i**nteractive): Vraagt bevestiging voordat een bestaand doelbestand wordt overschreven.
  * `-n` (`n` = **n**o-clobber): Overschrijft nooit een bestaand bestand.

#### `more` & `less`
* **Doel:** *Pagers* waarmee je grote bestanden pagina voor pagina of regel voor regel op het scherm kunt lezen zonder je terminal te overspoelen.
* **Verschillen & Besturing:**
  * `more`: De oudere pager; kan **alleen vooruit** scrollen (`Enter` = 1 regel, `Spatiebalk` = 1 pagina, `q` = afsluiten).
  * `less`: De moderne, krachtigere pager; kan **vooruit én achteruit** scrollen (`Pijltje omlaag`/`Enter` = 1 regel omlaag, `Pijltje omhoog` = 1 regel omhoog, `Spatiebalk` = 1 pagina omlaag, `b` = **b**ack / 1 pagina omhoog, `q` = afsluiten).
* **Praktijkgebruik:**
  ```bash
  # Lees een groot bestand met alleen voorwaartse navigatie
  more abigfile.txt

  # Lees een groot bestand met voor- en achterwaartse navigatie
  less abigfile.txt
  ```
* **[Aanvullend] Extra Parameters voor Loganalyse:**
  * `-S` (`S` = **S**horten/chop long lines): Kapt extreem lange regels horizontaal af (te scrollen met pijltjestoetsen links/rechts).
  * `-N` (`N` = **N**umbers): Toont regelnummers in `less` (bijv. `less -SN /var/log/syslog`).

#### `base64` & `head`
* **Doel:**
  * `base64`: Zet binaire of willekeurige bytes om naar afdrukbare ASCII-tekens.
  * `head`: Toont het begin (standaard de eerste 10 regels) van een bestand of datastroom.
* **Parameters & Opties:**
  * `-c` bij `head` (`c` = **c**haracters/bytes): Leest een exact aantal bytes (bijv. `1M` = 1 megabyte).
* **Praktijkgebruik:**
  ```bash
  # Genereer 1MB aan afdrukbare willekeurige tekst vanuit /dev/urandom
  base64 /dev/urandom | head -c 1M > abigfile.txt
  ```
* **[Aanvullend] Extra Parameters voor SOC-analyse:**
  * `-n` bij `head` (`n` = **n**umber of lines): Toont de eerste *N* regels (bijv. `head -n 20 auth.log`).
  * `-d` bij `base64` (`d` = **d**ecode): Decodeert verdachte Base64-strings terug naar leesbare tekst (`echo "d2hvYW1pCg==" | base64 -d`).

---

## 2. Algemene Uitleg & Theorie

### Wat is Linux en waar wordt het gebruikt?
* **Oorsprong:** Linux is een Unix-achtig besturingssysteem dat voornamelijk in de programmeertaal **C** is geschreven. **Linus Torvalds** begon in **1991** met de ontwikkeling ervan met als doel een gratis besturingssysteem voor onderwijsinstellingen te creëren.
* **Adoptie & Belang:** Linux is uitgegroeid tot een fundament van de moderne IT-infrastructuur:
  * Meer dan **47%** van de ontwikkelaars gebruikt Linux als primair besturingssysteem.
  * Meer dan **49%** van de top 100.000 websites en **40%** van *alle* websites wereldwijd draaien op Linux.
  * Meer dan **78%** van alle *Internet of Things* (IoT)-apparaten draait op Linux vanwege de kleine voetafdruk en hoge efficiëntie.
* Voor systeembeheerders en cybersecurityprofessionals (zoals SOC-analisten) is beheersing van Linux daarom onmisbaar.

### GUI vs. CLI & De Shell
* **GUI (Graphical User Interface):** Op Windows is de grafische, muisgestuurde interface de standaardmanier om het systeem te beheren. Hoewel Linux-desktops ook GUI-tools hebben, is dat niet de primaire beheermethode.
* **CLI (Command Line Interface):** In Linux vindt systeembeheer primair plaats via een tekstgebaseerde interface die een **terminal** of **shell** wordt genoemd (toetsenbordgestuurd).
* **BASH:** Er bestaan verschillende shells, maar de meest populaire is **BASH** (*Bourne Again Shell*), vernoemd naar **Steven Bourne**, de bedenker van de oorspronkelijke Unix Bourne shell (`sh`).
* **Waarom de CLI superieur is voor beheer en security:**
  1. **Snelheid:** Commando's typen is sneller dan met de muis door menu's zoeken.
  2. **Automatisering:** Repetitieve taken zijn eenvoudig te automatiseren via shell-scripts en het aan elkaar koppelen van commando's (*piping*).
  3. **Efficiëntie & Granulariteit:** De combinatie van een rijke commandovocabulaire met specifieke opties en argumenten biedt veel fijnmazigere controle dan een GUI.

### De Opbouw van de Terminal Prompt
Wanneer je een terminal opent (bijv. via rechtsklik op het bureaublad → *Open Terminal Here*), zie je een prompt zoals `cybrary@linux:~/Desktop$` of `cybrary@ip-10-191-20-113:~/Desktop$`. Elk onderdeel heeft een vaste betekenis:
* `cybrary`: De gebruikersnaam waarmee je bent ingelogd.
* `@`: Scheidingsteken ("at").
* `linux` of `ip-10-[...]`: De **hostnaam** van de machine.
* `:`: Scheidingsteken vóór het pad.
* `~/Desktop`: De huidige werkmap. De tilde (`~`) staat voor de home-directory van de gebruiker (`/home/cybrary`), dus `~/Desktop` betekent `/home/cybrary/Desktop`. Wanneer je naar de root gaat, verandert dit in `/`.
* `$`: Geeft aan dat je werkt als een **reguliere (non-root) gebruiker**.
* **[Aanvullend]:** Een `#` aan het einde van de prompt (in plaats van `$`) geeft aan dat je werkt met `root`-rechten.

### Verborgen Bestanden & Bestandsextensies
* **Verborgen puntbestanden:** Bestanden die beginnen met een punt (`.`), zoals `.bashrc`, `.bash_history`, `.profile` en `.gnupg`, worden standaard niet getoond bij `ls`. Ze bevatten terminalinstellingen, shell-configuraties en commandogeschiedenis, en zijn verborgen om onbedoelde wijzigingen te voorkomen en mapoverzichten schoon te houden.
* **Geen verplichte extensies:** Linux kijkt niet naar bestandsextensies om te bepalen hoe een bestand moet worden uitgevoerd of geopend. Extensies zoals `.txt` of `.sh` zijn puur een beleefdheidsconventie voor menselijke gebruikers.

---

## 3. Praktijkscenario's & Stappenplannen

### Scenario 1: Initiële Systeemverkenning & Identiteitscontrole op een Onbekende Linux-host
Wanneer je als beheerder of SOC-analist inlogt op een Linux-server (of een shell krijgt tijdens een onderzoek), kun je niet altijd vertrouwen op de terminalprompt. Volg dit stappenplan om je context veilig vast te stellen:

1. **Verifieer je gebruikersaccount en rechtenniveau:**
   ```bash
   whoami
   id
   ```
   * *Aandachtspunt:* Controleer of je UID `1000` of hoger hebt (standaardgebruiker) of UID `0` (`root`), en kijk of je lid bent van beheerdersgroepen zoals `sudo` (Debian/Ubuntu) of `wheel` (Arch).
2. **Controleer de hostnaam en je startlocatie:**
   ```bash
   hostname
   pwd
   ```
3. **Inspecteer de huidige map inclusief verborgen configuratie- en geschiedenisbestanden:**
   ```bash
   ls -la
   ```
   * **[Aanvullend] Valkuil:** Als je alleen `ls` gebruikt, mis je kritieke bestanden zoals `.bash_history` of `.ssh`, die voor een SOC-analist vaak de belangrijkste sporen van recente activiteit bevatten.

### Scenario 2: Bestandsmanipulatie, Organisatie & Veilig Opschonen
Een gestructureerde aanpak om werkbestanden aan te maken, te testen en zonder dataverlies te verplaatsen:

1. **Maak een geïsoleerde werkmap en testbestanden aan:**
   ```bash
   mkdir ~/labwork && cd ~/labwork
   touch file1.txt file2.txt file3.txt
   ```
2. **Schrijf inhoud weg met de juiste redirector:**
   ```bash
   echo "This is file 1" >> file1.txt
   ```
   * *Valkuil:* Gebruik `>>` om tekst toe te voegen. Een enkele `>` overschrijft het volledige doelbestand zonder waarschuwing.
3. **Controleer inhoud en werkelijk bestandstype:**
   ```bash
   cat file1.txt
   file file1.txt
   ```
4. **Organiseer in submappen en controleer recursief:**
   ```bash
   mkdir red blue green
   cp file1.txt blue/
   mv file2.txt green/
   mv file3.txt red/file3.txt
   ls -R
   ```
5. **Verwijder overbodige bestanden veilig:**
   ```bash
   rm -i file1.txt
   ```
   * *Valkuil:* Gebruik bij twijfel altijd `-i` (*interactive*), omdat `rm` bestanden permanent wist zonder prullenbak.

---

## 4. Aanvullende Bronnen & Referenties

* **Interne Commandoreferenties (SOC Analyst Map):**
  * Zie `BASH.md` voor het volledige, categorische overzicht van alle BASH-commando's, permutaties en distributieverschillen tussen Debian en Arch Linux.
  * Zie `CMD.md` en `PowerShell.md` voor de Windows-tegenhangers van deze bestands- en navigatiecommando's.
* **[Aanvullend] Officiële Documentatie & Hulpmiddelen:**
  * [GNU Bash Reference Manual](https://www.gnu.org/software/bash/manual/) — Officiële documentatie van de Bourne Again Shell.
  * [GNU Coreutils Manual](https://www.gnu.org/software/coreutils/manual/) — Documentatie voor basiscommando's zoals `ls`, `cp`, `mv`, `rm`, `cat`, `head`, `id` en `whoami`.
  * [Linux Filesystem Hierarchy Standard (FHS)](https://refspecs.linuxfoundation.org/FHS_3.0/fhs/index.html) — Uitleg over de standaard Linux-mappenstructuur onder `/` (`/bin`, `/etc`, `/var`, `/home`, `/tmp`).
  * [ArchWiki: General Recommendations](https://wiki.archlinux.org/title/General_recommendations) — Uitstekende referentie voor moderne Linux-systeembeheerpraktijken.