# VPN Fundamenten

Een Virtual Private Network (VPN) creëert een versleutelde tunnel over een onvertrouwd netwerk (zoals het internet) om veilig toegang te krijgen tot interne bronnen.

## 1. Commando's & Verificatie

### Connectiviteit testen
Gebruik `ping` om te verifiëren of een host in een extern subnet bereikbaar is over de tunnel.

<<< @/snippets/bash/network.sh#dns{bash}

### VPN Status (Linux CLI)
Op servers zonder GUI (Debian, Ubuntu, Arch) gebruik je tools als `strongSwan` of `OpenVPN`.

<<< @/snippets/bash/firewall.sh#vpn{bash}

## 2. VPN Protocollen

| Protocol | Poort | Veiligheid | Gebruik |
| :--- | :--- | :--- | :--- |
| **PPTP** | TCP 1723 | Zwak | Verouderd |
| **L2TP/IPsec** | UDP 500/4500 | Sterk | Veelzijdig |
| **SSTP** | TCP 443 | Sterk | Firewall-vriendelijk (HTTPS) |
| **OpenVPN** | UDP 1194 | Zeer Sterk | Open-source, flexibel |
| **IPsec** | UDP 500/4500 | Zeer Sterk | Site-to-Site standaard |

## 3. Anatomie van IPsec

IPsec beveiligd verkeer via twee kernprotocollen:
- **ESP (Encapsulating Security Payload):** Biedt versleuteling en authenticatie (standaard).
- **AH (Authentication Header):** Biedt alleen authenticatie en integriteit (geen versleuteling).

### Modi
- **Transport Mode:** Versleutelt alleen de payload (Host-to-Host).
- **Tunnel Mode:** Versleutelt het volledige pakket inclusief originele headers (Site-to-Site).

## 4. De 5 Stappen van IPsec (IKE)

1. **Trigger:** Verkeer voor een extern subnet wordt gedetecteerd.
2. **IKE Phase 1 (P1):** Authenticatie en opbouw van een veilig beheer-kanaal.
3. **IKE Phase 2 (P2):** Opbouw van de eigenlijke data-tunnel (Symmetrische encryptie).
4. **Data Transfer:** Versleuteld verkeer tussen de gateways.
5. **Termination:** De tunnel wordt verbroken bij inactiviteit of timeout.

## 5. Praktijk: pfSense Site-to-Site

Bij het configureren van een tunnel tussen twee locaties:
1. **Fase 1:** Stel remote gateway, PSK (Pre-Shared Key) en encryptie (bijv. AES-256) in.
2. **Fase 2:** Definieer lokale en externe subnetten.
3. **Firewall:** Voeg onder `Firewall -> Rules -> IPsec` een regel toe om verkeer toe te staan.

::: warning Firewall Regels
Zelfs als de tunnel op **Established** staat, zal verkeer falen als de IPsec-firewallregels op de firewall ontbreken.
:::
