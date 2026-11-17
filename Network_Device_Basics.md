# Network Device Basics

## 1. Overzicht van Relevante Commando's

### A. Netwerkconfiguratie & Interface-inspectie

#### `cat /etc/network/interfaces`
* **Doel:** Inspecteert het netwerkconfiguratiebestand om te controleren of interfaces (zoals `eth0` en `eth1`) zijn ingesteld op **DHCP** of op een **statisch IP-adres** met subnetmasker en gateway.
* **Praktijkgebruik:**
  ```bash
  # Bekijk of DHCP actief is of dat er statische IP-instellingen zijn geconfigureerd
  cat /etc/network/interfaces
  ```
* **Tips, Valkuilen & Modernere Mogelijkheden:**
  * Regels die beginnen met `#` zijn uitgecommentarieerd en niet actief. Wanneer `Static config` is uitgecommentarieerd en `iface eth0 inet dhcp` actief staat, vraagt de host automatisch een IP-adres en default gateway op bij de DHCP-server (zoals pfSense).
  * **[Aanvullend] Modernere mogelijkheden & OS-verschillen:**
    * **Recente Ubuntu / Debian servers:** Gebruiken **Netplan** (`/etc/netplan/*.yaml`, toegepast met `sudo netplan apply`) of **NetworkManager** (`nmcli device show`).
    * **Arch Linux:** Gebruikt `/etc/network/interfaces` niet; netwerkinterfaces worden beheerd via **systemd-networkd** (`/etc/systemd/network/*.network`), **NetworkManager** (`nmcli`) of `dhcpcd`.
    * **Windows:** Gebruik `ipconfig /all` (CMD) om te zien of `DHCP Enabled` op `Yes` staat, of `Get-NetIPInterface` (PowerShell).

#### `ifconfig` & `ip a`
* **Doel:** Inspecteert netwerkinterfaces, toegewezen IPv4-adressen, subnetmaskers en MAC-adressen op Linux-hosts en -routers.
* **Praktijkgebruik & Permutaties:**
  ```bash
  # Klassieke weergave van netwerkinterfaces (eth0, eth1, lo)
  ifconfig

  # Modernere weergave met CIDR-notatie (bijv. 192.168.1.100/24 of 10.10.10.1/24)
  ip a
  ```
* **[Aanvullend] Modernere Mogelijkheden & Windows-equivalenten:**
  * **Linux (Debian & Arch):** `ip -c a` (`-c` = **c**olor) en `ip -br a` (`-br` = **br**ief) zijn de moderne standaarden binnen `iproute2`.
  * **Windows:** `ipconfig /all`, `ipconfig /release` en `ipconfig /renew` (CMD) of `Get-NetIPAddress` (PowerShell) om DHCP-leases en IP-configuraties te controleren.

---

### B. Routering, Connectiviteit & Simulatietools

#### `netstat`
* **Doel:** Inspecteert de kernel IP-routeringstabel en netwerkverbindingen.
* **Parameters & Opties:**
  * `-r` (`r` = **r**oute): Toont de kernel IP-routeringstabel.
  * `-n` (`n` = **n**umeric): Toont numerieke IP-adressen in plaats van hostnamen op te lossen (sneller en voorkomt DNS-vertraging).
* **Praktijkgebruik:**
  ```bash
  # Controleer de default gateway (0.0.0.0) in numeriek formaat
  netstat -rn
  ```
* **Tips, Valkuilen & Modernere Mogelijkheden:**
  * In de routeringstabel betekent bestemming `0.0.0.0` ("alles"): al het verkeer dat niet voor een lokaal subnet bestemd is, wordt doorgestuurd naar de opgegeven *Gateway* (bijv. het LAN-adres `192.168.1.1` van de pfSense-firewall).
  * **[Aanvullend] Modernere Mogelijkheden (Linux & Windows):**
    * **Linux (Debian & Arch):** `ip route` (kortweg `ip r`) is de modernere opvolger van `netstat -rn`. Met `sudo ip route add 10.10.10.0/24 via 192.168.1.254` voeg je op Linux handmatig een statische route toe.
    * **Windows:** `route print` (CMD) of `Get-NetRoute` (PowerShell) toont de routeringstabel; `route add 10.10.10.0 mask 255.255.255.0 192.168.1.254` (CMD) of `New-NetRoute` (PowerShell) voegt een statische route toe.

