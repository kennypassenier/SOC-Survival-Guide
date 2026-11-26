# Het OSI-model: Van Klik tot Datapakket

Het OSI-model verdeelt netwerkcommunicatie in **7 abstracte lagen**. Elke laag heeft een specifieke taak en voegt controle-informatie (headers) toe aan de data (**encapsulatie**).

## Visueel Overzicht

```text
+----------------------+---------------------------------------+
| Laag 7: Applicatie   | HTTP-verzoek (Payload)                |
+----------------------+---------------------------------------+
| Laag 6: Presentatie  | TLS Encryptie (Veiligheid)            |
+----------------------+---------------------------------------+
| Laag 5: Sessie       | Verbinding openhouden (Sessiebeheer)  |
+----------------------+---------------------------------------+
| Laag 4: Transport    | TCP-poorten (Bron -> Doel)            |
+----------------------+---------------------------------------+
| Laag 3: Netwerk      | IP-adressen (Routering)               |
+----------------------+---------------------------------------+
| Laag 2: Datalink     | MAC-adressen (Lokale verbinding)      |
+----------------------+---------------------------------------+
| Laag 1: Fysiek       | Elektrische signalen / Lichtpulsen    |
+----------------------+---------------------------------------+
```

## Wat gebeurt er per laag?

### 7. Applicatie (*Application*)
De browser vertaalt een actie naar een verzoek, bijv.: `GET /index.html HTTP/1.1`.

### 6. Presentatie (*Presentation*)
Zorgt voor leesbaarheid en veiligheid. Hier vindt encryptie (TLS) en compressie plaats.

### 5. Sessie (*Session*)
Beheert de communicatiesessie tussen jouw apparaat en de server.

### 4. Transport (*Transport*)
Knipt data in **segmenten** (TCP) of datagrammen (UDP). Voegt poortnummers toe (bijv. 443 voor HTTPS).

### 3. Netwerk (*Network*)
Bepaalt de route via het internet. Data wordt een **pakket** met bron- en doel-IP.

### 2. Datalink (*Data Link*)
Communicatie tussen direct verbonden apparaten op het LAN. Data wordt een **frame** met MAC-adressen.

### 1. Fysiek (*Physical*)
Zet bits om in fysieke signalen over koper, glasvezel of Wi-Fi.

## De Terugweg: De-encapsulatie
Wanneer de server het pakket ontvangt, wordt het van **Laag 1 naar Laag 7** uitgepakt. Elke laag leest en verwijdert zijn eigen header om de originele payload af te leveren.

## Spiekbrief

| Laag | Data Unit | Adressering | Hardware |
| :--- | :--- | :--- | :--- |
| **4** | Segment | Poorten (80, 443) | L4 Firewall |
| **3** | Pakket | IP-adressen | Router |
| **2** | Frame | MAC-adressen | Switch |
| **1** | Bits | Voltages / Licht | Hub, Kabels |

::: tip Ezelsbruggetje
**A**lle **P**rima **S**ystemen **T**ransporteren **N**etjes **D**e **F**rames.
:::
