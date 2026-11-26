# Network Reference Models

## 1. Overzicht van Relevante Commando's & Netwerktools


### A. Wireshark Display Filters & Analyse-acties

#### `tcp` (Wireshark Display Filter)
* **Doel:** Filtert de *Packet List* in Wireshark zodat uitsluitend pakketten worden getoond die het Transmission Control Protocol (TCP) bevatten (inclusief hogere applicatieprotocollen zoals HTTP die bovenop TCP zijn ingekapseld).
* **Praktijkgebruik:**
  ```text
  # Voer in de Wireshark Display Filter-balk in:
  tcp
  ```
* **Tips, Best Practices & Valkuilen:**
  * Wanneer je filtert op `tcp`, zie je in de kolom *Protocol* zowel `TCP` als `HTTP` staan. Dat komt omdat HTTP-verkeer (Layer 7) is ingekapseld in TCP-segmenten (Layer 4).
  * **[Aanvullend] Nuttige Wireshark-filters voor SOC-analisten:**
    * `http.request` / `http.response`: Toont uitsluitend HTTP-verzoeken of -antwoorden.
    * `ip.addr == <IP-adres>`: Filtert al het verkeer van of naar een specifiek IP-adres.
    * `tcp.port == 80 || tcp.port == 443`: Filtert specifiek op HTTP- of HTTPS-poortverkeer.
    * `wlan.fc.type_subtype == 0x08`: Filtert specifiek op draadloze 802.11 Beacon-frames.

### B. [Aanvullend] Relevante CLI-equivalenten voor Packet Capture & Netwerkmodel-inspectie

Hoewel dit hoofdstuk alleen Wireshark gebruikt, werken System Admins en SOC-analisten op servers zonder GUI met CLI-tools om pakketten per laag te inspecteren (zie ook `BASH.md`, `CMD.md` en `PowerShell.md`):
* **Linux (Debian/Ubuntu & Arch):**
  * `tcpdump -i eth0 -w capture.pcap`: Vangt netwerkverkeer af vanaf de CLI voor latere analyse in Wireshark (`-i` = **i**nterface, `-w` = **w**rite to file).
  * `tshark -r Practice.pcpng -Y "tcp"`: De CLI-variant van Wireshark (`-r` = **r**ead file, `-Y` = displa**Y** filter).
  * `ip link` (Layer 2 MAC-adressen) & `ip addr` (Layer 3 IP-adressen): Moderne vervangers van `ifconfig`.
  * `ss -tulnp` (Layer 4 TCP/UDP-poorten): Moderne vervanger van `netstat`.
* **Windows (CMD & PowerShell):**
  * `Get-NetAdapter` (Layer 2) & `Get-NetIPAddress` (Layer 3) in PowerShell, of `ipconfig /all` in CMD.
  * `Get-NetTCPConnection` (Layer 4) in PowerShell, of `netstat -ano` in CMD.
  * `pktmon start --etw` (Windows ingebouwde Packet Monitor).

---

## 2. Algemene Uitleg & Theorie

### Wat zijn Netwerkreferentiemodellen?
Netwerkcommunicatie kan complex lijken door de vele acroniemen en protocollen. **Netwerkreferentiemodellen** bieden conceptuele, abstracte weergaven van hoe data over een netwerk wordt verzonden. Ze zijn opgebouwd als een **stack van lagen**, waarbij elke laag afhankelijk is van de aangrenzende lagen:
* **Onderaan de stack:** Elektriciteit, nullen en enen (bits) en fysieke symbolen.
* **Bovenaan de stack:** Visuele webpagina's en opgemaakte tekst in een browser of e-mailclient.

### Encapsulation & Decapsulation
Data beweegt met een vaste richting door de stack:
1. **Encapsulation (Omlaag door de stack — verzenden):** Elke laag verpakt de data die hij van de bovenliggende laag ontvangt met extra besturingsinformatie in de vorm van **headers** (aan het begin) en/of **trailers** (aan het einde), en geeft het geheel door aan de laag eronder.
2. **Transmissie:** De volledig ingekapselde data wordt als signaal over het fysieke medium (kabel of draadloos) naar het doelsysteem gestuurd.
3. **Decapsulation (Omhoog door de stack — ontvangen):** Elke laag op het doelsysteem leest zijn eigen header/trailer, verwijdert (*stript*) deze informatie en geeft de resterende payload door aan de volgende hogere laag, totdat bovenaan alleen de oorspronkelijke data overblijft.

---

### Het OSI-model (7 Lagen)
Het **Open Systems Interconnection (OSI)**-model werd in de jaren 1970 ontwikkeld door de **ISO** (*International Standards Organization*) om interoperabiliteit tussen verschillende leveranciers te bevorderen en een universeel referentiekader te bieden naast merkspecifieke (*proprietary*) protocollen.

