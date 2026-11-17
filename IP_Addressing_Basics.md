# IP Addressing Basics

## 1. Overzicht van Relevante Commando's

### A. Netwerkconfiguratie & Interfaces

#### `ifconfig`
* **Doel:** *Interface Configurator*: toont en configureert netwerkinterfaces, inclusief IPv4-adres (`inet addr`), subnetmasker (`Mask`), MAC-adres (`HWaddr` = *Hardware Address*) en interface-status (`eth0`, `lo`).
* **Praktijkgebruik:**
  ```bash
  # Toon alle actieve netwerkinterfaces en hun IP/MAC-configuratie
  ifconfig
  ```
* **Tips, Valkuilen & Modernere Mogelijkheden:**
  * In de uitvoer zie je onder meer `eth0` (primaire netwerkkaart) en `lo` (*loopback*-interface, gebruikt door het OS om met zichzelf te communiceren).
  * `ifconfig` toont het subnetmasker uitgeschreven (bijv. `255.255.255.0`), terwijl modernere tools CIDR-notatie (`/24`) gebruiken.
  * **[Aanvullend] Modernere mogelijkheden & OS-verschillen:** `ifconfig` maakt deel uit van het pakket `net-tools` en is op recente Debian/Ubuntu- en Arch Linux-systemen vaak niet meer standaard geïnstalleerd. De modernere Linux-opvolger is `ip a`. Op Windows gebruik je `ipconfig /all` (CMD) of `Get-NetIPAddress` / `Get-NetAdapter` (PowerShell).

#### `ip`
* **Doel:** Het modernere Linux-netwerkbeheercommando (`iproute2`) voor het inspecteren en configureren van netwerkinterfaces, IP-adressen (in CIDR slash-notatie zoals `/24`), routering en ARP/neighbor-tabellen.
* **Parameters & Subcommando's:**
  * `a` (`addr` / **a**ddress): Toont alle netwerkinterfaces en bijbehorende IPv4/IPv6-adressen.
* **Praktijkgebruik:**
  ```bash
  # Toon netwerkinterfaces en IP-adressen inclusief CIDR-prefix (bijv. 192.168.0.10/24)
  ip a
  ```
* **[Aanvullend] Extra Permutaties & OS-verschillen (Debian vs. Arch):**
  * `ip -c a` (`-c` = **c**olor): Kleurt interface-namen, IP-adressen en statussen (`UP`/`DOWN`) voor snellere visuele inspectie.
  * `ip -br a` (`-br` = **br**ief): Compact overzicht van interfacenaam, status en IP-adres op één regel.
  * `ip link`: Toont uitsluitend Layer 2-informatie (MAC-adressen, MTU en fysieke linkstatus).
  * **Debian vs. Arch:** `iproute2` (`ip`) is op zowel moderne Debian/Ubuntu- als Arch Linux-installaties standaard voorgeïnstalleerd en vormt op beide systemen de aanbevolen standaard.

#### `/etc/network/interfaces` (Configuratiebestand)
* **Doel:** Klassiek Debian/Ubuntu-configuratiebestand waarin statische IP-adressen, netmaskers en gateways voor interfaces zoals `eth0` worden vastgelegd.
* **Praktijkgebruik:**
  ```bash
  # Inspecteer de statische netwerkconfiguratie van het systeem
  cat /etc/network/interfaces
  ```
* **Tips, Valkuilen & Modernere Mogelijkheden:**
  * Als de `gateway` in `/etc/network/interfaces` verkeerd is ingesteld of ontbreekt, verschijnt er geen default gateway in de routeringstabel (`netstat -r` / `ip r`) en kan de host niet buiten zijn eigen subnet communiceren.
  * **[Aanvullend] Modernere netwerkconfiguratie (Debian/Ubuntu vs. Arch):**
    * **Recente Ubuntu / Debian servers:** Gebruiken tegenwoordig **Netplan** (`/etc/netplan/*.yaml`, toegepast met `sudo netplan apply`) of **NetworkManager** (`nmcli`).
    * **Arch Linux:** Gebruikt `/etc/network/interfaces` niet; netwerkconfiguratie verloopt via **systemd-networkd** (`/etc/systemd/network/*.network`), **NetworkManager** (`nmcli`) of `dhcpcd`.

---

### B. Routering, Connectiviteit & ARP

