# OSI-Model Deep Dive: Van Klik op Laptop tot Webserver en Terug

Deze gids volgt **elke afzonderlijke stap** van één HTTP-webpagina-aanvraag (`http://www.voorbeeld.be/index.html`) tot op het niveau van bits, headers, netwerkapparaten en protocollen, inclusief de exacte opbouw van het pakket of frame bij iedere tussenstap.

---

## De Netwerktopologie & Adressen in dit Voorbeeld

Om elke header exact te kunnen invullen, gaan we uit van de volgende opstelling:

```text
[Laptop] ~~~Wi-Fi~~~ [Access Point] ---UTP--- [Switch] ---UTP--- [Router] ---Coax/Glas--- [Modem] === [ISP Netwerk] === [Webserver]
```

| Apparaat / Entiteit | Lokaal IP (LAN) | Publiek IP (WAN) | MAC-adres (Fysiek) | Rol in het netwerk |
| :--- | :--- | :--- | :--- | :--- |
| **Laptop** | `192.168.1.15` | *(geen)* | `AA:AA:AA:11:11:11` | Cliënt (stuurt aanvraag) |
| **Access Point (AP)** | `192.168.1.2` | *(geen)* | `BB:BB:BB:22:22:22` | Bridge tussen Wi-Fi (802.11) en kabel (802.3) |
| **Netwerk Switch** | *(geen IP nodig)* | *(geen)* | *(transparant)* | Stuurt frames door op basis van MAC-adres |
| **Thuisrouter** | `192.168.1.1` *(Gateway)* | `84.192.10.50` | `CC:CC:CC:33:33:33` *(LAN)* | Routeert tussen LAN en WAN, doet NAT |
| **Modem** | *(transparant)* | *(transparant)* | *(transparant)* | Zet digitale signalen om voor de ISP-lijn |
| **DNS-Server (ISP)** | *(extern)* | `195.130.130.1` | *(achter router)* | Vertaalt domeinnamen naar IP-adressen |
| **Webserver** | *(extern)* | `93.184.216.34` | *(achter router)* | Host van `www.voorbeeld.be` |

---

## Fase 0: Voorbereiding – DNS & ARP (Wat er gebeurt vóór de HTTP-request)

Voordat de laptop ook maar één HTTP-pakket kan versturen, zijn twee essentiële stukjes informatie nodig:
1. Het **IP-adres** van `www.voorbeeld.be` (via **DNS**).
2. Het **MAC-adres** van de thuisrouter om het pakket het lokale netwerk uit te krijgen (via **ARP**).

### Stap 0A: DNS-resolutie (Domeinnaam -> IP-adres)
1. **Browser- & OS-cache check (Laag 7):** De gebruiker typt `http://www.voorbeeld.be/index.html` en drukt op Enter. De laptop kijkt eerst in het eigen geheugen (*DNS-cache*) en het `hosts`-bestand of het IP-adres al bekend is. Zo niet, dan maakt de DNS-client een **DNS Query** (`A-record` aanvraag voor `www.voorbeeld.be`).
2. **Encapsulatie & verzending:** Omdat DNS snelheid verkiest boven hertransmissie, wordt dit verzoek verpakt in een **UDP-datagram** (poort `53`) en een **IP-pakket** richting de DNS-server van de provider (`195.130.130.1`). De router past hierbij NAT toe (bron-IP wordt `84.192.10.50`).
3. **DNS-antwoord:** De DNS-server zoekt het adres op en stuurt een UDP-pakket terug met het antwoord: `www.voorbeeld.be = 93.184.216.34`.

```text
+-----------------------------------------------------------------------+
| Ethernet Header | Src MAC: AA:AA:AA:11:11:11 -> Dst MAC: CC:CC:CC:... |
+-----------------------------------------------------------------------+
| IPv4 Header     | Src IP: 192.168.1.15 -> Dst IP: 195.130.130.1       |
+-----------------------------------------------------------------------+
| UDP Header      | Src Port: 54321 -> Dst Port: 53 (DNS)               |
+-----------------------------------------------------------------------+
| DNS Payload     | Query: A-record voor www.voorbeeld.be?              |
+-----------------------------------------------------------------------+
```