Het model bestaat uit **7 lagen**, onderverdeeld in **Host-lagen** (L5–L7, gericht op applicaties) en **Media-lagen** (L1–L4, gericht op adressering, transport en aflevering):

| Laag | Naam | Categorie | Functie & Belangrijke Concepten | Voorbeelden / Apparaten |
| :--- | :--- | :--- | :--- | :--- |
| **Layer 7** | **Application** | Host | Mens-computerinteractie; netwerkdiensten voor applicaties. | Web browsers, e-mailclients, HTTP |
| **Layer 6** | **Presentation** | Host | Formatteren, vertalen, **compressie/decompressie**, **encryptie/decryptie** en **encoding/decoding** zodat data bruikbaar is voor L7 of L5. | TLS/SSL-encryptie, ASCII, JPEG |
| **Layer 5** | **Session** | Host | Opzetten, onderhouden en afsluiten (*teardown*) van communicatiesessies, inclusief **authenticatie en autorisatie**. | Sessiebeheer, RPC |
| **Layer 4** | **Transport** | Media | End-to-end datatransport tussen hosts via **poorten** (bijv. HTTP poort 80, HTTPS poort 443); opdelen en weer samenvoegen (*reassembly*) van grote datastromen.<br>• **TCP:** Verstuurt *segments*; biedt betrouwbare aflevering (foutcontrole, juiste volgorde, herverzending bij pakketverlies), ten koste van snelheid.<br>• **UDP:** Verstuurt *datagrams*; "fire and forget" zonder foutcontrole of herverzending — ideaal voor snelheid (gaming, video streaming). | TCP, UDP, Layer 4 stateful firewalls |
| **Layer 3** | **Network** | Media | Datatransport tussen verschillende netwerken (**routing**) op basis van logische **IP-adressen**. | Routers, Layer 3 switches, IPv4/IPv6 packets |
| **Layer 2** | **Data Link** | Media | Datatransport tussen nodes binnen één lokaal netwerk (**switching**) op basis van fysieke **MAC-adressen** (op netwerkkaarten). Gebruikt **Frames** in plaats van packets. | Switches, Wi-Fi (IEEE 802.11), MAC-adressen |
| **Layer 1** | **Physical** | Media | Verzenden van ruwe **bits** (0 en 1) en symbolen over een fysiek medium (koperkabel, glasvezel, radiogolven/lucht). | Kabels, Wi-Fi-radiosignalen (2.4GHz / 5GHz) |

