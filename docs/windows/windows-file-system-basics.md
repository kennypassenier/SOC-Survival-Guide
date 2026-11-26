# Windows File System Basics

NTFS, de belangrijkste mappen op `C:\`, Alternate Data Streams en de plekken waar aanvallers persistence achterlaten.

## Concepts

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

## Commands

De commando's voor dit onderwerp staan in de referentiepagina's, met parameters en voorbeelden:

- [dir /x & cd met spaties](/scripting/cmd#cmd-dir-x-cd-met-spaties)
- [echo %PATH%, cd %HOMEPATH% & sysdm](/scripting/cmd#cmd-echo-path-cd-homepath-sysdm)
- [echo ... > bestand:stream & type bestand:stream (CMD)](/scripting/cmd#cmd-alternate-data-streams-ads)
- [type C:\Windows\System32\drivers\etc\hosts](/scripting/cmd#cmd-het-hosts-bestand-lezen)
- [GUI- en Forensische Systeemtools (regedit, eventvwr, chntpw)](/scripting/cmd#cmd-gui-en-forensische-systeemtools)
- [Get-Item -Stream * & Get-Content -Stream (PowerShell)](/scripting/powershell#ps-alternate-data-streams-ads)

## Scenarios

### Scenario 1: Verborgen Data in NTFS Alternate Data Streams (ADS) Opsporen & Uitlezen
Aanvallers kunnen kwaadaardige tekst, scripts of payloads verbergen in een NTFS Alternate Data Stream zonder dat de bestandsgrootte in Verkenner of `dir` verandert. Zo maak en analyseer je een ADS:

1. **Maak een regulier bestand aan en koppel een verborgen stream in CMD:**
   <<< @/snippets/cmd/windows-file-system.bat#scenario-1-stap-1{cmd}
2. **Controleer dat `dir` en `type` geen afwijkingen tonen:**
   <<< @/snippets/cmd/windows-file-system.bat#scenario-1-stap-2{cmd}
   * *Valkuil:* De bestandsgrootte blijft gelijk aan die van de originele tekst en `type notasecret.txt` toont de verborgen stream niet.
3. **Inventariseer alle streams van het bestand in PowerShell:**
   <<< @/snippets/ps/windows-file-system.ps1#scenario-1-stap-1{powershell}
   * *Resultaat:* Naast de standaard `:$DATA`-stream verschijnt nu de extra stream `secret` met zijn werkelijke grootte in bytes.
4. **Lees de inhoud van de verborgen stream uit:**
   <<< @/snippets/ps/windows-file-system.ps1#scenario-1-stap-2{powershell}
   <<< @/snippets/cmd/windows-file-system.bat#scenario-1-stap-3{cmd}

### Scenario 2: Controle op Persistence & DNS-manipulatie (SOC Triage-check)
Bij het onderzoeken van een mogelijk gecompromitteerde Windows-werkplek controleer je onder meer deze locaties uit dit hoofdstuk:

1. **Controleer de gebruikers-Startup-map op verdachte scripts (`.bat`, `.vbs`, `.exe`):**
   * Open `shell:startup` (of controleer `C:\Users\<gebruiker>\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup`) en **Startup Apps** in Windows Instellingen.
2. **Controleer het `hosts`-bestand op ongeautoriseerde omleidingen:**
   <<< @/snippets/cmd/windows-file-system.bat#scenario-2-stap-1{cmd}
   * *Aandachtspunt:* Elke actieve regel zonder `#` die bekende domeinen (zoals banken, Microsoft of Google) laat verwijzen naar een onbekend IP-adres wijst op *hosts file hijacking*.
3. **Controleer de `PATH`-omgevingsvariabele op ongebruikelijke mappen:**
   <<< @/snippets/cmd/windows-file-system.bat#scenario-2-stap-2{cmd}

## References

* **Interne Commandoreferenties (SOC Analyst Map):**
  * Zie `CMD.md` en `PowerShell.md` voor het volledige overzicht van Windows-commando's (`dir /x`, `echo %PATH%`, `Get-Item -Stream *`, `Get-Content -Stream`, `Get-WinEvent`).
  * Zie `BASH.md` voor de Linux-equivalenten (`ls`, `echo $PATH`, `cat /etc/hosts`).
* **Officiële Documentatie & Security Referenties:**
  * [Microsoft Learn: NTFS Overview](https://learn.microsoft.com/en-us/windows-server/storage/file-server/ntfs-overview) — Technische documentatie over NTFS, bestandsgrootte-limieten en beveiligingsfuncties.
  * [MITRE ATT&CK T1564.004: Hide Artifacts — NTFS File Attributes (ADS)](https://attack.mitre.org/techniques/T1564/004/) — Uitleg over hoe aanvallers Alternate Data Streams misbruiken om malware en data te verbergen.
  * [MITRE ATT&CK T1547.001: Boot or Logon Autostart Execution — Registry Run Keys / Startup Folder](https://attack.mitre.org/techniques/T1547/001/) — Overzicht van persistence via de Windows Startup-map en Register-sleutels.