### Stap 0B: ARP-aanvraag (IP-adres Router -> MAC-adres Router)
1. **Subnet-check (Laag 3):** De laptop vergelijkt zijn eigen IP (`192.168.1.15` met subnetmasker `255.255.255.0`) met het doel-IP (`93.184.216.34`). Conclusie: de webserver zit **niet** in hetzelfde lokale netwerk. Het pakket moet dus naar de **Default Gateway** (`192.168.1.1`, de router).
2. **ARP Broadcast & Reply (Laag 2):** Om een frame naar de router te sturen, heeft de netwerkkaart het fysieke **MAC-adres** van `192.168.1.1` nodig. De laptop stuurt een broadcast-bericht naar het hele lokale netwerk (`FF:FF:FF:FF:FF:FF`). De router antwoordt direct met zijn MAC-adres (`CC:CC:CC:33:33:33`), waarna de laptop dit opslaat in zijn ARP-tabel.

```text
+-----------------------------------------------------------------------+
| Ethernet Header | Src MAC: AA:AA:AA:11:11:11 -> Dst MAC: FF:FF:FF:... |
+-----------------------------------------------------------------------+
| ARP Payload     | Who has 192.168.1.1? Tell 192.168.1.15              |
+-----------------------------------------------------------------------+
```

---

## Fase 1: Encapsulatie op de Laptop (Laag 7 -> Laag 1)

Nu alle adressen bekend zijn, bouwt de laptop de daadwerkelijke HTTP-aanvraag laag voor laag op.

### Laag 7: Applicatielaag
* **Actie:** De webbrowser stelt een platte tekst-aanvraag op volgens het **HTTP/1.1-protocol**.

```text
+-----------------------------------------------------------------------+
| HTTP Data (Payload)                                                   |
|   GET /index.html HTTP/1.1                                            |
|   Host: www.voorbeeld.be                                              |
|   User-Agent: Mozilla/5.0                                             |
|   Accept: text/html                                                   |
|   Connection: keep-alive                                              |
+-----------------------------------------------------------------------+
```

### Laag 6: Presentatielaag
* **Actie:** De tekst van het HTTP-verzoek wordt omgezet naar een gestandaardiseerd byteformaat dat zowel de laptop als de webserver begrijpt (**ASCII / UTF-8**). Omdat het om onversleutelde HTTP gaat, vindt hier geen encryptie plaats.

```text
+-----------------------------------------------------------------------+
| Gecodeerde Data (UTF-8 / ASCII Bytes)                                 |
|   47 45 54 20 2F 69 6E 64 65 78 2E 68 74 6D 6C ... ("GET /index...")  |
+-----------------------------------------------------------------------+
```

### Laag 5: Sessielaag
* **Actie:** Het besturingssysteem opent en beheert een communicatiekanaal (**Socket**) dat de lokale browserkoppeling verbindt met de webserver en de dialoogstatus (`Connection: keep-alive`) bijhoudt.

```text
+-----------------------------------------------------------------------+
| Sessie Context (OS Socket Descriptor #408)                            |
|   Status: ESTABLISHED | Modus: Request-Response (Keep-Alive)          |
| +-------------------------------------------------------------------+ |
| | Payload: HTTP Request (UTF-8 gecodeerd)                           | |
| +-------------------------------------------------------------------+ |
+-----------------------------------------------------------------------+
```

### Laag 4: Transportlaag (TCP 3-Way Handshake & Segmentatie)
* **Actie 1 (3-Way Handshake):** Omdat HTTP betrouwbaarheid vereist, gebruikt Laag 4 **TCP**. Vóór de HTTP-data verzonden wordt, wisselen laptop en webserver eerst drie controlepakketjes uit (`SYN` -> `SYN-ACK` -> `ACK`) om de verbinding te openen.
* **Actie 2 (Segmentatie):** De HTTP-data wordt voorzien van een **TCP-header** van 20 bytes en heet nu een **TCP-segment**.

