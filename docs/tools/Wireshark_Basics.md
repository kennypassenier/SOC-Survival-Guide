# Wireshark Basics

## 1. Overzicht van Relevante Commando's & Wireshark Filters

### A. Netwerk-emulatie & Packet Capture Opstarten (`clabnet`, `xterm`, `wireshark`, `tcpdump`)

#### `clabnet` & `xterm h1`
* **Doel:** Start de geëmuleerde netwerktopologie (*Mininet* met werkstation `h1` en servers `webserver`, `fileserver`, `utilserver`) en opent een grafisch terminalvenster op host `h1`.
* **Praktijkgebruik:**
  ```bash
  # Start het geëmuleerde labnetwerk als root
  clabnet

  # Open binnen de mininet> prompt een terminal voor werkstation h1
  xterm h1

  # Voer vanaf mininet> een volledige connectiviteitstest uit tussen alle hosts
  pingall
  ```

#### `wireshark &`
* **Doel:** Start de grafische netwerkprotocol-analyzer **Wireshark** op de achtergrond (`&`) vanuit de terminal zodat de terminal bruikbaar blijft voor andere opdrachten.
* **Praktijkgebruik:**
  ```bash
  # Start Wireshark vanuit de h1-terminal op de achtergrond
  wireshark&
  ```
* **Tips, Valkuilen & Modernere Mogelijkheden:**
  * Kies in een geëmuleerde omgeving (zoals Mininet) de virtuele netwerkinterface van de host (bijv. `h1-eth1`), en niet de standaard interface van de onderliggende lab-VM.
  * In productieomgevingen worden captures meestal niet op individuele endpoints gedraaid, maar op een **SPAN-poort (port mirroring)** van een switch of router, zodat al het passerende verkeer wordt gekopieerd.
  * **[Aanvullend] CLI-alternatieven zonder GUI (`tshark` & `tcpdump`):**
    * Op headless Linux-servers (Debian/Ubuntu & Arch) zonder grafische omgeving gebruik je **`tshark`** (de officiële CLI-versie van Wireshark) of **`tcpdump`** om verkeer op te vangen en later in Wireshark te openen:
```bash
# Leg verkeer op interface eth0 vast naar een .pcap-bestand voor analyse in Wireshark
sudo tcpdump -i eth0 -w capture.pcap

# Of gebruik tshark met een direct display filter (-Y)
sudo tshark -i eth0 -Y "http or dns"
```

---

### B. Wireshark Display Filters & Capture Filters

#### Display Filter Expressies (Tijdens of na de capture)
* **Doel:** Filtert welke reeds vastgelegde pakketten in het *Packet List*-venster worden weergegeven (zonder de overige vastgelegde pakketten uit de capture te verwijderen).
* **Belangrijkste Filter-syntaxis & Operatoren:**

