#region network-config
# Bekijk netwerkinterfaces (compact met ip -br a) en voeg een test-IP toe
ip a
ip -br a
sudo ip addr add 10.10.10.10/24 dev ens5

# Bekijk de routeringstabel, luisterende poorten en ARP-tabel
netstat -r
ip route
ss -tulnp
arp -a
#endregion network-config

#region dns
# Test connectiviteit stapsgewijs: gateway -> extern IP -> domeinnaam
ping -c 4 192.168.1.1
ping -c 4 8.8.8.8
ping -c 4 google.com

# Traceer route en bevraag DNS-records
traceroute -n 8.8.8.8
dig FILESERVER.clab.local
nslookup google.com

# Configureer een interne DNS-server, een search-domein en een statische host-entry
echo "nameserver 192.168.1.5" > /etc/resolv.conf
echo "search clab.local" >> /etc/resolv.conf
echo "192.168.1.20 FILESERVER" >> /etc/hosts
#endregion dns
