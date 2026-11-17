# Network Troubleshooting Basics

## 1. Overzicht van Relevante Commando's & Tools

### A. Connectiviteit, Routing & Interface-diagnose (`ping`, `traceroute`, `ip`, `netstat`)

#### `ping`
* **Doel:** Controleert met behulp van het **ICMP-protocol** (*Internet Control Message Protocol*) of een doelhost op een IP-netwerk bereikbaar is en meet de *round-trip time* (latentie).
* **Parameters & Opties:**
  * `-c <aantal>` (`c` = **c**ount — Linux/Unix): Verstuurt een exact aantal ICMP Echo Requests en stopt daarna automatisch (zonder `-c` blijft Linux oneindig pingen totdat je op `Ctrl + C` drukt).
* **Praktijkgebruik & Permutaties:**
  ```bash
  # Test eerst de lokale default gateway (Layer 3)
  ping -c 4 192.168.1.1

  # Test vervolgens algemene IP-connectiviteit naar het internet (bijv. Google DNS)
  ping -c 4 8.8.8.8

  # Test tot slot naamresolutie (DNS) via een domeinnaam of lokale hostnaam
  ping -c 4 google.com
  ping -c 4 FILESERVER
  ```
* **Tips, Valkuilen & OS-verschillen:**
  * **IP-test vs. Naam-test:** Als `ping 8.8.8.8` of `ping 192.168.1.20` wél werkt, maar `ping google.com` of `ping FILESERVER` faalt (bijv. met `bad address`), dan is de netwerkverbinding in orde en ligt het probleem bij **DNS / naamresolutie**.
  * **Windows-equivalent:** Op Windows stuurt `ping <doel>` standaard al 4 pakketten; gebruik `ping -n 4 <doel>` (`n` = **n**umber) om een ander aantal op te geven of `ping -t <doel>` om continu te pingen.

#### `traceroute` / `tracert`
* **Doel:** Brengt het volledige routeringspad (*hops*) in kaart dat netwerkpakketten afleggen van de broncomputer naar een doelhost, om te achterhalen waar vertragingen (*bottlenecks*) of verbindingsonderbrekingen optreden.
* **Praktijkgebruik:**
  ```bash
  # Linux / Unix: traceer de route naar een doel-IP of domein
  traceroute 8.8.8.8
  ```
  ```cmd
  :: Windows (CMD & PowerShell): traceer de route naar een doel
  tracert 8.8.8.8
  ```
* **[Aanvullend] Extra Switches & Modernere Mogelijkheden:**
  * **Linux:** Gebruik `traceroute -n 8.8.8.8` (`-n` = geen trage reverse DNS-lookups per hop) of het modernere `mtr 8.8.8.8` (*My Traceroute*, combineert `ping` en `traceroute` in realtime).
  * **Windows PowerShell:** `Test-NetConnection -ComputerName 8.8.8.8 -TraceRoute` (en voor specifieke TCP-poorttests: `Test-NetConnection -ComputerName FILESERVER -Port 445`).

#### `ip a`, `ifconfig` & `netstat -r`
* **Doel:**
  * `ip a` (of het oudere `ifconfig` op Linux, `ipconfig` op Windows): Toont de configuratie van netwerkinterfaces (IPv4/IPv6-adressen, subnetmaskers en interface-status).
  * `netstat -r`: Toont de actieve IP-routeringstabel en de geconfigureerde **default gateway**.
* **Praktijkgebruik:**
  ```bash
  # Controleer IP-adres en subnetmasker op Linux (ook op Alpine Linux)
  ip a

  # Controleer de routeringstabel en default gateway
  netstat -r
  ```
* **[Aanvullend] Modernere Linux-equivalenten:** Op moderne Debian/Ubuntu- en Arch-systemen is `ip route` (kortweg `ip r`) de standaardvervanger voor `netstat -r`, en `ss -tulnp` voor het bekijken van actieve verbindingen en luisterende poorten (`netstat -antup`).

---

### B. DNS & Naamresolutie (`nslookup`, `dig`, `/etc/resolv.conf`, `/etc/hosts`)

