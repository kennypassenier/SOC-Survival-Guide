# Nmap Basics

## 1. Overzicht van Relevante Commando's & Scan-opties

### A. Nmap Basisscans & TCP Scan-types (`-sT`, `-sS`, `-sA`, `-sU`)

#### `nmap` (Zonder root / TCP Connect Scan `-sT`)
* **Doel:** Voert een netwerkscan uit om actieve hosts en open poorten op een doelwit te ontdekken. Zonder `root`-rechten gebruikt Nmap standaard een **TCP Connect Scan (`-sT`)**.
* **Parameters & Opties:**
  * `-sT` (`s` = **s**can, `T` = **T**CP Connect / *full-open scan*): Voltooit de volledige TCP 3-way handshake (`SYN` → `SYN/ACK` → `ACK`) en sluit de verbinding daarna direct af (`ACK`, `RST`).
* **Praktijkgebruik:**
  ```bash
  # Voer een TCP Connect scan uit zonder root-rechten (standaard op top 1000 poorten)
  nmap 192.168.0.1
  nmap -sT 192.168.0.1
  ```

#### `sudo nmap` (Met root / SYN Stealth Scan `-sS` & Overige Scan-types)
* **Doel:** Met `root`-rechten (`sudo`) kan Nmap ruwe netwerkpakketten (*raw packets*) verzenden en gebruikt het standaard een **SYN Stealth Scan (`-sS`)**, wat sneller is en minder bandbreedte verbruikt.
* **Parameters & Opties:**
  * `-sS` (`s` = **s**can, `S` = **S**YN Stealth / *half-open scan*): Begint de TCP 3-way handshake (`SYN`), ontvangt `SYN/ACK` als de poort open is, maar breekt de verbinding abrupt af met een reset-pakket (`RST`) zonder de handshake te voltooien.
  * `-sA` (`A` = **A**CK scan): Verstuurt TCP `ACK`-pakketten om firewallregelsets en stateful vs. stateless filtering in kaart te brengen.
  * `-sU` (`U` = **U**DP scan): Scant op open **UDP**-poorten (zoals DNS poort 53, DHCP 67/68 of SNMP 161).
* **Praktijkgebruik:**
  ```bash
  # Voer een SYN Stealth scan uit met root-rechten (standaard bij sudo nmap)
  sudo nmap 192.168.0.1
  sudo nmap -sS 192.168.0.1
  ```
* **Tips & Valkuilen:**
  * **De term "Stealth":** `-sS` heet *stealth* omdat applicatielogs vaak alleen volledig voltooide TCP-verbindingen registreren. Moderne firewalls en IDS/IPS-systemen detecteren half-open SYN-scans echter net zo goed als connect-scans.
  * **Verschillen in scanresultaten:** Hoewel `-sS` en `-sT` meestal dezelfde open poorten vinden, kunnen strikte pakketfilters of rate-limiting ervoor zorgen dat een trage `-sT`-scan poorten ontdekt die bij een snelle `-sS`-scan als `filtered` worden gemarkeerd.

---

### B. Poortselectie (`-p`, `-p-`, `--top-ports`, `-F`)

#### Poort-specificatie Opties
* **Doel:** Bepaalt welke specifieke poorten Nmap controleert in plaats van de standaard top 1.000 meest voorkomende poorten.
* **Parameters & Opties:**
  * `-p <poorten>`: Scant een enkele poort (`-p 21`), een bereik (`-p 1-1000`), een kommagescheiden lijst (`-p 22,25,8080`) of een combinatie daarvan.
  * `-p-`: Verkorte notatie voor **alle 65.535 TCP-poorten** (gelijk aan `-p 1-65535`).
  * `--top-ports <aantal>`: Scant uitsluitend de `<aantal>` meest voorkomende poorten (bijv. `--top-ports 50`).
  * `-F` (`F` = **F**ast): Verkorte notatie voor `--top-ports 100` (scant de top 100 poorten).
