# Nmap

Nmap ontdekt hosts en open poorten en herkent diensten en besturingssystemen. Gebruik het alleen op systemen waarvoor je toestemming hebt.

## Concepts

### Basisscans

| Scan | Optie | Werking |
| :--- | :--- | :--- |
| **TCP connect** | `-sT` | Voltooit de handshake, werkt zonder root-rechten |
| **SYN-scan** | `-sS` | Half-open, sneller en stiller, vereist root-rechten |
| **UDP-scan** | `-sU` | Traag, nodig voor DNS, SNMP en DHCP |
| **Ping-scan** | `-sn` | Alleen host discovery |

### Poortstatussen

| Status | Betekenis | Reactie van de host |
| :--- | :--- | :--- |
| `open` | Een dienst luistert | SYN/ACK |
| `closed` | Poort bereikbaar, geen dienst | RST |
| `filtered` | Een firewall blokkeert | Geen antwoord |

### Timing

`-T0` tot `-T5` stellen de snelheid in. `-T1` is traag en valt minder op bij detectiesystemen. `-T5` is snel en erg luid.

## Commands

Parameters staan bij [nmap](/scripting/bash#sh-nmap).

::: code-group

<<< @/snippets/bash/recon.sh#nmap_basic{bash} [Discovery]

<<< @/snippets/bash/recon.sh#nmap_advanced{bash} [Poortselectie]

<<< @/snippets/bash/recon.sh#nmap_os{bash} [Versie en OS]

:::

## SOC use

- Een reeks SYN-pakketten naar veel poorten van één bron in korte tijd is een port scan, zie [Wireshark](/tools/wireshark-basics).
- Vergelijk scanresultaten met de verwachte configuratie om onbekende diensten te vinden.
