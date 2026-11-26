# Data Backup and Recovery Basics

## 1. Overzicht van Relevante Commando's & Tools

### A. Windows Server Backup (`wbadmin` & PowerShell)

#### `Install-WindowsFeature`
* **Doel:** Installeert de Windows Server Backup-functie op een Windows Server-omgeving via PowerShell.
* **Parameters & Opties:**
  * `Windows-Server-Backup`: De exacte naam van de Windows Server-feature die geïnstalleerd moet worden.
* **Praktijkgebruik:**
  ```powershell
  # Installeer de Windows Server Backup feature via PowerShell (Admin)
  Install-WindowsFeature Windows-Server-Backup
  ```
* **Tips, Valkuilen & Modernere Mogelijkheden:**
  * De installatie kan ook via de grafische *Server Manager GUI* (onder *Add Roles and Features*), maar via PowerShell is dit sneller en scriptbaar.
  * **[Aanvullend] Client- vs. Server-versies & PowerShell-cmdlets:**
    * `Install-WindowsFeature` is specifiek voor **Windows Server**. Op Windows 10/11-clientversies heet het equivalente commando `Enable-WindowsOptionalFeature -Online -FeatureName WindowsServerBackup` (of gebruik de ingebouwde *File History* / *Backup and Restore (Windows 7)*).
    * Na installatie biedt Windows Server ook volwaardige PowerShell-cmdlets uit de module `WindowsServerBackup` (zoals `New-WBPolicy`, `Add-WBBackupTarget`, `Start-WBBackup` en `Get-WBSummary`).

#### `wbadmin.msc`
* **Doel:** Opent de grafische Microsoft Management Console (MMC) voor **Windows Server Backup**, waarmee zowel geplande back-ups (*Backup Schedule Wizard*) als hersteltaken (*Recovery Wizard*) worden beheerd.
* **Praktijkgebruik:**
  ```powershell
  # Open de grafische Windows Server Backup console
  wbadmin.msc
  ```
* **Tips & Valkuilen:**
  * In het rechterdeelvenster (**Actions**) kun je via *Backup Schedule...* niet alleen een schema instellen, maar ook een bestaand schema wijzigen of volledig stopzetten (*Stop backup*).

#### `wbadmin start backup`
* **Doel:** Voert vanaf de opdrachtregel direct een eenmalige back-up (*one-time backup*) uit van opgegeven mappen, bestanden of volumes naar een doelvolume.
* **Parameters & Opties:**
  * `start backup`: Subcommando om een directe back-uptaak te starten.
  * `-backupTarget:<volume>`: Specificeert de doelschijf of het volume waarop de back-up wordt opgeslagen (bijv. `-backupTarget:D:`).
  * `-include:<pad>`: Specificeert welke map(pen) of bestand(en) in de back-up moeten worden opgenomen (bijv. `-include:C:\Sales`).
* **Praktijkgebruik:**
  ```powershell
  # Maak een eenmalige back-up van C:\Sales op de D:-schijf
  wbadmin start backup -backupTarget:D: -include:C:\Sales
  ```
* **Tips, Valkuilen & Modernere Mogelijkheden:**
  * Wanneer je het commando interactief draait, vraagt Windows om bevestiging (`Y/N`). Na afloop toont `wbadmin` de exacte map waarin het back-uplogbestand is opgeslagen (standaard onder `C:\Windows\Logs\WindowsServerBackup`).
  * **[Aanvullend] Extra `wbadmin`-switches & Linux-equivalenten:**
    * `-quiet`: Voert de back-up uit zonder interactieve `Y/N`-bevestiging (essentieel voor geautomatiseerde scripts en Scheduled Tasks).
    * `-allCritical`: Neemt alle kritieke systeemvolumes mee die nodig zijn voor een volledige *Bare Metal Recovery* (`wbadmin start backup -backupTarget:D: -allCritical -quiet`).
    * **Linux-equivalenten (Debian/Ubuntu & Arch):**
      * Bestandsniveau / incrementele sync: `rsync -avh --delete /bronmap/ /backupmap/`
      * Volledige archieven: `tar -czvf backup.tar.gz /bronmap/`
      * Block-level / Bare Metal disk-imaging: `dd if=/dev/sda of=/mnt/backup/disk.img bs=4M status=progress` (of tools zoals *Clonezilla* en *Timeshift* / *Snapper* op Btrfs/ZFS).

---

