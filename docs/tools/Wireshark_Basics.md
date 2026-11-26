# Wireshark Basics

Pakketanalyse en netwerkinspectie met Wireshark.

## 1. Commando's & Packet Capture

### Starten van Captures
* **`wireshark &`**: Start Wireshark op de achtergrond.
* **`tcpdump`**: CLI-alternatief om pakketten vast te leggen.

<<< @/snippets/bash/recon.sh#wireshark{bash}

## 2. Display Filters

| Filterexpressie | Doel |
| :--- | :--- |
| `icmp` | Toont ICMP-verkeer (ping). |
| `arp` | Toont ARP-verkeer. |
| `http` | Toont HTTP-verkeer. |
| `ip.addr == 192.168.0.1` | Verkeer van/naar specifiek IP. |
| `tcp.port == 22` | SSH-verkeer. |

## 3. Analyse & Reconstructie

### Streams en Objecten
* **Follow TCP Stream**: Combineert alle pakketten van een sessie (client in rood, server in blauw).
* **Export Objects**: Extraheert gedownloade bestanden (HTTP) uit de capture.
