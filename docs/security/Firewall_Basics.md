# Firewall Basics

Netwerkbeveiliging, pakketfiltering en stateful inspection.

## 1. Commando's & Netwerkbeheer

### Netwerkregels & Firewall Status
* **`iptables`** / **`nftables`**: Linux firewall-beheer.
* **Windows Firewall with Advanced Security**: Beheert inkomend en uitgaand verkeer op Windows.

<<< @/snippets/bash/firewall.sh#rules{bash}

## 2. Firewall Typen

| Type | Werking | Toepassing |
| :--- | :--- | :--- |
| **Packet Filtering** | Filtert op IP, poort en protocol (stateless). | Snelle, eenvoudige basisfunctie. |
| **Stateful Inspection** | Houdt de status van TCP-verbindingen bij. | Standaard voor moderne firewalls. |
| **Application Layer (WAF)** | Inspecteert HTTP/HTTPS payload op applicatieniveau. | Bescherming van webservers. |

## 3. Firewall Regels & Best Practices
- **Default Deny / Implicit Deny**: Alles wat niet expliciet is toegestaan, wordt standaard geblokkeerd.
- **Inbound vs. Outbound**: Inkomend verkeer streng filteren; uitgaand verkeer beperken om datalekken en C2-communicatie te voorkomen.