```text
+-----------------------------------------------------------------------+
| TCP Header (20 bytes)                                                 |
|   Src Port: 51432 | Dst Port: 80 | Seq: 1001 | Flags: PSH, ACK        |
| +-------------------------------------------------------------------+ |
| | Payload: HTTP Request (GET /index.html HTTP/1.1...)               | |
| +-------------------------------------------------------------------+ |
+-----------------------------------------------------------------------+
```

### Laag 3: Netwerklaag (Pakketvorming)
* **Actie:** De TCP/IP-stack van de laptop plakt een **IPv4-header** van 20 bytes vóór het TCP-segment. Het geheel heet nu een **IP-pakket**.
* **Belangrijk detail:** Hier wordt het **einddoel** ingevuld (`93.184.216.34`), *niet* het IP-adres van de thuisrouter.

```text
+-----------------------------------------------------------------------+
| IPv4 Header (20 bytes)                                                |
|   Src IP: 192.168.1.15 | Dst IP: 93.184.216.34 | Proto: 6 | TTL: 64   |
| +-------------------------------------------------------------------+ |
| | TCP Header (Src: 51432 -> Dst: 80)                                | |
| | +---------------------------------------------------------------+ | |
| | | Payload: HTTP Request                                         | | |
| | +---------------------------------------------------------------+ | |
| +-------------------------------------------------------------------+ |
+-----------------------------------------------------------------------+
```

### Laag 2: Datalinklaag (Wi-Fi Framevorming)
* **Actie:** De Wi-Fi-netwerkkaart (NIC) wikkelt het IP-pakket in een **IEEE 802.11 (Wi-Fi) frame** met MAC-adressen en een foutcontrolegetal (**FCS**) achteraan.
* **Belangrijk detail:** Laag 2 kijkt alleen naar de **eerstvolgende fysieke stap** binnen het lokale netwerk (het Access Point als directe ontvanger en de router als eindbestemming op het LAN).

```text
+-----------------------------------------------------------------------+
| 802.11 Wi-Fi Header                                                   |
|   RA (AP): BB:BB:BB:22:22:22 | TA (Laptop): AA:AA:AA:11:11:11         |
|   DA (Router): CC:CC:CC:33:33:33                                      |
| +-------------------------------------------------------------------+ |
| | IPv4 Header (192.168.1.15 -> 93.184.216.34 | TTL: 64)             | |
| | +---------------------------------------------------------------+ | |
| | | TCP Header (51432 -> 80)                                      | | |
| | | +-----------------------------------------------------------+ | | |
| | | | Payload: HTTP Request                                     | | | |
| | | +-----------------------------------------------------------+ | | |
| | +---------------------------------------------------------------+ | |
| +-------------------------------------------------------------------+ |
| FCS Trailer (4 bytes CRC Checksum)                                    |
+-----------------------------------------------------------------------+
```

### Laag 1: Fysieke Laag
* **Actie:** De Wi-Fi-chip zet het volledige frame om in een stroom van enen en nullen en moduleert deze tot 5 GHz-radiogolven via de antenne.

```text
+-----------------------------------------------------------------------+
| Fysiek Medium: 5 GHz Radiogolven (OFDM Modulatie)                     |
|   Bits: 10110010 01101110 11110000 00101011 10010110 ...              |
+-----------------------------------------------------------------------+
```

---

## Fase 2: De Reis door het Thuisnetwerk

Het signaal verlaat nu de laptop en reist via de lokale netwerkapparatuur naar buiten.