#### `nslookup` & `dig`
* **Doel:** Bevraagt DNS-servers om hostnamen naar IP-adressen te vertalen (A/AAAA-records) en omgekeerd (PTR-records) om DNS-problemen te diagnosticeren.
* **Praktijkgebruik:**
  ```bash
  # Linux / Unix: bevraag DNS-records met dig (of gebruik nslookup op Windows & Linux)
  dig FILESERVER.clab.local
  nslookup google.com
  ```

#### `/etc/resolv.conf`, `/etc/network/interfaces` & `/etc/hosts` (Linux)
* **Doel:**
  * `/etc/resolv.conf`: Standaard DNS-clientconfiguratiebestand op de meeste Linux-distributies; bepaalt welke DNS-server (`nameserver`) wordt geraadpleegd en welk zoekdomein (`search`) automatisch achter korte hostnamen wordt geplakt.
  * `/etc/network/interfaces`: Netwerkinterface-configuratiebestand op Alpine Linux en klassieke Debian-systemen (bijv. voor statische IP's of `dns-nameservers`).
  * `/etc/hosts`: Lokaal statisch bestand voor handmatige IP-naar-hostnaam-koppelingen; heeft voorrang op DNS en is nuttig wanneer slechts één losse client een specifieke server over een VPN moet bereiken zonder extra DNS-verkeer over de tunnel te sturen.
* **Praktijkgebruik & Permutaties:**
  ```bash
  # Inspecteer de huidige DNS- en interfaceconfiguratie
  cat /etc/network/interfaces
  cat /etc/resolv.conf

  # Stel een interne DNS-server in en voeg een search-domein toe zodat korte hostnamen werken
  echo "nameserver 192.168.1.5" > /etc/resolv.conf
  echo "search clab.local" >> /etc/resolv.conf

  # Voeg een lokale statische host-entry toe aan /etc/hosts
  echo "192.168.1.20 FILESERVER" >> /etc/hosts
  ```
* **Tips, Valkuilen & Modernere Mogelijkheden:**
  * **Search domain (`search clab.local`):** Wanneer een gebruiker alleen `FILESERVER` typt in plaats van de volledige *Fully Qualified Domain Name* (`FILESERVER.clab.local`), voegt de DNS-client automatisch `.clab.local` toe dankzij de `search`-regel in `/etc/resolv.conf`.
  * **[Aanvullend] Modernere DNS-beheertools op Linux & Windows:**
    * Op moderne Debian/Ubuntu- en Arch-systemen met `systemd-resolved` wordt `/etc/resolv.conf` vaak automatisch beheerd; inspecteer DNS daar met `resolvectl status`.
    * Op Windows leeg je de DNS-cache met `ipconfig /flushdns` (CMD) of `Clear-DnsClientCache` (PowerShell) en bevraag je DNS met `Resolve-DnsName`.

---

### C. DHCP-client, Pakketbeheer (Alpine), SMB & Packet Capture

#### `udhcpc` (Alpine Linux DHCP-client)
* **Doel:** Lichtgewicht DHCP-client op Alpine Linux en embedded systemen die bij de lokale DHCP-server een IP-adres, subnetmasker, gateway en DNS-servers opvraagt (*DORA*-proces).
* **Praktijkgebruik:**
  ```bash
  # Vraag handmatig een nieuwe DHCP-lease op bij de lokale DHCP-server (afbreken met Ctrl + C)
  udhcpc
  ```
* **[Aanvullend] OS-verschillen voor DHCP-vernieuwing:**
  * **Debian / Ubuntu:** `sudo dhclient -r && sudo dhclient` (of `sudo systemctl restart NetworkManager` / `netplan apply`).
  * **Arch Linux:** `sudo dhcpcd` of `networkctl renew <interface>`.
  * **Windows (CMD & PowerShell):** `ipconfig /release` gevolgd door `ipconfig /renew`.

#### `apk` & `smbclient` (Alpine Linux & SMB Shares)
* **Doel:**
  * `apk` (*Alpine Package Keeper*): De standaard pakketbeheerder op Alpine Linux (het equivalent van `apt` op Debian/Ubuntu, `pacman` op Arch en `yum`/`dnf` op RedHat).
  * `smbclient`: Command-line client om SMB/CIFS-netwerkshares op een bestandsserver te inventariseren en te benaderen.
* **Parameters & Opties:**
  * `add <pakket>` bij `apk`: Installeert een softwarepakket vanuit de Alpine-repositories.
  * `-L <host>` bij `smbclient` (`L` = **L**ist): Toont alle gedeelde mappen (*shares*) op de doelserver.
  * `-U <gebruiker>` bij `smbclient` (`U` = **U**ser): Specificeert de gebruikersnaam voor authenticatie.
* **Praktijkgebruik:**
  ```bash
  # Installeer de Samba-client op Alpine Linux en controleer de versie
  apk add samba-client
  smbclient --version

  # Vraag een overzicht op van alle beschikbare SMB-shares op FILESERVER als gebruiker 'cybrary'
  smbclient -L FILESERVER -U cybrary
  ```
* **Tips & Valkuilen:**
  * Een foutmelding zoals `temporary error` bij `apk add` wijst vrijwel altijd op het ontbreken van internettoegang of een defecte DNS-resolutie.

#### `Wireshark`, `TCPDump` & Kabeltesters
* **Doel:**
  * **Wireshark:** Grafische netwerkprotocol-analyzer om netwerkpakketten in realtime vast te leggen en per protocollaag te inspecteren op fouten, afwijkingen of overmatig verkeer.
  * **TCPDump:** Command-line packet analyzer voor Unix/Linux-systemen (bijv. `sudo tcpdump -i eth0 -n icmp`).
  * **Kabeltesters:** Fysieke hardwaretools om kabelbreuken, slechte connectoren of verkeerde aderparen op Layer 1 op te sporen.

---

## 2. Algemene Uitleg & Theorie

### Methodische Probleemoplossing (Troubleshooting Checklist)
Gebruikers melden vaak dat *"alles"* tegelijk kapot is. Een gestructureerde aanpak voorkomt giswerk door eerst de **scope** (*is het lokaal voor één gebruiker, één applicatie, één VLAN/afdeling of het hele netwerk?*) te verkleinen en van **binnen naar buiten** te testen:

1. **Define the Problem:** Verzamel nauwkeurige foutmeldingen en symptomen bij gebruikers en monitoringsystemen.
2. **Identify Affected Systems:** Bepaal welke specifieke hosts, servers of subnetten getroffen zijn.
3. **Isolate the Problem:** Stel vast of het probleem lokaal op één client zit of systemisch in het netwerk.
4. **Check Physical Connectivity:** Controleer kabels, netwerkkaarten (NIC's) en switchpoorten.
5. **Review Configuration:** Controleer IP-adressen, subnetmaskers, VLAN's, firewallregels (ACL's) en VPN-tunnels.
6. **Ping and Trace Route:** Test stap voor stap connectiviteit van lokaal (loopback/gateway) naar extern (remote subnet/internet).
7. **Check DNS and Name Resolution:** Controleer of IP-bereikbaarheid wél werkt maar naamresolutie niet (zonebestanden, A-records, DNS-resolver, `/etc/resolv.conf`).
8. **Examine Network Traffic:** Gebruik Wireshark of `tcpdump` om pakketverkeer diepgaand te analyseren.

### Laag-voor-Laag Probleemoplossing (Layer 1, 2 & 3)

| Netwerklaag | Focusgebied | Wat controleer je & hoe los je het op? |
| :--- | :--- | :--- |
| **Layer 1: Physical** | NIC, UTP-kabels, wandcontactdozen (*wall jacks*), patchpanelen en switchpoorten. | • Als Layer 1 faalt, falen alle bovenliggende lagen.<br>• Controleer OS-logs op NIC-hardwarefouten; test met een reserve-NIC of USB-NIC.<br>• Vervang UTP-patchkabels (host → wandcontactdoos en patchpaneel → switchpoort) of verplaats de host naar een andere wandcontactdoos / switchpoort in hetzelfde **VLAN**.<br>• Let op **Port Security** op switches (zoals Cisco-switches die een poort blokkeren zodra een nieuw/onbekend MAC-adres wordt gedetecteerd). |
| **Layer 2: Data Link** | Lokale LAN-communicatie (host → switch → host), MAC-adressen en VLAN's. | • Test of de host andere hosts binnen hetzelfde lokale subnet kan bereiken.<br>• Controleer de **ARP-cache** op zowel de lokale als de externe host op verouderde of onjuiste IP-naar-MAC-koppelingen.<br>• Controleer op de switch de **MAC-adrestabel (CAM-tabel)** en wis verouderde entries indien nodig.<br>• Verifieer dat de switchpoort aan het juiste **VLAN** is toegewezen. |
| **Layer 3: Network** | IP-routering tussen netwerken (host → router → host), DHCP en DNS. | • Controleer of **IP-adres**, **subnetmasker** en **default gateway** op de host kloppen.<br>• Test tweerichtingsverkeer: kan de host de gateway bereiken, en kan de gateway de host bereiken?<br>• **DHCP:** Clients huren (*leasen*) IP-instellingen (IP, masker, gateway, DNS-server, domeinnaam) uit een pool. Vernieuw een verlopen of mislukte DHCP-lease (`udhcpc`, `dhclient`, `ipconfig /renew`) en controleer of de DHCP-server (bijv. op pfSense) is ingeschakeld.<br>• **DNS:** Als pingen op IP wél werkt maar op naam niet, controleer `/etc/resolv.conf` op de client en controleer op de DNS-server of het **A-record** in het zonebestand bestaat en of de DNS-service draait. |

### DNS Server vs. DNS Resolver & IPsec VPN Tunnels
* **DNS Server vs. DNS Resolver:** Een **DNS-server** host daadwerkelijk lokale DNS-zonebestanden (zoals `clab.local`) met *SOA*-, *NS*- en *A*-records. Een **DNS-resolver** (zoals de *DNS Resolver*-service op pfSense) host zelf geen zonebestanden, maar handelt namens lokale clients DNS-aanvragen af door ze door te sturen naar externe of autoritatieve DNS-servers.
* **IPsec VPN (Phase 1 & Phase 2):** Een site-to-site IPsec VPN-tunnel tussen twee firewalls (zoals `Firewall-A` voor `192.168.1.0/24` en `Firewall-B` voor `10.10.10.0/24`) bestaat uit twee fasen: **Phase 1 (P1)** en **Phase 2 (P2)**, die samen een *Security Association (SA)* vormen. Door netwerkstoringen of inactiviteit kan een SA verlopen (*Disconnected*), waardoor verkeer tussen de twee subnetten stopt totdat P1 en P2 opnieuw worden opgebouwd.

---

## 3. Praktijkscenario's & Stappenplannen

### Scenario 1: Geen Internet of DNS-resolutie op een Linux Client (`Linux-A` in `192.168.1.0/24`)
Een gebruiker kan geen pakketten installeren (`apk add samba-client` geeft `temporary error`):

1. **Controleer interface-instellingen, routering en IP-connectiviteit van binnen naar buiten:**
   ```bash
   ip a
   netstat -r
   ping -c 4 192.168.1.1
   ping -c 4 8.8.8.8
   ```
   * *Diagnose:* Als `8.8.8.8` bereikbaar is maar `ping -c 4 google.com` faalt, werkt IP-routering maar ontbreekt DNS.
2. **Controleer `/etc/resolv.conf` en configureer de interne DNS-server (`192.168.1.5`) + search domain:**
   ```bash
   cat /etc/resolv.conf
   echo "nameserver 192.168.1.5" > /etc/resolv.conf
   echo "search clab.local" >> /etc/resolv.conf
   cat /etc/resolv.conf
   ```
3. **Verifieer naamresolutie en rond de pakketinstallatie af:**
   ```bash
   ping -c 4 google.com
   apk add samba-client
   smbclient --version
   ```

### Scenario 2: Client Krijgt Geen IP-adres via DHCP (`Linux-B` in `10.10.10.0/24`)
Een client op een nieuw omgezet DHCP-subnet heeft geen internetverbinding:

1. **Test handmatig een DHCP-aanvraag op de client:**
   ```bash
   udhcpc
   ```
   * *Diagnose:* Als de client blijft zoeken zonder antwoord, reageert de DHCP-server op het subnet niet.
2. **Activeer en configureer de DHCP-server op de lokale firewall (pfSense):**
   * Log in op de pfSense webinterface → **Services → DHCP Server → LAN**.
   * Vink **Enable DHCP server on LAN interface** aan, stel de IP-pool in (bijv. `10.10.10.100` t/m `10.10.10.110`), vul als **DNS Servers** en **Gateway** het LAN-IP van de firewall in (`10.10.10.1`) en klik op **Save**.
   * Controleer onder **Services → DNS Resolver** dat de resolver actief is.
3. **Vernieuw de DHCP-lease op `Linux-B` en valideer:**
   ```bash
   udhcpc
   ip a
   netstat -r
   cat /etc/resolv.conf
   ping -c 4 google.com
   ```

### Scenario 3: Lokale Server (`FILESERVER`) Onbereikbaar Lokaal én over Site-to-Site IPsec VPN
1. **Ontbrekend DNS A-record oplossen op de interne DNS-server (`192.168.1.5`):**
   * Als `smbclient -L FILESERVER -U cybrary` en `ping FILESERVER` falen terwijl de DNS-server wél bereikbaar is, open dan de DNS-beheerinterface → **Zones → `clab.local` → Add Record**.
   * Voeg een **A-record** toe voor `FILESERVER` verwijzend naar `192.168.1.20` (inclusief PTR-record) en test met `ping -c 4 FILESERVER` (dankzij `search clab.local` in `/etc/resolv.conf`).
2. **Naamresolutie en verbroken IPsec VPN-tunnel herstellen voor het externe subnet (`10.10.10.0/24`):**
   * Voeg voor een enkele externe client (`Linux-B`) een lokale host-entry toe om onnodig DNS-verkeer over de VPN te voorkomen:
```bash
echo "192.168.1.20 FILESERVER" >> /etc/hosts
```
   * Als `ping -c 4 FILESERVER` nu wél het juiste IP (`192.168.1.20`) oplost maar pakketten niet aankomen, open dan op pfSense **Status → IPsec**.
   * Wanneer de status op **Disconnected** staat, klik je op **Connect P1 and P2s** om de *Security Association* te herstarten, en verifieer je opnieuw met `ping -c 4 FILESERVER`.

---

## 4. Aanvullende Bronnen & Referenties

* **Interne Commandoreferenties (SOC Analyst Map):**
  * Zie `BASH.md` (Sectie 5: *Netwerkbeheer, Monitoring & Firewalls*) voor `ping`, `traceroute`, `ip a`, `netstat`, `dig`, `nslookup`, `tcpdump`, `udhcpc`, `apk` en `smbclient`.
  * Zie `CMD.md` (`tracert`, `ipconfig /release`, `ipconfig /renew`, `ipconfig /flushdns`, `nslookup`) en `PowerShell.md` (`Test-NetConnection`, `Resolve-DnsName`, `Clear-DnsClientCache`) voor de Windows-equivalenten.
* **[Aanvullend] Officiële Documentatie & Hulpmiddelen:**
  * [pfSense Documentation: IPsec Troubleshooting & DHCP Server](https://docs.netgate.com/pfsense/en/latest/) — Officiële documentatie voor pfSense DHCP, DNS Resolver en Phase 1/Phase 2 IPsec-tunnels.
  * [Alpine Linux Wiki: Package Management (`apk`) & Networking](https://wiki.alpinelinux.org/wiki/Alpine_Package_Keeper) — Referentie voor `apk`, `/etc/network/interfaces` en `udhcpc`.
  * [Wireshark User's Guide](https://www.wireshark.org/docs/wsug_html_chunked/) — Handleiding voor pakketanalyse en filterexpressies bij netwerkstoringen.