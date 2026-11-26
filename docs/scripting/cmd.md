---
outline: [2, 3]
---

# CMD Referentie <Badge type="info" text="Windows" />

Alle CMD-commando's uit de kennisbank, met parameters.

::: info Gerelateerd
Het PowerShell-equivalent van elk commando staat in de [PowerShell-referentie](/scripting/powershell). Voor Linux zie de [BASH-referentie](/scripting/bash).
:::

## Shell, identiteit & hulp

### cmd {#cmd-cmd}

Start een klassieke Windows Command Prompt (`cmd.exe`) sub-shell vanuit PowerShell of een ander venster.

<<< @/snippets/cmd/windows-cli-basics.bat#cli-cmd{cmd}

::: tip Tips & valkuilen
* Hoewel traditionele CMD-commando's ook in PowerShell werken, kan de PowerShell-interpreter soms afwijkend omgaan met aanhalingstekens of speciale tekens. Overschakelen naar `cmd` garandeert klassieke CMD-parsing.
* **Modernere mogelijkheden & OS-verschillen:** **PowerShell** (en **PowerShell 7 / `pwsh`**) is de moderne opvolger van CMD met object-georiënteerde pipelines. Op Linux (Debian/Ubuntu en Arch) is **BASH** (of **Fish** / **Zsh**) het equivalent.
:::

### whoami {#cmd-whoami}

Toont de gebruikersnaam en domein-/computernaam van het huidige actieve gebruikersaccount in het formaat `computernaam\gebruikersnaam` (of `domein\gebruikersnaam`).

<<< @/snippets/cmd/windows-cli-basics.bat#cli-whoami{cmd}

**Extra Parameters & OS-verschillen**

* `whoami /priv`: Toont de toegewezen Windows-beveiligingsprivileges (zoals `SeDebugPrivilege` of `SeImpersonatePrivilege`, cruciaal bij SOC-onderzoek en privilege escalation).
* `whoami /groups`: Toont alle groepslidmaatschappen en de integriteitslevel (*Mandatory Label*, zoals `High Mandatory Level` bij een Administrator-prompt).
* **Linux-equivalent (Debian & Arch):** `whoami` (print enkel de gebruikersnaam) en `id` (print UID, GID en groepen).

### runas {#cmd-runas}

Start een programma als een andere gebruiker.

| Parameter | Betekenis |
| :--- | :--- |
| `/user:<account>` | Account waaronder het programma draait, bijvoorbeeld `Administrator` of `DOMEIN\gebruiker`. |
| `/savecred` | Bewaart het wachtwoord in de Credential Manager. Gebruik dit niet op gedeelde systemen. |

<<< @/snippets/cmd/system.bat#runas{cmd}

### help {#cmd-help}

Toont de ingebouwde handleiding, syntaxis en beschikbare switches voor een specifiek CMD-commando.

<<< @/snippets/cmd/windows-cli-basics.bat#cli-help{cmd}

::: details Modernere Mogelijkheden & OS-verschillen
* **Windows CMD:** Je kunt ook `<commando> /?` gebruiken (bijv. `dir /?`), wat bij externe tools zoals `netstat` of `findstr` vaak werkt wanneer `help <commando>` ze niet kent.
* **Windows PowerShell:** `Get-Help <cmdlet> -Full` (bijv. `Get-Help Get-ChildItem -Full`).
* **Linux (Debian & Arch):** `man <commando>` of `<commando> --help`.
:::

### doskey /history {#cmd-doskey-history}

Toont de lijst met commando's die tijdens de huidige CMD-sessie zijn uitgevoerd.

<<< @/snippets/cmd/windows-cli-basics.bat#cli-doskey-history{cmd}

::: warning Let op
* In tegenstelling tot Linux (`history` / `~/.bash_history`) wordt `doskey /history` **gewist zodra het CMD-venster wordt gesloten**.
* **PowerShell** onthoudt de commandogeschiedenis wel tussen sessies en herstarts door via `PSReadLine` (op te vragen met `Get-History` of in het tekstbestand `(Get-PSReadlineOption).HistorySavePath`).
:::

## Navigatie & mappen

### cd {#cmd-cd}

*Change Directory*: wisselt van actieve werkmap of toont het huidige pad wanneer zonder argumenten uitgevoerd.

**Parameters & Omgevingsvariabelen**

