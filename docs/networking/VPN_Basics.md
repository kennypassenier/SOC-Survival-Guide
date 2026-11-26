# VPN Basics

## 1. Overzicht van Relevante Commando's & Tools

### A. Netwerksimulatie, Connectiviteit & VPN-verificatie (`gns3`, `ping`)

#### `gns3 &`
* **Doel:** Start de grafische netwerksimulator **GNS3** op de achtergrond (`&`) vanaf de Linux-opdrachtregel om virtuele netwerktopologieën (zoals routers, pfSense-firewalls en Linux-clients) te draaien.
* **Praktijkgebruik:**
  ```bash
  # Start GNS3 op de achtergrond vanuit de terminal
  gns3 &
  ```

#### `ping` (VPN Tunnel & Inter-Subnet Verificatie)
* **Doel:** Controleert via ICMP Echo Requests of een host in een extern subnet (bijv. `10.10.10.10` vanuit `192.168.1.0/24`) bereikbaar is over een actieve site-to-site VPN-tunnel.
* **Parameters & Opties:**
  * `-c <aantal>` (`c` = **c**ount — Linux/Unix): Verstuurt een exact aantal ping-pakketten en stopt daarna automatisch.
* **Praktijkgebruik:**
  ```bash
  # Test vanaf Linux-A (192.168.1.10) of Linux-B (10.10.10.10) bereikbaar is via de IPsec-tunnel
  ping -c 8 10.10.10.10
  ```
