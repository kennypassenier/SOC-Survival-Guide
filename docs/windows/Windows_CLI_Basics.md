# Windows CLI Basics

## 1. Overzicht van Relevante Commando's

### A. Shell-context, Identiteit & Hulp

#### `cmd`
* **Doel:** Start een klassieke Windows Command Prompt (`cmd.exe`) sub-shell vanuit PowerShell of een ander venster.
* **Praktijkgebruik:**
  ```cmd
  :: Start de klassieke Windows CLI vanuit een PowerShell-sessie
  cmd
  ```
* **Tips, Valkuilen & Modernere Mogelijkheden:**
  * Hoewel traditionele CMD-commando's ook in PowerShell werken, kan de PowerShell-interpreter soms afwijkend omgaan met aanhalingstekens of speciale tekens. Overschakelen naar `cmd` garandeert klassieke CMD-parsing.
  * **[Aanvullend] Modernere mogelijkheden & OS-verschillen:** **PowerShell** (en **PowerShell 7 / `pwsh`**) is de moderne opvolger van CMD met object-georiënteerde pipelines. Op Linux (Debian/Ubuntu en Arch) is **BASH** (of **Fish** / **Zsh**) het equivalent.

#### `whoami`
* **Doel:** Toont de gebruikersnaam en domein-/computernaam van het huidige actieve gebruikersaccount in het formaat `computernaam\gebruikersnaam` (of `domein\gebruikersnaam`).
* **Praktijkgebruik:**
  ```cmd
  :: Toon de huidige gebruikerscontext (bijv. EC2AMAZ-MVQDHPB\cybrary)
  whoami
  ```
* **[Aanvullend] Extra Parameters & OS-verschillen:**
  * `whoami /priv`: Toont de toegewezen Windows-beveiligingsprivileges (zoals `SeDebugPrivilege` of `SeImpersonatePrivilege`, cruciaal bij SOC-onderzoek en privilege escalation).
  * `whoami /groups`: Toont alle groepslidmaatschappen en de integriteitslevel (*Mandatory Label*, zoals `High Mandatory Level` bij een Administrator-prompt).
  * **Linux-equivalent (Debian & Arch):** `whoami` (print enkel de gebruikersnaam) en `id` (print UID, GID en groepen).

#### `help`
* **Doel:** Toont de ingebouwde handleiding, syntaxis en beschikbare switches voor een specifiek CMD-commando.
* **Praktijkgebruik:**
  ```cmd
  :: Bekijk alle opties en switches van het dir-commando
  help dir
  ```
* **[Aanvullend] Modernere Mogelijkheden & OS-verschillen:**
  * **Windows CMD:** Je kunt ook `<commando> /?` gebruiken (bijv. `dir /?`), wat bij externe tools zoals `netstat` of `findstr` vaak werkt wanneer `help <commando>` ze niet kent.
  * **Windows PowerShell:** `Get-Help <cmdlet> -Full` (bijv. `Get-Help Get-ChildItem -Full`).
  * **Linux (Debian & Arch):** `man <commando>` of `<commando> --help`.

---

### B. Navigatie & Mappenstructuur

#### `cd`
* **Doel:** *Change Directory*: wisselt van actieve werkmap of toont het huidige pad wanneer zonder argumenten uitgevoerd.
* **Parameters & Omgevingsvariabelen:**
  * `%HOMEPATH%`: Windows-omgevingsvariabele die verwijst naar het pad van de persoonlijke gebruikersmap (bijv. `\Users\cybrary`).
* **Praktijkgebruik & Permutaties:**
  ```cmd
  :: Navigeer naar de home-directory van de ingelogde gebruiker (C:\Users\cybrary)
  cd %HOMEPATH%
  ```
* **Tips, Valkuilen & Modernere Mogelijkheden:**
  * Windows-commando's en switches zijn doorgaans **niet hoofdlettergevoelig** (`CD` werkt hetzelfde als `cd`).
  * **[Aanvullend]:** Gebruik `cd /d D:\Mapnaam` (`/d` = **d**rive) wanneer je tegelijk van schijfletter en map wilt wisselen; zonder `/d` wisselt `cd` alleen de werkmap op die andere schijf zonder erheen te springen. In PowerShell gebruik je `Set-Location` (alias `cd ~` of `cd $HOME`).