* `%HOMEPATH%`: Windows-omgevingsvariabele die verwijst naar het pad van de persoonlijke gebruikersmap (bijv. `\Users\cybrary`).

<<< @/snippets/cmd/windows-cli-basics.bat#cli-cd{cmd}

::: tip Tips & valkuilen
* Windows-commando's en switches zijn doorgaans **niet hoofdlettergevoelig** (`CD` werkt hetzelfde als `cd`).
* Gebruik `cd /d D:\Mapnaam` (`/d` = **d**rive) wanneer je tegelijk van schijfletter en map wilt wisselen; zonder `/d` wisselt `cd` alleen de werkmap op die andere schijf zonder erheen te springen. In PowerShell gebruik je `Set-Location` (alias `cd ~` of `cd $HOME`).
:::

### dir {#cmd-dir}

*Directory*: toont een lijst van bestanden en submappen in de huidige of opgegeven map.

**Parameters & Opties (Switches)**

* `/S` (`S` = **S**ubdirectories): Toont recursief alle bestanden en mappen in de huidige map én alle onderliggende submappen.
* `/P` (`P` = **P**ause): Pauzeert de uitvoer per volledig scherm (druk op een willekeurige toets voor het volgende scherm, of `Ctrl + C` om af te breken).
* `/B` (`B` = **B**are format): Toont alleen de kale bestandspaden en bestandsnamen zonder kopteksten, datums of bestandsgroottes (ideaal om door te sturen via een pipe `|`).
* `*` (*Wildcard*): Vertegenwoordigt nul of meer willekeurige tekens (bijv. `apple*`).

<<< @/snippets/cmd/windows-cli-basics.bat#cli-dir{cmd}

**Extra Switches & Modernere Mogelijkheden**

* `/A` (`A` = **A**ttributes): Toont ook verborgen en systeembestanden (`dir /a`, equivalent van Linux `ls -la`).
* `/O:D` (`O` = **O**rder, `D` = **D**ate): Sorteert op datum (`dir /o:-d` voor nieuwste bovenaan).
* **PowerShell:** `Get-ChildItem -Force -Recurse` (aliassen `ls`, `dir`).
* **Linux (Debian & Arch):** `ls -la` en `ls -R`.

### tree {#cmd-tree}

Geeft de mappenstructuur van een pad visueel weer als boomdiagram.

<<< @/snippets/cmd/windows-cli-basics.bat#cli-tree{cmd}

**Extra Switches & OS-verschillen**

* `tree /f` (`f` = **f**iles): Toont naast de mappen ook alle bestanden binnen elke map.
* `tree /a` (`a` = **a**scii): Gebruikt standaard ASCII-tekens in plaats van grafische lijntekens (handig bij wegschrijven naar logbestanden).
* **Linux (Debian & Arch):** `tree` (installeren via `sudo apt install tree -y` op Debian/Ubuntu of `sudo pacman -S tree` op Arch).

### mkdir (of md) {#cmd-mkdir-of-md}

*Make Directory*: maakt één of meerdere nieuwe (geneste) mappen aan.

<<< @/snippets/cmd/windows-cli-basics.bat#cli-mkdir-of-md{cmd}

::: details OS-verschillen
* In tegenstelling tot Linux (waar `mkdir -p` vereist is voor geneste mappen), maakt Windows `mkdir` ontbrekende bovenliggende mappen automatisch aan.
:::

### dir /x & cd met spaties {#cmd-dir-x-cd-met-spaties}

* `dir /x`: Toont naast de reguliere bestands- en mapnamen ook de oude DOS-compatibele **8.3 korte namen** (bijv. `PROGRA~2` voor `Program Files (x86)`).
* `cd "<mapnaam met spaties>"`: Wisselt naar een map waarvan de naam spaties bevat door dubbele aanhalingstekens (`"..."`) te gebruiken.

**Parameters & Opties**

* `/x` (`x` = e**x**tended / 8.3 short names): Geeft de gegenereerde 8-tekens korte naam weer voor oudere applicaties en scripts.

<<< @/snippets/cmd/windows-file-system.bat#fs-dir-x-cd-met-spaties{cmd}

::: details Modernere Mogelijkheden (PowerShell & Linux)
* **Windows PowerShell:** `Set-Location "C:\Program Files (x86)"` (alias `cd`). PowerShell vult paden met spaties bij gebruik van de `Tab`-toets automatisch aan met aanhalingstekens.
* **Linux (Debian & Arch):** Gebruik aanhalingstekens (`cd "Mijn Map"`) of escape spaties met een backslash (`cd Mijn\ Map`).
:::

