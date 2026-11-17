# Windows Services

## 1. Overzicht van Relevante Commando's

### A. PowerShell Servicebeheer (`Get-Service`, `New-Service`, `Start-Service`, `Stop-Service`)

#### `Get-Service`
* **Doel:** Haalt de status, interne servicenaam (`Name`) en weergavenaam (`DisplayName`) op van alle of specifieke Windows-services.
* **Parameters & Opties:**
  * `-Name <servicenaam>`: Filtert op de interne servicenaam (bijv. `MyService` of `wuauserv`).
  * `Where-Object Status -EQ "Running"`: Filtert op uitsluitend actieve services (`-EQ` = **EQ**uals).
  * `Where-Object Status -NE "Running"`: Filtert op niet-actieve services zoals `Stopped`, `Paused` of `Starting` (`-NE` = **N**ot **E**quals).
  * `Select-Object -Property * | Format-Table` (kortweg `select -Property * | FT`): Toont alle beschikbare objecteigenschappen in tabelvorm.
* **Praktijkgebruik & Permutaties:**
  ```powershell
  # Toon alle Windows-services
  Get-Service

  # Filter op actief draaiende services
  Get-Service | Where-Object Status -EQ "Running"

  # Filter op services die momenteel niet draaien
  Get-Service | Where-Object Status -NE "Running"

  # Inspecteer een specifieke service op basis van de interne servicenaam
  Get-Service -Name MyService

  # Toon alle eigenschappen van alle services in tabelformaat
  Get-Service | select -Property * | FT
  ```
* **Tips, Valkuilen & Modernere Mogelijkheden:**
  * PowerShell gebruikt standaard de interne **servicenaam** (`wuauserv`, `spooler`, `MpsSvc`), niet de weergavenaam (`Windows Update`). Gebruik `-DisplayName` als je op de weergavenaam wilt zoeken.
  * `Get-Service` toont in standaard Windows PowerShell 5.1 niet direct het uitvoerbare pad (`BinaryPathName`).
  * **[Aanvullend] Modernere PowerShell-alternatieven voor Service-paden (zonder WMIC):**
    * In **PowerShell 7 (`pwsh`)** bevat `Get-Service` wél direct de eigenschap `BinaryPathName`: `Get-Service | Select-Object Name, StartType, BinaryPathName`.
    * In **alle Windows PowerShell-versies** is `Get-CimInstance Win32_Service` de moderne opvolger van `wmic service`:
```powershell
# Moderne vervanger van WMIC om ongequote servicepaden op te sporen
Get-CimInstance Win32_Service | Where-Object { $_.StartMode -eq 'Auto' -and $_.PathName -notlike 'C:\Windows\*' -and $_.PathName -notlike '"*"*' } | Select-Object Name, StartMode, PathName
```
    * **Windows CMD:** `sc qc <servicenaam>` (*Query Config*) toont direct het `BINARY_PATH_NAME` en de `SERVICE_START_NAME` van een specifieke service.

#### `New-Service`, `Start-Service` & `Stop-Service`
* **Doel:**
  * `New-Service`: Registreert een nieuwe Windows-service in het register en bij de Service Control Manager (SCM).
  * `Start-Service`: Start een gestopte service.
  * `Stop-Service`: Stopt een actieve service (waarmee de status wordt gewist en de service bij herstart "schoon" begint).
* **Parameters & Opties:**
  * `-Name <naam>`: Interne servicenaam.
  * `-BinaryPathName "<pad>"`: Het pad naar het uitvoerbare `.exe`-bestand van de service.
* **Praktijkgebruik & Permutaties:**
  ```powershell
  # Registreer een nieuwe service (let op: PowerShell plaatst de aanhalingstekens niet in het register)
  New-Service -Name MyService -BinaryPathName "C:\Program Files\my service\WindowsService1.exe"

  # Start, stop en controleer de service
  Start-Service -Name MyService
  Stop-Service -Name MyService
  Get-Service -Name MyService
  ```
* **Valkuilen & Aanvullende Cmdlets:**
  * Zelfs als je in PowerShell dubbele aanhalingstekens om `-BinaryPathName` zet, worden die aanhalingstekens **niet** opgeslagen in de `ImagePath`-waarde in het Windows-register (`HKLM\System\CurrentControlSet\Services\<Naam>`). Bevat het pad spaties, dan ontstaat er een **Unquoted Service Path**-kwetsbaarheid.
  * **[Aanvullend]:** Gebruik `Restart-Service -Name <naam>` om een service in één stap te herstarten, `Set-Service -Name <naam> -StartupType Disabled` om het opstarttype te wijzigen, en `Remove-Service -Name <naam>` (PowerShell 6+) of `sc.exe delete <naam>` om een service te verwijderen.

