# Netwerkmodellen: OSI & TCP/IP

Netwerkcommunicatie wordt beschreven aan de hand van gelaagde referentiemodellen. Elke laag heeft een specifieke functie en communiceert met de lagen direct erboven en eronder.

## 1. Encapsulatie & Decapsulatie

- **Encapsulatie (Zenden):** Data beweegt van boven naar beneden. Elke laag voegt een **header** (en soms een trailer) toe met besturingsinformatie.
- **Decapsulatie (Ontvangen):** Data beweegt van beneden naar boven. Elke laag stript zijn eigen header eraf en geeft de rest door aan de hogere laag.

## 2. Het OSI-model (7 Lagen)

Het OSI-model is de theoretische standaard voor netwerkanalyse en troubleshooting.

| Laag | Naam | Data Unit (PDU) | Functie | Voorbeelden |
| :--- | :--- | :--- | :--- | :--- |
| 7 | Applicatie | Data | Gebruikersinteractie & API's | HTTP, DNS, SMTP |
| 6 | Presentatie | Data | Formatteren, Encryptie, Compressie | TLS, JPEG, ASCII |
| 5 | Sessie | Data | Sessiebeheer & Verbindingen | Sockets, RPC |
| 4 | Transport | Segment (TCP) | End-to-end foutcontrole & Poorten | TCP, UDP |
| 3 | Netwerk | Pakket (IP) | Routing & Logische adressering | IP, ICMP, Routers |
| 2 | Datalink | Frame | Lokale adressering & Fysieke links | Ethernet, MAC, Switches |
| 1 | Fysiek | Bits | Fysieke overdracht (stroom, licht) | Kabels, Wi-Fi signalen |

### Onthouden
- **L7 naar L1:** **A**lle **P**rima **S**ystemen **T**ransporteren **N**etjes **D**e **F**rames.
- **L1 naar L7:** **P**lease **D**o **N**ot **T**hrow **S**ausage **P**izza **A**way.

## 3. Het TCP/IP-model (4 Lagen)

Dit is het praktische model waarop het internet is gebouwd.

| TCP/IP Laag | OSI Overeenkomst | Kernfunctie |
| :--- | :--- | :--- |
| **Application** | L5, L6, L7 | Applicatieprotocollen en dataformattering. |
| **Transport** | L4 | Poort-gebaseerde communicatie (TCP/UDP). |
| **Internet** | L3 | Logische adressering en routing (IP). |
| **Network Access** | L1, L2 | Fysieke overdracht en lokale adressering (MAC). |

## 4. Analyse in Wireshark

Wireshark toont de lagen van een pakket in omgekeerde volgorde (laagste laag bovenaan).

### Nuttige Display Filters
- `tcp`: Toont al het TCP-verkeer (inclusief ingekapselde HTTP).
- `http.request`: Filtert specifiek op uitgaande HTTP-verzoeken.
- `ip.addr == <IP>`: Al het verkeer van of naar een specifiek adres.
- `tcp.port == 80`: Specifiek HTTP-verkeer op poort 80.

::: tip PDU Terminologie
In netwerkanalyse gebruiken we specifieke termen: op L4 spreken we over **Segmenten**, op L3 over **Pakketten** en op L2 over **Frames**.
:::