#### `dir`
* **Doel:** *Directory*: toont een lijst van bestanden en submappen in de huidige of opgegeven map.
* **Parameters & Opties (Switches):**
  * `/S` (`S` = **S**ubdirectories): Toont recursief alle bestanden en mappen in de huidige map én alle onderliggende submappen.
  * `/P` (`P` = **P**ause): Pauzeert de uitvoer per volledig scherm (druk op een willekeurige toets voor het volgende scherm, of `Ctrl + C` om af te breken).
  * `/B` (`B` = **B**are format): Toont alleen de kale bestandspaden en bestandsnamen zonder kopteksten, datums of bestandsgroottes (ideaal om door te sturen via een pipe `|`).
  * `*` (*Wildcard*): Vertegenwoordigt nul of meer willekeurige tekens (bijv. `apple*`).
* **Praktijkgebruik & Permutaties:**
  ```cmd
  :: Toon de inhoud van de huidige map
  dir

  :: Toon recursief alle submappen en pauzeer per scherm
  dir /S /P

  :: Filter op mappen of bestanden die beginnen met 'apple'
  dir apple*

  :: Geef een kale lijst van alle volledige paden (ideaal voor piping naar findstr)
  dir /s /b
  ```
* **[Aanvullend] Extra Switches & Modernere Mogelijkheden:**
  * `/A` (`A` = **A**ttributes): Toont ook verborgen en systeembestanden (`dir /a`, equivalent van Linux `ls -la`).
  * `/O:D` (`O` = **O**rder, `D` = **D**ate): Sorteert op datum (`dir /o:-d` voor nieuwste bovenaan).
  * **PowerShell:** `Get-ChildItem -Force -Recurse` (aliassen `ls`, `dir`).
  * **Linux (Debian & Arch):** `ls -la` en `ls -R`.

#### `tree`
* **Doel:** Geeft de mappenstructuur van een pad visueel weer als boomdiagram.
* **Praktijkgebruik:**
  ```cmd
  :: Toon de mappenstructuur onder de map 'one'
  tree one
  ```
* **[Aanvullend] Extra Switches & OS-verschillen:**
  * `tree /f` (`f` = **f**iles): Toont naast de mappen ook alle bestanden binnen elke map.
  * `tree /a` (`a` = **a**scii): Gebruikt standaard ASCII-tekens in plaats van grafische lijntekens (handig bij wegschrijven naar logbestanden).
  * **Linux (Debian & Arch):** `tree` (installeren via `sudo apt install tree -y` op Debian/Ubuntu of `sudo pacman -S tree` op Arch).

---

### C. Bestandsbeheer, Zoeken & Geschiedenis

#### `mkdir` (of `md`)
* **Doel:** *Make Directory*: maakt één of meerdere nieuwe (geneste) mappen aan.
* **Praktijkgebruik & Permutaties:**
  ```cmd
  :: Maak drie mappen tegelijk aan
  mkdir apple1 apple2 apple3

  :: Maak een geneste mappenstructuur in één keer aan (werkt in Windows zonder extra vlag)
  mkdir one\two\three
  ```
* **[Aanvullend] OS-verschillen:**
  * In tegenstelling tot Linux (waar `mkdir -p` vereist is voor geneste mappen), maakt Windows `mkdir` ontbrekende bovenliggende mappen automatisch aan.

#### `echo`, `type` & Output Redirection (`>`, `>>`)
* **Doel:**
  * `echo`: Print tekst naar het scherm of schrijft deze via redirection naar een bestand.
  * `type`: Toont de inhoud van een tekstbestand in de terminal (Windows-equivalent van Linux `cat`).
* **Operators:**
  * `>`: Overschrijft het doelbestand volledig met de uitvoer.
  * `>>`: Voegt de uitvoer onderaan toe aan een bestaand doelbestand (*append*).
* **Praktijkgebruik & Permutaties:**
  ```cmd
  :: Schrijf tekst naar een nieuw bestand (aanhalingstekens zijn niet verplicht in CMD)
  echo The cow says moo. > apple1\cow.txt

  :: Lees de inhoud van het bestand
  type apple1\cow.txt

  :: Voeg de inhoud van cow.txt onderaan toe aan manycows.txt
  type apple1\cow.txt >> apple3\manycows.txt
  ```
