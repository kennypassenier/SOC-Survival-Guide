#region nmap
# 1. Host Discovery op een subnet inclusief reden (ARP/ICMP)
sudo nmap -sn --reason 192.168.0.0/24

# 2. Snelle SYN-scan op de top 100 poorten (zonder ping-check)
sudo nmap -Pn 192.168.0.2-100 -F

# 3. Serviceversie- en OS-enumeratie op een doelhost
sudo nmap -sV 192.168.0.20 -p 21
sudo nmap -O --osscan-guess 192.168.0.20

# 4. Scan alle 65.535 poorten op hoge snelheid (-T5)
sudo nmap -Pn 192.168.0.20 -T5 -p-

# 5. Trage TCP Connect-scan (-T1 zonder sudo) om rate-limiting/pakketfilters te omzeilen
nmap -Pn 192.168.0.2 -T1 -p 22,25,1000,2099,8080,8888
#endregion nmap

#region capture
# Start Wireshark of GNS3 op de achtergrond vanuit de terminal
wireshark&
gns3 &

# Simuleer een luisterende TCP-poort met Netcat (-k = keep listening, -l = listen, -v = verbose, -p = port)
sudo nc -klvp 80

# Leg netwerkverkeer op interface eth0 vast naar een .pcap-bestand voor Wireshark
sudo tcpdump -i eth0 -w capture.pcap
sudo tshark -i eth0 -Y "http or dns"
#endregion capture

#region smb
# Inventariseer beschikbare SMB-shares op FILESERVER
smbclient -L FILESERVER -U cybrary

# Onversleutelde FTP- en Telnet-sessies (alleen voor lab/demonstratie)
ftp fileserver
telnet utilserver
#endregion smb