---

### B. WMIC & CMD-commando's voor Service-inspectie (`wmic`, `findstr`)

#### `wmic service`
* **Doel:** *Windows Management Instrumentation Command*: bevraagt gedetailleerde WMI-eigenschappen van Windows-services vanaf de opdrachtregel, waaronder `PathName`, `StartMode` en `ProcessId`.
* **Parameters & Clausules:**
  * `get <eigenschappen>`: Selecteert specifieke kolommen zoals `Name`, `DisplayName`, `PathName`, `StartMode`, `Started`, `StartName` en `ProcessId`.
  * `where <conditie>`: Filtert resultaten op basis van een voorwaarde (bijv. `Started=True` of `Started=False`).
* **Praktijkgebruik & Permutaties:**
  ```cmd
  :: Toon alle service-details pagina voor pagina
  wmic service | more

  :: Toon uitsluitend servicenaam en uitvoerbaar pad
  wmic service get name,pathname

  :: Filter op actief draaiende of niet-draaiende services
  wmic service where Started=True get name,pathname
  wmic service where Started=False get name,pathname

  :: Toon naam, weergavenaam, status, Process ID en pad (alleen actieve services hebben een PID)
  wmic service get name,displayname,started,processid,pathname

  :: Detecteer kwetsbare Unquoted Service Paths (automatisch startend, buiten C:\Windows, zonder quotes)
  wmic service get name,pathname,startmode | findstr /i "auto" | findstr /i /v "c:\windows\\" | findstr /i /v """
  ```
* **Tips, Valkuilen & Modernere Mogelijkheden:**
  * In de detectie-oneliner betekent `findstr /i /v """`: `/i` = hoofdletterongevoelig (*ignore case*), `/v` = in**v**ert match (sluit regels uit die aanhalingstekens bevatten).
  * **[Aanvullend] Modernere mogelijkheden & OS-verschillen:**
    * **Windows (WMIC uitfasering):** Microsoft heeft `wmic.exe` in Windows 11 (24H2) en Windows Server 2025 uitgefaseerd en standaard verwijderd. Gebruik voortaan PowerShell **`Get-CimInstance Win32_Service`** (bijv. `Get-CimInstance Win32_Service | Select-Object Name, DisplayName, State, ProcessId, PathName`).
    * **Linux (Debian/Ubuntu & Arch):** Het equivalent van Windows Services zijn **systemd units/services**, beheerd met `systemctl` (bijv. `systemctl list-units --type=service`, `systemctl status sshd`, `sudo systemctl start/stop/restart <service>`).

---

### C. GUI-beheer & Loganalyse (`services.msc`, `eventvwr.msc`)

#### `services.msc` & `eventvwr.msc`
* **Doel:**
  * `services.msc`: Opent de grafische **Service Control Manager (SCM)** om services te starten, stoppen, pauzeren, hervatten, herstelacties (*Recovery*) en afhankelijkheden (*Dependencies*) in te stellen, of verbinding te maken met een externe computer (*Connect to another computer*).
  * `eventvwr.msc`: Opent de **Windows Event Viewer** om service-activiteiten en foutmeldingen te controleren (bijv. onder *Windows Logs → Application*).
* **Praktijkgebruik:**
  ```powershell
  # Open de Event Viewer rechtstreeks vanuit PowerShell of CMD
  eventvwr.msc
  ```
* **[Aanvullend] Modernere PowerShell-alternatieven:**
  * Filter recente Application-logs van een specifieke bron zonder GUI: `Get-WinEvent -FilterHashtable @{LogName='Application'; ProviderName='SimpleService'} -MaxEvents 10`.

---

## 2. Algemene Uitleg & Theorie

### Architectuur & Werking van Windows Services
* **Wat is een Windows Service?** Een speciaal achtergrondprogramma dat zonder gebruikersinteractie draait. Services starten meestal automatisch bij het opstarten van het systeem, maar kunnen ook door een andere service of systeemgebeurtenis worden geactiveerd.
* **Session Zero-isolatie:** Services draaien in hun eigen geïsoleerde sessie (**Session Zero**), volledig gescheiden van de grafische gebruikerssessies (Session 1, 2, enz.) van ingelogde gebruikers.
* **Rechtencontext (*Log On As*):**
  * Veel standaardservices draaien onder het uiterst krachtige **Local System Account** (of *Local Service* / *Network Service*).
  * **Security Best Practice:** Maak voor maatwerkservices een apart serviceaccount aan volgens het principe van *"just enough privilege"* (*Principle of Least Privilege*).