* **[Aanvullend] Modernere Mogelijkheden:**
  * **PowerShell:** `Get-Content` (alias `cat`) voor lezen, en `Set-Content` (`>`) / `Add-Content` (`>>`) voor schrijven.

#### `copy`, `move` & `rename` (of `ren`)
* **Doel:**
  * `copy`: Kopieert één of meer bestanden naar een andere locatie.
  * `move`: Verplaatst bestanden naar een andere map (laat geen kopie achter).
  * `rename`: Hernoemt een bestand of map binnen dezelfde locatie.
* **Praktijkgebruik & Permutaties:**
  ```cmd
  :: Kopieer een bestand onder een nieuwe naam
  copy apple1\cow.txt apple2\notacow.txt

  :: Hernoem een bestand
  rename apple2\notacow.txt reallyacow.txt

  :: Verplaats een bestand naar een andere map
  move apple3\manycows.txt apple2
  ```
* **[Aanvullend] Modernere Mogelijkheden:**
  * Voor het kopiëren van volledige mappenstructuren gebruik je in CMD `xcopy /E /I` of het modernere `robocopy bron doel /E` (*Robust File Copy*). In PowerShell gebruik je `Copy-Item`, `Move-Item` en `Rename-Item`.

#### `del` (of `erase`) & `rmdir` (of `rd`)
* **Doel:**
  * `del` / `erase`: Verwijdert één of meerdere bestanden definitief (niet naar de Prullenbak).
  * `rmdir` / `rd`: Verwijdert een map.
* **Parameters & Opties:**
  * `/P` bij `del` (`P` = **P**rompt): Vraagt expliciet om bevestiging vóór verwijdering.
  * `/S` bij `rmdir` (`S` = **S**ubdirectories): Verwijdert de opgegeven map inclusief alle submappen en bestanden.
* **Praktijkgebruik & Permutaties:**
  ```cmd
  :: Verwijder een bestand direct (zonder bevestiging)
  del apple2\manycows.txt

  :: Verwijder een bestand veilig met bevestigingsvraag
  del /p apple2\manycows.txt

  :: Verwijder een niet-lege map inclusief alle submappen
  rmdir /s one
  ```
* **Valkuilen & Aanvullende Switches:**
  * `rmdir` zonder `/s` weigert een map te verwijderen als deze niet leeg is.
  * Bestanden die met `del` of `rmdir` worden verwijderd, gaan **niet** naar de Windows Prullenbak en zijn direct verdwenen.
  * **[Aanvullend]:** Voeg `/Q` (`Q` = **Q**uiet) toe aan `rmdir /s /q <map>` om zonder bevestigingsvraag te verwijderen (vergelijkbaar met Linux `rm -rf`). In PowerShell is het equivalent `Remove-Item -Recurse -Force`.

#### `findstr` & `find`
* **Doel:**
  * `findstr`: Zoekt naar specifieke tekstpatronen in bestanden of gepipete uitvoer (Windows-equivalent van Linux `grep`).
  * `find`: Ouder zoekcommando dat voornamelijk wordt gebruikt vanwege de ingebouwde regelteller (`/c`).
* **Parameters & Opties:**
  * `/c` bij `find` (`c` = **c**ount): Telt het aantal regels dat overeenkomt met de opgegeven zoekstring (vergelijkbaar met `wc -l` in Linux).
  * `/v` bij `find` (`v` = in**v**ert): Toont of telt alle regels die de opgegeven string **niet** bevatten (bijv. `find /c /v ""` telt alle niet-lege regels).
* **Praktijkgebruik & Permutaties:**
  ```cmd
  :: Zoek een woord in een specifiek bestand of in alle bestanden (*) in de huidige map
  findstr "moo" notacow.txt
  findstr "keyword" *

  :: Combineer dir met findstr via pipes om paden te filteren
  dir /s /b | findstr apple | findstr .txt

  :: Tel het aantal gevonden .txt-bestanden met find /c
  dir /s /b | findstr apple | findstr .txt | find /c ".txt"
  ```
