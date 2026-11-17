# Antivirus Basics

## 1. Overzicht van Relevante Commando's & Tools

### A. Microsoft Defender Antivirus via PowerShell (`Start-MpScan`)

#### `Start-MpScan`
* **Doel:** Start vanaf de PowerShell-opdrachtregel een handmatige malwarescan met **Microsoft Defender Antivirus** op een specifiek bestand, een specifieke map of het volledige systeem.
* **Parameters & Opties:**
  * `-ScanPath <pad>`: Specificeert de exacte map of het bestand dat gescand moet worden (bijv. `C:\Evil\`).
  * `-ScanType <type>`: Bepaalt het type scan:
    * `CustomScan`: Scant uitsluitend de opgegeven locatie achter `-ScanPath`.
    * `QuickScan` **[Aanvullend]**: Scant standaard de meest kwetsbare systeemlocaties (geheugen, opstartmappen, register).
    * `FullScan` **[Aanvullend]**: Scant het volledige bestandssysteem en alle aangesloten schijven.
* **Praktijkgebruik & Permutaties:**
  ```powershell
  # Voer een gerichte scan uit op een specifieke map (bijv. C:\Evil\)
  Start-MpScan -ScanPath C:\Evil\ -ScanType CustomScan

  # [Aanvullend] Voer een snelle systeemscan uit of werk eerst de signatures bij
  Update-MpSignature
  Start-MpScan -ScanType QuickScan
  ```
* **Tips, Valkuilen & Modernere Mogelijkheden:**
  * Vereist **Administrator-rechten** (*Windows PowerShell (Admin)*) om uitsluitingen te beheren en scans op systeemmappen af te dwingen.
  * **Valkuil met Exclusions:** Als een map (zoals `C:\Evil`) onder *Exclusions* in Windows Security staat geregistreerd, slaat zowel *Real-time Protection* als `Start-MpScan` die map over totdat de uitsluiting is verwijderd.
  * **[Aanvullend] Extra Microsoft Defender PowerShell-cmdlets (SOC Triage & Beheer):**
    * `Get-MpComputerStatus`: Toont de actuele status van Microsoft Defender (of *RealTimeProtectionEnabled* aanstaat, en de datum/versie van de handtekeningen).
    * `Get-MpThreatDetection` & `Get-MpThreat`: Haalt de volledige detectiegeschiedenis, dreigingsnamen, ernstniveaus (*Severity*) en getroffen bestandspaden op zonder de GUI te openen.
    * `Get-MpPreference` / `Remove-MpPreference -ExclusionPath "C:\Evil"`: Bekijkt of verwijdert geconfigureerde scan-uitsluitingen vanaf de CLI (cruciaal bij SOC-onderzoek, omdat aanvallers vaak mappen uitsluiten van Defender).
  * **[Aanvullend] Linux-equivalenten (Debian/Ubuntu & Arch):**
    * **ClamAV** (open-source antivirus voor Linux-servers): `sudo freshclam` (signatures bijwerken) en `clamscan -r --remove /pad/naar/map` (recursieve scan).

---

### B. Archiefbestanden Uitpakken & GUI-beheer (`7-Zip` & `Windows Security`)

#### `7-Zip` (Wachtwoordbeveiligde Malware-archieven)
* **Doel:** Pakt gecomprimeerde en met een wachtwoord beveiligde archiefbestanden (`.zip`, `.7z`) uit.
* **Praktijkgebruik:**
  * Rechtsklik op het archief (bijv. `Sample1.zip`) → **7-Zip → Extract Here** en voer het standaard lab-/malware-archiefwachtwoord in (`infected`).
  * **[Aanvullend] CLI-equivalent (`7z` op Windows & Linux):**
```bash
# Pak een met wachtwoord beveiligd archief uit via de CLI
7z x Sample1.zip -pinfected
```
* **Tips & Security Best Practice:**
  * Malware-samples worden vrijwel altijd verspreid in wachtwoordbeveiligde `.zip`-bestanden (met standaardwachtwoorden zoals `infected` of `malware`) zodat antivirusscanners de payload niet al tijdens het downloaden blokkeren voordat een analist deze in een geïsoleerde sandbox kan onderzoeken.

#### Windows Security GUI (`Virus & threat protection`)
* **Doel:** Grafische interface voor het beheren van Microsoft Defender Antivirus:
  * **Current threats:** Toont het tijdstip van de laatste scan, het scantype, gevonden dreigingen, scanduur en aantal gescande bestanden.
  * **Manage settings:** Schakelt **Real-time protection** in of uit en beheert **Exclusions** (*Add or remove exclusions*).
  * **Threat history → Quarantined Threats:** Toont geblokkeerde dreigingen inclusief *Alert Level*, *Type* malware, details en een directe link naar *Microsoft Security Intelligence* (*Learn more*).

---

## 2. Algemene Uitleg & Theorie

### Malware & Categorieën
* **Definitie van Malware:** Afkorting van *Malicious Software* — software die ontworpen is om de normale werking van een computer of computernetwerk te verstoren, of om één of meerdere pijlers van de **CIA Triad** (*Confidentiality, Integrity, Availability*) te schenden.
* **Bredere definitie:** Software hoeft niet destructief te zijn om als malware te gelden; in brede zin is **elke software die handelt in het belang van een ander en niet in het belang van de gebruiker** malware.
* **Belangrijkste soorten malware:**
  * **Viruses** (hechten zich aan legitieme bestanden/programma's en vereisen gebruikersactie om te verspreiden)
  * **Worms** (verspreiden zich zelfstandig over netwerken zonder gebruikersinteractie)
  * **Trojans** (doen zich voor als legitieme, nuttige software maar bevatten verborgen kwaadaardige functionaliteit)
  * **Spyware & Keyloggers** (verzamelen ongemerkt gebruikersactiviteiten, gegevens of toetsaanslagen)
  * **Adware** (toont ongewenste advertenties en volgt vaak surfgedrag)
  * **Ransomware** (versleutelt bestanden of blokkeert systemen en eist losgeld)
  * **Cryptojacking software** (misbruikt heimelijk de rekenkracht van het slachtoffer om cryptovaluta te minen)

### Antivirus-functies & De Vier Detectietechnieken
Antivirus- of antimalwaresoftware kan bestanden scannen, een systeem in realtime monitoren, verdachte bestanden in quarantaine plaatsen (*quarantine*) en samenwerken met AI en **EDR** (*Endpoint Detection and Response*)-systemen om incidentrespons te automatiseren.

| Detectietechniek | Werking | Voordelen | Nadelen |
| :--- | :--- | :--- | :--- |
| **1. Signature-based** | Zoekt naar specifieke patronen (hashes of byte-sequenties) van bekende malware in een lokale database en plaatst overeenkomsten in quarantaine. | Zeer snel, lage systeembelasting en extreem laag aantal *false positives*. | Vereist voortdurende updates van nieuwe signatures; detecteert geen gloednieuwe (*zero-day*) malware. |
| **2. Heuristic** | Gebruikt statische en dynamische analyse; draait verdachte code in een afgeschermde **sandbox** om eigenschappen en Indicators of Compromise (zoals kwaadaardige IP's of bekende libraries) te beoordelen. | Kan nieuwe of onbekende varianten van malware detecteren zonder bestaande signature. | Rekenkundig zwaar (resource-intensief) en gevoeliger voor **false positives**. |
| **3. Behavior-based** | Een vorm van heuristische analyse die kijkt naar **wat het programma daadwerkelijk doet** in plaats van hoe de code eruitziet (*"als de code 'koe' zegt maar kwaakt, is het een eend"*). Stelt een baseline op van normaal gedrag en grijpt in bij afwijkingen. | Zeer effectief tegen versleutelde, gepackte of polymorfe malware die statische checks omzeilt. | Vereist nauwkeurige gedragsbaselines om legitieme beheertools niet onterecht te blokkeren. |
| **4. Adaptive (AI / ML)** | Combineert heuristische en gedragsgebaseerde analyse met *Machine Learning* en *Artificial Intelligence*. Leert autonoom van nieuwe dreigingen, genereert zelf nieuwe signatures en deelt deze direct met andere verbonden endpoints. | Snelle, geautomatiseerde bescherming tegen opkomende dreigingen binnen het hele netwerk. | Afhankelijk van cloud-telemetrie en geavanceerde endpoint-agents (zoals EDR). |

### Microsoft Defender Antivirus vs. Defender for Endpoint
* **Microsoft Defender Antivirus:** De standaard ingebouwde antivirusoplossing op Windows-systemen. Omdat Windows het meest aangevallen besturingssysteem is, heeft Microsoft dit sterk doorontwikkeld. De standaardversie is primair **signature-based**, lichtgewicht en zeer effectief als stand-alone antivirus.
* **Microsoft Defender for Endpoint (M365 E3 / E5):** De zakelijke uitbreiding voor organisaties met een Microsoft 365 E3- of E5-licentie. Voegt **adaptive analysis**, volledige **EDR-functionaliteit** (*Endpoint Detection and Response*) en centraal beheer toe bovenop Windows Defender.

---

## 3. Praktijkscenario's & Stappenplannen

### Scenario 1: Real-time Protection & Quarantaine Testen met een Malware Sample
Het controleren hoe Microsoft Defender Antivirus actief ingrijpt zodra een kwaadaardig bestand buiten een uitgesloten map wordt geplaatst:

1. **Controleer of Real-time Protection actief is:**
   * Open **Windows Security → Virus & threat protection → Manage settings** en verifieer dat **Real-time protection** op **On** staat.
2. **Pak het sample uit binnen een uitgesloten map (`C:\Evil`):**
   * Navigeer naar `C:\Evil`, rechtsklik op `Sample1.zip` → **7-Zip → Extract Here** en gebruik wachtwoord `infected`.
   * *Inzicht:* Het uitgepakte `.exe`-bestand blijft hier staan omdat `C:\Evil` op de uitsluitingslijst (*Exclusions*) van Defender staat.
3. **Verplaats of kopieer het bestand naar een bewaakte locatie (`C:\`):**
   * Kopieer het uitgepakte `.exe`-bestand naar de root van `C:\`.
   * *Resultaat:* Binnen enkele seconden verschijnt rechtsonder een melding dat er een dreiging is gedetecteerd en wordt het bestand automatisch van `C:\` verwijderd en in quarantaine geplaatst.
4. **Analyseer de detectie in Threat History:**
   * Open in Windows Security **Virus & threat protection → Threat history → Quarantined Threats**.
   * Vouw het record open en klik op **See details** (noteer het *Alert Level*, het *Type* malware en de exacte dreigingsnaam voor verdere threat intelligence-opzoeking).

### Scenario 2: Scan-uitsluiting Verwijderen & Handmatig Scannen via PowerShell
Wanneer een verdachte map onterecht is uitgesloten van antivirusscans (een veelvoorkomende aanvalstechniek) en je deze handmatig wilt opschonen:

1. **Bereid de testmap voor en schakel Real-time Protection tijdelijk uit (alleen in geïsoleerde labomgeving):**
   * Pak in `C:\Evil` het archief `Sample2.zip` uit met wachtwoord `infected`.
   * Zet in **Windows Security → Manage settings** tijdelijk *Real-time protection* uit zodat je de uitsluiting kunt verwijderen vóór de handmatige scan.
2. **Verwijder de uitsluiting (`C:\Evil`):**
   * Ga in **Manage settings** omlaag naar **Exclusions → Add or remove exclusions**, klik op het pijltje naast `C:\Evil` en kies **Remove** *(of gebruik in PowerShell `Remove-MpPreference -ExclusionPath "C:\Evil"` **[Aanvullend]**)*.
3. **Voer een gerichte Custom Scan uit via PowerShell (Admin):**
   ```powershell
   Start-MpScan -ScanPath C:\Evil\ -ScanType CustomScan
   ```
4. **Verifieer opschoning en beoordeel de vondst (Malware vs. Dual-Use Tool):**
   * Controleer dat de uitgepakte bestanden uit `Sample1` en `Sample2` zijn verwijderd en bekijk de details onder **Quarantined Threats** (of via `Get-MpThreatDetection` **[Aanvullend]**).
   * *SOC-inzicht:* Onderzoek de gedetecteerde dreigingsnaam altijd via Threat Intelligence. Sommige detecties betreffen geen pure malware, maar **offensive security / dual-use tools** (zoals Mimikatz, PsExec of netwerkscanners) die zowel door systeembeheerders/pentesters als door aanvallers kunnen worden gebruikt.

---

## 4. Aanvullende Bronnen & Referenties

* **Interne Commandoreferenties (SOC Analyst Map):**
  * Zie `PowerShell.md` voor `Start-MpScan`, `Update-MpSignature`, `Get-MpComputerStatus`, `Get-MpThreatDetection` en `Remove-MpPreference`.
  * Zie `BASH.md` voor het Linux-equivalent (`clamscan` / `freshclam`).
* **[Aanvullend] Officiële Documentatie & Threat Intelligence:**
  * [Microsoft Learn: Defender PowerShell Module](https://learn.microsoft.com/en-us/powershell/module/defender/) — Volledige referentie van alle Microsoft Defender Antivirus PowerShell-cmdlets.
  * [Microsoft Security Intelligence Threat Encyclopedia](https://www.microsoft.com/en-us/wdsi/threats) — Database om gedetecteerde Microsoft Defender-dreigingsnamen en gedrag op te zoeken.
  * [MITRE ATT&CK T1562.001: Impair Defenses — Disable or Modify Tools](https://attack.mitre.org/techniques/T1562/001/) — Techniek waarbij aanvallers Real-time Protection uitschakelen of mappen toevoegen aan Defender Exclusions.