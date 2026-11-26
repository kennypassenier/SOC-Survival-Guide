#region iptables
# Bekijk de huidige firewallregels
sudo iptables -L

# Sta SSH (22) toe voor specifieke hosts, HTTP (80) voor het subnet, en blokkeer de rest
sudo iptables -A INPUT -s 10.0.0.1 -p tcp --dport 22 -j ACCEPT
sudo iptables -A INPUT -s 10.0.0.2 -p tcp --dport 22 -j ACCEPT
sudo iptables -A INPUT -s 10.0.0.2 -p tcp --dport 21 -j ACCEPT
sudo iptables -A INPUT -s 10.0.0.0/24 -p tcp --dport 80 -j ACCEPT
sudo iptables -A INPUT -s 10.0.0.0/24 -j DROP

# Wis alle firewallregels om een opgeschoonde regelset opnieuw in te laden
sudo iptables -F
#endregion iptables

#region vpn
# Bekijk actieve IPsec Phase 1 en Phase 2 Security Associations (strongSwan)
sudo ipsec statusall
sudo ip xfrm state

# Start een OpenVPN-clientverbinding vanaf de CLI
sudo openvpn --config client.ovpn
#endregion vpn