* **Tips, Valkuilen & Modernere Mogelijkheden:**
  * Hoewel de Windows CLI over het algemeen niet hoofdlettergevoelig is, is **`findstr` standaard wél hoofdlettergevoelig** (gebruik `findstr /i` voor hoofdletterongevoelig zoeken **[Aanvullend]**).
  * **[Aanvullend] PowerShell-equivalent:** `Select-String -Path *.txt -Pattern "moo"` en `(Get-ChildItem -Recurse -Filter *apple*.txt).Count`.

#### `doskey /history`
* **Doel:** Toont de lijst met commando's die tijdens de huidige CMD-sessie zijn uitgevoerd.
* **Praktijkgebruik:**
  ```cmd
  :: Bekijk de commandogeschiedenis van het huidige venster
  doskey /history
  ```
* **Valkuilen & OS-verschillen:**
  * In tegenstelling tot Linux (`history` / `~/.bash_history`) wordt `doskey /history` **gewist zodra het CMD-venster wordt gesloten**.
  * **PowerShell** onthoudt de commandogeschiedenis wel tussen sessies en herstarts door via `PSReadLine` (op te vragen met `Get-History` of in het tekstbestand `(Get-PSReadlineOption).HistorySavePath` **[Aanvullend]**).

---

### D. Systeembeheer, Services, Netwerk & Discovery

#### `systeminfo`, `tasklist`, `date` & `time`
* **Doel:**
  * `systeminfo`: Toont uitgebreide systeemconfiguratie (OS-naam en -versie, BIOS, geheugen, processor en geïnstalleerde hotfixes/patches).
  * `tasklist`: Toont alle momenteel actieve processen en hun PID's.
  * `date /t` & `time /t`: Toont de huidige systeemdatum en -tijd (`/t` voorkomt dat Windows vraagt om een nieuwe datum/tijd in te voeren).
* **Praktijkgebruik & Permutaties:**
  ```cmd
  systeminfo
  tasklist
  tasklist /v
  date /t
  time /t
  ```
* **[Aanvullend] Switches & Modernere Mogelijkheden:**
  * `/v` bij `tasklist` (`v` = **v**erbose): Toont extra details zoals de gebruikerscontext (`User Name`), status en venstertitel van elk proces.
  * **PowerShell-equivalenten:** `Get-ComputerInfo`, `Get-Process` en `Get-Date`.

#### `sc` & `more`
* **Doel:**
  * `sc`: *Service Control*: bevraagt, start, stopt en beheert Windows-services en stuurprogramma's.
  * `more`: Pager die lange uitvoer pagina voor pagina toont (`Enter` = 1 regel, `Spatiebalk` = 1 pagina).
* **Praktijkgebruik & Permutaties:**
  ```cmd
  :: Bekijk alle actieve services en drivers pagina voor pagina
  sc query | more

  :: Controleer de status van een specifieke service via de interne servicenaam (niet de weergavenaam)
  sc query wscsvc
  ```
* **Valkuilen & Modernere Mogelijkheden:**
  * `sc query` vereist de interne **servicenaam** (bijv. `wscsvc`) en werkt niet met de weergavenaam (*Display Name*, zoals `Security Center`).
  * **[Aanvullend] PowerShell-equivalent:** `Get-Service` (bijv. `Get-Service -Name wscsvc` of `Get-Service -DisplayName "*Security Center*"`).

#### `net` (`share`, `user`, `localgroup`, `accounts`)
* **Doel:** Het multifunctionele Windows-beheercommando voor gebruikersaccounts, lokale groepen, gedeelde mappen (*shares*) en wachtwoordbeleid.
* **Praktijkgebruik & Permutaties:**
  ```cmd
  :: Toon alle subcommando's van net
  net

  :: Toon alle gedeelde mappen, inclusief verborgen administratieve shares (C$, IPC$, ADMIN$)
  net share

  :: Toon alle lokale gebruikersaccounts (of bekijk help met: net help user)
  net user

  :: Toon alle lokale groepen (elke groepsnaam begint met een *)
  net localgroup

  :: Bekijk het ingestelde wachtwoord- en vergrendelingsbeleid
  net accounts

  :: Tel nauwkeurig het aantal lokale groepen en verborgen shares met find /c
  net localgroup | find /c "*"
  net share | find /c "$"
  ```
