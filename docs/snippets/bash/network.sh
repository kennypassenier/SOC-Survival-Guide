#region network-config
# Toon alle interfaces met IP- en MAC-adres
ip a
# -br: compact, één regel per interface
ip -br a
# Voeg een tijdelijk IP-adres toe aan interface ens5 (verdwijnt na een herstart)
sudo ip addr add 10.10.10.10/24 dev ens5

# Routeringstabel (verouderd commando, nog veel gebruikt)
netstat -r
# Routeringstabel met het moderne commando
ip route
# Luisterende sockets: -t TCP, -u UDP, -l listening, -n numeriek, -p proces
ss -tulnp
# ARP-tabel: gekoppelde IP- en MAC-adressen in je subnet
arp -a
#endregion network-config

#region dns
# Test stap voor stap: eerst de gateway, dan een extern IP, dan een domeinnaam
# -c 4 stuurt vier pakketten en stopt dan
ping -c 4 192.168.1.1
ping -c 4 8.8.8.8
ping -c 4 google.com

# Toon elke router onderweg; -n slaat DNS-opzoeking van de routers over
traceroute -n 8.8.8.8
# Vraag DNS-records op; dig toont het volledige antwoord
dig FILESERVER.clab.local
# Eenvoudiger DNS-opzoeking
nslookup google.com

# Stel een interne DNS-server in (> overschrijft het bestand)
echo "nameserver 192.168.1.5" > /etc/resolv.conf
# Voeg een zoekdomein toe zodat je FILESERVER kunt typen in plaats van FILESERVER.clab.local
echo "search clab.local" >> /etc/resolv.conf
# Statische naam-naar-IP-koppeling, heeft voorrang op DNS
echo "192.168.1.20 FILESERVER" >> /etc/hosts
#endregion dns

#region connections
# Luisterende poorten met het bijbehorende proces; sudo is nodig om alle processen te zien
sudo ss -tulpn

# Test of poort 443 bereikbaar is; -z scant zonder data te sturen, -v toont het resultaat
nc -zv 192.168.0.20 443

# Vraag het A-record (IPv4-adres) van een domein op
dig example.com A
#endregion connections

#region network-extra
# -s: samenvatting van het aantal sockets per status
ss -s
# -t: TCP, -n: numeriek, state established: alleen bestaande verbindingen
ss -tn state established
# Toon de ARP/neighbor-tabel met het moderne ip-commando
ip neigh
# -s: toon statistieken per interface, zoals fouten en gedropte pakketten
ip -s link show eth0
# -I: haal alleen de HTTP-headers op, zonder de pagina te downloaden
curl -I https://example.com
# +short: toon alleen het antwoord
dig +short example.com
# @8.8.8.8: vraag een specifieke DNS-server in plaats van de standaardserver
dig @8.8.8.8 example.com
# host is een eenvoudige DNS-opzoeking
host example.com
#endregion network-extra