### echo %PATH%, cd %HOMEPATH% & sysdm {#cmd-echo-path-cd-homepath-sysdm}

* `echo %PATH%`: Toont alle mappen (gescheiden door puntkomma's `;`) waarin Windows automatisch zoekt naar uitvoerbare programma's en DLL's (gecombineerde Systeem- en Gebruikers-`PATH`).
* `cd %HOMEPATH%`: Navigeert naar de persoonlijke home-directory van de ingelogde gebruiker (bijv. `\Users\cybrary`, vergelijkbaar met `cd ~` in Linux).
* `sysdm` (of `sysdm.cpl`): Opent het venster *System Properties* om via *Advanced → Environment Variables* de gebruikers- en systeemomgevingsvariabelen (zoals `Path`) te beheren.

<<< @/snippets/cmd/windows-file-system.bat#fs-echo-path-cd-homepath-sysdm{cmd}

::: tip Tips & valkuilen
* `echo %PATH%` combineert zowel de **System Variables** als de **User Variables** van het ingelogde account in één lijst.
* **SOC-context (PATH Hijacking) & PowerShell-equivalent:**
  * **Security-valkuil:** Wanneer een map met schrijfrechten voor standaardgebruikers vóór `C:\Windows\System32` in `%PATH%` staat, kan een aanvaller een kwaadaardige binary met dezelfde naam als een systeemtool plaatsen (*Unquoted Service Path* of *PATH Hijacking*).
  * **PowerShell-equivalent:** `$env:PATH -split ';'` print elk zoekpad overzichtelijk op een eigen regel.
  * **Linux (Debian & Arch):** `echo $PATH` (gescheiden door dubbele punten `:`).
:::

## Bestanden & tekstverwerking

### echo, type & Output Redirection (>, >>) {#cmd-echo-type-output-redirection}

* `echo`: Print tekst naar het scherm of schrijft deze via redirection naar een bestand.
* `type`: Toont de inhoud van een tekstbestand in de terminal (Windows-equivalent van Linux `cat`).

**Operators**

* `>`: Overschrijft het doelbestand volledig met de uitvoer.
* `>>`: Voegt de uitvoer onderaan toe aan een bestaand doelbestand (*append*).

<<< @/snippets/cmd/windows-cli-basics.bat#cli-echo-type-output-redirection{cmd}

::: details Modernere Mogelijkheden
* **PowerShell:** `Get-Content` (alias `cat`) voor lezen, en `Set-Content` (`>`) / `Add-Content` (`>>`) voor schrijven.
:::

### copy, move & rename (of ren) {#cmd-copy-move-rename-of-ren}

* `copy`: Kopieert één of meer bestanden naar een andere locatie.
* `move`: Verplaatst bestanden naar een andere map (laat geen kopie achter).
* `rename`: Hernoemt een bestand of map binnen dezelfde locatie.

<<< @/snippets/cmd/windows-cli-basics.bat#cli-copy-move-rename-of-ren{cmd}

::: details Modernere Mogelijkheden
* Voor het kopiëren van volledige mappenstructuren gebruik je in CMD `xcopy /E /I` of het modernere `robocopy bron doel /E` (*Robust File Copy*). In PowerShell gebruik je `Copy-Item`, `Move-Item` en `Rename-Item`.
:::

### del (of erase) & rmdir (of rd) {#cmd-del-of-erase-rmdir-of-rd}

* `del` / `erase`: Verwijdert één of meerdere bestanden definitief (niet naar de Prullenbak).
* `rmdir` / `rd`: Verwijdert een map.

**Parameters & Opties**

* `/P` bij `del` (`P` = **P**rompt): Vraagt expliciet om bevestiging vóór verwijdering.
* `/S` bij `rmdir` (`S` = **S**ubdirectories): Verwijdert de opgegeven map inclusief alle submappen en bestanden.

<<< @/snippets/cmd/windows-cli-basics.bat#cli-del-of-erase-rmdir-of-rd{cmd}

::: warning Let op
* `rmdir` zonder `/s` weigert een map te verwijderen als deze niet leeg is.
* Bestanden die met `del` of `rmdir` worden verwijderd, gaan **niet** naar de Windows Prullenbak en zijn direct verdwenen.
* Voeg `/Q` (`Q` = **Q**uiet) toe aan `rmdir /s /q <map>` om zonder bevestigingsvraag te verwijderen (vergelijkbaar met Linux `rm -rf`). In PowerShell is het equivalent `Remove-Item -Recurse -Force`.
:::

### findstr & find {#cmd-findstr-find}

* `findstr`: Zoekt naar specifieke tekstpatronen in bestanden of gepipete uitvoer (Windows-equivalent van Linux `grep`).
* `find`: Ouder zoekcommando dat voornamelijk wordt gebruikt vanwege de ingebouwde regelteller (`/c`).

**Parameters & Opties**

* `/c` bij `find` (`c` = **c**ount): Telt het aantal regels dat overeenkomt met de opgegeven zoekstring (vergelijkbaar met `wc -l` in Linux).
* `/v` bij `find` (`v` = in**v**ert): Toont of telt alle regels die de opgegeven string **niet** bevatten (bijv. `find /c /v ""` telt alle niet-lege regels).

<<< @/snippets/cmd/windows-cli-basics.bat#cli-findstr-find{cmd}

::: tip Tips & valkuilen
* Hoewel de Windows CLI over het algemeen niet hoofdlettergevoelig is, is **`findstr` standaard wél hoofdlettergevoelig** (gebruik `findstr /i` voor hoofdletterongevoelig zoeken).
* **PowerShell-equivalent:** `Select-String -Path *.txt -Pattern "moo"` en `(Get-ChildItem -Recurse -Filter *apple*.txt).Count`.
:::

### Het hosts-bestand lezen {#cmd-het-hosts-bestand-lezen}

Leest het lokale Windows `hosts`-bestand om handmatige IP-naar-hostnaam-koppelingen te controleren.

<<< @/snippets/cmd/windows-file-system.bat#fs-type-c-windows-system32-drivers-etc-host{cmd}

::: tip Tips & valkuilen
* Regels die beginnen met `#` zijn commentaar en worden genegeerd. Actieve regels volgen het formaat `<IP-adres> <spatie/tab> <hostnaam>` (bijv. `10.10.10.10 www.happypuppy.com`).
* Het `hosts`-bestand heeft **voorrang op DNS**. Aanvallers passen dit bestand soms aan (*hosts file hijacking*) om gebruikers naar kwaadaardige servers te sturen wanneer zij een vertrouwde domeinnaam bezoeken.
* **OS-verschillen & PowerShell-equivalent:**
  * **Windows PowerShell:** `Get-Content C:\Windows\System32\drivers\etc\hosts`
  * **Linux (Debian & Arch):** `cat /etc/hosts`
:::

### certutil {#cmd-certutil}

Certificaat-hulpprogramma dat ook hashes berekent en Base64 codeert.

| Parameter | Betekenis |
| :--- | :--- |
| `-hashfile <bestand> <algoritme>` | Berekent een hash. Ondersteunde algoritmen: `MD5`, `SHA1`, `SHA256`. |
| `-encode <in> <uit>` | Codeert een bestand naar Base64. |
| `-decode <in> <uit>` | Decodeert Base64 terug naar het originele bestand. |

<<< @/snippets/cmd/processing.bat#certutil{cmd}

::: warning SOC-context
`certutil` is een *living off the land*-binary. Aanvallers gebruiken het om bestanden te downloaden en te decoderen, dus onverwacht gebruik in process-logs is verdacht.
:::

### python, py & ssh-keygen {#cmd-python}

Start Python-scripts en genereer key pairs.

| Parameter | Betekenis |
| :--- | :--- |
| `python <script>` / `py <script>` | Voert een script uit. `py` is de launcher die de juiste Python-versie kiest. |
| `ssh-keygen -t ed25519` | Genereert een modern Ed25519-key pair. `-t` kiest het sleuteltype. |

<<< @/snippets/cmd/processing.bat#script{cmd}

## Permissies & Alternate Data Streams

### icacls {#cmd-icacls}

Toont en wijzigt NTFS-rechten (ACL's) van bestanden en mappen.

| Parameter | Betekenis |
| :--- | :--- |
| `/t` | Verwerkt ook alle onderliggende mappen en bestanden. |
| `/grant "<groep>:<rechten>"` | Kent rechten toe, bijvoorbeeld `Leaders:(OI)(CI)M`. |
| `(OI)` / `(CI)` | *Object Inherit* en *Container Inherit*: overerving naar bestanden en naar submappen. |
| `M`, `F`, `R`, `W` | Modify, Full control, Read en Write. |
| `/inheritance:d` | Schakelt overerving uit en behoudt de overgenomen rechten als expliciete rechten. |
| `/remove "<account>"` | Verwijdert alle rechten van een account of groep. |

<<< @/snippets/cmd/access-control.bat#icacls{cmd}

### Alternate Data Streams (ADS) {#cmd-alternate-data-streams-ads}

Schrijft verborgen data naar een NTFS **Alternate Data Stream (ADS)** achter een regulier bestand en leest deze weer uit wanneer de naam van de stream bekend is.

<<< @/snippets/cmd/windows-file-system.bat#fs-echo-bestand-stream-type-bestand-stream{cmd}

::: tip Tips & valkuilen
* Een standaard `dir` en `type notasecret.txt` tonen **niet** dat er een verborgen stream aanwezig is en ook de weergegeven bestandsgrootte verandert niet.
* In CMD toont `dir /r` (`/r` = data st**r**eams) wel alle Alternate Data Streams van bestanden in een map.
:::

## Systeem, services & gebruikers

### systeminfo, tasklist, date & time {#cmd-systeminfo-tasklist-date-time}

* `systeminfo`: Toont uitgebreide systeemconfiguratie (OS-naam en -versie, BIOS, geheugen, processor en geïnstalleerde hotfixes/patches).
* `tasklist`: Toont alle momenteel actieve processen en hun PID's.
* `date /t` & `time /t`: Toont de huidige systeemdatum en -tijd (`/t` voorkomt dat Windows vraagt om een nieuwe datum/tijd in te voeren).

<<< @/snippets/cmd/windows-cli-basics.bat#cli-systeminfo-tasklist-date-time{cmd}

::: tip Switches & Modernere Mogelijkheden
* `/v` bij `tasklist` (`v` = **v**erbose): Toont extra details zoals de gebruikerscontext (`User Name`), status en venstertitel van elk proces.
* **PowerShell-equivalenten:** `Get-ComputerInfo`, `Get-Process` en `Get-Date`.
:::

### sc & more {#cmd-sc-more}

* `sc`: *Service Control*: bevraagt, start, stopt en beheert Windows-services en drivers.
* `more`: Pager die lange uitvoer pagina voor pagina toont (`Enter` = 1 regel, `Spatiebalk` = 1 pagina).

<<< @/snippets/cmd/windows-cli-basics.bat#cli-sc-more{cmd}

::: warning Let op
* `sc query` vereist de interne **servicenaam** (bijv. `wscsvc`) en werkt niet met de weergavenaam (*Display Name*, zoals `Security Center`).
* **PowerShell-equivalent:** `Get-Service` (bijv. `Get-Service -Name wscsvc` of `Get-Service -DisplayName "*Security Center*"`).
:::

### wmic service {#cmd-wmic-service}

*Windows Management Instrumentation Command*: bevraagt gedetailleerde WMI-eigenschappen van Windows-services vanaf de opdrachtregel, waaronder `PathName`, `StartMode` en `ProcessId`.

**Parameters & Clausules**

* `get <eigenschappen>`: Selecteert specifieke kolommen zoals `Name`, `DisplayName`, `PathName`, `StartMode`, `Started`, `StartName` en `ProcessId`.
* `where <conditie>`: Filtert resultaten op basis van een voorwaarde (bijv. `Started=True` of `Started=False`).

<<< @/snippets/cmd/windows-services.bat#svc-wmic-service{cmd}

::: tip Tips & valkuilen
* In de detectie-oneliner betekent `findstr /i /v """`: `/i` = hoofdletterongevoelig (*ignore case*), `/v` = in**v**ert match (sluit regels uit die aanhalingstekens bevatten).
* **Modernere mogelijkheden & OS-verschillen:**
  * **Windows (WMIC uitfasering):** Microsoft heeft `wmic.exe` in Windows 11 (24H2) en Windows Server 2025 uitgefaseerd en standaard verwijderd. Gebruik voortaan PowerShell **`Get-CimInstance Win32_Service`** (bijv. `Get-CimInstance Win32_Service | Select-Object Name, DisplayName, State, ProcessId, PathName`).
  * **Linux (Debian/Ubuntu & Arch):** Het equivalent van Windows Services zijn **systemd units/services**, beheerd met `systemctl` (bijv. `systemctl list-units --type=service`, `systemctl status sshd`, `sudo systemctl start/stop/restart <service>`).
:::

### net (share, user, localgroup, accounts) {#cmd-net-share-user-localgroup-accounts}

Het multifunctionele Windows-beheercommando voor gebruikersaccounts, lokale groepen, gedeelde mappen (*shares*) en wachtwoordbeleid.

<<< @/snippets/cmd/windows-cli-basics.bat#cli-net-share-user-localgroup-accounts{cmd}

::: tip Tips & valkuilen
* **Administratieve shares (`$`):** Shares die eindigen op een dollarteken (`C$`, `IPC$`, `ADMIN$`) zijn standaard verborgen shares voor extern systeembeheer.
* **Valkuil bij tellen met `find`:** `net user | find /c /v ""` geeft een onjuist aantal gebruikers omdat `find` ook de kop- en voettekstregels meetelt. Bij `net localgroup` werkt `find /c "*"` wel betrouwbaar omdat elke groepsregel met een `*` begint.
* **Modernere PowerShell-equivalenten:** `Get-SmbShare`, `(Get-LocalUser).Count`, `Get-LocalGroup` en `Get-LocalGroupMember -Group "Administrators"`.
:::

### services.msc & eventvwr.msc {#cmd-services-msc-eventvwr-msc}

* `services.msc`: Opent de grafische **Service Control Manager (SCM)** om services te starten, stoppen, pauzeren, hervatten, herstelacties (*Recovery*) en afhankelijkheden (*Dependencies*) in te stellen, of verbinding te maken met een externe computer (*Connect to another computer*).
* `eventvwr.msc`: Opent de **Windows Event Viewer** om service-activiteiten en foutmeldingen te controleren (bijv. onder *Windows Logs → Application*).

<<< @/snippets/ps/services.ps1#service-eventviewer{powershell}

::: details Modernere PowerShell-alternatieven
* Filter recente Application-logs van een specifieke bron zonder GUI: `Get-WinEvent -FilterHashtable @{LogName='Application'; ProviderName='SimpleService'} -MaxEvents 10`.
:::

### wevtutil {#cmd-wevtutil}

Bevraagt event logs vanaf de opdrachtregel.

| Parameter | Betekenis |
| :--- | :--- |
| `qe <logboek>` | *Query events*: leest gebeurtenissen uit een log zoals `Security`. |
| `/c:<aantal>` | Beperkt het aantal events. |
| `/rd:true` | Toont de nieuwste events eerst (*reverse direction*). |
| `/f:text` | Uitvoer als leesbare tekst in plaats van XML. |

<<< @/snippets/cmd/os-management.bat#eventlog{cmd}

### wbadmin {#cmd-wbadmin}

Maakt back-ups met Windows Server Backup.

| Parameter | Betekenis |
| :--- | :--- |
| `start backup` | Start een back-uptaak. |
| `-backupTarget:<schijf>` | Doelschijf voor de back-up. |
| `-include:<pad>` | Neemt specifieke mappen of volumes op. |
| `-allCritical` | Neemt alle voor herstel kritieke volumes op. |
| `-quiet` | Voert uit zonder bevestigingsvraag. |

<<< @/snippets/cmd/os-management.bat#backup{cmd}

### GUI- en forensische systeemtools {#cmd-gui-en-forensische-systeemtools}

* `regedit` (`regedit.exe`): Opent de Windows Registry Editor om sleutels, waarden en *hives* (zoals `HKEY_LOCAL_MACHINE\SECURITY`, `SOFTWARE`, `SYSTEM`) te bekijken.
* `eventvwr` (`eventvwr.exe`): Opent de Windows Event Viewer om binaire `.evtx`-logbestanden (`Application`, `Security`, `System`) te analyseren.
* `shell:startup` (via *Uitvoeren* / `Win + R`): Opent direct de persoonlijke opstartmap van de huidige gebruiker.
* `chntpw` **[Linux-tool voor offline Windows-herstel/forensics]**: Een Linux-hulpprogramma waarmee de Windows `SAM`-database offline kan worden uitgelezen of aangepast wanneer een Windows-schijf aan een Linux-systeem of bootdisk is gekoppeld.

::: details Modernere CLI-equivalenten (PowerShell)
* **Windows Registry:** `Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"` (inspecteert opstartitems in het register vanaf de CLI).
* **Windows Event Logs (`.evtx`):** `Get-WinEvent -LogName Security -MaxEvents 20` of `Get-WinEvent -Path .\Application.evtx` (leest `.evtx`-bestanden direct uit in PowerShell).
:::

### Triage commands {#cmd-triage}

Snelle controles op een systeem zonder PowerShell.

| Parameter | Betekenis |
| :--- | :--- |
| `schtasks /query /fo LIST /v` | Alle geplande taken. `/fo LIST` = lijstvorm, `/v` = verbose. |
| `reg query <sleutel>` | Leest een registersleutel, zoals de `Run`-sleutel voor autostart. |
| `netstat -b` | Toont het programma achter elke verbinding, vereist een verhoogde prompt. |
| `tasklist /svc` | Welke services draaien in elk proces, handig bij `svchost.exe`. |
| `whoami /all` | Gebruiker, groepen en privileges in één overzicht. |
| `net session` | Wie is via het netwerk aangemeld op dit systeem. |
| `net user <naam>` | Details van één account. |

<<< @/snippets/cmd/os-management.bat#triage{cmd}

## Netwerk

### ipconfig, for /L Ping Sweep, ping, nslookup & netstat {#cmd-ipconfig-for-l-ping-sweep-ping-nslookup}

* `ipconfig`: Toont IPv4/IPv6-adressen, subnetmaskers en default gateways.
* `for /L ... ping`: Voert een CLI-based *ping sweep* uit over een volledig `/24`-subnet om actieve hosts te ontdekken.
* `nslookup`: Bevraagt een DNS-server om domeinnamen naar IP-adressen om te zetten.
* `netstat -ant`: Toont actieve netwerkverbindingen en luisterende poorten.

**Parameters & Opties**

* `/L` bij `for` (`L` = **L**oop through numbers): Telt van startwaarde met stapgrootte naar eindwaarde, bijv. `(1,1,255)`.
* `-n 1` bij `ping` (`n` = **n**umber): Stuurt exact 1 ICMP-pakket.
* `-w 10` bij `ping` (`w` = **w**ait): Wacht maximaal 10 milliseconden op antwoord.
* `&&`: Voert het rechtercommando (`echo`) alleen uit als het linkercommando (`ping`) succesvol was.
* `-ant` bij `netstat`: `-a` = **a**ll connections/ports, `-n` = **n**umeric IP/ports, `-t` = offload state / TCP-verbindingen.

<<< @/snippets/cmd/windows-cli-basics.bat#cli-ipconfig-for-l-ping-sweep-ping-nslookup{cmd}

::: warning Let op
* **Valkuil (`> null` vs. `> nul`):** In Windows heet het virtuele null-apparaat **`nul`** (met één `l`). Als je `> null` typt, maakt Windows een gewoon tekstbestand genaamd `null` aan in je huidige map! Gebruik altijd `> nul`.
* **PowerShell-equivalenten:** `Resolve-DnsName www.moo.com -Server 8.8.8.8` (modern equivalent van `nslookup`) en `Get-NetTCPConnection` (modern equivalent van `netstat`).
:::

### tracert, netstat -ano & netsh {#cmd-netstat}

Aanvullende netwerkcommando's.

| Parameter | Betekenis |
| :--- | :--- |
| `tracert <host>` | Toont elke router (*hop*) naar de bestemming. |
| `netstat -ano` | `-a` alle verbindingen en poorten, `-n` numeriek, `-o` PID van het eigenaar-proces. |
| `netsh advfirewall firewall add rule` | Voegt een Windows Firewall-regel toe. `dir` = richting, `action` = allow of block, `protocol` en `localport` bepalen het verkeer. |

<<< @/snippets/cmd/network.bat#network-extra{cmd}

## Group Policy & Active Directory

### gpupdate {#cmd-gpupdate}

Dwingt een onmiddellijke vernieuwing (*refresh*) af van zowel de lokale als de Active Directory Group Policy-instellingen op de computer en voor de ingelogde gebruiker (zonder te hoeven wachten op de standaard achtergrondcyclus van 90 minuten).

**Parameters & Opties**

* `/force`: Past alle beleidsinstellingen opnieuw toe, ook de instellingen die sinds de laatste verversing niet zijn gewijzigd.

<<< @/snippets/ps/windows-group-policy.ps1#gpo-gpupdate{powershell}

::: tip Tips & valkuilen
* Bepaalde beleidsinstellingen — zoals software-installaties, mapomleidingen (*Folder Redirection*) of computer-opstartscripts — kunnen niet altijd direct op de achtergrond worden toegepast en vereisen een herstart of opnieuw aanmelden (*logoff/logon*).
* **Extra `gpupdate`-switches & PowerShell-equivalent:**
  * `gpupdate /target:computer /force` of `gpupdate /target:user /force`: Vernieuwt uitsluitend het computer- of gebruikersgedeelte.
  * **PowerShell-cmdlet:** `Invoke-GPUpdate -Force` (onderdeel van de `GroupPolicy`-module; kan met `-Computer "<hostnaam>"` ook op afstand op een domeincomputer worden uitgevoerd).
:::

### gpresult {#cmd-gpresult}

Genereert een **Resultant Set of Policy (RSoP)**-rapport op de opdrachtregel om te analyseren welke Group Policy Objects (GPO's) daadwerkelijk zijn toegepast, welke instellingen actief zijn en welke GPO heeft gewonnen bij een conflict.

**Parameters & Opties**

* `/Z` (`Z` = super-verbose): Toont alle gedetailleerde beleidsinstellingen (inclusief *Administrative Templates* en registerwaarden) die voor de gebruiker en computer gelden.
* `/R` (`R` = **R**esultant summary): Geeft een beknopt overzicht van toegepaste GPO's, groepslidmaatschappen en de laatst gebruikte Domain Controller.
* `/H <pad.html>` (`H` = **H**TML report): Exporteert een overzichtelijk, klikbaar RSoP-rapport naar een HTML-bestand (bijv. `gpresult /H C:\Temp\rsop.html`).

<<< @/snippets/ps/windows-group-policy.ps1#gpo-gpresult{powershell}

::: tip Tips & valkuilen
* Om in `gpresult /Z` ook de **Computer Configuration**-policies te kunnen zien, moet je het commando uitvoeren vanuit een verhoogde (**Administrator**) PowerShell- of CMD-sessie.
* **PowerShell-alternatief:** `Get-GPResultantSetOfPolicy -ReportType Html -Path "C:\Temp\rsop.html"`.
:::

### gpedit.msc & gpmc.msc {#cmd-gpedit-msc-gpmc-msc}

* `gpedit.msc`: Opent de **Local Group Policy Editor** om het lokale groepsbeleid op een individuele Windows-machine te bekijken en te configureren.
* `gpmc.msc`: Opent de **Group Policy Management Console (GPMC)** op een Domain Controller of beheerwerkstation om domeinbrede GPO's aan te maken, te koppelen (*linken*), te bewerken en te simuleren (*Group Policy Modeling* / *Group Policy Results*).

<<< @/snippets/cmd/windows-group-policy.bat#gpo-gpedit-msc-gpmc-msc{cmd}

::: details Linux- & Cloud-equivalenten (Debian/Ubuntu, Arch & Entra ID)
* **Cloud (Microsoft Entra ID / Intune):** In moderne cloud-only omgevingen wordt Group Policy vervangen door **Microsoft Intune Configuration Profiles** (MDM / CSP-policies) in combinatie met *Entra ID Conditional Access*.
* **Linux (Debian/Ubuntu & Arch):** Er bestaat geen native GPO-engine, maar centraal configuratiebeheer wordt uitgevoerd met **Configuration Management / IaC-tools** zoals **Ansible**, **Puppet** of **SaltStack**. Voor Linux-clients die aan een Active Directory-domein zijn gekoppeld, kunnen **SSSD (`sssd-ad`)** of **Ubuntu ADSys** een subset van AD Group Policies toepassen.
:::

### dsa.msc & servermanager {#cmd-dsa-msc-servermanager}

* `dsa.msc`: Opent **Active Directory Users and Computers (ADUC)** (via *Uitvoeren* / `Win + R` of de CLI) om grafisch OU's, gebruikers, computers en groepen te beheren.
* `servermanager`: Opent de **Windows Server Manager** om rollen en features (*Add Roles and Features*) toe te voegen en een server tot Domain Controller te promoveren.

<<< @/snippets/cmd/windows-active-directory.bat#ad-dsa-msc-servermanager{cmd}
