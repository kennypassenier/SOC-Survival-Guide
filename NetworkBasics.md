# Network Basics & Diagnostics Cheat Sheet

Een overzichtelijke naslaggids voor netwerkdiagnostiek, routing en de werking van het Address Resolution Protocol (ARP) op Layer 2 en Layer 3, inclusief moderne en legacy commando's.

---

## 1. Gestructureerde Netwerkdiagnostiek (Bottom-Up)

Bij het opsporen van netwerkproblemen werk je methodisch van de lokale stack naar buiten toe:

### Stap 1: Lokale interface en IP-configuratie controleren
Controleer of de netwerkinterface up is en een geldig IP-adres heeft verkregen.

**Moderne methode (iproute2):**
* `ip addr show`
* `ip link show`

**Verouderde methode (net-tools):**
* `ifconfig -a`

**Configuratiebestanden per distributie en generatie:**
* Debian/Ubuntu (Netplan - modern): `/etc/netplan/*.yaml`
* Debian/Ubuntu (Traditioneel / legacy): `/etc/network/interfaces`
* RHEL/CentOS/Fedora (NetworkManager): `/etc/NetworkManager/system-connections/` of via CLI: `nmcli device status`
* systemd-networkd: `/etc/systemd/network/*.network`

---

### Stap 2: Loopback stack valideren
Controleer of de lokale TCP/IP-stack van het besturingssysteem correct functioneert:
* `ping -c 2 127.0.0.1`

---

### Stap 3: Default Gateway verifiëren en testen
Bevestig welke gateway het systeem gebruikt om extern verkeer te routeren.

**Moderne methode (iproute2):**
* `ip route show`

**Verouderde methode (net-tools):**
* `netstat -rn`
* `route -n`

**Test connectiviteit naar het IP-adres van de default gateway:**
* `ping -c 4 192.168.0.1`

---

### Stap 4: Externe IP-connectiviteit en DNS testen
Als de gateway bereikbaar is, test je internettoegang (eerst op IP, daarna op domeinnaam om DNS-problemen te isoleren):

**Directe IP-connectiviteit (omzeilt DNS):**
* `ping -c 4 1.1.1.1`

**DNS-resolutie controleren:**
* `nslookup google.com`
* `dig google.com`
* `host google.com`

**Actieve DNS-servers inspecteren:**
* `cat /etc/resolv.conf`
* `resolvectl status`

---

## 2. ARP (Address Resolution Protocol)

ARP opereert tussen Layer 2 (Data Link) en Layer 3 (Network). Het vertaalt een bekend IPv4-adres naar een fysiek MAC-adres binnen hetzelfde Ethernet-broadcastdomein.

### ARP Cache Inspecteren en Beheren

| Bewerking | Modern (iproute2) | Legacy (net-tools) |
| :--- | :--- | :--- |
| **Cache tonen** | `ip neigh show` | `arp -a` of `arp -n` |
| **Item verwijderen** | `ip neigh del 192.168.0.50 dev eth0` | `arp -d 192.168.0.50` |
| **Statische entry toevoegen** | `ip neigh add 192.168.0.50 lladdr 00:11:22:33:44:55 dev eth0 nud permanent` | `arp -s 192.168.0.50 00:11:22:33:44:55` |

---

## 3. Exacte Werking van ARP Exchanges

### Scenario A: Apparaten in hetzelfde subnet (D1 -> D2)

Situatie: D1 (192.168.1.10) wil pingen naar D2 (192.168.1.20) binnen hetzelfde /24 subnet.

<pre>
D1 (192.168.1.10)                                 D2 (192.168.1.20)
       |                                                 |
       |--- 1. ARP Request (Broadcast: FF:FF:FF:FF:FF:FF) --> (Iedereen ontvangt dit)
       |       "Wie heeft 192.168.1.20? Vertel het 1.10" |
       |                                                 | [D2 leest direct IP+MAC van D1
       |                                                 |  en slaat dit direct op in cache]
       |&lt;-- 2. ARP Reply (Unicast naar D1 MAC) ----------|
       |       "Ik ben 192.168.1.20, mijn MAC is D2:MAC" |
       |                                                 |
  [D1 slaat D2 op                                        |
   en start ICMP]                                        |
</pre>

