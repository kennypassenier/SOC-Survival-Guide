# Nmap Basics

Netwerkdetectie, poortscanning en host-discovery met Nmap.

## 1. Commando's & Scan-opties

### Basisscans
* **`nmap`**: TCP Connect Scan (`-sT`) zonder root-rechten.
* **`sudo nmap`**: SYN Stealth Scan (`-sS`) met root-rechten (sneller, half-open).

<<< @/snippets/bash/recon.sh#nmap_basic{bash}

### Poortselectie en Host Discovery
* **`-p`**: Specifieke poorten (`-p 80,443` of `-p-` voor alle 65535 poorten).
* **`-sn`**: Alleen host discovery (geen poortscan).
* **`-Pn`**: Slaat host discovery over (neemt aan dat host online is).

<<< @/snippets/bash/recon.sh#nmap_advanced{bash}

### OS en Versiedetectie
* **`-sV`**: Service- en versiedetectie.
* **`-O`**: OS-detectie.
* **`-T<0-5>`**: Timing templates (van paranoid tot insane).

<<< @/snippets/bash/recon.sh#nmap_os{bash}

## 2. Nmap Poortstatussen

| Status | Betekenis | Oorzaak |
| :--- | :--- | :--- |
| **`open`** | Dienst actief | Antwoordt met SYN/ACK. |
| **`closed`** | Geen dienst | Antwoordt met RST. |
| **`filtered`** | Geblokkeerd | Geen antwoord door firewall. |
