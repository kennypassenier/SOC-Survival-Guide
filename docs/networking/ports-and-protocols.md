# Poorten & Protocollen

Veelvoorkomende poorten, protocollen en TCP-vlaggen.

## Veelgebruikte poorten

| Poort | Protocol | Transport | Dienst | SOC-relevantie |
| :--- | :--- | :--- | :--- | :--- |
| 20, 21 | FTP | TCP | Bestandsoverdracht | Onversleuteld; inloggegevens zichtbaar in captures |
| 22 | SSH | TCP | Beveiligde shell en SFTP | Brute-force en laterale beweging |
| 23 | Telnet | TCP | Externe shell | Onversleuteld; hoort niet meer in productie |
| 25 | SMTP | TCP | Mail verzenden | Spam en mailrelay-misbruik |
| 53 | DNS | UDP/TCP | Naamresolutie | Tunneling en exfiltratie via DNS |
| 67, 68 | DHCP | UDP | Dynamische IP-toewijzing | Rogue DHCP-servers |
| 80 | HTTP | TCP | Web | Onversleuteld; controleer user-agents en URI's |
| 88 | Kerberos | TCP/UDP | Authenticatie in AD | Kerberoasting, ticket-misbruik |
| 110, 143 | POP3, IMAP | TCP | Mail ophalen | Onversleutelde varianten vermijden |
| 123 | NTP | UDP | Tijdsynchronisatie | Misbruik voor amplification |
| 135 | MS RPC | TCP | Remote procedure calls | Laterale beweging op Windows |
| 137-139 | NetBIOS | UDP/TCP | Naamservice en sessies | Legacy; enumeratie |
| 161 | SNMP | UDP | Netwerkbeheer | Standaard community strings |
| 389, 636 | LDAP, LDAPS | TCP | Verzoeken aan de directory | AD-enumeratie |
| 443 | HTTPS | TCP | Web met TLS | Versleutelde C2 en exfiltratie |
| 445 | SMB | TCP | Bestands- en printershares | Ransomware, lateral movement |
| 514 | Syslog | UDP | Logtransport | Logintegriteit |
| 1433 | MSSQL | TCP | Database | Blootstelling aan internet |
| 3306 | MySQL | TCP | Database | Blootstelling aan internet |
| 3389 | RDP | TCP | Extern bureaublad | Brute-force, ransomware-toegang |
| 5985, 5986 | WinRM | TCP | Remote PowerShell | Laterale beweging |

## Poortbereiken

| Bereik | Naam | Gebruik |
| :--- | :--- | :--- |
| 0-1023 | Well-known ports | Standaarddiensten, vereisen vaak verhoogde rechten |
| 1024-49151 | Registered ports | Applicaties en producten |
| 49152-65535 | Dynamische poorten | Tijdelijke bronpoorten van clients |

## TCP-vlaggen

| Vlag | Betekenis | Waar je het ziet |
| :--- | :--- | :--- |
| `SYN` | Verbinding starten | Eerste pakket van de handshake, ook bij portscans |
| `SYN-ACK` | Verbinding accepteren | Antwoord van een open poort |
| `ACK` | Ontvangst bevestigen | Vrijwel elk pakket na de handshake |
| `FIN` | Verbinding netjes sluiten | Normale afsluiting |
| `RST` | Verbinding afbreken | Antwoord van een gesloten poort |
| `PSH` | Data direct doorgeven | Interactieve sessies |

::: tip Handshake
De TCP 3-way handshake verloopt als `SYN`, `SYN-ACK`, `ACK`. Een groot aantal `SYN`-pakketten zonder vervolg wijst op een SYN-scan of een SYN-flood.
:::

## Protocols per OSI layer

| Layer | Protocollen |
| :--- | :--- |
| 7 Application | HTTP, DNS, SMTP, FTP, SSH, DHCP |
| 6 Presentation | TLS, MIME |
| 4 Transport | TCP, UDP |
| 3 Network | IP, ICMP, IPsec |
| 2 Data Link | Ethernet, ARP, VLAN (802.1Q) |

Zie [OSI-model](/networking/osi-model) en [TCP/IP-model](/networking/tcp-ip-model) voor de lagen zelf en [Wireshark Basics](/tools/wireshark-basics) voor filters op deze poorten.
