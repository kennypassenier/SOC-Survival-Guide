#region network
# Netwerkadapters en hun status (vervangt ipconfig /all voor de hardwaregegevens)
Get-NetAdapter
# IPv4-adressen per interface
Get-NetIPAddress -AddressFamily IPv4
# Routeringstabel, inclusief de default gateway (0.0.0.0/0)
Get-NetRoute -AddressFamily IPv4
# ARP-cache: gekoppelde IP- en MAC-adressen in het lokale netwerk
Get-NetNeighbor
# Alle bestaande TCP-verbindingen
Get-NetTCPConnection -State Established

# Test of poort 21 bereikbaar is (vervangt telnet); TcpTestSucceeded geeft True of False
Test-NetConnection -ComputerName 192.168.0.20 -Port 21
# -TraceRoute toont elke hop naar de bestemming (vervangt tracert)
Test-NetConnection -ComputerName 8.8.8.8 -TraceRoute

# Vraag DNS-records op (vervangt nslookup)
Resolve-DnsName google.com
# Leeg de DNS-cache van de client (vervangt ipconfig /flushdns)
Clear-DnsClientCache

# Maak een inkomende firewallregel: -Direction = richting, -LocalPort/-Protocol = verkeer, -Action = toestaan of blokkeren
New-NetFirewallRule -DisplayName "Allow SSH" -Direction Inbound -LocalPort 22 -Protocol TCP -Action Allow

# Toon de ingestelde VPN-verbindingen
Get-VpnConnection
# Toon de actieve IPsec Phase 1-beveiligingsassociaties
Get-NetIPsecMainModeSA
#endregion network

#region crypto
# Versleutel een bestand met de publieke sleutel in het certificaat (-To) en schrijf naar -OutFile
Protect-CmsMessage -To "certificaat.cer" -Path .\message.txt -OutFile .\message.enc
# Ontsleutel met de bijbehorende private sleutel uit je certificaatopslag
Unprotect-CmsMessage -Path .\message.enc

# Lees alle bytes van het bestand en codeer ze naar Base64
[Convert]::ToBase64String([IO.File]::ReadAllBytes("message.enc")) > message.base64
# Decodeer de Base64-tekst (-Raw leest het bestand als één tekenreeks) en schrijf de bytes terug
[IO.File]::WriteAllBytes("message.enc", [Convert]::FromBase64String((Get-Content .\message.base64 -Raw)))
#endregion crypto

#region connections
# Open verbindingen met het eigenaar-proces; koppel OwningProcess aan Get-Process voor de programmanaam
Get-NetTCPConnection -State Established | Select-Object LocalPort, RemoteAddress, RemotePort, OwningProcess
# Alleen luisterende poorten (diensten die verbindingen accepteren)
Get-NetTCPConnection -State Listen

# Vraag een specifiek DNS-recordtype op (hier het A-record, IPv4)
Resolve-DnsName example.com -Type A

# IP-configuratie per interface, inclusief gateway en DNS-servers
Get-NetIPConfiguration
#endregion connections
