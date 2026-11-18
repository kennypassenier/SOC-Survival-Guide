# Work in progress

## Openstaande hoofdstukken
- IDS Basics

## IDS Basics 
### Commands used
Snort
```bash
sudo snort <--- Standaard draait dit Snort in sniffer modus.
sudo snort -T -c /etc/snort/snort.conf <--- -T betekent test en -c verwijst naar een configuratiebestand. Dit commando wordt gebruikt om het configuratiebestand te valideren. 
sudo snort -c /etc/snort/snort.conf <--- Draait snort in intrusion detection mode.
sudo snort -c /etc/snort/snort.conf -r sample.pcap <--- analyseert een packet capture file.
sudo snort -q -A console -c /etc/snort/snort.conf -r sample.pcap <--- -q is voor stille modus (geen startup bericht) -A console zegt Snort om ons alerts te tonen wanneer die gebeuren.
sudo snort -q -A console -c /etc/snort/snort.conf -r pcaps/apple.pcap <--- Andere packet capture file.
sudo snort -q -A console -c /etc/snort/snort.conf -r pcaps/apple.pcap | grep ICMP | grep PING <--- filter op ICMP paketten.
sudo snort -c /etc/snort/snort.conf -r sample.pcap -l /home/cybrary/Desktop <--- -l staat voor logging en stuurt alle info die normaal in de console komt naar een logfile.
```
U2spewfoo
```bash
sudo u2spewfoo snort.log <--- Sinds de .log files van Snort in "unified2" formaat zijn, gebruiken we deze tool om de log bestanden uit te lezen.
```