## 2. Algemene Uitleg & Theorie

### CIA Triad, Business Continuity & Disaster Recovery
* **Ondersteuning van Availability:** Data backup and recovery is het proces waarbij kopieën van computergegevens worden gemaakt om originele data te herstellen wanneer deze verloren gaat, beschadigd raakt of ontoegankelijk wordt. Dit ondersteunt rechtstreeks de **Availability**-pijler van de **CIA Triad** (*Confidentiality, Integrity, Availability*).
* **Business Continuity (BC) & Disaster Recovery (DR):**
  * **Business Continuity:** Het vermogen van een organisatie om tijdens en na een verstorende gebeurtenis op een acceptabel niveau te blijven functioneren.
  * **Disaster Recovery:** Een kernonderdeel van Business Continuity dat zich specifiek richt op het behouden en herstellen van kritieke IT-infrastructuur na een ramp (natuurlijk of door mensen veroorzaakt) met zo min mogelijk verlies van functionaliteit en data.
* **BCP, DRP & Recovery Point Objective (RPO):**
  * In een **Business Continuity Plan (BCP)** en **Disaster Recovery Plan (DRP)** vormen gedetailleerde back-up- en herstelprocedures een van de eerste en belangrijkste onderdelen: welke data wordt geback-upt, hoeveel kopieën worden bewaard, op hoeveel locaties en welk type back-up wordt gebruikt.
  * **Recovery Point Objective (RPO):** Bepaalt de maximale hoeveelheid dataverlies (uitgedrukt in tijd) die een organisatie bereid is te accepteren bij een storing. Een strenge RPO (bijv. maximaal 1 uur dataverlies) vereist frequentere back-ups (zoals wekelijks Full, dagelijks Differential en elk uur Incremental).

### De Zes Typen Back-ups

| Back-up Type | Wat wordt er opgeslagen? | Benodigd voor Volledig Herstel | Voordelen & Nadelen |
| :--- | :--- | :--- | :--- |
| **Full** | Alle geselecteerde bestanden en mappen op het systeem. | Alleen de **laatste Full back-up**. | Snelste en eenvoudigste restore, maar vraagt de meeste tijd, opslagruimte en netwerkbandbreedte. |
| **Differential** | Alle bestanden die nieuw of gewijzigd zijn **sinds de laatste Full back-up**. | De **laatste Full back-up** + **1 laatste Differential back-up**. | Snelle restore (maximaal 2 sets nodig), maar elke volgende differential groeit in omvang tot de volgende full back-up. |
| **Incremental** | Eerste keer: alles sinds de Full back-up. Daarna: enkel wat nieuw of gewijzigd is **sinds de vorige Incremental back-up**. | De **laatste Full back-up** + **alle opeenvolgende Incremental back-ups**. | Snelste back-up en minste opslagruimte nodig, maar traagste en meest kwetsbare restore (als één schakel ontbreekt, faalt de rest van de keten). |
| **Synthetic Full** | Wordt op de back-upopslag zelf opgebouwd door een eerdere Full back-up samen te voegen met latere incremental/differential wijzigingen. | Alleen de **Synthetic Full back-up**. | Combineert het herstelgemak van een Full back-up met de lage netwerkbelasting van een Incremental back-up (veelgebruikt in cloudoplossingen). |
| **Continuous (CDP)** | Na één initiële Full back-up worden alle wijzigingen doorlopend/realtime weggeschreven naar de opslag. | De initiële Full + continue wijzigingslog tot het gewenste herstelpunt. | Minimale RPO (vrijwel geen dataverlies), maar vereist continue bandbreedte en gespecialiseerde opslag. |
| **Bare Metal** | Een specifieke vorm van Full back-up die het volledige systeem vastlegt: besturingssysteem (OS), applicaties, instellingen én data. | De **Bare Metal back-up**. | Maakt herstel naar compleet nieuwe fysieke hardware, een nieuwe VM of migratie naar de cloud mogelijk zonder het OS en complexe applicaties opnieuw te installeren. |

* **[Aanvullend] Security & Ransomware Best Practice (3-2-1-1-0 Regel):**
  * Voor SOC-analisten en systeembeheerders is een standaard back-up onvoldoende als ransomware ook de aangekoppelde back-upschijf (`D:`) kan versleutelen. Hanteer daarom de moderne **3-2-1-1-0 back-upregel**: **3** kopieën van je data, op **2** verschillende opslagmedia, waarvan **1** kopie *offsite* (extern), **1** kopie *offline/immutable* (onveranderbaar, zodat ransomware het niet kan wissen of versleutelen), met **0** fouten na geautomatiseerde hersteltests.