#### `netstat`
* **Doel:** *Network Statistics*: toont actieve netwerkverbindingen, luisterende poorten en de kernel IP-routeringstabel.
* **Parameters & Opties:**
  * `-r` (`r` = **r**oute): Toont de kernel IP-routeringstabel, inclusief de *default gateway* (`0.0.0.0` of `default`).
* **Praktijkgebruik:**
  ```bash
  # Bekijk de routeringstabel en controleer de default gateway
  netstat -r
  ```
* **[Aanvullend] Modernere Mogelijkheden (Linux & Windows):**
  * **Linux (Debian & Arch):** Er zijn modernere alternatieven voor `netstat` (`net-tools`). Gebruik **`ip route`** (of kortweg **`ip r`**) om de routeringstabel te bekijken, en **`ss -tulnp`** (*Socket Statistics*: `t` = TCP, `u` = UDP, `l` = listening, `n` = numeric, `p` = processes) om open poorten en actieve verbindingen te onderzoeken.
  * **Windows:** `route print` (CMD) of `Get-NetRoute` (PowerShell) voor de routeringstabel; `netstat -ano` (CMD) of `Get-NetTCPConnection` (PowerShell) voor verbindingen.

#### `ping`
* **Doel:** Test Layer 3 IP-connectiviteit naar een gateway, lokale host of extern netwerk door ICMP Echo Request-pakketten te sturen en te wachten op Echo Replies.
* **Parameters & Opties:**
  * `-c <aantal>` (`c` = **c**ount): Stopt automatisch na het versturen van het opgegeven aantal ICMP-pakketten (bijv. `-c 4`).
* **Praktijkgebruik & Permutaties:**
  ```bash
  # Test connectiviteit naar de lokale default gateway met 4 pakketten
  ping -c 4 192.168.0.1

  # Test connectiviteit naar een host op een ander subnet via de router
  ping -c 4 192.168.1.10
  ```
* **Tips, Valkuilen & OS-verschillen:**
  * In Linux gaat `ping` **oneindig door** als je `-c` weglaat (onderbreek met `Ctrl + C`). Op Windows CMD stuurt `ping` standaard slechts 4 pakketten (en gebruik je `-t` voor oneindig pingen).
  * **[Aanvullend]:** Een mislukte `ping` betekent niet altijd dat een host offline is; veel firewalls (waaronder Windows Defender Firewall) blokkeren inkomend ICMP-verkeer standaard. Gebruik `-W <seconden>` (`W` = **W**ait timeout) om wachttijd te verkorten bij scriptmatige scans.

#### `arp`
* **Doel:** Toont en beheert de lokale ARP-cache (*Address Resolution Protocol*), waarin recente vertalingen van lokale IPv4-adressen naar fysieke MAC-adressen zijn opgeslagen.
* **Parameters & Opties:**
  * `-a` (`a` = **a**ll): Toont alle actieve entries in de lokale ARP-tabel.
* **Praktijkgebruik:**
  ```bash
  # Bekijk de huidige ARP-cache van de host
  arp -a
  ```
* **Tips, Valkuilen & Modernere Mogelijkheden:**
  * `ifconfig` toont MAC-adressen vaak in hoofdletters (`AA:BB:CC:...`), terwijl `arp -a` ze in kleine letters toont (`aa:bb:cc:...`). MAC-adressen zijn **niet hoofdlettergevoelig**.
  * De ARP-cache bevat **uitsluitend lokale adressen** uit hetzelfde subnet (plus het MAC-adres van de default gateway voor verkeer naar externe subnetten).
  * **[Aanvullend] Modernere Mogelijkheden & SOC-analyse:**
    * **Linux (Debian & Arch):** De modernere opvolger binnen `iproute2` is **`ip neigh`** (`neigh` = **neigh**bour) of `ip n`.
    * **Windows:** `arp -a` (CMD) of `Get-NetNeighbor` (PowerShell).
    * **SOC-valkuil (ARP Spoofing / MITM):** Controleer bij verdacht lokaal netwerkverkeer de ARP-tabel op meerdere IP-adressen (bijv. zowel de default gateway als een andere host) die naar **exact hetzelfde MAC-adres** verwijzen. Dit is een klassieke indicator voor een *ARP Spoofing / Man-in-the-Middle*-aanval.

#### `gns3` & Wireshark Filter `arp`
* **Doel:**
  * `gns3`: Start de GNS3 grafische netwerksimulator vanuit de terminal.
  * `arp` (Wireshark display filter): Filtert packet captures zodat uitsluitend ARP-broadcasts en ARP-replies zichtbaar zijn.
