#region nmap_basic
# -sn: alleen host discovery, geen poortscan. --reason toont waarom een host als up gezien wordt (ARP of ICMP)
sudo nmap -sn --reason 192.168.0.0/24

# -Pn: sla de ping-controle over en neem aan dat de hosts online zijn. -F: scan alleen de 100 meest gebruikte poorten.
# 2-100 is het bereik van laatste octetten
sudo nmap -Pn 192.168.0.2-100 -F
#endregion nmap_basic

#region nmap_advanced
# -p-: alle 65.535 poorten. -T5: snelste timing (luid, kan pakketten missen)
sudo nmap -Pn 192.168.0.20 -T5 -p-

# Zonder sudo wordt dit een TCP connect-scan. -T1: heel traag, valt minder op bij detectie.
# -p 22,25,...: alleen de opgegeven poorten
nmap -Pn 192.168.0.2 -T1 -p 22,25,1000,2099,8080,8888
#endregion nmap_advanced

#region nmap_os
# -sV: bepaal de versie van de dienst op de poort; -p 21 beperkt de scan tot FTP
sudo nmap -sV 192.168.0.20 -p 21
# -O: raad het besturingssysteem; --osscan-guess toont ook minder zekere gokken
sudo nmap -O --osscan-guess 192.168.0.20
#endregion nmap_os

#region capture
# Start Wireshark en GNS3 op de achtergrond; & geeft de terminal terug
wireshark&
gns3 &

# Simuleer een luisterende poort 80: -l luister, -k blijf luisteren na een verbinding, -v verbose, -p poort
sudo nc -klvp 80

# -i: interface, -w: schrijf het verkeer naar een .pcap-bestand dat je later in Wireshark opent
sudo tcpdump -i eth0 -w capture.pcap
# tshark is Wireshark in de terminal; -Y past een display filter toe
sudo tshark -i eth0 -Y "http or dns"
#endregion capture

#region smb
# -L: toon de shares van de server, -U: gebruikersnaam
smbclient -L FILESERVER -U cybrary

# Onversleutelde sessies, alleen voor een lab: wachtwoorden zijn op het netwerk mee te lezen
ftp fileserver
telnet utilserver
#endregion smb