**Stap-voor-stap uitleg:**
1. **Subnetevaluatie:** D1 vergelijkt het doel-IP (192.168.1.20) met zijn eigen subnetmasker en stelt vast dat D2 zich in hetzelfde lokale subnet bevindt.
2. **Cache check:** D1 controleert zijn lokale ARP-tabel. Staat het MAC-adres van D2 er niet in, dan wordt het ICMP-pakket even vastgehouden.
3. **ARP Request:** D1 verstuurt een Ethernet-frame met broadcast MAC-adres `FF:FF:FF:FF:FF:FF`. Elk apparaat op de switch ontvangt dit. Payload: *"Wie heeft 192.168.1.20? Meld dit aan 192.168.1.10 op D1:MAC"*.
4. **Verwerking door D2:** D2 herkent zijn IP. D2 leest de zendergegevens (IP en MAC van D1) uit de header en bewaart deze direct in zijn eigen ARP-cache. D2 stuurt GEEN aparte ARP-request meer terug.
5. **ARP Reply:** D2 stuurt een gerichte unicast direct naar het MAC-adres van D1 met de bevestiging van zijn MAC-adres.
6. **Dataoverdracht:** D1 slaat de entry op in de cache en verzendt direct de ICMP echo-request (ping).

---

### Scenario B: Apparaten in verschillende subnets via een Router (D1 -> D3)

Situatie: D1 (192.168.1.10) wil pingen naar D3 (10.0.0.50) via router-interface R1 (192.168.1.1).

<pre>
D1 (192.168.1.10)                Router (R1: 192.168.1.1)            D3 (10.0.0.50)
       |                                   |                                |
  [Berekent: D3 is extern!                 |                                |
   Doel MAC = Default Gateway]             |                                |
       |                                   |                                |
       |--- 1. ARP Request (Broadcast) ---&gt;|                                |
       |    "Wie heeft 192.168.1.1?"       |                                |
       |&lt;-- 2. ARP Reply (Unicast) --------|                                |
       |    "192.168.1.1 is R1:MAC"        |                                |
       |                                   |                                |
       |=== 3. ICMP Packet ================|                                |
       |    Src IP: 192.168.1.10           |--- 4. Router doet ARP voor D3-&gt;|
       |    Dst IP: 10.0.0.50              |&lt;--    (indien niet in cache) --|
       |    Dst MAC: R1:MAC                |                                |
       |                                   |=== 5. Forward ICMP ===========&gt;|
       |                                   |    Src IP: 192.168.1.10        |
       |                                   |    Dst IP: 10.0.0.50           |
       |                                   |    Dst MAC: D3:MAC             |
</pre>

**Stap-voor-stap uitleg:**
1. **Subnetevaluatie:** D1 vergelijkt 10.0.0.50 met zijn eigen subnetmasker en concludeert dat D3 zich in een ander subnet bevindt.
2. **Routing lookup:** Omdat D3 extern is, zendt D1 NOOIT een ARP-request uit voor 10.0.0.50 (routers laten Layer 2 broadcasts immers niet door). D1 kijkt in de routeringstabel en ziet dat al het niet-lokale verkeer naar de Default Gateway (192.168.1.1) moet.
3. **ARP voor de Gateway:** D1 stuurt een ARP-broadcast met de vraag: *"Wie heeft 192.168.1.1?"*.
4. **Gateway Reply:** De router antwoordt met zijn eigen MAC-adres (`R1:MAC`).
5. **Frame-opbouw (Layer 2 versus Layer 3 splitsing):**
   * **Layer 3 (IP-header):** Bron = `192.168.1.10` | Doel = `10.0.0.50` (het einddoel-IP blijft ongewijzigd).
   * **Layer 2 (Ethernet-header):** Bron = `D1:MAC` | Doel = `R1:MAC` (het frame wordt afgeleverd bij de tussenstap: de router).
6. **Forwarding:** De router ontvangt het frame, stript de Layer 2 header eraf, ziet in de Layer 3 header dat het pakket bestemd is voor 10.0.0.50, raadpleegt zijn eigen routeringstabel en voert op het subnet van D3 zo nodig een eigen ARP-resolutie uit om het MAC-adres van D3 op te halen en het pakket door te sturen.