### 1. Access Point (AP) – *Werkt op Laag 1 en Laag 2*
* **Actie:** Het AP vangt de radiogolven op (Laag 1) en fungeert als **Layer 2 Bridge**. Het stript de draadloze **802.11 Wi-Fi header** eraf, controleert de FCS, en verpakt exact hetzelfde IP-pakket in een bekabeld **802.3 Ethernet-frame**. Het AP kijkt niet naar IP-adressen en past deze dus ook niet aan.

```text
+-----------------------------------------------------------------------+
| 802.3 Ethernet Header (NIEUW)                                         |
|   Src MAC: AA:AA:AA:11:11:11 (Laptop) -> Dst MAC: CC:CC:CC:33:33:33   |
| +-------------------------------------------------------------------+ |
| | IPv4 Header (192.168.1.15 -> 93.184.216.34 | TTL: 64) [ONGEWIJZIGD] |
| | +---------------------------------------------------------------+ | |
| | | TCP Header (51432 -> 80) [ONGEWIJZIGD]                        | | |
| | | +-----------------------------------------------------------+ | | |
| | | | Payload: HTTP Request [ONGEWIJZIGD]                       | | | |
| | | +-----------------------------------------------------------+ | | |
| | +---------------------------------------------------------------+ | |
| +-------------------------------------------------------------------+ |
| FCS Trailer (NIEUW - 4 bytes CRC)                                     |
+-----------------------------------------------------------------------+
```

### 2. Netwerk Switch – *Werkt op Laag 1 en Laag 2*
* **Actie:** De switch ontvangt de elektrische pulsen op poort 1, leest alleen het **Doel-MAC** (`CC:CC:CC:33:33:33`), ziet in zijn *MAC Address Table* dat de router op poort 8 zit, en stuurt het signaal 1-op-1 door naar poort 8 zonder iets aan het frame te wijzigen.

```text
+-----------------------------------------------------------------------+
| 802.3 Ethernet Header [ONGEWIJZIGD]                                   |
|   Src MAC: AA:AA:AA:11:11:11 -> Dst MAC: CC:CC:CC:33:33:33 (Poort 8)  |
| +-------------------------------------------------------------------+ |
| | IPv4 Header (192.168.1.15 -> 93.184.216.34 | TTL: 64) [ONGEWIJZIGD] |
| | +---------------------------------------------------------------+ | |
| | | TCP Header (51432 -> 80) [ONGEWIJZIGD]                        | | |
| | | +-----------------------------------------------------------+ | | |
| | | | Payload: HTTP Request [ONGEWIJZIGD]                       | | | |
| | | +-----------------------------------------------------------+ | | |
| | +---------------------------------------------------------------+ | |
| +-------------------------------------------------------------------+ |
| FCS Trailer [ONGEWIJZIGD]                                             |
+-----------------------------------------------------------------------+
```

### 3. Thuisrouter – *Werkt op Laag 1, 2 en 3 (en 4 via NAT)*
* **Actie:**
  1. **Laag 2 strippen:** De router ziet zijn eigen MAC-adres, controleert de FCS, en gooit de volledige Ethernet-header en trailer weg.
  2. **Routering & TTL (Laag 3):** Het Doel-IP (`93.184.216.34`) ligt buiten het LAN. De router stuurt het pakket naar de WAN-poort en verlaagt de **TTL** van `64` naar `63`.
  3. **NAT (Laag 3 & 4):** Privé-IP's (`192.168.x.x`) werken niet op het internet. De router vervangt het Bron-IP door zijn publieke WAN-IP (`84.192.10.50`), past de bronpoort aan (`51432` -> `60123`) en slaat deze vertaling op in zijn NAT-tabel.
  4. **Nieuwe Laag 2-header:** Het pakket krijgt een nieuw WAN-frame (bijv. Ethernet/PPPoE) richting de gateway van de ISP.