* **Praktijkgebruik & Permutaties:**
  ```bash
  # Zoek specifiek naar webservers op veelgebruikte HTTP/HTTPS-poorten
  nmap -p 80,443,8080,8443 192.168.0.20

  # Scan de top 50 of top 100 (-F) meest voorkomende poorten
  nmap --top-ports 50 192.168.0.0/24
  sudo nmap -Pn 192.168.0.2-100 -F

  # Scan alle 65.535 poorten op een doelhost
  sudo nmap -Pn 192.168.0.20 -T5 -p-
  ```

---

### C. Host Discovery (`-sn`, `-Pn`, `--reason`)

#### Host Discovery Opties
* **Doel:** Bepaalt hoe Nmap actieve hosts op een netwerk opspoort vóór (of zonder) het scannen van poorten.
* **Parameters & Opties:**
  * `-sn` (voorheen `-sP` — *No port scan* / *Ping scan*): Schakelt poortscanning volledig uit en voert **uitsluitend Host Discovery** uit om te inventariseren welke IP-adressen online zijn.
  * `-Pn` (*No ping* / *Treat all hosts as online*): Slaat de Host Discovery-fase volledig over en gaat ervan uit dat alle opgegeven doelhosts online zijn.
  * `--reason`: Toont de exacte reden waarom Nmap een host als *up* of een poort als *open/closed/filtered* heeft geclassificeerd (bijv. `arp-response`, `syn-ack` of `reset`).
* **Praktijkgebruik & Permutaties:**
  ```bash
  # Voer alleen Host Discovery uit op een subnet en toon hoe elke host is gevonden
  sudo nmap -sn 192.168.0.0/24
  sudo nmap -sn --reason 192.168.0.0/24

  # Sla Host Discovery over (-Pn) wanneer doelhosts ICMP/ping-probes blokkeren
  sudo nmap -Pn 192.168.0.2-100 -F
  ```
* **Tips & Valkuilen:**
  * **ARP Discovery op lokale netwerken:** Wanneer je `sudo nmap -sn` uitvoert op hetzelfde lokale subnet, gebruikt Nmap **ARP-broadcasts** (*wie heeft dit IP en wat is je MAC-adres?*) om actieve hosts te ontdekken, wat veel betrouwbaarder is dan ICMP ping.
  * **Waarom `-Pn` onmisbaar is:** Standaard scant Nmap geen poorten op een host die niet reageert tijdens Host Discovery. Omdat moderne firewalls en Windows-hosts ICMP-pings standaard blokkeren, gebruik je `-Pn` om Nmap te dwingen toch direct de poorten te scannen.

---

### D. OS-detectie, Service-enumeratie & Timing (`-O`, `--osscan-guess`, `-sV`, `-T0` t/m `-T5`)

#### Fingerprinting & Timing Opties
* **Doel:**
  * `-O` (`O` = **O**perating System): Analyseert TCP/IP-stack-antwoorden om het besturingssysteem van de doelhost te identificeren.
  * `--osscan-guess`: Dwingt Nmap om agressiever de beste gokken weer te geven wanneer er geen exacte OS-fingerprint-match is.
  * `-sV` (`s` = **s**can, `V` = **V**ersion): Stuurt specifieke applicatie-probes naar open poorten om de exacte **servicedienst en softwareversie** te achterhalen (cruciaal voor kwetsbaarheidsanalyse).
  * `-T<0-5>` (`T` = **T**iming template): Regelt de scansnelheid van `0` (*Paranoid* — extreem traag voor IDS-evasion), `1` (*Sneaky*), `2` (*Polite*), `3` (*Normal* — standaard), `4` (*Aggressive*) tot `5` (*Insane* — extreem snel, maar kan pakketverlies of rate-limiting veroorzaken).
