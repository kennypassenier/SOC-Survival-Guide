#region network
# Inspecteer netwerkadapters, IP-adressen, routering en actieve TCP-verbindingen
Get-NetAdapter
Get-NetIPAddress -AddressFamily IPv4
Get-NetRoute -AddressFamily IPv4
Get-NetNeighbor
Get-NetTCPConnection -State Established

# Test specifieke TCP-poortbereikbaarheid en traceer routes (vervangt telnet/tracert)
Test-NetConnection -ComputerName 192.168.0.20 -Port 21
Test-NetConnection -ComputerName 8.8.8.8 -TraceRoute

# DNS-resolutie opvragen en client-DNS-cache legen
Resolve-DnsName google.com
Clear-DnsClientCache

# Voeg een inkomende Windows Firewall-regel toe voor SSH (TCP 22)
New-NetFirewallRule -DisplayName "Allow SSH" -Direction Inbound -LocalPort 22 -Protocol TCP -Action Allow

# Controleer actieve VPN- en IPsec Security Associations
Get-VpnConnection
Get-NetIPsecMainModeSA
#endregion network

#region crypto
# Versleutel en ontsleutel een bericht met een certificaat
Protect-CmsMessage -To "certificaat.cer" -Path .\message.txt -OutFile .\message.enc
Unprotect-CmsMessage -Path .\message.enc

# Base64-encoding en -decoding van binaire bestanden in PowerShell
[Convert]::ToBase64String([IO.File]::ReadAllBytes("message.enc")) > message.base64
[IO.File]::WriteAllBytes("message.enc", [Convert]::FromBase64String((Get-Content .\message.base64 -Raw)))
#endregion crypto