```text
+-----------------------------------------------------------------------+
| WAN Laag 2 Header (NIEUW - richting ISP Gateway)                      |
|   Src MAC: [Router WAN MAC] -> Dst MAC: [ISP Gateway MAC]             |
| +-------------------------------------------------------------------+ |
| | IPv4 Header (GEWIJZIGD door NAT & Routing)                        | |
| |   Src IP: 84.192.10.50 | Dst IP: 93.184.216.34 | TTL: 63          | |
| | +---------------------------------------------------------------+ | |
| | | TCP Header (GEWIJZIGD door NAT)                               | | |
| | |   Src Port: 60123 | Dst Port: 80 | Seq: 1001 | Flags: PSH,ACK | | |
| | | +-----------------------------------------------------------+ | | |
| | | | Payload: HTTP Request [ONGEWIJZIGD]                       | | | |
| | | +-----------------------------------------------------------+ | | |
| | +---------------------------------------------------------------+ | |
| +-------------------------------------------------------------------+ |
| WAN FCS Trailer (NIEUW)                                               |
+-----------------------------------------------------------------------+
```

### 4. Modem – *Werkt op Laag 1*
* **Actie:** Het modem (in bridge-modus) opent geen headers en kijkt niet naar IP- of MAC-adressen. Het zet de digitale Ethernet-bits simpelweg om naar het fysieke signaal van de providerlijn (lichtpulsen bij glasvezel, RF-signaal bij coax of tonen bij DSL).

```text
+-----------------------------------------------------------------------+
| Fysiek Medium ISP: Lichtpulsen (Glasvezel) of RF-signaal (Coax)       |
|   Bits: 10110010 01101110 11110000 00101011 10010110 ...              |
+-----------------------------------------------------------------------+
```

---

## Fase 3: Het Internet / ISP Netwerk

* **Actie:** In de wijkcentrale van de provider (DSLAM/CMTS/OLT) worden de fysieke signalen terug omgezet naar digitale frames. Daarna reist het pakket via **BGP-routering** langs meerdere core-routers over het internet.
* **Bij elke individuele router onderweg:**
  * De binnenkomende **Laag 2-header** wordt gestript en vervangen door een nieuwe Laag 2-header voor de volgende router (*next hop*).
  * De **IP-adressen (Laag 3)** blijven gedurende de hele reis over het internet identiek, maar elke router verlaagt de **TTL** met `1` (bijv. van `63` naar `52` na 11 routers).

```text
+-----------------------------------------------------------------------+
| Backbone Laag 2 Header (VERVANGEN BIJ ELKE HOP)                       |
|   Src MAC/Label: [Router N] -> Dst MAC/Label: [Router N+1]            |
| +-------------------------------------------------------------------+ |
| | IPv4 Header (TTL VERLAAGD BIJ ELKE HOP)                           | |
| |   Src IP: 84.192.10.50 | Dst IP: 93.184.216.34 | TTL: 52          | |
| | +---------------------------------------------------------------+ | |
| | | TCP Header (Src: 60123 -> Dst: 80) [ONGEWIJZIGD]              | | |
| | | +-----------------------------------------------------------+ | | |
| | | | Payload: HTTP Request [ONGEWIJZIGD]                       | | | |
| | | +-----------------------------------------------------------+ | | |
| | +---------------------------------------------------------------+ | |
| +-------------------------------------------------------------------+ |
| Backbone FCS Trailer (VERVANGEN BIJ ELKE HOP)                         |
+-----------------------------------------------------------------------+
```

---

## Fase 4: Aankomst & De-encapsulatie bij de Webserver (Laag 1 -> Laag 7)

Het pakket bereikt de netwerkkaart van de webserver (`93.184.216.34`) en wordt van onder naar boven afgepeld.

### 1. Laag 1 & Laag 2 (Netwerkkaart Webserver)
* **Actie:** De netwerkkaart zet de licht-/stroompulsen om in bits (Laag 1), controleert de FCS, herkent zijn eigen MAC-adres, en **stript de Ethernet-header en trailer**.

