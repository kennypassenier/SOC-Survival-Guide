# Glossary

Afkortingen en vaktermen uit de kennisbank.

## A

| Term | Betekenis |
| :--- | :--- |
| **ACE** | *Access Control Entry*: één regel in een ACL die zegt wie welke rechten heeft. |
| **ACL** | *Access Control List*: de lijst van ACE's op een bestand, map of ander object. Zie [Access Control](/security/access-control-basics). |
| **AD DS** | *Active Directory Domain Services*: de serverrol die een domein met centrale accounts en beleid mogelijk maakt. Zie [Active Directory](/windows/active-directory-basics). |
| **AES** | *Advanced Encryption Standard*: het gangbare symmetrische versleutelingsalgoritme, meestal met een sleutel van 256 bit. |
| **AGDLP** | *Accounts, Global groups, Domain Local groups, Permissions*: de aanbevolen volgorde om rechten via groepen toe te kennen. |
| **ARP** | *Address Resolution Protocol*: koppelt een IP-adres aan een MAC address binnen het lokale netwerk. |
| **Attack vector** | De route waarlangs een aanvaller binnenkomt of rechten verhoogt, zoals een kwetsbare service. |

## B

| Term | Betekenis |
| :--- | :--- |
| **Base64** | Een encoding die binaire data omzet naar tekst. Het is geen encryptie. |
| **Beaconing** | Regelmatig terugkerend verkeer van een geïnfecteerd systeem naar een C2-server. |
| **BPF** | *Berkeley Packet Filter*: de syntax voor capture filters in `tcpdump`. |
| **Brute force** | Alle mogelijkheden proberen, bijvoorbeeld wachtwoorden of sleutels. |

## C

| Term | Betekenis |
| :--- | :--- |
| **C2** | *Command and Control*: de server waarmee een aanvaller geïnfecteerde systemen aanstuurt. |
| **CA** | *Certificate Authority*: de partij die certificaten uitgeeft en ondertekent. |
| **CIA triad** | *Confidentiality, Integrity, Availability*: de drie basisdoelen van informatiebeveiliging. |
| **CIDR** | *Classless Inter-Domain Routing*: de notatie `192.168.1.0/24` die netwerk en prefix lengte aangeeft. |
| **Collision** | Twee verschillende invoeren met dezelfde hash. |

## D

| Term | Betekenis |
| :--- | :--- |
| **DAC** | *Discretionary Access Control*: de eigenaar bepaalt de rechten. Standaard in NTFS en Linux. |
| **DC** | *Domain Controller*: de server die authenticatie en de AD-database beheert. |
| **Decapsulation** | Het verwijderen van een header door de ontvangende laag. Het omgekeerde van encapsulation. |
| **Default gateway** | De router waarnaar een host verkeer stuurt dat buiten het eigen subnet bestemd is. |
| **DHCP** | *Dynamic Host Configuration Protocol*: kent automatisch IP-adres, gateway en DNS-server toe. |
| **DNS** | *Domain Name System*: vertaalt namen naar IP-adressen. |
| **DSRM** | *Directory Services Restore Mode*: de herstelmodus van een domain controller, met een eigen wachtwoord. |

## E

| Term | Betekenis |
| :--- | :--- |
| **Encapsulation** | Het toevoegen van een header (en soms trailer) door elke laag bij het verzenden. |
| **Event ID** | Het nummer van een gebeurtenis in de Windows Event Log, bijvoorbeeld 4625 voor een mislukte aanmelding. |
| **Exclusion** | Een map of proces dat een antivirusprogramma niet scant. |

## F

| Term | Betekenis |
| :--- | :--- |
| **FCS** | *Frame Check Sequence*: de checksum in de Ethernet-trailer. |
| **FHS** | *Filesystem Hierarchy Standard*: de standaardindeling van mappen in Linux. |
| **Firewall** | Filtert netwerkverkeer op basis van regels. Zie [Firewalls](/security/firewall-basics). |
| **Forest** | De bovenste container van Active Directory en de security boundary. |
| **FQDN** | *Fully Qualified Domain Name*: de volledige naam, zoals `www.voorbeeld.be`. |
| **Frame** | De PDU op layer 2 (Data Link). |

## G

| Term | Betekenis |
| :--- | :--- |
| **GPO** | *Group Policy Object*: een verzameling instellingen die centraal wordt afgedwongen. Zie [Group Policy](/windows/group-policy-basics). |

## H

| Term | Betekenis |
| :--- | :--- |
| **Handshake** | De uitwisseling waarmee twee partijen een verbinding opzetten, bij TCP `SYN`, `SYN-ACK`, `ACK`. |
| **Hash** | De vaste uitvoer van een hashfunctie. Zie [Hash Functions](/security/cryptographic-hash-functions). |
| **Header** | De besturingsinformatie die een laag voor de data plaatst. |
| **Hop** | Eén router op de route van een pakket. |