* **Tips, Valkuilen & Modernere Mogelijkheden:**
  * **Administratieve shares (`$`):** Shares die eindigen op een dollarteken (`C$`, `IPC$`, `ADMIN$`) zijn standaard verborgen shares voor extern systeembeheer.
  * **Valkuil bij tellen met `find`:** `net user | find /c /v ""` geeft een onjuist aantal gebruikers omdat `find` ook de kop- en voettekstregels meetelt. Bij `net localgroup` werkt `find /c "*"` wel betrouwbaar omdat elke groepsregel met een `*` begint.
  * **[Aanvullend] Modernere PowerShell-equivalenten:** `Get-SmbShare`, `(Get-LocalUser).Count`, `Get-LocalGroup` en `Get-LocalGroupMember -Group "Administrators"`.

#### `ipconfig`, `for /L` Ping Sweep, `ping`, `nslookup` & `netstat`
* **Doel:**
  * `ipconfig`: Toont IPv4/IPv6-adressen, subnetmaskers en default gateways.
  * `for /L ... ping`: Voert een CLI-based *ping sweep* uit over een volledig `/24`-subnet om actieve hosts te ontdekken.
  * `nslookup`: Bevraagt een DNS-server om domeinnamen naar IP-adressen om te zetten.
  * `netstat -ant`: Toont actieve netwerkverbindingen en luisterende poorten.
* **Parameters & Opties:**
  * `/L` bij `for` (`L` = **L**oop through numbers): Telt van startwaarde met stapgrootte naar eindwaarde, bijv. `(1,1,255)`.
  * `-n 1` bij `ping` (`n` = **n**umber): Stuurt exact 1 ICMP-pakket.
  * `-w 10` bij `ping` (`w` = **w**ait): Wacht maximaal 10 milliseconden op antwoord.
  * `&&`: Voert het rechtercommando (`echo`) alleen uit als het linkercommando (`ping`) succesvol was.
  * `-ant` bij `netstat`: `-a` = **a**ll connections/ports, `-n` = **n**umeric IP/ports, `-t` = offload state / TCP-verbindingen.
* **Praktijkgebruik & Permutaties:**
  ```cmd
  :: Bekijk IP-adres, subnetmasker en default gateway
  ipconfig

  :: Ping sweep over een volledig /24-subnet (vervang x.y.z door de eerste 3 octetten)
  for /L %a in (1,1,255) do @ping -n 1 -w 10 x.y.z.%a > nul && echo x.y.z.%a is up!

  :: Test externe connectiviteit en DNS-resolutie via Google DNS (8.8.8.8)
  ping 8.8.8.8
  nslookup [www.moo.com](https://www.moo.com) 8.8.8.8

  :: Bekijk actieve netwerkverbindingen en luisterende poorten
  netstat -ant
  ```
* **[Aanvullend] Valkuil in de Ping Sweep & Modernere Mogelijkheden:**
  * **Valkuil (`> null` vs. `> nul`):** In Windows heet het virtuele null-apparaat **`nul`** (met één `l`). Als je `> null` typt, maakt Windows een gewoon tekstbestand genaamd `null` aan in je huidige map! Gebruik altijd `> nul`.
  * **PowerShell-equivalenten:** `Resolve-DnsName www.moo.com -Server 8.8.8.8` (modern equivalent van `nslookup`) en `Get-NetTCPConnection` (modern equivalent van `netstat`).

---

## 2. Algemene Uitleg & Theorie

### Historie van Windows: Van PC-DOS naar PowerShell
* **1981 (PC-DOS / MS-DOS):** Microsoft ontwikkelde PC-DOS (*Disk Operating System*) als herwerking van *86-DOS* van Seattle Computer Products. Net als zijn voorganger CP/M was DOS volledig command-line-gestuurd zonder GUI of muisondersteuning.
* **1992 (Windows 3.1):** Introduceerde een grafische gebruikersinterface (GUI) met muis- en toetsenbordbediening, maar draaide nog steeds bovenop DOS als onderliggend besturingssysteem.
* **1995 (Windows 95):** De eerste Windows-versie die niet langer afhankelijk was van DOS als losstaand onderliggend OS, al bleef de DOS-opdrachtprompt behouden als standaard CLI.
* **Vandaag (PowerShell & CMD):** **PowerShell** heeft de klassieke Command Prompt grotendeels vervangen voor systeembeheer en automatisering. Toch blijft `cmd.exe` veelgebruikt voor snelle opdrachten, batchscripts en tijdens Red Team- of aanvalsanalyses waarbij ingebouwde systeemtools worden misbruikt (**"Living off the Land"** / LOLBins).