```text
+-----------------------------------------------------------------------+
| IPv4 Header                                                           |
|   Src IP: 84.192.10.50 | Dst IP: 93.184.216.34 | Proto: 6 | TTL: 52   |
| +-------------------------------------------------------------------+ |
| | TCP Header (Src: 60123 -> Dst: 80)                                | |
| | +---------------------------------------------------------------+ | |
| | | Payload: HTTP Request                                         | | |
| | +---------------------------------------------------------------+ | |
| +-------------------------------------------------------------------+ |
+-----------------------------------------------------------------------+
```

### 2. Laag 3 (IP-stack Besturingssysteem)
* **Actie:** Het besturingssysteem ziet dat Doel-IP `93.184.216.34` overeenkomt met zijn eigen IP-adres. Het **stript de IPv4-header** en leest aan protocolnummer `6` dat de payload naar TCP moet.

```text
+-----------------------------------------------------------------------+
| TCP Header                                                            |
|   Src Port: 60123 | Dst Port: 80 | Seq: 1001 | Flags: PSH, ACK        |
| +-------------------------------------------------------------------+ |
| | Payload: HTTP Request (GET /index.html HTTP/1.1...)               | |
| +-------------------------------------------------------------------+ |
+-----------------------------------------------------------------------+
```

### 3. Laag 4, 5 & 6 (TCP, Socket & Tekencodering)
* **Actie:** TCP ziet doelpoort `80` (waar webserver-software zoals Nginx of Apache luistert), stuurt een `ACK` terug naar `84.192.10.50`, **stript de TCP-header** (Laag 4), koppelt de data aan de actieve socket-sessie (Laag 5) en zet de UTF-8 bytes terug om naar leesbare tekst (Laag 6).

```text
+-----------------------------------------------------------------------+
| Gecodeerde Data (UTF-8 / ASCII Bytes)                                 |
|   47 45 54 20 2F 69 6E 64 65 78 2E 68 74 6D 6C ... ("GET /index...")  |
+-----------------------------------------------------------------------+
```

### 4. Laag 7 (Webserver Applicatie)
* **Actie:** Nginx/Apache ontvangt het schone HTTP-verzoek, leest dat `/index.html` wordt opgevraagd en haalt dit bestand van zijn opslagschijf.

```text
+-----------------------------------------------------------------------+
| HTTP Data (Payload)                                                   |
|   GET /index.html HTTP/1.1                                            |
|   Host: www.voorbeeld.be                                              |
|   User-Agent: Mozilla/5.0                                             |
|   Accept: text/html                                                   |
|   Connection: keep-alive                                              |
+-----------------------------------------------------------------------+
```

---

## Fase 5: De Terugweg (HTTP Response)

De webserver stuurt nu de HTML-pagina terug door het volledige proces om te keren:

1. **Webserver (Laag 7 -> Laag 1):** Verpakt de HTML-code met een `HTTP/1.1 200 OK` statusheader, voegt TCP-, IP- en Ethernet-headers toe en stuurt het pakket het internet op richting het publieke IP van de thuisrouter (`84.192.10.50`).

```text
+-----------------------------------------------------------------------+
| Ethernet Header | Src MAC: [Server] -> Dst MAC: [Datacenter Router]   |
| +-------------------------------------------------------------------+ |
| | IPv4 Header | Src IP: 93.184.216.34 -> Dst IP: 84.192.10.50         | |
| | +---------------------------------------------------------------+ | |
| | | TCP Header | Src Port: 80 -> Dst Port: 60123                  | | |
| | | +-----------------------------------------------------------+ | | |
| | | | HTTP Response: HTTP/1.1 200 OK + <html>...</html>         | | | |
| | | +-----------------------------------------------------------+ | | |
| | +---------------------------------------------------------------+ | |
| +-------------------------------------------------------------------+ |
| FCS Trailer                                                           |
+-----------------------------------------------------------------------+
```