## I

| Term | Betekenis |
| :--- | :--- |
| **ICMP** | *Internet Control Message Protocol*: foutmeldingen en diagnose, onder andere `ping`. |
| **IKE** | *Internet Key Exchange*: het protocol waarmee IPsec sleutels en parameters afspreekt. |
| **IOC** | *Indicator of Compromise*: een aanwijzing voor een inbreuk, zoals een hash, IP-adres of domein. |
| **IPsec** | Een suite van protocollen die IP-verkeer versleutelt en authenticeert. Zie [VPN](/networking/vpn-basics). |

## L

| Term | Betekenis |
| :--- | :--- |
| **LOLBin** | *Living off the Land Binary*: een legitiem systeemprogramma dat misbruikt wordt, bijvoorbeeld `certutil`. |
| **LSDOU** | *Local, Site, Domain, OU*: de volgorde waarin GPO's worden toegepast. |

## M

| Term | Betekenis |
| :--- | :--- |
| **MAC (access control)** | *Mandatory Access Control*: het systeem bepaalt toegang op basis van labels. |
| **MAC address** | Het hardwareadres van een netwerkkaart, geldig binnen het lokale netwerk. |
| **MITRE ATT&CK** | Een kennisbank van tactieken en technieken van aanvallers. Zie de [Roadmap](/roadmap). |

## N

| Term | Betekenis |
| :--- | :--- |
| **NAT** | *Network Address Translation*: vervangt private adressen en poorten door een publiek adres. |
| **NTFS** | Het standaard bestandssysteem van Windows, met ACL's en Alternate Data Streams. |

## O

| Term | Betekenis |
| :--- | :--- |
| **OU** | *Organizational Unit*: een container in Active Directory waaraan beleid kan worden gekoppeld. |

## P

| Term | Betekenis |
| :--- | :--- |
| **Payload** | De nuttige data in een pakket, zonder de headers. |
| **PDU** | *Protocol Data Unit*: de naam van de data per laag: segment, packet, frame, bits. |
| **Persistence** | Technieken waarmee een aanvaller na een herstart toegang behoudt. |
| **PKI** | *Public Key Infrastructure*: certificaten, CA's en regels voor vertrouwen. |
| **Privilege escalation** | Het verkrijgen van hogere rechten dan bedoeld. |

## R

| Term | Betekenis |
| :--- | :--- |
| **RBAC** | *Role-Based Access Control*: rechten volgen uit functierollen. |
| **RPO** | *Recovery Point Objective*: hoeveel dataverlies, in tijd, acceptabel is. |
| **RSoP** | *Resultant Set of Policy*: de beleidsinstellingen die uiteindelijk gelden voor een gebruiker of computer. |
| **RTO** | *Recovery Time Objective*: hoe lang herstel mag duren. |

## S

| Term | Betekenis |
| :--- | :--- |
| **Salt** | Willekeurige extra data bij het hashen van een wachtwoord, zodat gelijke wachtwoorden verschillende hashes geven. |
| **SAM** | *Security Account Manager*: de lokale database met Windows-accounts en wachtwoordhashes. |
| **SCM** | *Service Control Manager*: het onderdeel van Windows dat services beheert. |
| **Segment** | De PDU op layer 4 (Transport) voor TCP. |
| **SIEM** | *Security Information and Event Management*: platform dat logs verzamelt en correleert. |
| **SMB** | *Server Message Block*: het protocol voor bestands- en printerdeling. |
| **SUID** | Een Linux-bit waardoor een programma met de rechten van de eigenaar draait. |
| **SYSVOL** | De gedeelde map op een domain controller met GPO's en logonscripts. |

## T

| Term | Betekenis |
| :--- | :--- |
| **TLS** | *Transport Layer Security*: versleutelt verkeer, onder meer voor HTTPS. |
| **TTL** | *Time To Live*: de teller in een IP-header die bij elke router met 1 daalt. |

## U

| Term | Betekenis |
| :--- | :--- |
| **Unquoted service path** | Een service-pad met spaties zonder aanhalingstekens, waardoor een aanvaller een eigen programma kan laten starten. |

## V

| Term | Betekenis |
| :--- | :--- |
| **VLAN** | *Virtual LAN*: een logische scheiding van een netwerk op layer 2. |
| **VPN** | *Virtual Private Network*: een versleutelde tunnel over een onvertrouwd netwerk. |

## W

| Term | Betekenis |
| :--- | :--- |
| **WAF** | *Web Application Firewall*: filtert HTTP-verkeer op applicatieniveau. |
| **WMI** | *Windows Management Instrumentation*: het raamwerk om Windows-systemen te bevragen en te beheren. |

## Z

| Term | Betekenis |
| :--- | :--- |
| **Zone.Identifier** | Een Alternate Data Stream die aangeeft dat een bestand van internet komt (*Mark of the Web*). |