* **[Aanvullend] Linux CLI-tools voor IPsec & OpenVPN (`strongswan`, `ip xfrm`, `openvpn`):**
  * Waar in deze labomgeving **pfSense** (via de web-GUI) wordt gebruikt om IPsec te configureren, beheer je IPsec op Linux-servers (Debian/Ubuntu & Arch) doorgaans met **strongSwan** of **Libreswan**:
    * Tunnelstatus bekijken: `sudo ipsec statusall` of `sudo swanctl --list-sas`
    * Kernel Security Associations (SA's) en policies inspecteren: `sudo ip xfrm state` en `sudo ip xfrm policy`
    * OpenVPN-client starten vanaf de CLI: `sudo openvpn --config client.ovpn`
  * **Windows-equivalent (PowerShell):** `Get-NetIPsecMainModeSA`, `Get-NetIPsecQuickModeSA` en `Get-VpnConnection`.

---

### B. pfSense Web-GUI Beheeronderdelen (`IPsec`, `Firewall Rules`, `Diagnostics`, `Status`)

#### pfSense IPsec & Firewall Configuratie
* **Doel:** Configureren, beveiligen en activeren van een **Site-to-Site IPsec VPN-tunnel** tussen twee netwerken (`Site-A` met WAN `198.51.100.3` / LAN `192.168.1.0/24` en `Site-B` met WAN `203.0.113.5` / LAN `10.10.10.0/24`).
* **Belangrijkste Menu-onderdelen in pfSense:**
  * **Diagnostics → Ping:** Test rechtstreeks vanaf de WAN-interface van de firewall of de externe WAN-interface van de andere site (`203.0.113.5`) bereikbaar is.
  * **VPN → IPsec → Tunnels (`Add P1` / `Add P2`):**
    * **Phase 1 (P1):** Configureert de IKE Phase 1 Security Association (Remote Gateway, Pre-Shared Key, Encryption Algorithm zoals AES 256-bit, Lifetime en *Child SA Start/Close Action*).
    * **Phase 2 (P2):** Configureert de IKE Phase 2 Security Association (Local/Remote Network subnetten zoals `10.10.10.0/24`, Protocol `ESP` en Encryption Algorithms zoals `AES192-GCM`).
  * **Firewall → Rules → IPsec:** Standaard blokkeert pfSense verkeer dat uit een IPsec-tunnel aankomt; op beide firewalls moet op het tabblad **IPsec** expliciet een firewallregel worden aangemaakt om verkeer vanuit het externe LAN-subnet naar het lokale `LAN net` toe te staan.
  * **Status → IPsec → Overview (`Connect P1 and P2s`):** Toont de actuele verbindingsstatus van de P1- en P2-tunnels en biedt de knop **Connect P1 and P2s** om de tunnel handmatig op te bouwen.
* **Tips & Valkuilen:**
  * **WAN Ping-regel:** Een WAN-regel die ICMP/ping vanaf `*` (*any*) toestaat is handig om tijdens de opzet te testen of de remote gateway bereikbaar is, maar wordt in productieomgevingen na het testen uitgeschakeld.
  * **Sterke Pre-Shared Keys (PSK):** Gebruik in productie nooit een kort wachtwoord zoals `"cybrary"` als Pre-Shared Key, maar een lange, cryptografisch willekeurige sleutel (of certificaten).
  * **Vergeet de IPsec-firewallregels niet:** Een veelgemaakte fout is dat de IPsec-tunnel zelf op *Established* staat, maar er geen verkeer doorheen komt omdat op het tabblad **Firewall → Rules → IPsec** nog geen *Allow*-regel is toegevoegd.

---

## 2. Algemene Uitleg & Theorie

### Wat is een VPN & Veelgebruikte VPN-protocollen
* **Virtual Private Network (VPN):** Een technologie die een beveiligde, versleutelde verbinding (*tunnel*) opzet over een publiek of onvertrouwd netwerk (zoals het internet). Hierdoor kunnen gebruikers veilig interne bedrijfsbronnen benaderen en gegevens verzenden.
* **Kernvoordelen:** Waarborgt **privacy**, **vertrouwelijkheid (confidentiality)** en **data-integriteit** via cryptografische protocollen, ondersteunt diverse authenticatiemethoden (wachtwoorden, Pre-Shared Keys, digitale certificaten) en verbergt het werkelijke IP-adres en de fysieke locatie van de gebruiker.

| VPN-protocol | Transport & Poort | Encryptie & Authenticatie | Kenmerken & Beveiligingsstatus |
| :--- | :--- | :--- | :--- |
| **PPTP** (*Point-to-Point Tunneling Protocol*) | TCP | **MS-CHAP** (onveilige authenticatie) + **RC4** (verouderde stream cipher). | Oud protocol (vooral op Windows); eenvoudig op te zetten, maar **cryptografisch onveilig** en verouderd. |
| **L2TP** (*Layer 2 Tunneling Protocol*) | UDP (sneller dan PPTP's TCP) | **Geen eigen encryptie**; wordt vrijwel altijd gecombineerd met **IPsec** (*L2TP/IPsec*). | Combineert de tunnelopbouw van L2TP met de beveiliging van IPsec. |
| **SSTP** (*Secure Socket Tunneling Protocol*) | **TCP poort 443** | Maakt gebruik van SSL/TLS (historisch SSL 3.0). | Handig om strenge firewalls te omzeilen omdat het standaard HTTPS-poort `443` gebruikt; oudere SSL 3.0-implementaties zijn echter kwetsbaar voor de **POODLE**-aanval. |
| **IPsec** (*Internet Security Protocol*) | IP-protocoluitbreiding (ESP / AH, UDP 500/4500) | Ondersteunt AES, GCM, SHA-2, PSK en certificaten. | Complete protocolsuite die authenticatie, encryptie, integriteit en sleuteluitwisseling toevoegt aan standaard IP-pakketten. |
| **OpenVPN** | TCP of UDP (configureerbaar, vaak UDP 1194 of TCP 443) | Gebruikt de **OpenSSL**-bibliotheek (certificaten en/of pre-shared keys). | Open-source, zeer flexibel en veelgebruikt voor zowel *Remote Access* als *Site-to-Site* VPN's (ook ingebouwd in pfSense). |

### Anatomie van IPsec: Protocollen & Modi
Standaard IP-pakketten (IP-header + TCP-header + data) zijn onversleuteld en niet geauthenticeerd. IPsec beveiligt IP-verkeer met twee kernprotocollen en twee werkingsmodi:

* **De twee IPsec-beveiligingsprotocollen:**
  1. **AH (Authentication Header):** Biedt data-integriteit en authenticatie van de afzender, maar **versleutelt de inhoud (payload) niet**.
  2. **ESP (Encapsulating Security Payload):** Biedt zowel **versleuteling (confidentiality)** als authenticatie en integriteit van het IP-pakket (de standaardkeuze in moderne IPsec-configuraties).
* **De twee IPsec-modi (Transport Mode vs. Tunnel Mode):**
  * **Transport Mode:** Versleutelt en/of authenticeert uitsluitend de payload van het IP-pakket en behoudt de oorspronkelijke IP-header. Wordt gebruikt voor **end-to-end / peer-to-peer** communicatie tussen twee individuele hosts.
  * **Tunnel Mode (Site-to-Site):** Kapselt het **volledige oorspronkelijke IP-pakket** (inclusief de originele interne IP-header) in en voegt een **nieuwe buitenste IP-header** toe (met de publieke WAN-IP's van de VPN-gateways). Wordt gebruikt om twee volledige netwerken/vestigingen (*site-to-site*) met elkaar te verbinden.

### De 5 Stappen van een IPsec-verbinding (IKE Phase 1 & Phase 2)
Een IPsec-verbinding werkt als een **"tunnel binnen een tunnel"** via **Security Associations (SA's)** en doorloopt vijf fasen:

1. **Tunnel Creation Trigger (*Interesting Traffic*):** Een router, firewall of VPN-client ziet dataverkeer dat bestemd is voor het externe subnet (bijv. verkeer vanuit `192.168.1.0/24` naar `10.10.10.0/24`). Dit verkeer wordt aangemerkt als *interesting traffic* en triggert de opbouw van de tunnel *(bij site-to-site VPN's start de beheerder de tunnel vaak ook handmatig)*.
2. **IKE Phase 1 (P1):** Bouwt de eerste beveiligde tunnel op (*Phase 1 Security Association*). Richt zich op wederzijdse **authenticatie** (via Pre-Shared Key of certificaten) en onderhandelt over een veilig kanaal voor Phase 2. Phase 1 is rekenkundig zwaarder en trager (asymmetrische cryptografie / Diffie-Hellman).
3. **IKE Phase 2 (P2):** Bouwt binnen de beveiligde Phase 1-tunnel de tweede tunnel op (*Phase 2 / Child Security Association*). Phase 2 zorgt voor de snelle **symmetrische versleuteling** (bijv. `AES192-GCM` via `ESP`) van het daadwerkelijke dataverkeer tussen de subnetten.
4. **Data Transfer:** Zolang de Security Associations geldig zijn, wordt dataverkeer versleuteld tussen beide gateways verzonden.
5. **Tunnel Termination:** Wanneer een SA verloopt (*lifetime timeout*) of de verbinding wegvalt, wordt de tunnel afgebroken. Beheerders moeten tunnelstatussen monitoren en een verlopen SA indien nodig herstarten.

---

## 3. Praktijkscenario's & Stappenplannen

### Scenario 1: Site-to-Site IPsec VPN (Tunnel Mode) Configureren op Twee pfSense Firewalls
Het veilig koppelen van twee interne bedrijfsnetwerken (`Site-A`: `192.168.1.0/24` met WAN `198.51.100.3` en `Site-B`: `10.10.10.0/24` met WAN `203.0.113.5`) over het publieke internet:

1. **Valideer WAN-bereikbaarheid tussen beide firewalls:**
   * Open op `Site-A` **Diagnostics → Ping**, voer het publieke WAN-IP van `Site-B` (`203.0.113.5`) in en controleer of de ICMP-ping slaagt.
2. **Configureer IKE Phase 1 (P1) en Phase 2 (P2) op `Site-A` (Initiator):**
   * Ga naar **VPN → IPsec → Tunnels → Add P1**:
     * *Remote Gateway:* `203.0.113.5`
     * *Pre-Shared Key:* `cybrary` *(in productie: sterke willekeurige sleutel)*
     * *Encryption Algorithm:* AES `256 bits`
     * *Child SA Close Action:* `Restart/Reconnect`
     * Klik op **Save** en **Apply Changes**.
   * Klik onder de nieuwe P1 op **Show Phase 2 Entries → Add P2**:
     * *Remote Network:* `Network` `10.10.10.0/24`
     * *Protocol:* `ESP`
     * *Encryption Algorithms:* `AES192-GCM`
     * Klik op **Save** en **Apply Changes**.
   * Ga naar **Firewall → Rules → IPsec → Add** en maak een regel aan die verkeer van `10.10.10.0/24` naar `LAN net` toestaat (*Apply Changes*).
3. **Configureer het spiegelbeeld (P1, P2 en Firewall Rule) op `Site-B` (Responder):**
   * Ga op `Site-B` naar **VPN → IPsec → Tunnels → Add P1**:
     * *Remote Gateway:* `198.51.100.3`
     * *Pre-Shared Key:* `cybrary` (moet exact overeenkomen met Site-A)
     * *Encryption Algorithm:* AES `256 bits`, *Life Time:* `31680`
     * *Child SA Start Action:* `None (Responder Only)`, *Child SA Close Action:* `Close connection and clear SA`
     * Klik op **Save** en **Apply Changes**.
   * Voeg onder P1 een **P2**-entry toe met *Remote Network* `192.168.1.0/24`, *Encryption* `AES192-GCM` en *Life Time* `5400` (*Save* → *Apply Changes*).
   * Voeg onder **Firewall → Rules → IPsec** een regel toe die verkeer van `192.168.1.0/24` naar `LAN net` toestaat (*Apply Changes*).
4. **Activeer de tunnel en verifieer end-to-end connectiviteit:**
   * Ga op `Site-A` naar **Status → IPsec → Overview** en klik op **Connect P1 and P2s** totdat zowel P1 als P2 op *Established* staan.
   * Test vanaf `Linux-A` (`192.168.1.10`) naar `Linux-B` (`10.10.10.10`) en vice versa:
```bash
# Vanaf Linux-A (192.168.1.0/24) naar Linux-B (10.10.10.10):
ping -c 8 10.10.10.10

# Vanaf Linux-B (10.10.10.0/24) naar Linux-A (192.168.1.10):
ping -c 8 192.168.1.10
```

---

## 4. Aanvullende Bronnen & Referenties

* **Interne Commandoreferenties (SOC Analyst Map):**
  * Zie `BASH.md` (Sectie 5: *Netwerkbeheer, Monitoring & Firewalls*) voor `gns3`, `ping`, `ipsec statusall`, `ip xfrm` en `openvpn`.
  * Zie `PowerShell.md` voor `Get-NetIPsecMainModeSA` en `Get-VpnConnection`.
* **[Aanvullend] Officiële Documentatie & Referenties:**
  * [Netgate pfSense Documentation: IPsec VPN Configuration](https://docs.netgate.com/pfsense/en/latest/vpn/ipsec/index.html) — Officiële documentatie voor Phase 1, Phase 2, IPsec firewallregels en troubleshooting.
  * [RFC 4301: Security Architecture for the Internet Protocol](https://datatracker.ietf.org/doc/html/rfc4301) — Technische standaard voor IPsec, AH, ESP, Transport Mode en Tunnel Mode.
  * [OpenVPN Community Resources & Documentation](https://openvpn.net/community-resources/) — Documentatie voor TLS-gebaseerde Remote Access en Site-to-Site VPN's.