2. **Thuisrouter (Reverse NAT):** De router ontvangt het pakket op poort `60123`, zoekt deze op in zijn **NAT-tabel**, en ziet dat dit hoort bij laptop `192.168.1.15` (poort `51432`). De router herschrijft het Doel-IP en de doelpoort terug naar de laptop en stuurt het als Ethernet-frame naar de switch.

```text
+-----------------------------------------------------------------------+
| 802.3 Ethernet Header | Src MAC: CC:CC:CC:33:33:33 -> Dst: AA:AA:AA.. |
| +-------------------------------------------------------------------+ |
| | IPv4 Header | Src IP: 93.184.216.34 -> Dst IP: 192.168.1.15       | |
| | +---------------------------------------------------------------+ | |
| | | TCP Header | Src Port: 80 -> Dst Port: 51432                  | | |
| | | +-----------------------------------------------------------+ | | |
| | | | HTTP Response: HTTP/1.1 200 OK + <html>...</html>         | | | |
| | | +-----------------------------------------------------------+ | | |
| | +---------------------------------------------------------------+ | |
| +-------------------------------------------------------------------+ |
| FCS Trailer                                                           |
+-----------------------------------------------------------------------+
```

3. **Switch & Access Point:** De switch stuurt het frame naar het AP. Het AP vertaalt de bekabelde 802.3 Ethernet-header terug naar een draadloze **802.11 Wi-Fi-header** en zendt het signaal uit via radiogolven.

```text
+-----------------------------------------------------------------------+
| 802.11 Wi-Fi Header | TA (AP): BB:BB:BB... -> RA (Laptop): AA:AA:AA.. |
| +-------------------------------------------------------------------+ |
| | IPv4 Header | Src IP: 93.184.216.34 -> Dst IP: 192.168.1.15       | |
| | +---------------------------------------------------------------+ | |
| | | TCP Header | Src Port: 80 -> Dst Port: 51432                  | | |
| | | +-----------------------------------------------------------+ | | |
| | | | HTTP Response: HTTP/1.1 200 OK + <html>...</html>         | | | |
| | | +-----------------------------------------------------------+ | | |
| | +---------------------------------------------------------------+ | |
| +-------------------------------------------------------------------+ |
| FCS Trailer                                                           |
+-----------------------------------------------------------------------+
```

4. **Laptop (Laag 1 -> Laag 7):** De laptop vangt de radiogolven op, stript achtereenvolgens de Wi-Fi-, IP- en TCP-headers eraf, en levert de schone HTML-code af bij de browser, die de webpagina op het scherm rendert.

```text
+-----------------------------------------------------------------------+
| HTTP Response (Payload bij Browser)                                   |
|   HTTP/1.1 200 OK                                                     |
|   Content-Type: text/html; charset=UTF-8                              |
|                                                                       |
|   <!DOCTYPE html><html><body><h1>Welkom!</h1></body></html>           |
+-----------------------------------------------------------------------+
```

---

## Samenvattend Overzicht: Welk apparaat kijkt naar welke laag?

| Apparaat | Hoogste OSI-laag | Wat doet dit apparaat met de headers? |
| :--- | :--- | :--- |
| **Kabels / Glasvezel / Lucht** | Laag 1 (Fysiek) | Transporteert alleen signalen (geen kennis van data). |
| **Modem** | Laag 1 (Fysiek) | Zet signaalvorm om (bijv. Ethernet <-> Coax/Glas). |
| **Switch & Access Point** | Laag 2 (Datalink) | Leest **MAC-adressen**. Wijzigt geen IP-adressen. (AP wisselt tussen 802.11 en 802.3 header). |
| **Router** | Laag 3 (Netwerk)* | Leest **IP-adressen**, verlaagt **TTL**, vervangt Laag 2-frames volledig. *(Past via NAT ook Laag 3/4 aan)*. |
| **Laptop & Webserver** | Laag 7 (Applicatie) | Bouwen alle 7 lagen op (encapsulatie) en breken ze weer af (de-encapsulatie). |
