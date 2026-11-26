#region iptables
# Toon de huidige regels per chain (INPUT, FORWARD, OUTPUT)
sudo iptables -L

# -A INPUT: voeg een regel toe aan inkomend verkeer, -s: bronadres, -p tcp: protocol,
# --dport: doelpoort, -j ACCEPT: toestaan. Hier mogen twee hosts via SSH (22) binnen
sudo iptables -A INPUT -s 10.0.0.1 -p tcp --dport 22 -j ACCEPT
sudo iptables -A INPUT -s 10.0.0.2 -p tcp --dport 22 -j ACCEPT
# Eén host mag ook FTP (21)
sudo iptables -A INPUT -s 10.0.0.2 -p tcp --dport 21 -j ACCEPT
# Het hele subnet (/24) mag HTTP (80)
sudo iptables -A INPUT -s 10.0.0.0/24 -p tcp --dport 80 -j ACCEPT
# -j DROP: verwerp al het overige verkeer uit dit subnet zonder antwoord. Deze regel moet als laatste staan
sudo iptables -A INPUT -s 10.0.0.0/24 -j DROP

# -F (flush): wis alle regels, bijvoorbeeld om opnieuw te beginnen
sudo iptables -F
#endregion iptables

#region vpn
# Toon de IPsec Phase 1- en Phase 2-verbindingen van strongSwan
sudo ipsec statusall
# Toon de actieve IPsec Security Associations in de kernel
sudo ip xfrm state

# Start een OpenVPN-client met het opgegeven configuratiebestand
sudo openvpn --config client.ovpn
#endregion vpn