* **Praktijkgebruik:**
  ```bash
  # Start GNS3 op de achtergrond (&) zodat de terminalprompt bruikbaar blijft
  gns3 &
  ```
  ```text
  # Wireshark Display Filter voor ARP-verkeer:
  arp
  ```

---

## 2. Algemene Uitleg & Theorie

### TCP/IP Protocol Suite & Historie
* **Ontstaan:** TCP/IP en ARP ontstonden eind jaren 1960 en begin jaren 1970, toen netwerken nog met dure, merkspecifieke (*proprietary*) hardware en software werden gebouwd. In de jaren 1990 werkte de **IETF** (*Internet Engineering Task Force*) samen met leveranciers om open standaarden vast te leggen die nu de ruggengraat van het internet vormen.
* **TCP (Transmission Control Protocol):** Biedt betrouwbare, **verbindingsgeoriënteerde** (*connection-oriented*) communicatie met foutcontrole en gegarandeerde aflevering. TCP gebruikt **poortnummers** om diensten op dezelfde host te onderscheiden (bijv. poort `80` voor HTTP en poort `25` voor SMTP).
* **UDP (User Datagram Protocol):** Biedt snellere, **verbindingsloze** (*connectionless*) communicatie zonder de overhead van foutcontrole of herverzending.

### IPv4-adressering, Octetten & Subnetmaskers
* **IPv4 vs. IPv6:** IPv4 gebruikt **32-bit** adressen opgedeeld in **vier octetten** (elk een getal van `0` t/m `255`), gecombineerd met een subnetmasker. IPv6 gebruikt **128-bit** adressen om het groeiende aantal internetapparaten te ondersteunen.
* **Netwerkdeel vs. Hostdeel:** Het subnetmasker bepaalt welk deel van het IP-adres het netwerk identificeert en welk deel de individuele host:
  * `255` in het subnetmasker betekent dat het bijbehorende octet onderdeel is van het **netwerk**.
  * `0` in het subnetmasker betekent dat het bijbehorende octet de **host** vertegenwoordigt.
  * *Voorbeeld:* Bij IP `192.168.10.100` met subnetmasker `255.255.255.0` (ook geschreven in CIDR-notatie als **`192.168.10.100/24`**) is `192.168.10.0` het netwerk en `.100` de specifieke host.

### Routering & Default Gateway
* **Communicatie binnen hetzelfde subnet:** Hosts op hetzelfde netwerk (bijv. `192.168.10.10/24` en `192.168.10.20/24`) kunnen rechtstreeks met elkaar communiceren zonder router.
* **Communicatie tussen verschillende subnetten:** Om van `192.168.10.10/24` naar `192.168.11.10/24` te communiceren, heeft een host een **router** nodig (zijn **default gateway**, bijv. `192.168.10.1`). Een router heeft in elk verbonden netwerk een eigen IP-adres en kan pakketten verder doorsturen naar andere netwerken of het internet.

### MAC-adressen & Address Resolution Protocol (ARP)
* **MAC-adres:** Een 12-cijferig hexadecimaal fysiek adres dat uniek is op een lokaal netwerksegment (Layer 2).
* **Werking van ARP (3 stappen):**
  1. **ARP Request (Broadcast):** Een host stuurt een ARP-verzoek als broadcast naar alle apparaten op het lokale subnet met de vraag welk MAC-adres bij het doel-IP hoort.
  2. **ARP Reply (Unicast):** Alleen het apparaat met het gezochte IP-adres antwoordt met zijn eigen MAC-adres.
  3. **ARP Cache:** De vragende host slaat de koppeling (`IP ↔ MAC`) tijdelijk op in zijn **ARP-cache** om herhaalde broadcasts te voorkomen. Entries hebben een *timeout* en vervallen na verloop van tijd (*stale*).
* **Virtualisatie-opmerking:** In virtuele testomgevingen zoals GNS3 veranderen MAC-adressen telkens wanneer het netwerk opnieuw wordt opgestart; in de fysieke wereld zijn MAC-adressen vastgebrand op de netwerkkaart (al kunnen moderne apparaten zoals smartphones hun MAC-adres *spoofen* voor privacy).

---

## 3. Praktijkscenario's & Stappenplannen