* **Praktijkgebruik & Permutaties:**
  ```bash
  # Achterhaal welke software en versie op poort 21 (FTP) draait
  sudo nmap -sV 192.168.0.20 -p 21

  # Detecteer het besturingssysteem (met agressieve schatting indien nodig)
  sudo nmap -O 192.168.0.20
  sudo nmap -O --osscan-guess 192.168.0.20

  # Voer een trage, beleefde scan (-T1) uit om rate-limiting/pakketfilters te omzeilen
  nmap -Pn 192.168.0.2 -T1 -p 22,25,1000,2099,8080,8888
  ```
* **[Aanvullend] Geavanceerde Nmap-vlaggen & Windows/Linux-alternatieven:**
  * `-sC` (of `--script=default`): Voert Nmap's standaard **NSE-scripts** (*Nmap Scripting Engine*) uit voor diepere enumeratie (bijv. SSL-certificaten, SMB-shares, HTTP-titels).
  * `-A` (*Aggressive scan*): Combineert `-O` (OS-detectie), `-sV` (versiedetectie), `-sC` (default scripts) en `--traceroute` in één opdracht (`sudo nmap -A 192.168.0.20`).
  * `-oA <bestandsnaam>` (`oA` = **o**utput **A**ll formats): Slaat scanresultaten tegelijk op in `.nmap` (leesbaar), `.gnmap` (grepable) en `.xml` (voor import in rapportagetools).
  * **Windows PowerShell-alternatief (zonder Nmap):** Voor snelle verificatie van afzonderlijke poorten zonder extra software gebruik je `Test-NetConnection -ComputerName 192.168.0.20 -Port 21` (of een lus `21,22,80,443 | ForEach-Object { Test-NetConnection 192.168.0.20 -Port $_ }`).

---

## 2. Algemene Uitleg & Theorie