### Windows CLI vs. Linux CLI
* **Overeenkomsten:** Commando's zoals `cd`, `echo`, `more` en `mkdir` bestaan in beide werelden (al verschillen hun switches: Windows gebruikt meestal `/` zoals `/s`, terwijl Linux `-` of `--` gebruikt).
* **Windows-specifieke beheertools:** Hulpprogramma's zoals `net`, `tasklist` en `sc` zijn specifiek ontworpen voor de Windows-architectuur (services, lokale SAM-accounts en SMB-shares).
* **Hoofdlettergevoeligheid:** Bestandspaden en commando-switches in Windows zijn over het algemeen **niet hoofdlettergevoelig** (`dir /S /P` is gelijk aan `dir /s /p`), met enkele uitzonderingen zoals `findstr` (dat standaard wel hoofdlettergevoelig zoekt).

---

## 3. Praktijkscenario's & Stappenplannen

### Scenario 1: Bestanden Zoeken, Filteren & Tellen via Pipes in CMD
Wanneer je op een Windows-systeem snel specifieke bestanden in een diepe mappenstructuur wilt opsporen zonder Verkenner te gebruiken:

1. **Genereer een kale lijst van alle paden en submappen:**
   ```cmd
   dir /s /b
   ```
2. **Filter de uitvoer stapsgewijs met `findstr`:**
   ```cmd
   dir /s /b | findstr apple | findstr .txt
   ```
   * *Valkuil:* Vergeet niet dat `findstr` hoofdlettergevoelig is; gebruik `findstr /i` als bestandsnamen hoofdletters kunnen bevatten.
3. **Tel het aantal gevonden overeenkomsten met `find /c`:**
   ```cmd
   dir /s /b | findstr apple | findstr .txt | find /c ".txt"
   ```

### Scenario 2: Lokale Systeem- & Netwerkverkenning (Triage / Red Team "Living off the Land")
Een gestandaardiseerd overzicht om een Windows-host snel in kaart te brengen met uitsluitend ingebouwde CMD-tools:

1. **Controleer gebruikersidentiteit en systeemdetails:**
   ```cmd
   whoami
   systeminfo
   ```
2. **Inventariseer lokale gebruikers, groepen, wachtwoordbeleid en gedeelde mappen:**
   ```cmd
   net user
   net localgroup
   net accounts
   net share
   ```
   * *Aandachtspunt:* Let bij `net share` op standaard administratieve shares (`C$`, `IPC$`, `ADMIN$`) én eventuele niet-standaard shares die door beheerders zijn aangemaakt.
3. **Controleer actieve processen, services en netwerkverbindingen:**
   ```cmd
   tasklist /v
   sc query | more
   netstat -ant
   ```
4. **Voer lokale netwerkdiscovery uit op het actieve subnet:**
   ```cmd
   ipconfig
   for /L %a in (1,1,255) do @ping -n 1 -w 10 10.91.17.%a > nul && echo 10.91.17.%a is up!
   ```

---

## 4. Aanvullende Bronnen & Referenties

* **Interne Commandoreferenties (SOC Analyst Map):**
  * Zie `CMD.md` voor het volledige, categorische overzicht van alle Windows Command Prompt-commando's, switches en permutaties.
  * Zie `PowerShell.md` en `BASH.md` voor de moderne PowerShell-cmdlets en Linux-equivalenten.
* **[Aanvullend] Officiële Documentatie & Security Referenties:**
  * [Microsoft Learn: Windows Commands Reference](https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/windows-commands) — Officiële documentatie voor alle `cmd.exe`-commando's en switches.
  * [LOLBAS Project (Living Off The Land Binaries, Scripts and Libraries)](https://lolbas-project.github.io/) — Overzicht voor SOC-analisten van ingebouwde Windows-tools (`cmd.exe`, `certutil.exe`, `net.exe`, `sc.exe`) en hoe deze door aanvallers kunnen worden misbruikt.