---

## 3. Praktijkscenario's & Stappenplannen

### Scenario 1: Eenmalige Back-up Maken met Windows Server Backup (`wbadmin`)
Het installeren van de back-upfunctie en het uitvoeren van een directe CLI-back-up van een kritieke bedrijfsmap (`C:\Sales`) naar een tweede volume (`D:`):

1. **Installeer de Windows Server Backup-feature in een Administrator PowerShell-venster:**
   ```powershell
   Install-WindowsFeature Windows-Server-Backup
   ```
2. **Controleer of beheer eventuele bestaande back-upschema's via de console:**
   ```powershell
   wbadmin.msc
   ```
   * Ga naar **Local Backup**. In het rechterpaneel (**Actions**) kun je via **Backup Schedule...** een dagelijks schema aanmaken of een bestaand schema stoppen (*Stop backup*).
3. **Start een eenmalige back-up van `C:\Sales` naar volume `D:` via de opdrachtregel:**
   ```powershell
   wbadmin start backup -backupTarget:D: -include:C:\Sales
   ```
   * Bevestig met `Y` en druk op Enter.
   * *Aandachtspunt:* Controleer na voltooiing het pad van het gegenereerde back-uplogbestand in de terminaluitvoer.

### Scenario 2: Verwijderde Mappen en Bestanden Herstellen via de Recovery Wizard
Wanneer een map per ongeluk is verwijderd (`C:\Sales`) en teruggezet moet worden vanaf een back-up op een ander volume (`D:\WindowsImageBackup`):

1. **Controleer de aanwezigheid van de back-upmap op het doelvolume:**
   * Zorg ervoor dat de map `WindowsImageBackup` rechtstreeks in de root van het back-upvolume staat (bijv. `D:\WindowsImageBackup`, indien uitgepakt vanuit een archief naar exact `D:\`).
   * *Valkuil:* Als je een `.zip`-archief uitpakt naar een submap zoals `D:\WindowsImageBackup\WindowsImageBackup`, herkent de Recovery Wizard de back-up niet en geeft deze een foutmelding.
2. **Start de Recovery Wizard in `wbadmin.msc`:**
   * Open `wbadmin.msc`, klik in het linkerpaneel op **Local Backup** en klik rechts op **Recover...**.
   * Kies **A backup stored on another location** → **Local drives** en selecteer het volume `D:`.
   * Kies de juiste servernaam en de datum/tijd van de back-up.
3. **Selecteer het hersteltype en de gewenste map:**
   * Kies bij *Select Recovery Type* voor **Files and Folders**.
   * Blader naar `C:\Sales`, selecteer de map en klik op **Next**.
   * Geef bij *Recovery Destination* het doelpad op (bijv. `C:\` om naar de oorspronkelijke locatie te herstellen) en klik op **Recover**.
4. **Verifieer de herstelde bestanden:**
   * Controleer in `wbadmin.msc` of de status *Completed* is en open de herstelde bestanden in `C:\Sales` om de integriteit te bevestigen.

---

## 4. Aanvullende Bronnen & Referenties

* **Interne Commandoreferenties (SOC Analyst Map):**
  * Zie `PowerShell.md` (voor `Install-WindowsFeature`, `Enable-WindowsOptionalFeature` en `Get-WBSummary`) en `CMD.md` (voor `wbadmin start backup` en `wbadmin.msc`).
  * Zie `BASH.md` voor Linux-back-upcommando's (`rsync`, `tar`, `dd`).
* **[Aanvullend] Officiële Documentatie & Security Richtlijnen:**
  * [Microsoft Learn: `wbadmin start backup`](https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/wbadmin-start-backup) — Officiële commandoreferentie met alle switches voor Windows Server Backup.
  * [NIST SP 800-34 Rev. 1: Contingency Planning Guide for Federal Information Systems](https://csrc.nist.gov/pubs/sp/800/34/r1/final) — Richtlijnen voor Business Continuity Planning (BCP), Disaster Recovery (DRP), RPO en RTO.
  * [CISA: Ransomware Guide — Backup Best Practices](https://www.cisa.gov/stopransomware/ransomware-guide) — Aanbevelingen voor offline en immutable back-ups ter bescherming tegen ransomware.