### Scanning vs. Enumeration & De 4 Nmap-fasen
* **Scanning:** Het in kaart brengen van een netwerk om **actieve hosts**, **open poorten** en de **typen diensten** op die poorten te ontdekken.
* **Enumeration:** Het actief verzamelen van gedetailleerde informatie over de gevonden hosts en poorten — zoals het **besturingssysteem**, de **exacte softwareversies** en eventuele bekende kwetsbaarheden (*CVE's*) die bij die versies horen.
* **De vier kernfasen uit dit hoofdstuk (van de 11 totale fasen in een Nmap-scan):**
  1. **Host Discovery** (Ping scanning — *Scanning*)
  2. **Port Scanning** (*Scanning*)
  3. **Operating System Detection** (*Enumeration*)
  4. **Service / Service Version Detection** (*Enumeration*)

### TCP Poorten, De 3-Way Handshake & Fingerprinting
* **IP-adres vs. Poort:** Een IP-adres identificeert de host (het straatadres van een appartementencomplex); een **poortnummer** identificeert de specifieke netwerkapplicatie op die host (het huisnummer/appartement).
* **TCP 3-Way Handshake:** Elke reguliere TCP-verbinding start met drie stappen:
  1. **Client → Server:** `SYN` (*Synchronize*)
  2. **Server → Client:** `SYN/ACK` (*Synchronize / Acknowledge*)
  3. **Client → Server:** `ACK` (*Acknowledge*)
  * Omdat een open TCP-poort altijd met `SYN/ACK` antwoordt op een `SYN`-verzoek, kan Nmap betrouwbaar vaststellen of er een dienst luistert.
* **Fingerprinting:** Nmap stuurt zorgvuldig samengestelde netwerkpakketten (*probes*) en vergelijkt de subtiele verschillen in antwoorden met zijn interne database van **fingerprints** om het exacte besturingssysteem en de applicatieversie te onderscheiden.

### De Drie Primaire Nmap Poortstatussen

| Poortstatus | Betekenis | Netwerkgedrag & Interpretatie |
| :--- | :--- | :--- |
| **`open`** | De poort is bereikbaar en er **luistert actief een applicatie/dienst** op. | De doelhost antwoordt met `SYN/ACK` op een TCP `SYN`-probe. |
| **`closed`** | De poort is bereikbaar, maar er **luistert momenteel geen dienst** op. | De doelhost is online en niet geblokkeerd door een firewall, maar stuurt direct een TCP `RST` (*Reset*) terug (*"de deur is open, maar er is niemand thuis"*). |
| **`filtered`** | Nmap kan niet bepalen of de poort open of gesloten is omdat de probes worden geblokkeerd. | Pakketten worden onderweg tegengehouden (meestal door een **firewall**, router-ACL of pakketfilter die pakketten dropt zonder antwoord). |

---

## 3. Praktijkscenario's & Stappenplannen

### Scenario 1: Een Onbekend Subnet in Kaart Brengen & Enumereren
Een gestandaardiseerde verkenningsworkflow van breed en snel naar gericht en diepgaand:

1. **Inventariseer welke hosts actief zijn op het subnet (`Host Discovery`):**
   ```bash
   sudo nmap -sn --reason 192.168.0.0/24
   ```
   * Noteer de gevonden actieve IP-adressen en de door Nmap uitgevoerde reverse DNS-namen (bijv. `webserver` en `fileserver`).
2. **Voer een snelle scan uit op de top 100 poorten van de ontdekte hosts:**
   ```bash
   sudo nmap -Pn 192.168.0.2-100 -F
   ```
   * Gebruik `-Pn` zodat hosts die ICMP/ARP-probes blokkeren niet worden overgeslagen.
3. **Enumereer softwareversies en het besturingssysteem op specifieke open poorten:**
   ```bash
   sudo nmap -sV 192.168.0.20 -p 21
   sudo nmap -O --osscan-guess 192.168.0.20
   ```
4. **Controleer alle 65.535 poorten op verborgen diensten op hoge poortnummers:**
   ```bash
   sudo nmap -Pn 192.168.0.20 -T5 -p-
   ```

### Scenario 2: Omzeilen van Rate-Limiting & Pakketfilters op een Gefilterde Host
Wanneer een snelle scan (`-T5` met `-sS`) op een doelhost (zoals `192.168.0.2`) de meeste poorten als `filtered` rapporteert:

1. **Analyseer waarom snelle scans falen:**
   * Een firewall, IPS of pakketfilter kan hoge pakketsnelheden (`-T5`) aanzien voor een Denial-of-Service-aanval of half-open `SYN`-pakketten zonder volledige handshake (`-sS`) blokkeren.
2. **Schakel over op een langzamere timing (`-T1` Polite) en een volledige TCP Connect scan (`nmap` zonder `sudo` / `-sT`):**
   ```bash
   nmap -Pn 192.168.0.2 -T1 -p 22,25,1000,2099,8080,8888
   ```
   * *Inzicht:* Door de scan te vertragen (`-T1`) en de volledige TCP 3-way handshake af te ronden (`-sT`), worden tijdelijke rate-limits omzeild en komen werkelijk open poorten alsnog naar voren. Goede verkenning draait om het combineren en vergelijken van meerdere scanprofielen.

---

## 4. Aanvullende Bronnen & Referenties

* **Interne Commandoreferenties (SOC Analyst Map):**
  * Zie `BASH.md` (Sectie 5: *Netwerkbeheer, Monitoring & Firewalls*) voor `nmap` scan-types, poortselectie, host discovery en timing-templates.
  * Zie `PowerShell.md` voor het Windows-alternatief (`Test-NetConnection`).
* **[Aanvullend] Officiële Documentatie & Hulpmiddelen:**
  * [Nmap Official Reference Guide (Man Page)](https://nmap.org/book/man.html) — Volledige documentatie van alle scan-types, poortstatussen (`open|filtered`, `closed|filtered`, `unfiltered`), timing-templates en NSE-scripts.
  * [Nmap Port Scanning Basics](https://nmap.org/book/man-port-scanning-basics.html) — Diepgaande uitleg over de zes poortstatussen in Nmap.