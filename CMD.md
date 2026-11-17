# CMD.md — Windows Command Prompt Referentie

Centraal naslagwerk voor alle Windows Command Prompt (`cmd.exe`) commando's, switches, permutaties en praktijkvoorbeelden uit de Cybrary SOC Analyst-modules, aangevuld met moderne equivalenten en OS-verschillen.

> **Legenda:** Reguliere items en voorbeelden zijn rechtstreeks afkomstig uit het cursusmateriaal. Extra switches, moderne opvolgers (zoals PowerShell-cmdlets of `robocopy`) en SOC-praktijktips zijn gemarkeerd met **[Aanvullend]**.

## Inhoudsopgave
1. [Shell-context, Identiteit & Hulp](#1-shell-context-identiteit--hulp)
2. [Navigatie, Mappenstructuur & Bestandsbeheer](#2-navigatie-mappenstructuur--bestandsbeheer)
3. [Bestandsinhoud, Zoeken, Tellen & Encoding](#3-bestandsinhoud-zoeken-tellen--encoding)
4. [Permissies, ACL's & Alternate Data Streams (ADS)](#4-permissies-acls--alternate-data-streams-ads)
5. [Systeembeheer, Services, Gebruikers & Back-up](#5-systeembeheer-services-gebruikers--back-up)
6. [Netwerkdiagnose, Discovery & Group Policy](#6-netwerkdiagnose-discovery--group-policy)
7. [GUI-beheerconsoles & Forensische Tools (CLI-starters)](#7-gui-beheerconsoles--forensische-tools-cli-starters)

---

## 1. Shell-context, Identiteit & Hulp

### `cmd`
* **Doel:** Start een klassieke Windows Command Prompt (`cmd.exe`) sub-shell vanuit PowerShell of een ander terminalvenster.
* **Praktijkgebruik:**
  ```cmd
  :: Start de klassieke Windows CLI vanuit een PowerShell-sessie
  cmd
  ```
* **Tips & Valkuilen:**
  * Hoewel traditionele CMD-commando's ook in PowerShell werken, gaat de PowerShell-interpreter soms anders om met aanhalingstekens en speciale tekens. Overschakelen naar `cmd` garandeert klassieke CMD-parsing.
  * **[Aanvullend] Modernere mogelijkheden & OS-verschillen:** **PowerShell** (en **PowerShell 7 / `pwsh`**) is de moderne object-georiënteerde opvolger op Windows. Op Linux (Debian/Ubuntu en Arch) is **BASH** (of **Zsh** / **Fish**) het equivalent.

### `whoami`
* **Doel:** Toont de computernaam/domeinnaam en gebruikersnaam van het huidige actieve account in het formaat `computernaam\gebruikersnaam` (of `domein\gebruikersnaam`).
* **Praktijkgebruik:**
  ```cmd
  :: Toon de huidige gebruikerscontext
  whoami
  ```
* **[Aanvullend] Extra Switches & OS-verschillen:**
  * `whoami /priv`: Toont toegewezen Windows-privileges (bijv. `SeDebugPrivilege`, `SeImpersonatePrivilege`).
  * `whoami /groups`: Toont groepslidmaatschappen en het *Mandatory Integrity Level* (zoals `High Mandatory Level` bij een Administrator-prompt).
  * **Linux (Debian & Arch):** `whoami` (enkel gebruikersnaam) en `id` (UID, GID en groepen).

### `runas`
* **Doel:** Voert een specifiek programma of een nieuwe opdrachtprompt uit onder de rechten van een ander lokaal of domeinaccount.
* **Parameters & Opties:**
  * `/user:<gebruiker>`: Specificeert het doelaccount (bijv. `Administrator` of `DOMEIN\gebruiker`).
* **Praktijkgebruik:**
  ```cmd
  :: Open een nieuwe Command Prompt als lokale Administrator
  runas /user:Administrator cmd
  ```
* **[Aanvullend] Modernere Mogelijkheden & OS-verschillen:**
  * **PowerShell:** `Start-Process cmd -Credential (Get-Credential)` of `Enter-PSSession -Credential`.
  * **Linux (Debian & Arch):** `sudo <commando>` of `su - <gebruiker>`.

### `help` & `/?`
* **Doel:** Toont de ingebouwde handleiding, syntaxis en switches van een CMD-commando.
* **Praktijkgebruik:**
  ```cmd
  :: Bekijk de documentatie van een ingebouwd CMD-commando
  help dir

  :: Gebruik /? voor externe CLI-hulpprogramma's (zoals netstat, findstr of icacls)
  findstr /?
  ```
* **[Aanvullend] OS-verschillen:**
  * **PowerShell:** `Get-Help <cmdlet> -Full`.
  * **Linux (Debian & Arch):** `man <commando>` of `<commando> --help`.

### `doskey /history`
* **Doel:** Toont alle uitgevoerde commando's binnen de huidige `cmd.exe`-sessie.
* **Praktijkgebruik:**
  ```cmd
  :: Bekijk de commandogeschiedenis van het huidige CMD-venster
  doskey /history
  ```
* **Valkuilen & OS-verschillen:**
  * In tegenstelling tot Linux (`history` / `~/.bash_history`) wordt `doskey /history` gewist zodra het CMD-venster sluit.
  * **[Aanvullend] PowerShell:** Bewaart geschiedenis persistent via `PSReadLine` (`Get-History` of `(Get-PSReadlineOption).HistorySavePath`).

---

## 2. Navigatie, Mappenstructuur & Bestandsbeheer

### `cd` (of `chdir`), `mkdir` (of `md`) & `rmdir` (of `rd`)
* **Doel:**
  * `cd`: *Change Directory* — wisselt van actieve werkmap (ondersteunt `..` voor bovenliggende map en `\` voor root).
  * `mkdir`: *Make Directory* — maakt één of meerdere nieuwe mappen aan.
  * `rmdir`: *Remove Directory* — verwijdert een map.
* **Parameters & Opties:**
  * `/d` bij `cd` **[Aanvullend]** (`d` = **d**rive): Wisselt tegelijk van schijfletter en map (bijv. `cd /d D:\Data`).
  * `/S` bij `rmdir` (`S` = **S**ubdirectories): Verwijdert de map inclusief alle submappen en bestanden.
  * `/Q` bij `rmdir` **[Aanvullend]** (`Q` = **Q**uiet): Voert `/S` uit zonder bevestigingsvraag.
* **Praktijkgebruik & Permutaties:**
  ```cmd
  :: Navigeer naar de persoonlijke home-directory via omgevingsvariabele
  cd %HOMEPATH%

  :: Maak een nieuwe map en een geneste submap aan
  mkdir C:\Labwork
  mkdir "C:\Program Files\my service"

  :: Verwijder een map inclusief alle onderliggende submappen en bestanden
  rmdir /S C:\Labwork
  ```
* **[Aanvullend] PowerShell & Linux Equivalenten:**
  * **PowerShell:** `Set-Location` (`cd`), `New-Item -ItemType Directory` (`mkdir`), `Remove-Item -Recurse -Force` (`rm -r`).
  * **Linux:** `cd`, `mkdir -p` en `rm -rf`.

### `dir` & `tree`
* **Doel:**
  * `dir`: *Directory* — toont bestanden en submappen in de huidige of opgegeven locatie.
  * `tree`: Toont de mappenstructuur visueel als boomdiagram.
* **Parameters & Opties:**
  * `/S` bij `dir` (`S` = **S**ubdirectories): Doorzoekt recursief alle submappen.
  * `/P` bij `dir` (`P` = **P**ause): Pauzeert de uitvoer per scherm.
  * `/B` bij `dir` (`B` = **B**are format): Toont uitsluitend kale bestandspaden zonder kopteksten of metadata (ideaal voor piping naar `findstr`).
  * `/X` bij `dir` (`X` = e**X**tended / 8.3 short names): Toont naast de lange bestandsnaam ook de oude MS-DOS 8.3 korte bestandsnaam (bijv. `PROGRA~1`).
  * `/R` bij `dir` **[Aanvullend]** (`R` = st**R**eams): Toont verborgen NTFS *Alternate Data Streams (ADS)*.
  * `/A` bij `dir` **[Aanvullend]** (`A` = **A**ttributes): Toont ook verborgen en systeembestanden (`dir /a`).
  * `/F` bij `tree` (`F` = **F**iles): Toont naast de mappen ook alle individuele bestanden in de boomstructuur.
* **Praktijkgebruik & Permutaties:**
  ```cmd
  :: Toon recursief alle submappen en pauzeer per scherm
  dir /S /P

  :: Genereer een kale lijst van alle volledige bestandspaden voor piping
  dir /s /b

  :: Bekijk de 8.3 korte bestandsnamen in de root van C:\
  dir /x C:\

  :: Toon de volledige mappen- en bestandsstructuur van een projectmap
  tree Hall_of_Justice /F
  ```
* **[Aanvullend] PowerShell & Linux Equivalenten:**
  * **PowerShell:** `Get-ChildItem -Force -Recurse` (`ls`, `dir`).
  * **Linux:** `ls -la`, `ls -R` en `tree -a`.

### `copy`, `move`, `rename` (of `ren`) & `del` (of `erase`)
* **Doel:**
  * `copy`: Kopieert bestanden naar een andere locatie.
  * `move`: Verplaatst bestanden (of mappen) naar een nieuwe locatie.
  * `rename`: Hernoemt een bestand of map op dezelfde locatie.
  * `del`: Verwijdert één of meerdere bestanden definitief (buiten de Prullenbak om).
* **Parameters & Opties:**
  * `/P` bij `del` (`P` = **P**rompt): Vraagt voor elk bestand om bevestiging (`Y/N`).
  * `/F` bij `del` **[Aanvullend]** (`F` = **F**orce): Dwingt verwijdering van alleen-lezen (*read-only*) bestanden af.
* **Praktijkgebruik & Permutaties:**
  ```cmd
  :: Kopieer een bestand naar een andere map of onder een nieuwe naam
  copy apple1\cow.txt apple2\notacow.txt

  :: Hernoem een bestand
  rename apple2\notacow.txt reallyacow.txt

  :: Verplaats een bestand naar een andere directory
  move apple3\manycows.txt apple2

  :: Verwijder een bestand met bevestigingsprompt
  del /P apple2\reallyacow.txt
  ```
* **[Aanvullend] Modernere Kopieertools & Equivalenten:**
  * Gebruik voor complete mappenstructuren in CMD `xcopy /E /I` of het modernere `robocopy <bron> <doel> /E` (*Robust File Copy*).
  * **PowerShell:** `Copy-Item`, `Move-Item`, `Rename-Item` en `Remove-Item`.

---

## 3. Bestandsinhoud, Zoeken, Tellen & Encoding

### `echo`, `type`, `more` & Redirection (`>`, `>>`, `|`)
* **Doel:**
  * `echo`: Print tekst naar de terminal of schrijft deze weg naar een bestand (ook gebruikt om omgevingsvariabelen zoals `%PATH%` uit te lezen).
  * `type`: Toont de volledige inhoud van een tekstbestand in de console.
  * `more`: Pager die lange uitvoer pagina voor pagina toont (`Enter` = 1 regel, `Spatiebalk` = 1 pagina).
* **Operators:**
  * `>`: Overschrijft het doelbestand volledig met de uitvoer.
  * `>>`: Voegt de uitvoer onderaan toe (*append*).
  * `|`: *Pipe* — stuurt de standaarduitvoer van het linkercommando door als invoer voor het rechtercommando.
* **Praktijkgebruik & Permutaties:**
  ```cmd
  :: Toon de actieve systeem- en gebruikers-PATH-variabelen
  echo %PATH%

  :: Schrijf tekst naar een nieuw bestand en voeg daarna extra tekst toe
  echo The cow says moo. > apple1\cow.txt
  type apple1\cow.txt >> apple3\manycows.txt

  :: Bekijk het lokale Windows hosts-bestand
  type C:\Windows\System32\drivers\etc\hosts

  :: Lees lange uitvoer pagina voor pagina
  sc query | more
  ```

### `findstr` & `find`
* **Doel:**
  * `findstr`: Zoekt naar specifieke tekstpatronen of reguliere expressies in bestanden of gepipete uitvoer (Windows-equivalent van Linux `grep`).
  * `find`: Ouder zoekcommando dat voornamelijk wordt gebruikt voor het tellen van regels (`/c`).
* **Parameters & Opties:**
  * `/i` bij `findstr` (`i` = **i**gnore case): Zoekt hoofdletterongevoelig (standaard zoekt `findstr` **wel** hoofdlettergevoelig!).
  * `/v` bij `findstr` & `find` (`v` = in**v**ert match): Toont of telt uitsluitend regels die de opgegeven zoekterm **niet** bevatten.
  * `/c` bij `find` (`c` = **c**ount): Telt het aantal regels dat de zoekstring bevat (vergelijkbaar met `wc -l` in Linux).
* **Praktijkgebruik & Permutaties:**
  ```cmd
  :: Zoek een woord in een specifiek bestand of in alle bestanden (*) in de huidige map
  findstr "moo" notacow.txt
  findstr /i "error" *.log

  :: Combineer dir met findstr via pipes en tel het resultaat met find /c
  dir /s /b | findstr apple | findstr .txt | find /c ".txt"

  :: Tel lokale groepen (elke regel begint met *) en verborgen shares ($)
  net localgroup | find /c "*"
  net share | find /c "$"
  ```
* **[Aanvullend] PowerShell-equivalent:** `Select-String -Path *.txt -Pattern "moo"` (standaard hoofdletterongevoelig).

### `certutil` (Hashing & Base64 Encoding/Decoding)
* **Doel:** Ingebouwd Windows-hulpprogramma voor certificaatbeheer dat door beheerders en SOC-analisten veelvuldig wordt gebruikt om cryptografische bestandshashes te berekenen en bestanden van/naar Base64 om te zetten.
* **Parameters & Opties:**
  * `-hashfile <bestand> <algoritme>`: Berekent de hashwaarde van een bestand (bijv. `SHA256`, `SHA512`, `MD5`).
  * `-encode <invoer> <uitvoer>`: Codeert een binair bestand naar Base64 ASCII-tekst.
  * `-decode <invoer> <uitvoer>`: Decodeert een Base64-tekstbestand terug naar binair.
* **Praktijkgebruik & Permutaties:**
  ```cmd
  :: Bereken de SHA-256 (of MD5) hash van een verdacht uitvoerbaar bestand
  certutil -hashfile happypuppy.exe SHA256
  certutil -hashfile happypuppy.exe MD5

  :: Codeer en decodeer bestanden via Base64
  certutil -encode message.enc message.base64
  certutil -decode message.base64 message.enc
  ```
* **Tips & Security Context:**
  * **[Aanvullend] LOLBin-waarschuwing:** Omdat `certutil.exe` standaard op elke Windows-machine staat en ook bestanden van internet kan downloaden (`-urlcache`), wordt het regelmatig misbruikt door aanvallers (*Living off the Land*). In PowerShell is `Get-FileHash` het schonere equivalent voor hashing.

### `python` / `py` & `ssh-keygen`
* **Doel:**
  * `python` / `py`: Start de Python-interpreter of voert een Python-script uit (bijv. voor cryptografie- of automatiseringstaken).
  * `ssh-keygen` **[Aanvullend]**: Genereert moderne asymmetrische SSH-sleutelparen (standaard ingebouwd in Windows 10/11 en Windows Server 2019+).
* **Praktijkgebruik:**
  ```cmd
  :: Start een Python-script op Windows
  python caesar.py
  py caesar.py

  :: [Aanvullend] Genereer een modern Ed25519 asymmetrisch sleutelpaar
  ssh-keygen -t ed25519
  ```

---

## 4. Permissies, ACL's & Alternate Data Streams (ADS)

### `icacls`
* **Doel:** *Integrity Control Access Control List* — inspecteert, wijzigt, kopieert of herstelt NTFS Access Control Lists (ACL's) en overervingsinstellingen (*inheritance*) op mappen en bestanden.
* **Parameters, Switches & Permissiecodes:**
  * `/t` (`t` = **t**raverse / recursive): Past de weergave of wijziging recursief toe op alle submappen en bestanden.
  * `/grant "<groep/gebruiker>:<rechten>"` **[Aanvullend]**: Voegt een nieuwe *Allow*-ACE toe aan de ACL.
  * `/remove "<groep/gebruiker>"` **[Aanvullend]**: Verwijdert alle ACE's voor een specifieke gebruiker of groep (bijv. `BUILTIN\Users`).
  * `/inheritance:d` **[Aanvullend]** (`d` = **d**isable & copy): Schakelt overerving uit en zet geërfde regels om naar expliciete regels (`r` = **r**emove all inherited, `e` = **e**nable).
  * **Permissiecodes in uitvoer:**
    * `(F)`: **F**ull Control (volledig beheer)
    * `(M)`: **M**odify (lezen, schrijven, uitvoeren, wijzigen en verwijderen)
    * `(RX)`: **R**ead & e**X**ecute
    * `(R)`: **R**ead-only
    * `(W)`: **W**rite-only
  * **Overervingsvlaggen (*Inheritance flags*):**
    * `(I)`: **I**nherited (overgenomen van bovenliggende map)
    * `(OI)`: **O**bject **I**nherit (bestanden in deze map erven dit recht)
    * `(CI)`: **C**ontainer **I**nherit (submappen erven dit recht)
    * `(IO)`: **I**nherit **O**nly (geldt alleen voor onderliggende objecten, niet voor de map zelf)
* **Praktijkgebruik & Permutaties:**
  ```cmd
  :: Toon de ACL (alle ACE's) van een specifieke map
  icacls Hall_of_Justice

  :: Toon recursief alle ACL's van alle onderliggende submappen en bestanden
  icacls Hall_of_Justice /t

  :: [Aanvullend] Geef groep 'Leaders' Modify-rechten met overerving op submappen en bestanden
  icacls C:\Leadership /grant "Leaders:(OI)(CI)M"

  :: [Aanvullend] Schakel overerving uit met behoud van rechten en verwijder BUILTIN\Users
  icacls C:\Leadership /inheritance:d
  icacls C:\Leadership /remove "BUILTIN\Users"
  ```
* **[Aanvullend] PowerShell & Linux Equivalenten:**
  * **PowerShell:** `Get-Acl` en `Set-Acl`.
  * **Linux:** `chmod`, `chown` en `getfacl` / `setfacl`.

### NTFS Alternate Data Streams (ADS) via `echo`, `type` & `more`
* **Doel:** Maakt verborgen datastromen (*Alternate Data Streams*) aan achter een regulier NTFS-bestand (`bestandsnaam:streamnaam`) en leest deze weer uit.
* **Praktijkgebruik & Permutaties:**
  ```cmd
  :: Schrijf verborgen data naar een Alternate Data Stream achter notasecret.txt
  echo "Verborgen boodschap" > notasecret.txt:secret

  :: Lees de inhoud van de Alternate Data Stream uit
  more < notasecret.txt:secret

  :: [Aanvullend] Toon alle Alternate Data Streams in de huidige map met dir /r
  dir /r
  ```
* **Tips & Valkuilen:**
  * De zichtbare bestandsgrootte van het hoofdbestand (`notasecret.txt`) verandert **niet** wanneer je data in een ADS schrijft.
  * **[Aanvullend] PowerShell-equivalent:** `Get-Item .\notasecret.txt -Stream *` en `Get-Content .\notasecret.txt -Stream secret`.

---

## 5. Systeembeheer, Services, Gebruikers & Back-up

### `systeminfo`, `tasklist`, `date /t` & `time /t`
* **Doel:**
  * `systeminfo`: Toont uitgebreide systeemconfiguratie (OS-versie, installatiedatum, uptime, geheugen, netwerkkaarten en geïnstalleerde hotfixes).
  * `tasklist`: Toont alle actief draaiende processen en hun Process ID (`PID`).
  * `date /t` & `time /t`: Toont de huidige systeemdatum en -tijd (`/t` voorkomt een interactieve prompt om de tijd te wijzigen).
* **Parameters & Opties:**
  * `/v` bij `tasklist` (`v` = **v**erbose): Toont ook de gebruikerscontext (`User Name`), processtatus en venstertitel.
* **Praktijkgebruik:**
  ```cmd
  systeminfo
  tasklist
  tasklist /v
  date /t
  time /t
  ```
* **[Aanvullend] PowerShell-equivalenten:** `Get-ComputerInfo`, `Get-Process` en `Get-Date`.

### `sc` & `wmic service`
* **Doel:**
  * `sc`: *Service Control* — bevraagt, configureert, start en stopt Windows-services.
  * `wmic service`: *Windows Management Instrumentation Command* — bevraagt uitgebreide service-eigenschappen (`Name`, `DisplayName`, `PathName`, `StartMode`, `Started`, `ProcessId`).
* **Parameters & Opties:**
  * `query` bij `sc`: Toont de actuele status (`RUNNING`, `STOPPED`, `PAUSED`) van alle services of van één specifieke service (via de interne **servicenaam**, niet de weergavenaam).
  * `qc` bij `sc` **[Aanvullend]** (*Query Config*): Toont het geconfigureerde uitvoerbare pad (`BINARY_PATH_NAME`), opstarttype en serviceaccount (`SERVICE_START_NAME`).
  * `get <kolommen>` & `where <conditie>` bij `wmic service`: Selecteert en filtert service-eigenschappen.
* **Praktijkgebruik & Permutaties:**
  ```cmd
  :: Bekijk alle actieve services pagina voor pagina
  sc query | more

  :: Controleer de status en configuratie van een specifieke service (interne naam)
  sc query wscsvc
  sc qc wscsvc

  :: Toon naam, weergavenaam, status, PID en uitvoerbaar pad via WMIC
  wmic service get name,displayname,started,processid,pathname

  :: Filter op actief draaiende of niet-draaiende services
  wmic service where Started=True get name,pathname
  wmic service where Started=False get name,pathname

  :: Detecteer kwetsbare Unquoted Service Paths (Auto-start, buiten C:\Windows, zonder quotes)
  wmic service get name,pathname,startmode | findstr /i "auto" | findstr /i /v "c:\windows\\" | findstr /i /v """
  ```
* **Tips, Valkuilen & Modernere Mogelijkheden:**
  * **[Aanvullend] WMIC uitfasering:** Microsoft heeft `wmic.exe` in Windows 11 (24H2) en Windows Server 2025 verwijderd. Gebruik voortaan PowerShell `Get-CimInstance Win32_Service` (of `sc qc <naam>` in CMD).
  * **[Aanvullend] Linux-equivalent:** `systemctl list-units --type=service` en `systemctl status <service>`.

### `net` (`user`, `localgroup`, `share`, `accounts`)
* **Doel:** Multifunctioneel Windows-beheercommando voor lokale gebruikers, groepen, SMB-netwerkshares en wachtwoordbeleid.
* **Praktijkgebruik & Permutaties:**
  ```cmd
  :: Toon alle lokale gebruikersaccounts (of bekijk help met: net help user)
  net user

  :: Toon alle lokale groepen of inspecteer de leden van een specifieke groep
  net localgroup
  net localgroup Leaders

  :: Toon alle gedeelde mappen, inclusief verborgen administratieve shares (C$, IPC$, ADMIN$)
  net share

  :: Bekijk het lokale wachtwoord- en accountvergrendelingsbeleid
  net accounts
  ```
* **[Aanvullend] PowerShell-equivalenten:** `Get-LocalUser`, `Get-LocalGroup`, `Get-LocalGroupMember` en `Get-SmbShare`.

### `wbadmin` (Windows Server Backup)
* **Doel:** Voert vanaf de opdrachtregel back-up- en hersteltaken uit op Windows Server (vereist dat de feature `Windows-Server-Backup` is geïnstalleerd).
* **Parameters & Opties:**
  * `start backup`: Start een directe eenmalige back-up (*one-time backup*).
  * `-backupTarget:<volume>`: Specificeert het doelvolume (bijv. `D:`).
  * `-include:<pad>`: Specificeert welke mappen of bestanden geback-upt moeten worden (bijv. `C:\Sales`).
  * `-quiet` **[Aanvullend]**: Voert de back-up uit zonder interactieve `Y/N`-bevestiging.
  * `-allCritical` **[Aanvullend]**: Neemt alle kritieke systeemvolumes mee voor een volledige *Bare Metal Recovery*.
* **Praktijkgebruik & Permutaties:**
  ```cmd
  :: Maak een eenmalige back-up van C:\Sales op de D:-schijf
  wbadmin start backup -backupTarget:D: -include:C:\Sales

  :: [Aanvullend] Maak een volledige kritieke systeemback-up zonder bevestigingsprompt
  wbadmin start backup -backupTarget:D: -allCritical -quiet
  ```

---

## 6. Netwerkdiagnose, Discovery & Group Policy

### `ipconfig`, `ping`, `tracert`, `nslookup`, `netstat` & `for /L` Ping Sweep
* **Doel:**
  * `ipconfig`: Toont IPv4/IPv6-adressen, subnetmaskers en default gateways (vernieuwt en leegt ook DHCP/DNS met `/release`, `/renew`, `/flushdns`).
  * `ping`: Test hostbereikbaarheid en latentie via ICMP Echo Requests.
  * `tracert`: Traceert het routeringspad (*hops*) naar een doelhost.
  * `nslookup`: Bevraagt DNS-servers voor naam-naar-IP- en IP-naar-naam-resolutie.
  * `netstat`: Toont actieve netwerkverbindingen, luisterende poorten en routeringstabellen.
  * `for /L ... ping`: Voert een native CMD *ping sweep* uit over een `/24`-subnet om actieve hosts te ontdekken.
* **Parameters & Opties:**
  * `/all` bij `ipconfig` **[Aanvullend]**: Toont MAC-adressen, DHCP-status, lease-tijden en geconfigureerde DNS-servers.
  * `-n <aantal>` bij `ping` (`n` = **n**umber): Verstuurt een exact aantal ICMP-pakketten (standaard 4 op Windows).
  * `-w <ms>` bij `ping` (`w` = **w**ait): Maximale wachttijd in milliseconden per antwoord.
  * `-ant` / `-ano` bij `netstat`: `-a` = **a**ll connections & listening ports, `-n` = **n**umeric IP's/poorten, `-o` **[Aanvullend]** = **o**wning Process ID (PID).
  * `/L` bij `for` (`L` = **L**oop through numbers): Telt van `(start,stap,eind)`.
* **Praktijkgebruik & Permutaties:**
  ```cmd
  :: Controleer lokale netwerkinstellingen, DNS-resolutie en route naar doelhost
  ipconfig /all
  nslookup google.com
  tracert 8.8.8.8

  :: Toon alle actieve verbindingen en poorten numeriek (plus PID met -ano)
  netstat -ant
  netstat -ano

  :: Voer een ping sweep uit over een volledig /24-subnet vanuit CMD
  for /L %a in (1,1,255) do @ping -n 1 -w 10 10.91.17.%a > nul && echo 10.91.17.%a is up!
  ```
* **[Aanvullend] Firewall-beheer in CMD (`netsh advfirewall`):**
  ```cmd
  :: Voeg een inkomende Windows Firewall-regel toe voor SSH (TCP 22)
  netsh advfirewall firewall add rule name="Allow SSH" dir=in action=allow protocol=TCP localport=22
  ```

### `gpupdate` & `gpresult` (Group Policy)
* **Doel:**
  * `gpupdate`: Dwingt onmiddellijke vernieuwing van lokale en Active Directory Group Policies af.
  * `gpresult`: Genereert een **Resultant Set of Policy (RSoP)**-rapport van alle toegepaste GPO's en winnende beleidsregels.
* **Parameters & Opties:**
  * `/force` bij `gpupdate`: Past alle beleidsregels opnieuw toe, ook ongewijzigde instellingen.
  * `/Z` bij `gpresult` (`Z` = super-verbose): Toont alle toegepaste beleidsdetails inclusief *Administrative Templates* (vereist Administrator-prompt voor Computer Policies).
  * `/R` bij `gpresult` **[Aanvullend]** (`R` = **R**esultant summary): Beknopt overzicht van toegepaste GPO's en groepslidmaatschappen.
  * `/H <pad.html>` bij `gpresult` **[Aanvullend]** (`H` = **H**TML): Exporteert een visueel RSoP-rapport naar HTML.
* **Praktijkgebruik:**
  ```cmd
  :: Forceer onmiddellijke verversing van alle Group Policies
  gpupdate /force

  :: Genereer een gedetailleerd RSoP-overzicht in de console of als HTML-rapport
  gpresult /Z
  gpresult /H C:\Temp\rsop.html
  ```

---

## 7. GUI-beheerconsoles & Forensische Tools (CLI-starters)

Onderstaande beheerconsoles kunnen rechtstreeks vanuit `cmd.exe`, PowerShell of *Uitvoeren* (`Win + R`) worden gestart:

| Commando | Doel & Geopende Console |
| :--- | :--- |
| `dsa.msc` | Opent **Active Directory Users and Computers (ADUC)** voor het beheren van OU's, gebruikers, groepen en computers. |
| `gpmc.msc` | Opent de **Group Policy Management Console (GPMC)** voor domein-GPO's, *Group Policy Results* en *Group Policy Modeling*. |
| `gpedit.msc` | Opent de **Local Group Policy Editor** voor lokaal groepsbeleid. |
| `services.msc` | Opent de grafische **Windows Services**-beheerconsole. |
| `eventvwr.msc` (of `eventvwr`) | Opent de **Windows Event Viewer** voor het analyseren van `.evtx`-logbestanden (*Application*, *Security*, *System*). |
| `wbadmin.msc` | Opent de **Windows Server Backup**-console (*Backup Schedule* & *Recovery Wizard*). |
| `sysdm.cpl` (of `sysdm`) | Opent **System Properties** (om via *Advanced → Environment Variables* de systeem-`Path` te beheren). |
| `regedit` | Opent de **Windows Registry Editor** om register-hives (`HKLM`, `HKCU`) en opstart-sleutels te inspecteren. |
| `control` | Opent het klassieke **Windows Configuratiescherm** (*Control Panel*). |