# Wireshark

Wireshark leest en decodeert pakketten uit een live capture of een `.pcap`-bestand. Het is het gereedschap om te zien wat er werkelijk over de lijn gaat.

## Concepts

### Venster en lagen

Het pakketdetails-venster toont de lagen van een pakket van layer 1 naar boven, dus de applicatiedata staat onderaan. Zie het [TCP/IP-model](/networking/tcp-ip-model) en het [OSI-model](/networking/osi-model).

### Display filters

Een *display filter* verbergt pakketten na de capture. Een *capture filter* (BPF, zoals in `tcpdump`) beperkt wat wordt vastgelegd.

| Filter | Doel |
| :--- | :--- |
| `icmp` | ICMP-verkeer, zoals ping |
| `arp` | ARP-verkeer |
| `http` | HTTP-verkeer |
| `dns` | DNS-queries en antwoorden |
| `ip.addr == 192.168.0.1` | Verkeer van of naar één adres |
| `tcp.port == 22` | SSH-verkeer |
| `tcp.flags.syn == 1 && tcp.flags.ack == 0` | Alleen eerste SYN-pakketten, handig bij scans |
| `http.request.method == "POST"` | HTTP POST-verzoeken |

### Analyse

- **Follow TCP Stream:** voegt alle pakketten van een sessie samen (client in rood, server in blauw).
- **Export Objects:** haalt bestanden uit HTTP-verkeer.
- **Statistics:** *Conversations* en *Protocol Hierarchy* geven snel een overzicht van een capture.

::: warning Gevoelige data
Onversleutelde protocollen (HTTP, FTP, Telnet) tonen wachtwoorden en inhoud in leesbare tekst. Behandel captures als vertrouwelijk.
:::

## Commands

Parameters staan bij [tcpdump, tshark, nc & Wireshark](/scripting/bash#sh-capture).

<<< @/snippets/bash/recon.sh#capture{bash}

## SOC use

- Een patroon van gelijke pakketten op vaste intervallen kan *beaconing* naar een C2-server zijn.
- Ongebruikelijke DNS-queries (lange, willekeurige namen) wijzen op DNS-tunneling.
- Gebruik [Poorten & Protocollen](/networking/ports-and-protocols) om verkeer te duiden.