### Scenario 1: Netwerkproblemen Troubleshooten & Subnet-communicatie Testen
Wanneer een host geen verbinding kan maken met een ander netwerksegment, volg je deze gestructureerde troubleshooting-volgorde (van lokaal naar extern):

1. **Controleer de lokale interface-configuratie (IP & Subnetmasker):**
   ```bash
   ip a
   # (Of op oudere systemen: ifconfig)
   ```
   * *Aandachtspunt:* Controleer of de primaire interface (`eth0`) een geldig IP-adres en het juiste subnetmasker (`/24`) heeft.
2. **Controleer de routeringstabel en netwerkconfiguratie:**
   ```bash
   netstat -r
   cat /etc/network/interfaces
   ```
   * *Valkuil:* Als `netstat -r` (of `ip r`) geen `default` gateway toont, controleer dan of `gateway` correct is gedefinieerd in `/etc/network/interfaces` (of Netplan/systemd-networkd).
3. **Test connectiviteit naar de lokale default gateway:**
   ```bash
   ping -c 4 192.168.0.1
   ```
   * *Aandachtspunt:* Als de default gateway niet bereikbaar is, ligt het probleem op het lokale netwerksegment (Layer 1/2 of lokale IP-configuratie).
4. **Test connectiviteit naar een host in een ander subnet:**
   ```bash
   ping -c 4 192.168.1.10
   ```
   * *Aandachtspunt:* Als de gateway wel antwoordt maar het externe subnet niet, controleer dan of de router online is en routes naar het doelsubnet kent.

### Scenario 2: ARP-gedrag Analyseren voor Lokaal vs. Extern Verkeer
Een veelvoorkomende denkfout bij beginners is te verwachten dat elk gepingd IP-adres in de ARP-cache verschijnt. Dit stappenplan laat het exacte verschil zien:

1. **Bekijk een schone ARP-cache na herstart van de interfaces:**
   ```bash
   arp -a
   ```
2. **Ping een host binnen hetzelfde subnet (`192.168.0.0/24`) en controleer de ARP-cache:**
   ```bash
   ping -c 4 192.168.0.20
   arp -a
   ```
   * *Resultaat:* In de ARP-cache verschijnt nu het IP-adres `192.168.0.20` gekoppeld aan het MAC-adres van `Linux-2`. In Wireshark (`arp`-filter) zie je dat `Linux-1` een ARP-broadcast stuurt, `Linux-2` antwoordt met zijn MAC-adres, en `Linux-2` direct daarna zelf een ARP-request stuurt om het MAC-adres van `Linux-1` te cachen.
3. **Ping een host in een ander subnet (`192.168.1.10`) en controleer de ARP-cache opnieuw:**
   ```bash
   ping -c 4 192.168.1.10
   arp -a
   ```
   * *Valkuil:* `192.168.1.10` en `192.168.1.20` verschijnen **niet** in de ARP-cache van `Linux-1`. Omdat ARP uitsluitend op Layer 2 binnen het lokale subnet werkt, vraagt `Linux-1` via ARP alleen het MAC-adres van de **default gateway (`192.168.0.1`)** op en stuurt het Ethernet-frame daarheen. De router verzorgt vervolgens de verdere ARP-afhandeling op het `192.168.1.0/24`-netwerk.

---

## 4. Aanvullende Bronnen & Referenties

* **Interne Commandoreferenties (SOC Analyst Map):**
  * Zie `BASH.md` (Sectie 9: *Netwerkconfiguratie, Routering & ARP*) voor alle Linux-netwerkcommando's, modernere `iproute2`-opvolgers en distributieverschillen.
  * Zie `CMD.md` en `PowerShell.md` voor de Windows-equivalenten (`ipconfig`, `arp`, `route`, `Get-NetIPAddress`, `Get-NetNeighbor`).
* **[Aanvullend] Officiële Documentatie & Hulpmiddelen:**
  * [Linux `iproute2` Documentation (`ip(8)`)](https://man7.org/linux/man-pages/man8/ip.8.html): Officiële man-page voor `ip addr`, `ip link`, `ip route` en `ip neigh`.
  * [RFC 826: An Ethernet Address Resolution Protocol (ARP)](https://datatracker.ietf.org/doc/html/rfc826): De originele IETF-specificatie van ARP.
  * [RFC 1918: Address Allocation for Private Internets](https://datatracker.ietf.org/doc/html/rfc1918): Specificatie van private IPv4-adresreeksen (`10.0.0.0/8`, `172.16.0.0/12`, `192.168.0.0/16`).