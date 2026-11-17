# Windows File System Basics

## 1. Overzicht van Relevante Commando's

### A. Bestands- & Mapnavigatie, 8.3-namen & Omgevingsvariabelen

#### `dir /x` & `cd` met spaties
* **Doel:**
  * `dir /x`: Toont naast de reguliere bestands- en mapnamen ook de oude DOS-compatibele **8.3 korte namen** (bijv. `PROGRA~2` voor `Program Files (x86)`).
  * `cd "<mapnaam met spaties>"`: Wisselt naar een map waarvan de naam spaties bevat door dubbele aanhalingstekens (`"..."`) te gebruiken.
* **Parameters & Opties:**
  * `/x` (`x` = e**x**tended / 8.3 short names): Geeft de gegenereerde 8-tekens korte naam weer voor oudere applicaties en scripts.
* **Praktijkgebruik & Permutaties:**
  ```cmd
  :: Navigeer naar een map met spaties via dubbele aanhalingstekens
  cd "Program Files (x86)"

  :: Bekijk de 8.3 korte namen van mappen op C:\ (bijv. PROGRA~1 en PROGRA~2)
  dir /x C:\
  ```
* **[Aanvullend] Modernere Mogelijkheden (PowerShell & Linux):**
  * **Windows PowerShell:** `Set-Location "C:\Program Files (x86)"` (alias `cd`). PowerShell vult paden met spaties bij gebruik van de `Tab`-toets automatisch aan met aanhalingstekens.
  * **Linux (Debian & Arch):** Gebruik aanhalingstekens (`cd "Mijn Map"`) of escape spaties met een backslash (`cd Mijn\ Map`).