#### `ping`
* **Doel:** Test Layer 3 connectiviteit tussen interne hosts, routers, de pfSense-firewall en externe "Internet"-hosts (zoals de ISP op `66.67.68.1` of `Web`).
* **Parameters & Opties:**
  * `-c <aantal>` (`c` = **c**ount): Specificeert het aantal ICMP Echo Requests (bijv. `ping -c 4 192.168.1.1`).
* **Praktijkgebruik:**
  ```bash
  # Test vanuit Linux-2 eerst de eigen gateway (Router) en daarna de Firewall
  ping -c 4 10.10.10.1
  ping -c 4 192.168.1.1
  ```
* **[Aanvullend] Modernere Mogelijkheden & Windows-equivalenten:**
  * **Windows CMD:** `ping 192.168.1.1` (stuurt standaard 4 pakketten; gebruik `-t` voor continu pingen).
  * **Windows PowerShell:** `Test-Connection 192.168.1.1 -Count 4` voor ICMP, of `Test-NetConnection 192.168.1.1 -Port 80` om specifieke firewallregels en TCP-poorten te testen.

#### `gns3` & `vi`
* **Doel:**
  * `gns3`: Start de GNS3 netwerksimulator op de achtergrond (`gns3 &`).
  * `vi`: Klassieke teksteditor in de terminal om configuratiebestanden zoals `/etc/network/interfaces` te bewerken (in de labomgeving kan ook de GNS3 Node Properties GUI gebruikt worden).
* **[Aanvullend] Modernere Teksteditors:**
  * Op zowel Debian/Ubuntu als Arch Linux zijn `nano` (toegankelijk) of `vim` / `neovim` (`nvim`) veelgebruikte alternatieven voor `vi`.

---

## 2. Algemene Uitleg & Theorie

### Historie van Netwerken & Standaarden
* **ARPANET & TCP/IP:** Moderne netwerken vinden hun oorsprong in **ARPANET**, een vroeg prototype om onderzoeksinstellingen te verbinden. Aanvankelijk gebruikte ARPANET eigen, ad-hoc methoden, maar in de jaren 1970 stapte het over op het **TCP/IP-protocol**, wat de basis legde voor het eerste wereldwijde netwerk.
* **Van Gopher/Usenet naar het Web & DNS:** Vroege tools zoals *Gopher* en *Usenet* waren beperkt. De introductie van **HTML**, webbrowsers en het hiërarchische **Domain Name System (DNS)** (dat cryptische IP-adressen vertaalt naar leesbare domeinnamen) maakte informatie wereldwijd toegankelijk.
* **Evolutie van LAN- en Wi-Fi-snelheden:**
  * Leveranciers zoals IBM, Novell en Sun Microsystems ontwikkelden vroege LAN-technologieën zoals *Arcnet* en *Token Ring*, maar **Ethernet** over *twisted-pair*-kabels werd de standaard. Tegenwoordig is **1 Gbps (1000Base-T)** naar de desktop de standaard.
  * Draadloze netwerken (Wi-Fi) groeiden van **54 Mbps (`802.11g`)** naar **100 Gbps (`802.11ay`)**.

