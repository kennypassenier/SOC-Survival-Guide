# OSI-Model Referentiegids: Van Klik tot Datapakket

Het **OSI-model** (*Open Systems Interconnection*) verdeelt netwerkcommunicatie in **7 abstracte lagen**. Elke laag heeft een specifieke taak en voegt zijn eigen controle-informatie (*header*, en soms een *trailer*) toe aan de data. Dit proces heet **encapsulatie**.

---

## Het Voorbeeld: Een webpagina opvragen

Stel, je opent je browser en typt `https://www.voorbeeld.be` in om de startpagina te bekijken. Hieronder zie je hoe jouw verzoek van boven (Laag 7) naar beneden (Laag 1) wordt opgebouwd voordat het de netwerkkabel of wifi-verbinding op gaat.

### Visueel Overzicht (Encapsulatie)

```text
+-----------------------------------------------------------------------+
| Laag 7: Applicatie  | GET /index.html HTTP/1.1 (Jouw aanvraag)        |
+-----------------------------------------------------------------------+
| Laag 6: Presentatie | [Versleuteld via TLS 1.3]                       |
+-----------------------------------------------------------------------+
| Laag 5: Sessie      | Sessie-ID: #84920 (Verbinding openhouden)       |
+-----------------------------------------------------------------------+
| Laag 4: Transport   | [TCP Header: Bronpoort 51432 -> Doelpoort 443]  |
+-----------------------------------------------------------------------+
| Laag 3: Netwerk     | [IP Header: Bron 192.168.1.15 -> Doel 93.184.x] |
+-----------------------------------------------------------------------+
| Laag 2: Datalink    | [Ethernet: MAC PC -> MAC Router] + [FCS Check]  |
+-----------------------------------------------------------------------+
| Laag 1: Fysiek      | 01011001 11001010 ... (Elektrische signalen)    |
+-----------------------------------------------------------------------+
```

---

## Wat gebeurt er per laag?

### 7. Applicatielaag (*Application Layer*)
* **Wat gebeurt hier?** De applicatie (jouw webbrowser) vertaalt jouw actie naar een netwerkverzoek.
* **Informatie in deze laag:** De eigenlijke payload en applicatieprotocollen (zoals HTTP/HTTPS, DNS, SMTP).
* **In ons voorbeeld:** De browser maakt het bericht: `GET /index.html HTTP/1.1`.

### 6. Presentatielaag (*Presentation Layer*)
* **Wat gebeurt hier?** Zorgt ervoor dat de data in een leesbaar formaat staat voor de ontvanger, comprimeert de data en regelt versleuteling.
* **Informatie in deze laag:** Tekencodering (UTF-8), bestandsformaten (JSON, HTML, JPEG) en encryptie (TLS/SSL).
* **In ons voorbeeld:** Omdat je `https://` gebruikt, wordt het HTTP-verzoek versleuteld via **TLS**, zodat niemand onderweg kan meelezen.

### 5. Sessielaag (*Session Layer*)
* **Wat gebeurt hier?** Opent, beheert en sluit de communicatiesessie tussen jouw apparaat en de webserver.
* **Informatie in deze laag:** Sessie-ID's, authenticatietokens en synchronisatiepunten (zodat een afgebroken download hervat kan worden).
* **In ons voorbeeld:** Er wordt een actieve sessie opgezet met de server zodat meerdere onderdelen van de webpagina (tekst, afbeeldingen) binnen dezelfde verbinding kunnen worden opgehaald.

### 4. Transportlaag (*Transport Layer*)
* **Wat gebeurt hier?** Knipt de data in kleinere stukjes (**segmenten**) en zorgt voor betrouwbare (of snelle) aflevering bij de juiste applicatie.
* **Informatie in deze laag:** **Poortnummers** (bronpoort en doelpoort), volgnummers (*sequence numbers*) en foutcontrole.
* **In ons voorbeeld:** Het verzoek krijgt een **TCP-header** met doelpoort `443` (standaard voor HTTPS) en jouw willekeurige bronpoort `51432`. TCP garandeert dat alle stukjes in de juiste volgorde aankomen.

### 3. Netwerklaag (*Network Layer*)
* **Wat gebeurt hier?** Bepaalt de beste route over verschillende netwerken (het internet) van jouw thuisnetwerk naar de server. De data heet nu een **pakket**.
* **Informatie in deze laag:** **IP-adressen** (bron-IP en doel-IP) en *Time-To-Live* (TTL).
* **In ons voorbeeld:** De router en je PC voegen een **IP-header** toe met jouw lokale IP (`192.168.1.15`) en het publieke IP-adres van de webserver (`93.184.216.34`).

### 2. Datalinklaag (*Data Link Layer*)
* **Wat gebeurt hier?** Verzorgt de communicatie tussen twee direct verbonden apparaten binnen hetzelfde lokale netwerk (bijv. jouw laptop en je thuisrouter). De data heet nu een **frame**.
* **Informatie in deze laag:** **MAC-adressen** (fysieke hardware-adressen) en een *Frame Check Sequence* (FCS) aan het einde om bitfouten op te sporen.
* **In ons voorbeeld:** Een **Ethernet-header** (of Wi-Fi-header) wordt toegevoegd met het MAC-adres van jouw netwerkkaart als bron, en het MAC-adres van je thuisrouter als eerste tussenstop (*next hop*).

### 1. Fysieke laag (*Physical Layer*)
* **Wat gebeurt hier?** Zet de digitale enen en nullen (**bits**) om in fysieke signalen over het medium.
* **Informatie in deze laag:** Elektrische spanningen (koperkabel), lichtpulsen (glasvezel) of radiogolven (Wi-Fi).
* **In ons voorbeeld:** De netwerkkaart stuurt een reeks radiogolven (Wi-Fi) of stroomstootjes (UTP-kabel) naar je router.

---

## De Terugweg: De-encapsulatie

Wanneer het pakket aankomt bij de webserver, gebeurt precies het omgekeerde (**de-encapsulatie**). De server leest de informatie van **Laag 1 naar Laag 7**, stript bij elke laag de bijbehorende header eraf, en levert uiteindelijk het pure `GET /index.html`-verzoek af bij de webserver-software.

---

## Snelle Referentietabel (Spiekbrief)

| Laag | Naam | Data-eenheid (PDU) | Belangrijkste Adressering / Info | Voorbeeld Protocollen / Hardware |
| :--- | :--- | :--- | :--- | :--- |
| **7** | Applicatie | Data | Gebruikersdata & API's | HTTP, HTTPS, DNS, SMTP, FTP |
| **6** | Presentatie | Data | Encryptie, compressie, codering | TLS/SSL, ASCII, UTF-8, JPEG |
| **5** | Sessie | Data | Sessiebeheer & tokens | NetBIOS, RPC, Sockets |
| **4** | Transport | Segment / Datagram | Poortnummers (bijv. 80, 443) | TCP, UDP |
| **3** | Netwerk | Pakket (*Packet*) | IP-adressen (logisch) | IPv4, IPv6, ICMP, Routers |
| **2** | Datalink | Frame | MAC-adressen (fysiek) & VLAN | Ethernet, Wi-Fi (802.11), Switches |
| **1** | Fysiek | Bits (`0` en `1`) | Voltages, licht, radiofrequenties | UTP-kabels, Glasvezel, Hubs |

> **Ezelsbruggetje (van Laag 7 naar Laag 1):**  
> **A**lle **P**rima **S**ystemen **T**ransporteren **N**etjes **D**e **F**rames *(Applicatie, Presentatie, Sessie, Transport, Netwerk, Datalink, Fysiek)*