#### `echo %PATH%`, `cd %HOMEPATH%` & `sysdm`
* **Doel:**
  * `echo %PATH%`: Toont alle mappen (gescheiden door puntkomma's `;`) waarin Windows automatisch zoekt naar uitvoerbare programma's en DLL's (gecombineerde Systeem- en Gebruikers-`PATH`).
  * `cd %HOMEPATH%`: Navigeert naar de persoonlijke home-directory van de ingelogde gebruiker (bijv. `\Users\cybrary`, vergelijkbaar met `cd ~` in Linux).
  * `sysdm` (of `sysdm.cpl`): Opent het venster *System Properties* om via *Advanced → Environment Variables* de gebruikers- en systeemomgevingsvariabelen (zoals `Path`) te beheren.
* **Praktijkgebruik:**
  ```cmd
  :: Toon alle actieve zoekpaden in de PATH-omgevingsvariabele
  echo %PATH%

  :: Open het System Properties-venster vanaf de opdrachtprompt
  sysdm
  ```
* **Tips, Valkuilen & Modernere Mogelijkheden:**
  * `echo %PATH%` combineert zowel de **System Variables** als de **User Variables** van het ingelogde account in één lijst.
  * **[Aanvullend] SOC-context (PATH Hijacking) & PowerShell-equivalent:**
    * **Security-valkuil:** Wanneer een map met schrijfrechten voor standaardgebruikers vóór `C:\Windows\System32` in `%PATH%` staat, kan een aanvaller een kwaadaardige binary met dezelfde naam als een systeemtool plaatsen (*Unquoted Service Path* of *PATH Hijacking*).
    * **PowerShell-equivalent:** `$env:PATH -split ';'` print elk zoekpad overzichtelijk op een eigen regel.
    * **Linux (Debian & Arch):** `echo $PATH` (gescheiden door dubbele punten `:`).

---

### B. Alternate Data Streams (ADS) Inspecteren & Uitlezen

#### `echo ... > bestand:stream` & `type bestand:stream` (CMD)
* **Doel:** Schrijft verborgen data naar een NTFS **Alternate Data Stream (ADS)** achter een regulier bestand en leest deze weer uit wanneer de naam van de stream bekend is.
* **Praktijkgebruik & Permutaties:**
  ```cmd
  :: Maak een normaal tekstbestand aan
  echo This is not a secret. > notasecret.txt

  :: Verberg tekst in een Alternate Data Stream genaamd 'secret' achter het bestand
  echo The password is MUSTARD1234 > notasecret.txt:secret

  :: Controleer bestandsgrootte en reguliere inhoud (blijven ogenschijnlijk ongewijzigd)
  dir notasecret.txt
  type notasecret.txt

  :: Lees de verborgen stream rechtstreeks uit in CMD (als de streamnaam bekend is)
  type notasecret.txt:secret
  ```
* **Tips & Valkuilen:**
  * Een standaard `dir` en `type notasecret.txt` tonen **niet** dat er een verborgen stream aanwezig is en ook de weergegeven bestandsgrootte verandert niet.
  * **[Aanvullend]:** In CMD toont `dir /r` (`/r` = data st**r**eams) wel alle Alternate Data Streams van bestanden in een map.

#### `Get-Item -Stream *` & `Get-Content -Stream` (PowerShell)
* **Doel:** Ontdekt alle aanwezige Alternate Data Streams (inclusief onbekende streamnamen) op een NTFS-bestand en leest de inhoud van een specifieke stream uit.
* **Parameters & Opties:**
  * `-Stream *`: Toont alle datastreams gekoppeld aan het bestand (zowel de standaard `:$DATA`-stream als verborgen ADS-streams).
  * `-Stream <naam>`: Leest de inhoud van een specifieke benoemde stream.
* **Praktijkgebruik:**
  ```powershell
  # Ontdek alle Alternate Data Streams van notasecret.txt
  Get-Item .\notasecret.txt -Stream *

  # Lees de inhoud van de verborgen stream 'secret' uit
  Get-Item .\notasecret.txt | Get-Content -Stream secret
  ```
* **[Aanvullend] SOC-context (Zone.Identifier & Malware-detectie):**
  * Windows gebruikt ADS legitiem voor de `Zone.Identifier`-stream (*Mark of the Web*): elk bestand dat van internet is gedownload krijgt een `Zone.Identifier` (`ZoneId=3`), waarmee Windows waarschuwt bij het openen.
  * Aanvallers misbruiken ADS om payloads of scripts onzichtbaar te verbergen achter legitieme bestanden. Met `Get-ChildItem -Recurse | Get-Item -Stream * | Where-Object Stream -ne ':$DATA'` spoor je als SOC-analist snel alle verborgen streams in een map op.

---

### C. Systeemconfiguratie & Netwerkbestanden Inspecteren

#### `type C:\Windows\System32\drivers\etc\hosts`
* **Doel:** Leest het lokale Windows `hosts`-bestand om handmatige IP-naar-hostnaam-koppelingen te controleren.
* **Praktijkgebruik:**
  ```cmd
  :: Bekijk de inhoud van het lokale hosts-bestand
  type C:\Windows\System32\drivers\etc\hosts
  ```
* **Tips, Valkuilen & OS-verschillen:**
  * Regels die beginnen met `#` zijn commentaar en worden genegeerd. Actieve regels volgen het formaat `<IP-adres> <spatie/tab> <hostnaam>` (bijv. `10.10.10.10 www.happypuppy.com`).
  * Het `hosts`-bestand heeft **voorrang op DNS**. Aanvallers passen dit bestand soms aan (*hosts file hijacking*) om gebruikers naar kwaadaardige servers te sturen wanneer zij een vertrouwde domeinnaam bezoeken.
  * **[Aanvullend] OS-verschillen & PowerShell-equivalent:**
    * **Windows PowerShell:** `Get-Content C:\Windows\System32\drivers\etc\hosts`
    * **Linux (Debian & Arch):** `cat /etc/hosts`

#### GUI- en Forensische Systeemtools (`regedit`, `eventvwr`, `chntpw`)
* **Doel:**
  * `regedit` (`regedit.exe`): Opent de Windows Registry Editor om sleutels, waarden en *hives* (zoals `HKEY_LOCAL_MACHINE\SECURITY`, `SOFTWARE`, `SYSTEM`) te bekijken.
  * `eventvwr` (`eventvwr.exe`): Opent de Windows Event Viewer om binaire `.evtx`-logbestanden (`Application`, `Security`, `System`) te analyseren.
  * `shell:startup` (via *Uitvoeren* / `Win + R`): Opent direct de persoonlijke opstartmap van de huidige gebruiker.
  * `chntpw` **[Linux-tool voor offline Windows-herstel/forensics]**: Een Linux-hulpprogramma waarmee de Windows `SAM`-database offline kan worden uitgelezen of aangepast wanneer een Windows-schijf aan een Linux-systeem of bootdisk is gekoppeld.
* **[Aanvullend] Modernere CLI-equivalenten (PowerShell):**
  * **Windows Registry:** `Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"` (inspecteert opstartitems in het register vanaf de CLI).
  * **Windows Event Logs (`.evtx`):** `Get-WinEvent -LogName Security -MaxEvents 20` of `Get-WinEvent -Path .\Application.evtx` (leest `.evtx`-bestanden direct uit in PowerShell).

---

## 2. Algemene Uitleg & Theorie

### Windows Bestandssystemen & Volumes
* **Hiërarchie & Schijfletters:** Windows organiseert opslag in een hiërarchie van **volumes** (fysieke schijven of logische partities met een schijfletter zoals `C:\`), mappen (*folders*) en bestanden.
* **Bestandssystemen:**
  * **FAT16 / FAT32 / exFAT:** *File Allocation Table*. Vroeger gebruikt voor harde schijven; tegenwoordig vooral standaard voor USB-sticks en externe flashopslag (`FAT32` en `exFAT`).
  * **NTFS (New Technology File System):** Ontwikkeld door Microsoft in 1993 voor Windows NT en vandaag de standaard voor moderne Windows-systemen. Biedt ten opzichte van FAT veel grotere opslagcapaciteit (`16 TB` tot `8 PB`), betere fouttolerantie, bestandsversleuteling (EFS), compressie, gebruikersquota en uitgebreide toegangsrechten (ACL's).

### Belangrijke Standaardmappen op `C:\`
Een moderne Windows-installatie bevat op het hoogste niveau van `C:\` doorgaans zeven kernmappen:

| Map | Functie & Inhoud | Belangrijke Details & Pad-notaties |
| :--- | :--- | :--- |
| **`C:\EFI`** | **Extensible Firmware Interface** | Bevat opstartbestanden en werkt samen met de verborgen EFI-systeempartitie. Het belangrijkste bestand is **`C:\EFI\Microsoft\Boot\BCD`** (*Boot Configuration Data*), dat alle opstartopties bevat. |
| **`C:\PerfLogs`** | **Performance Logs** | Opslaglocatie voor loggegevens van de Windows *Performance Monitor* (voor het opsporen van systeemknelpunten). Wordt automatisch door Windows opnieuw aangemaakt indien verwijderd. |
| **`C:\Program Files`** & **`C:\Program Files (x86)`** | **Geïnstalleerde Programma's** | `Program Files` bevat **64-bit** applicaties; `Program Files (x86)` bevat **32-bit** applicaties (geïnstalleerd via `.exe` of `.msi`). Korte 8.3-namen: `PROGRA~1` en `PROGRA~2`. |
| **`C:\ProgramData`** | **Gedeelde Applicatiedata** | Verborgen map waarin programma's instellingen en data opslaan die voor **alle gebruikers** op het systeem gelden (tegenover `C:\Users\<naam>\AppData` voor gebruikersspecifieke data). |
| **`C:\Users`** | **Gebruikersprofielen** | Bevat per lokale gebruiker een persoonlijke profielmap (`Desktop`, `Documents`, `Downloads`, enz.). Deze submappen worden pas aangemaakt nadat een gebruiker **voor het eerst inlogt**. |
| **`C:\Windows`** | **Het Besturingssysteem** | Bevat alle systeembestanden en core-applicaties:<br>• **`C:\Windows\System32`**: Kern-DLL's (*Dynamic Link Libraries*) en essentiële executables (`cmd.exe`, `eventvwr.exe`, `netstat.exe`, `calc.exe`, `mspaint.exe`).<br>• **`C:\Windows`**: Bevat o.a. `regedit.exe`, `explorer.exe`, `notepad.exe` en `write.exe`.<br>• **`%SystemRoot%`**: Omgevingsvariabele die verwijst naar `C:\Windows`. |

* **Verborgen items & Extensies:** Windows verbergt standaard mappen zoals `ProgramData` en `AppData`, evenals bekende bestandsextensies (`.txt`, `.bat`, `.exe`). In Verkenner maak je deze zichtbaar via het tabblad **View → Hidden items** en **File name extensions**.

### Kritieke Windows-onderdelen voor Beheerders & SOC-analisten
1. **Startup Folder (Persistence-locatie):**
   * Pad: `C:\Users\<gebruiker>\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup` (snel te openen via `Win + R` → `shell:startup`).
   * Elk programma, snelkoppeling of batchbestand (`.bat`) in deze map wordt automatisch uitgevoerd zodra die specifieke gebruiker inlogt.
2. **Security Accounts Manager (SAM) & Windows Registry (`C:\Windows\System32\config`):**
   * **SAM-database:** Bevat lokale gebruikersaccounts, wachtwoordhashes en beveiligingsdescriptors. Zolang Windows draait, is het bestand `SAM` volledig vergrendeld door het besturingssysteem en door niemand te openen of te lezen. Offline (via een Linux bootdisk of gekoppelde cloud-schijf) kan het worden bewerkt met `chntpw`.
   * **Windows Registry Hives:** De bestanden `SECURITY`, `SOFTWARE` en `SYSTEM` in `C:\Windows\System32\config` vormen de fysieke opslag van de corresponderende *hives* onder `HKEY_LOCAL_MACHINE` in het Windows-register (een hiërarchische database van sleutels en *key-value pairs*).
3. **Windows Event Logs (`.evtx`):**
   * Opgeslagen onder `%SystemRoot%\System32\Winevt\Logs` (met aparte logboeken voor **Application**, **Security** en **System**).
   * Gebruiken het propriëtaire binaire `.evtx`-formaat en kunnen niet met Kladblok worden gelezen, maar wel met **Event Viewer** (`eventvwr.exe`) of PowerShell (`Get-WinEvent`).
4. **Bestandstypes & Extensies:**
   * In tegenstelling tot Linux (dat naar *magic bytes* kijkt) bepaalt Windows aan de hand van de **bestandsextensie** (`.txt`, `.wav`, `.bat`, `.gif`) welk type bestand het is en welke standaardapplicatie (*Default apps by file type*) het moet openen.

---

## 3. Praktijkscenario's & Stappenplannen

### Scenario 1: Verborgen Data in NTFS Alternate Data Streams (ADS) Opsporen & Uitlezen
Aanvallers kunnen kwaadaardige tekst, scripts of payloads verbergen in een NTFS Alternate Data Stream zonder dat de bestandsgrootte in Verkenner of `dir` verandert. Zo maak en analyseer je een ADS:

1. **Maak een regulier bestand aan en koppel een verborgen stream in CMD:**
   ```cmd
   cd %HOMEPATH%
   echo This is not a secret. > notasecret.txt
   echo The password is MUSTARD1234 > notasecret.txt:secret
   ```
2. **Controleer dat `dir` en `type` geen afwijkingen tonen:**
   ```cmd
   dir notasecret.txt
   type notasecret.txt
   ```
   * *Valkuil:* De bestandsgrootte blijft gelijk aan die van de originele tekst en `type notasecret.txt` toont de verborgen stream niet.
3. **Inventariseer alle streams van het bestand in PowerShell:**
   ```powershell
   Get-Item .\notasecret.txt -Stream *
   ```
   * *Resultaat:* Naast de standaard `:$DATA`-stream verschijnt nu de extra stream `secret` met zijn werkelijke grootte in bytes.
4. **Lees de inhoud van de verborgen stream uit:**
   ```powershell
   # In PowerShell:
   Get-Item .\notasecret.txt | Get-Content -Stream secret
   ```
   ```cmd
   :: Of in CMD (alleen als je de exacte streamnaam al weet):
   type notasecret.txt:secret
   ```

### Scenario 2: Controle op Persistence & DNS-manipulatie (SOC Triage-check)
Bij het onderzoeken van een mogelijk gecompromitteerde Windows-werkplek controleer je onder meer deze locaties uit dit hoofdstuk:

1. **Controleer de gebruikers-Startup-map op verdachte scripts (`.bat`, `.vbs`, `.exe`):**
   * Open `shell:startup` (of controleer `C:\Users\<gebruiker>\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup`) en **Startup Apps** in Windows Instellingen.
2. **Controleer het `hosts`-bestand op ongeautoriseerde omleidingen:**
   ```cmd
   type C:\Windows\System32\drivers\etc\hosts
   ```
   * *Aandachtspunt:* Elke actieve regel zonder `#` die bekende domeinen (zoals banken, Microsoft of Google) laat verwijzen naar een onbekend IP-adres wijst op *hosts file hijacking*.
3. **Controleer de `PATH`-omgevingsvariabele op ongebruikelijke mappen:**
   ```cmd
   echo %PATH%
   ```

---

## 4. Aanvullende Bronnen & Referenties

* **Interne Commandoreferenties (SOC Analyst Map):**
  * Zie `CMD.md` en `PowerShell.md` voor het volledige overzicht van Windows-commando's (`dir /x`, `echo %PATH%`, `Get-Item -Stream *`, `Get-Content -Stream`, `Get-WinEvent`).
  * Zie `BASH.md` voor de Linux-equivalenten (`ls`, `echo $PATH`, `cat /etc/hosts`).
* **[Aanvullend] Officiële Documentatie & Security Referenties:**
  * [Microsoft Learn: NTFS Overview](https://learn.microsoft.com/en-us/windows-server/storage/file-server/ntfs-overview) — Technische documentatie over NTFS, bestandsgrootte-limieten en beveiligingsfuncties.
  * [MITRE ATT&CK T1564.004: Hide Artifacts — NTFS File Attributes (ADS)](https://attack.mitre.org/techniques/T1564/004/) — Uitleg over hoe aanvallers Alternate Data Streams misbruiken om malware en data te verbergen.
  * [MITRE ATT&CK T1547.001: Boot or Logon Autostart Execution — Registry Run Keys / Startup Folder](https://attack.mitre.org/techniques/T1547/001/) — Overzicht van persistence via de Windows Startup-map en Register-sleutels.