### Moderne Netwerkapparaten & OSI-lagen
* **Network Interface Card (NIC):** De netwerkkaart die een client of server fysiek of draadloos verbindt met het netwerk.
* **Bekabeling & Patchpaneel:** Een **UTP-kabel** (*Unshielded Twisted Pair*) loopt van de NIC naar een wandcontactdoos, vandaar naar een **patchpaneel** in de serverruimte en vervolgens naar een poort op een switch.
* **Switch (OSI Layer 2: Data Link):** Beheert lokaal LAN-verkeer door frames alleen naar de specifieke poort van het doelapparaat te sturen (op basis van MAC-adressen). Verkeer voor IP-adressen buiten het eigen LAN wordt doorgestuurd naar een router.
  * *Layer 3 Switches:* Geavanceerde switches die zowel lokaal Layer 2-verkeer afhandelen als Layer 3 IP-routering uitvoeren tussen geïsoleerde virtuele netwerken (**VLAN's**).
* **Router (OSI Layer 3: Network):** Verbindt verschillende LAN's met elkaar en routeert IP-pakketten tussen netwerken totdat het doel-LAN is bereikt.
* **Wireless Access Point (WAP):** Verbindt draadloze clients via een UTP-koppeling naar een switch met het bekabelde LAN.

### Verouderde Netwerkapparaten (Legacy)
* **Hub:** Een minder intelligente voorloper van de switch die elk binnenkomend pakket naar **alle poorten tegelijk** stuurt. Dit veroorzaakt netwerkcollisies (*collisions*) en vertraagt het netwerk.
* **Bridge:** Verbindt twee afzonderlijke LAN-segmenten tot één enkel LAN (het tegenovergestelde van een router, die netwerken juist scheidt).
* **Repeater:** Versterkt en verlengt het netwerksignaal wanneer een kabel zijn maximale lengte bereikt.

### Beveiligingsapparaten & WAN-verbindingen
* **Firewall:** Controleert en filtert verkeersstromen tussen een vertrouwd intern netwerk (LAN) en een onvertrouwd netwerk (WAN/Internet). Staat gewenst uitgaand verkeer toe (bijv. HTTPS) en beperkt inkomend verkeer tot publieke servers (bijv. een webserver).
  * **NAT (Network Address Translation):**
    * *Many-to-one NAT:* Laat alle interne clients één publiek IP-adres delen om op internet te browsen.
    * *One-to-one NAT:* Koppelt een publiek IP-adres aan een specifieke interne server zodat deze vanaf internet bereikbaar is.
* **Proxy:** Haalt webcontent op namens een interne client. Vaak krijgt uitsluitend de proxy directe internettoegang van de firewall; alle gebruikers gaan via de proxy zodat deze applicatieverkeer kan filteren en kwaadaardige websites kan blokkeren via een *blocklist*.
* **VPN (Virtual Private Network):** Creëert een versleutelde "virtuele netwerkkabel" (bijv. via **IPsec**) zodat externe clients veilig toegang krijgen tot interne LAN-bronnen. (Veel moderne firewalls integreren zowel VPN- als proxy-functies).
* **WAN (Wide Area Network):** Verbindt locaties over grote afstanden (bijv. kantoren en datacenters) via routers en gehuurde telecomlijnen, zoals **Frame Relay** met seriële kaarten in een ster- of mesh-topologie. Omdat WAN-verbindingen trager zijn dan LAN's, is verkeersbeheer nodig om verzadiging (*saturation*) te voorkomen.

---

## 3. Praktijkscenario's & Stappenplannen

### Scenario 1: Een pfSense Firewall, DHCP Server & Firewall Rules Inspecteren
In een bedrijfsnetwerk fungeert een appliance zoals **pfSense** vaak tegelijkertijd als firewall, primaire router/default gateway en DHCP-server:

1. **Controleer de netwerkinterfaces op pfSense (Web GUI):**
   * **LAN-interface (`em1`):** Bevat het interne statische IPv4-adres (bijv. `192.168.1.1/24`), dat dient als default gateway voor interne clients.
   * **WAN-interface (`em0`):** Bevat het externe IP-adres en wijst naar de **IPv4 Upstream gateway** (de ISP op `66.67.68.1`), waarheen al het niet-lokale internetverkeer wordt doorgestuurd.
2. **Controleer de DHCP-serverconfiguratie (*Services → DHCP Server → LAN*):**
   * Verifieer of DHCP actief is en welke IP-pool wordt uitgedeeld (bijv. `.100` tot `.200` in `192.168.1.0/24`), inclusief de meegestuurde Gateway (`192.168.1.1`).
   * Bevestig op een Linux-client (`Linux-1`) met `cat /etc/network/interfaces`, `ip a` en `netstat -rn` dat de client een IP-adres uit deze pool en default gateway `0.0.0.0 → 192.168.1.1` heeft ontvangen.
3. **Analyseer de Firewall Rules (*Firewall → Rules*):**
   * **WAN-tabblad:** Bevat standaard geen zichtbare regels, maar elke firewall-interface heeft altijd een verborgen impliciete regel: **"deny everything"** (blokkeer al het ongevraagde inkomende verkeer vanaf internet).
   * **Stateful filtering:** Omdat pfSense een *stateful firewall* is, wordt antwoordverkeer op een geldige uitgaande aanvraag van een interne client wél automatisch terug doorgelaten zonder aparte WAN-regel.
   * **LAN-tabblad:** Bevat standaard regels die toegang tot de webconfiguratie (poort 80) en al het uitgaande IPv4/IPv6-verkeer vanaf `LAN net` toestaan.
   * **[Aanvullend] SOC & Security Best Practice:** In een productieomgeving mag uitgaand verkeer vanaf het LAN nooit volledig openstaan (`any`); beperk uitgaande poorten tot strikt noodzakelijke protocollen (zoals HTTPS/DNS) zodat gecompromitteerde hosts met malware geen ongehinderde verbinding met Command-and-Control (C2)-servers kunnen opzetten.

### Scenario 2: Een Nieuw Subnet (`10.10.10.0/24`) Toevoegen Achter een Interne Router
Wanneer je een tweede lokaal netwerksegment achter een extra router plaatst, volstaat alleen het instellen van IP-adressen op de router en client **niet**. Volg dit volledige stappenplan:

1. **Configureer twee interfaces op de interne Router:**
   * `eth0` (verbonden met het bestaande netwerk): IP `192.168.1.254`, netmask `255.255.255.0`, gateway `192.168.1.1` (de pfSense-firewall).
   * `eth1` (verbonden met het nieuwe subnet): IP `10.10.10.1`, netmask `255.255.255.0`.
   * Herstart de router en controleer met `ifconfig` (of `ip a`) en `netstat -rn` (of `ip r`) dat beide interfaces actief zijn en `192.168.1.1` als default gateway staat.
2. **Configureer de host in het nieuwe subnet (`Linux-2`):**
   * Stel `eth0` in op IP `10.10.10.100`, netmask `255.255.255.0` en gateway `10.10.10.1` (het interne adres van de Router).
3. **Herken het asymmetrische routeringsprobleem (Valkuil!):**
   * Als `Linux-2` nu `10.10.10.1` (de Router) pingt, werkt dit.
   * Als `Linux-2` echter `192.168.1.1` (de pfSense-firewall) pingt, **faalt de ping**! De pakketten bereiken de firewall wél, maar de firewall kent het netwerk `10.10.10.0/24` niet en stuurt zijn antwoordpakketten naar zijn eigen upstream gateway (`66.67.68.1` / ISP), waar ze verdwijnen.
4. **Voeg een Gateway en Static Route toe op de pfSense-firewall:**
   * Ga naar **System → Routing → Gateways → Add**: maak een gateway genaamd `Router` aan op interface `LAN` met IP `192.168.1.254` en klik op **Apply Changes**.
   * Ga naar **System → Routing → Static Routes → Add**: routeer doelnetwerk `10.10.10.0/24` via gateway `Router - 192.168.1.254` en klik op **Apply Changes**.
5. **Pas de Firewall Rules op de LAN-interface aan:**
   * De standaard LAN-regel staat alleen verkeer vanaf `LAN net` (`192.168.1.0/24`) toe, waardoor verkeer vanaf `10.10.10.0/24` alsnog door de firewall wordt geblokkeerd.
   * Voeg onder **Firewall → Rules → LAN** een regel toe voor `10.10.10.0/24` (of pas in een labomgeving de bron aan naar `any`) en klik op **Apply Changes**.
6. **Valideer end-to-end connectiviteit:**
   * Test vanaf `Linux-2` met `ping -c 4 192.168.1.1` en daarna een ping naar het externe `Web`-toestel.

---

## 4. Aanvullende Bronnen & Referenties

* **Interne Commandoreferenties (SOC Analyst Map):**
  * Zie `BASH.md` (Sectie 9: *Netwerkconfiguratie, Routering & ARP*) voor de Linux-commando's `ip`, `netstat`, `ifconfig`, `ping` en `/etc/network/interfaces`.
  * Zie `CMD.md` en `PowerShell.md` voor de Windows-equivalenten (`ipconfig /release` & `/renew`, `route add`, `New-NetRoute`, `Test-NetConnection`).
* **[Aanvullend] Officiële Documentatie & Hulpmiddelen:**
  * [Netgate pfSense Documentation: Routing & Gateways](https://docs.netgate.com/pfsense/en/latest/routing/) — Officiële documentatie over statische routes en gateways in pfSense.
  * [Netgate pfSense Documentation: Firewall Rules](https://docs.netgate.com/pfsense/en/latest/firewall/) — Uitleg over stateful inspection, impliciete deny-regels en interface-filtering.
  * [GNS3 Documentation](https://docs.gns3.com/) — Handleidingen voor het bouwen en emuleren van virtuele netwerktopologieën.