* **Twee hoofdtypen services:**
  1. **`Win32OwnProcess`:** Een zelfstandig uitvoerbaar bestand (`.exe`) dat rechtstreeks door de **Service Control Manager (SCM)** wordt gestart en beheerd.
  2. **`Win32ShareProcess`:** Een service waarvan de code is ondergebracht in een **DLL** (*Dynamic Link Library*) en die samen met andere services wordt geladen binnen een gedeeld **Service Host (`svchost.exe`)**-proces.
* **Servicestatussen & Opstarttypen:**
  * **Paused vs. Stopped:** Een gepauzeerde (*Paused*) service behoudt zijn huidige statusinformatie in het geheugen voor wanneer hij wordt hervat (*Resumed*). Een gestopte (*Stopped*) service verliest alle statusinformatie en begint bij opnieuw starten helemaal "schoon".
  * **Startup Types:** *Automatic*, *Automatic (Delayed Start)* (start kort na het opstarten om de boot-snelheid te verbeteren), *Trigger Start* (sluimert totdat een specifieke gebeurtenis of service hem wekt), *Manual* en *Disabled*.

### Overzicht van Belangrijke Standaard Windows Services

| Display Name | Service Name | Functie |
| :--- | :--- | :--- |
| **Windows Update** | `wuauserv` | Controleert op en installeert Windows-updates en beveiligingspatches. |
| **Print Spooler** | `spooler` | Beheert afdruktaken en wachtrijen naar printers (bekend doelwit bij o.a. *PrintNightmare*). |
| **Windows Defender Antivirus Service** | `WinDefend` | Biedt realtime bescherming tegen virussen, malware en andere dreigingen. |
| **Background Intelligent Transfer Service** | `BITS` | Verzorgt achtergrond-bestandsoverdrachten (zoals Windows Updates en downloads). |
| **Cryptographic Services** | `CryptSvc` | Verzorgt cryptografische bewerkingen zoals encryptie, decryptie en certificaatbeheer. |
| **Windows Audio** | `Audiosrv` | Beheert audiofuncties voor weergave en opname. |
| **Task Scheduler** | `Schedule` | Plant en start taken en processen op specifieke tijdstippen of bij bepaalde triggers. |
| **Remote Desktop Services** | `TermService` | Maakt externe bureaublad- of applicatiesessies via het netwerk (RDP) mogelijk. |
| **Windows Time** | `w32time` | Synchroniseert de systeemklok met een tijdserver (NTP) binnen het netwerk. |
| **Windows Management Instrumentation** | `winmgmt` | Biedt het WMI-framework voor het beheren en bevragen van systeeminformatie. |
| **Distributed Link Tracking Client** | `TrkWks` | Houdt koppelingen tussen verplaatste of hernoemde bestanden binnen een volume bij. |
| **Windows Firewall** | `MpsSvc` | Beheert de ingebouwde Windows Defender Firewall voor inkomend en uitgaand netwerkverkeer. |
| **Windows Event Log** | `eventlog` | Beheert en registreert gebeurtenissen en fouten in de System-, Application- en Security-logs. |
| **Server** | `LanmanServer` | Verzorgt bestands- en printerdeling (SMB) voor netwerkclients. |
| **Remote Procedure Call** | `RpcSs` | Essentiële component voor inter-proces- en netwerkcommunicatie tussen systemen. |

### Windows Services als Aanvalsvectoren (Privilege Escalation)
Omdat veel Windows-services draaien met verhoogde rechten (`SYSTEM`), vormen ze een belangrijk doelwit voor lokale **Privilege Escalation** en **Persistence**. De drie belangrijkste aanvalsvectoren zijn:

1. **Unquoted Service Path:**
   * Wanneer een servicepad spaties bevat en **niet** tussen dubbele aanhalingstekens staat (bijv. `C:\Program Files\my service\WindowsService1.exe`), probeert Windows bij het starten van de service van links naar rechts telkens bij elke spatie een uitvoerbaar bestand te vinden:
     1. `C:\Program.exe`
     2. `C:\Program Files\my.exe`
     3. `C:\Program Files\my service\WindowsService1.exe`
   * Als een aanvaller schrijfrechten heeft op `C:\` of `C:\Program Files\`, kan hij een kwaadaardige `Program.exe` plaatsen die bij herstart van de service met `SYSTEM`-rechten wordt uitgevoerd.
2. **User-Writable Service Path:**
   * Wanneer de map of het uitvoerbare bestand van een legitieme service zelf schrijfbaar is voor standaardgebruikers, kan een aanvaller het originele `.exe`-bestand direct overschrijven met een kwaadaardig bestand onder dezelfde naam.
3. **User-Modifiable Service Path (Weak Service Permissions):**
   * Wanneer een standaardgebruiker rechten heeft om de configuratie van een bestaande service aan te passen (bijv. via `sc config` of het register), kan hij het `BinaryPathName` wijzigen zodat de service voortaan een kwaadaardig programma start.

* **Voorwaarden in de praktijk:** Voor een succesvolle *Unquoted Service Path*-aanval moeten meerdere factoren samenkomen: een kwetsbaar pad met spaties, schrijfrechten op een van de tussenliggende mappen, een kwaadaardige service-binary en de mogelijkheid om de service te herstarten (of te wachten op een systeemherstart).

---

## 3. Praktijkscenario's & Stappenplannen

### Scenario 1: Unquoted Service Paths Opsporen, Analyseren & Verhelpen
Een praktisch stappenplan voor systeembeheerders en SOC-analisten om kwetsbare servicepaden op te sporen, de werking van de exploit te begrijpen en het lek te dichten:

1. **Scan het systeem op kwetsbare, automatisch startende services zonder aanhalingstekens:**
   ```cmd
   wmic service get name,pathname,startmode | findstr /i "auto" | findstr /i /v "c:\windows\\" | findstr /i /v """
   ```
   *(Of in PowerShell met `Get-CimInstance Win32_Service` **[Aanvullend]**).*
2. **Simuleer een kwetsbare service (`MyService`) in een labomgeving:**
   ```powershell
   mkdir "C:\Program Files\my service"
   copy C:\Users\cybrary\Desktop\WindowsService1.exe "C:\Program Files\my service"
   New-Service -Name MyService -BinaryPathName "C:\Program Files\my service\WindowsService1.exe"
   Start-Service -Name MyService
   ```
   * Controleer via het WMIC-commando uit stap 1 dat `C:\Program Files\my service\WindowsService1.exe` nu als kwetsbaar wordt gedetecteerd.
3. **Demonstreer de kaping via `C:\Program.exe`:**
   ```powershell
   copy C:\Users\cybrary\Desktop\EvilWindowsService.exe C:\Program.exe
   Stop-Service -Name MyService
   Start-Service -Name MyService
   ```
   * *Resultaat:* Bij het starten vindt Windows eerst `C:\Program.exe` vóór de spatie in `Program Files` en voert de kwaadaardige service uit in plaats van `WindowsService1.exe`. Controleer dit in **Event Viewer** (`eventvwr.msc` → *Windows Logs → Application*, EventID `0`, Source `SimpleService`).
4. **Remediation (Het lek dichten):**
   * Open `regedit.exe` en navigeer naar `HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\MyService`.
   * Dubbelklik op de waarde **`ImagePath`** en plaats dubbele aanhalingstekens om het volledige pad naar het uitvoerbare bestand:
     `"C:\Program Files\my service\WindowsService1.exe"`
   * Verwijder `C:\Program.exe` en herstart de service.

### Scenario 2: Vastgelopen of Verdachte Services Onderzoeken
1. **Controleer welke automatische services onverwacht niet draaien:**
   ```powershell
   Get-Service | Where-Object { $_.StartType -eq "Automatic" -and $_.Status -ne "Running" }
   ```
2. **Inspecteer de afhankelijkheden en herstelinstellingen:**
   * Open `services.msc`, klik met rechts op de betreffende service → **Properties**.
   * Controleer op het tabblad **Dependencies** welke onderliggende systeemcomponenten (zoals `RpcSs`) eerst moeten draaien.
   * Controleer op het tabblad **Recovery** of er bij *First/Second/Subsequent failure* een verdacht programma wordt gestart (*Run a program* is een bekende persistence-techniek voor SOC-analisten **[Aanvullend]**).

---

## 4. Aanvullende Bronnen & Referenties

* **Interne Commandoreferenties (SOC Analyst Map):**
  * Zie `PowerShell.md` en `CMD.md` voor het volledige overzicht van alle service-commando's (`Get-Service`, `New-Service`, `Start-Service`, `Stop-Service`, `Get-CimInstance`, `wmic service`, `sc`).
  * Zie `BASH.md` voor de Linux `systemd`-equivalenten (`systemctl`).
* **[Aanvullend] Officiële Documentatie & Security Referenties:**
  * [Microsoft Learn: Windows Services Overview](https://learn.microsoft.com/en-us/dotnet/framework/windows-services/introduction-to-windows-service-applications) — Uitleg over Session Zero, `Win32OwnProcess`, `Win32ShareProcess` en de Service Control Manager.
  * [MITRE ATT&CK T1574.009: Hijack Execution Flow — Path Interception by Unquoted Path](https://attack.mitre.org/techniques/T1574/009/) — Analyse en detectie van Unquoted Service Path-aanvallen.
  * [MITRE ATT&CK T1543.003: Create or Modify System Process — Windows Service](https://attack.mitre.org/techniques/T1543/003/) — Overzicht van persistence en privilege escalation via Windows Services.