| Filterexpressie | Betekenis & Werking |
| :--- | :--- |
| `icmp` | Toont uitsluitend ICMP-verkeer (zoals `ping` Echo Requests en Replies). |
| `arp` | Toont ARP-verkeer (IP-naar-MAC-adresresolutie op het lokale subnet). |
| `http` | Toont alle HTTP-verkeer. |
| `http.cookie` | Toont uitsluitend HTTP-pakketten die een `Cookie`-header bevatten. |
| `telnet` | Toont alle Telnet-verkeer (onversleutelde remote terminal-sessies). |
| `ftp` | Toont FTP-besturingsverkeer (*control channel* op TCP poort 21: login, commando's). |
| `ftp-data` | Toont het aparte FTP-datakanaal waarop daadwerkelijke bestandsinhoud wordt verzonden. |
| `ip.src == 192.168.0.1` | Toont pakketten afkomstig van bron-IP `192.168.0.1`. |
| `ip.dst == 192.168.0.1` | Toont pakketten bestemd voor doel-IP `192.168.0.1`. |
| `ip.addr == 192.168.0.1` | Verkorte notatie voor `ip.src == 192.168.0.1 or ip.dst == 192.168.0.1` (alle verkeer van of naar dit IP). |
| `ether.addr == 00:01:02:03:04:05` | Toont pakketten met het opgegeven MAC-adres. |
| `tcp.port == 22` | Toont pakketten met bron- of bestemmingspoort TCP `22` (SSH). |
| `http or dns` / `icmp or arp` | Logische `or`: toont pakketten die aan minstens één van beide voorwaarden voldoen. |
| `!(arp or icmp or dns)` | Logische negatie (`!`): verbergt alle ruis van ARP-, ICMP- en DNS-pakketten. |
| `ip.addr == 192.168.1.1 && ip.addr == 172.16.0.1 and http` | Combineert een *Conversation Filter* met een specifiek applicatieprotocol. |

* **Tips & Valkuilen (Capture Filter vs. Display Filter):**
  * **Capture Filter** (ingesteld *vóór* het starten van de capture boven de interfacelijst, bijv. `host 192.168.1.1` of `tcp port 80`): neemt **uitsluitend** pakketten op die aan het filter voldoen. Pakketten die niet matchen worden definitief weggegooid en kunnen achteraf niet meer worden teruggehaald.
  * **Display Filter** (onder de menubalk): neemt **alles** op en verbergt tijdelijk wat je niet wilt zien. Gebruik bij incident response en forensics bij voorkeur eerst een volledige capture met achteraf Display Filters.
  * **[Aanvullend] Handige SOC Triage Display Filters:**
    * `tcp.flags.syn == 1 and tcp.flags.ack == 0`: Spoort uitgaande TCP-verbindingspogingen en mogelijke SYN-scans op.
    * `http.request.method == "POST"`: Filtert op verzonden formulieren, inloggegevens en bestandsuploads.
    * `dns.qry.name contains "evil"`: Zoekt naar specifieke domeinaanvragen in DNS-verkeer.

---

### C. Verkeersgeneratie & Cleartext Protocollen (`ftp`, `telnet`)

#### `ftp` & `telnet` (Onversleutelde legacy-protocollen)
* **Doel:**
  * `ftp <host>`: Start een interactieve File Transfer Protocol-sessie (gebruikt TCP poort `21` voor opdrachten en een apart datakanaal `ftp-data` voor bestandsoverdracht).
  * `telnet <host>`: Opent een onversleutelde remote terminal-sessie op TCP poort `23`.
* **Praktijkgebruik (Lab-opdrachten):**
  ```bash
  # Verbind met een FTP-server, bekijk en download een bestand (let op: alles in cleartext!)
  ftp fileserver
  # Binnen ftp>: ls | get passwords.txt | delete passwords.txt | exit

  # Verbind met een Telnet-server (in productie altijd vervangen door SSH)
  telnet utilserver
  # Binnen telnet-sessie: pwd | ls | cat servers.txt | exit
  ```
* **Security Best Practice:** Gebruik in productieomgevingen **nooit** `telnet` of standaard `ftp`, omdat zowel gebruikersnamen en wachtwoorden als alle overgedragen bestanden volledig onversleuteld (*cleartext*) over het netwerk gaan. Vervang deze door **SSH (`ssh`)** en **SFTP (`sftp`)** of **SCP (`scp`)**.

---

## 2. Algemene Uitleg & Theorie

### Wat is Wireshark & Toepassingen per Rol
* **Definitie:** Wireshark is een krachtige **packet / traffic / protocol analyzer** (een "röntgenapparaat voor computernetwerken") waarmee netwerkpakketten worden onderschept en op elk protocollaagniveau worden geïnspecteerd.
* **Protocollen vs. Pakketten:** Netwerkprotocollen (zoals IPv4, TCP, HTTP) zijn de strikte communicatieregels ("grammatica en syntaxis") waarmee systemen zonder ruimte voor interpretatie met elkaar spreken; pakketten zijn de afzonderlijke "woorden" die over de lijn gaan.
* **Praktisch gebruik per vakgebied:**
  * **Network Engineers:** Netwerkprestaties en verbindingsproblemen analyseren.
  * **Security Analysts (SOC):** Inbraakpogingen (*intrusion attempts*) onderzoeken en beveiligingscontroles valideren.
  * **Forensic Analysts:** Datalekken (*security breaches*) en malwareverspreiding reconstrueren vanuit `.pcap`-captures.
  * **Penetration Testers:** Onversleutelde gevoelige gegevens (wachtwoorden, sessietokens, bestanden) opsporen op het netwerk.

### De Wireshark GUI & De Drie Hoofdvensters (Panes)
Na het starten van een capture op het startscherm (waar netwerkinterfaces zoals Ethernet, Wi-Fi/WLAN, Bluetooth, USB of SSH-remote captures worden gekozen) opent het hoofdvenster met **drie gesynchroniseerde deelvensters**:

1. **Packet List (Bovenste deelvenster):**
   * Chronologische lijst van alle vastgelegde pakketten met kolommen voor pakketnummer, tijdstempel, bron-IP (*Source*), doel-IP (*Destination*), protocol, lengte en een samenvatting (*Info*).
   * De kleurcodering van rijen wordt bepaald door filterregels onder **View → Coloring Rules...**.
2. **Packet Details (Middelste deelvenster):**
   * Toont de opbouw van het geselecteerde pakket als een hiërarchie van ingekapselde protocollen (*nesting dolls*, van Layer 1/2 Ethernet bovenaan tot Layer 7 HTTP onderaan).
   * Door velden open te klappen kun je specifieke headers inspecteren (zoals `Hypertext Transfer Protocol → Cookie`).
3. **Packet Bytes (Onderste deelvenster):**
   * Toont de ruwe inhoud van het geselecteerde pakket in **hexadecimaal (base 16)** links en **ASCII-tekst** rechts.
   * Bij onversleuteld (*cleartext*) verkeer zijn wachtwoorden, commando's en bestandsinhoud hier direct leesbaar. Selecteren van een veld in *Packet Details* markeert automatisch de bijbehorende bytes in *Packet Bytes* (en omgekeerd).

### Streams, Conversations & File Reconstruction
* **Follow TCP Stream / Follow HTTP Stream:**
  * Rechtsklikken op een pakket → **Follow → TCP Stream** (of **HTTP Stream**) groepeert alle pakketten van die ene specifieke sessie (op basis van IP-adressen, poorten en TCP-vlaggen zoals `SYN` aan het begin en `FIN`/`RST` aan het einde).
  * In het streamvenster wordt verkeer van de **client in rood** en antwoorden van de **server in blauw** weergegeven.
  * *Valkuil bij Telnet-streams:* In Telnet worden getypte tekens één voor één door de server teruggestuurd (*echoed*) zodat ze op het scherm van de gebruiker verschijnen (waardoor een gebruikersnaam als `ttuusseerr` oogt), terwijl wachtwoorden niet worden ge-echood en elk teken dus maar één keer verschijnt.
* **Conversations (`Conversation Filter → IPv4`):**
  * Groepeert **al het verkeer** tussen twee specifieke IP-adressen, ongeacht het gebruikte protocol of het aantal losse sessies (ideaal als startpunt voor verbindingsloze protocollen zoals HTTP).
* **Objecten Extraheren (`File → Export Objects → HTTP`):**
  * Omdat Wireshark alle bytes vastlegt die over het netwerk gaan, kan het gedownloade bestanden (zoals een kwaadaardig script, `.elf`-bestand of afbeelding die de gebruiker direct na downloaden heeft gewist) volledig reconstrueren en opslaan via **File → Export Objects → HTTP**.

---

## 3. Praktijkscenario's & Stappenplannen

### Scenario 1: Cleartext Credentials & Gedownloade Bestanden Reconstrueren (SOC / Forensics)
Wanneer een gebruiker verdachte activiteiten heeft uitgevoerd (zoals inloggen op een webapplicatie en een bestand downloaden dat daarna is verwijderd) en je de `.pcap`-capture analyseert:

1. **Analyseer ARP- en ICMP-verkeer voor netwerkoverzicht en afwijkingen:**
   * Gebruik het display filter `icmp or arp` om actieve hosts op het lokale subnet te zien en te controleren op tekenen van *MAC spoofing* of *Man-in-the-Middle (MITM)*-aanvallen.
2. **Extraheer gelekte inloggegevens en commando's uit cleartext-sessies (Telnet & FTP):**
   * Filter op `telnet`, klik met rechts op een pakket van de eerste sessie en kies **Follow → TCP Stream** (rood = clientinvoer, blauw = serveruitvoer) om de gebruikersnaam, het wachtwoord en de bekeken bestanden (`servers.txt`) uit te lezen.
   * Filter op `ftp` → **Follow → TCP Stream** om FTP-inloggegevens te zien, en gebruik vervolgens het filter **`ftp-data`** → **Follow → TCP Stream** op het bestandspakket (`passwords.txt`) om de inhoud van het overgedragen bestand terug te halen.
3. **Onderzoek HTTP-sessies, persistente cookies en gedownloade bestanden:**
   * Selecteer een pakket tussen client en webserver, kies **Conversation Filter → IPv4** en voeg `and http` toe aan de filterbalk.
   * Gebruik **Follow → HTTP Stream** op een HTTP-pakket om de server-header (zoals de Python-versie) en de HTTP-requests/responses te bekijken.
   * Filter op `http.cookie` en inspecteer pakketten na het `/logout`-verzoek om te controleren of tracking- of sessiecookies na uitloggen actief blijven.
4. **Herstel een door de gebruiker verwijderd gedownload bestand rechtstreeks uit de capture:**
   * Ga in het menu naar **File → Export Objects → HTTP**.
   * Selecteer het gedownloade object (bijv. `download`) in de lijst en klik op **Save** om het bestand veilig op schijf op te slaan voor forensische inspectie.

---

## 4. Aanvullende Bronnen & Referenties

* **Interne Commandoreferenties (SOC Analyst Map):**
  * Zie `BASH.md` (Sectie 5: *Netwerkbeheer, Monitoring & Firewalls*) voor `wireshark`, `tshark`, `tcpdump`, `clabnet`, `ftp` en `telnet`.
* **[Aanvullend] Officiële Documentatie & Cheat Sheets:**
  * [Wireshark User's Guide: User Interface & Display Filters](https://www.wireshark.org/docs/wsug_html_chunked/) — Officiële documentatie van alle Wireshark-vensters, capture/display filters en object-exportfuncties.
  * [Wireshark Display Filter Reference](https://www.wireshark.org/docs/dfref/) — Volledige naslagdatabase van alle protocolspecifieke filtervelden (`http.*`, `tcp.*`, `dns.*`, `arp.*`).
  * [StationX Wireshark Cheat Sheet](https://www.stationx.net/wireshark-cheat-sheet) — Overzichtelijke cheat sheet met veelgebruikte Wireshark capture- en display-filters.