* **Evolutie van netwerkapparatuur langs de OSI-lagen:**
  * **Switches:** Traditioneel Layer 2-apparaten (schakelen op MAC-adres), maar moderne *Layer 3 switches* kunnen ook routeren tussen virtuele netwerken (VLAN's) op basis van IP-adressen.
  * **Firewalls:** Begonnen als simpele *packet filters* op Layer 3, evolueerden naar *stateful* firewalls op Layer 4 (volgen TCP-sessiestatussen) en zijn tegenwoordig *Next-Generation Firewalls (NGFW)* die tot op Layer 7 (applicatieniveau) inspecteren.
* **Ezelsbruggetjes (Mnemonics) voor OSI:**
  * **L7 → L1:** **A**ll **P**eople **S**eem **T**o **N**eed **D**ata **P**rocessing
  * **L1 → L7:** **P**eople **D**on’t **N**eed **T**hose **S**tupid **P**ackets **A**nyway

---

### Het TCP/IP-model (4 Lagen)
Waar het OSI-model vooral theoretisch en diagnostisch wordt gebruikt, is het **TCP/IP-model** het praktische model dat als **Internet Protocol Suite** het fundament vormt van het moderne internet. Het voegt meerdere OSI-lagen samen tot **4 lagen**:

| TCP/IP Laag | Naam | Overeenkomstige OSI-lagen | Kernfunctie |
| :--- | :--- | :--- | :--- |
| **Layer 4** | **Application** | Layer 5, 6 & 7 (Session, Presentation, Application) | Applicatieprotocollen, dataformattering en sessieafhandeling (HTTP, DNS, SSH). |
| **Layer 3** | **Transport** | Layer 4 (Transport) | Betrouwbare of snelle overdracht via poorten (TCP / UDP). |
| **Layer 2** | **Internet** | Layer 3 (Network) | Logische adressering en routering tussen netwerken (IP). |
| **Layer 1** | **Network Access** | Layer 1 & 2 (Physical, Data Link) | Fysieke overdracht en lokale netwerkadressering (Ethernet, Wi-Fi, MAC). |

* **Ezelsbruggetje (Mnemonic) voor TCP/IP (L4 → L1):** **A TIN** (**A**pplication, **T**ransport, **I**nternet, **N**etwork Access).
* **[Aanvullend] Protocol Data Units (PDU's) per laag:** In netwerkanalyse heeft data op elke laag een specifieke benaming: op L7–L5 heet het *Data*, op L4 een *Segment* (TCP) of *Datagram* (UDP), op L3 een *Packet* (IP), op L2 een *Frame* (Ethernet/802.11) en op L1 *Bits*.

---

## 3. Praktijkscenario's & Stappenplannen

### Scenario 1: Packet Capture Analyse in Wireshark (Draadloos & HTTP-verkeer Ontleden)
Wireshark gebruikt een hybride weergave tussen OSI en TCP/IP: het combineert OSI L5–L7 tot één *Application*-laag, maar houdt L1 (*Physical*) en L2 (*Data Link*) gescheiden. Bovendien toont Wireshark de **laagste laag bovenaan** en de **hoogste laag onderaan**.

1. **Open het capture-bestand en optimaliseer de weergave:**
   * Open `Practice.pcpng` in Wireshark.
   * Verberg het onderste *Packet Bytes*-venster via **View → Packet Bytes** zodat het *Packet List*-venster (boven) en het *Packet Details*-venster (midden) overzichtelijk zichtbaar zijn.
2. **Inspecteer Layer 1 (Physical) en Layer 2 (Data Link) in een Wireless Beacon-frame:**
   * Selecteer een draadloos *Beacon*-pakket (uitgezonden door een Wireless Access Point om zijn netwerk aan te kondigen).
   * *Wireshark Meta-laag (`Frame`):* Dit is geen OSI Layer 2-frame, maar Wireshark-metadata over het pakket, waaronder *Encapsulation type* en *Protocols in frame* (van laag naar hoog, bijv. radio + 802.11 WLAN).
   * *Physical Layer (`Radiotap Header v0` & `802.11 radio information`):* Toont datasnelheid, signaalsterkte in **dBm**, kanaal en frequentie (bijv. **2.4GHz** of **5GHz**). *(Opmerking: Bij een bekabelde Ethernet-capture begint Wireshark direct op Layer 2; alleen een draadloze capture bevat Layer 1 radio-informatie).*
   * *Data Link Layer (`IEEE 802.11 Beacon frame`):* Bevat de bron- en doel-**MAC-adressen**. Een broadcast-bestemming is te herkennen aan `ff:ff:ff:ff:ff:ff` (`FF` is de hoogste hexadecimale waarde); het bron-MAC-adres is de netwerkkaart van het WAP.
3. **Filter op TCP en volg de volledige encapsulation-stack van een HTTP-verzoek (Pakket nr. 841):**
   * Typ `tcp` in de display filter-balk en selecteer een `HTTP`-pakket.
   * Inspecteer van boven naar beneden (laag naar hoog in de stack):
     1. **Physical Layer:** Radio-informatie.
     2. **Data Link Layer:** IEEE 802.11 en Logical-Link Control (MAC-adressen).
     3. **Internet/Network Layer (`Internet Protocol Version 4`):** Bevat bron- en doel-**IP-adressen** en het ingekapselde protocol (`TCP`).
     4. **Transport Layer (`Transmission Control Protocol`):** Bevat bronpoort (willekeurig gekozen door client) en doelpoort (bijv. `80` voor HTTP), plus *Sequence*- en *Acknowledgement*-nummers voor foutcontrole en herassemblage.
     5. **Application Layer (`Hypertext Transfer Protocol`):** Toont het daadwerkelijke verzoek, zoals `GET / HTTP/1.1` en de volledige Host-URI.
4. **Analyseer de HTTP-response en lees de applicatiedata uit (Pakket nr. 844):**
   * Selecteer het bijbehorende HTTP-antwoordpakket.
   * Wireshark toont hier een extra Transport-rij voor de herassembleerde TCP-segmenten en een nieuwe Application-rij (`Line-based text data`) met de daadwerkelijke inhoud van de webpagina (in de lab-oefening staat hier de CTF-flag in `{brackets}`).
   * *Valkuil:* Verwar een CTF-"flag" (een unieke tekststring tussen `{}`) niet met **TCP-flags** (zoals `SYN`, `ACK`, `FIN`, `RST` in de TCP-header).

---

## 4. Aanvullende Bronnen & Referenties

* **Interne Commandoreferenties (SOC Analyst Map):**
  * Zie `BASH.md`, `CMD.md` en `PowerShell.md` voor CLI-netwerkcommando's waarmee je Layer 2- (MAC), Layer 3- (IP/routing) en Layer 4- (poorten/sessies) informatie op Linux en Windows opvraagt.
* **[Aanvullend] Officiële Documentatie & Hulpmiddelen:**
  * [Wireshark User's Guide](https://www.wireshark.org/docs/wsug_html_chunked/) — Officiële handleiding voor pakketanalyse en display filters.
  * [Wireshark Display Filter Reference](https://www.wireshark.org/docs/dfref/) — Volledig overzicht van alle protocolfilters in Wireshark.
  * [RFC 1122: Requirements for Internet Hosts — Communication Layers](https://datatracker.ietf.org/doc/html/rfc1122) — Officiële IETF-specificatie van de TCP/IP-architectuur.