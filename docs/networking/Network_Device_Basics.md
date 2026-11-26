# Netwerkapparatuur & Infrastructuur

Overzicht van actieve netwerkcomponenten, van fysieke bekabeling tot intelligente firewalls en routers.

## 1. Commando's & Configuratie

### Interface Inspectie
Controleer of interfaces statisch zijn geconfigureerd of via DHCP een IP ontvangen.

<<< @/snippets/bash/network.sh#network-config{bash}

### Routering & Connectiviteit
De routeringstabel bepaalt hoe pakketten het lokale netwerk verlaten.

<<< @/snippets/bash/network.sh#network-config{bash}
<<< @/snippets/bash/network.sh#dns{bash}

## 2. Kerncomponenten

### Layer 2: Switches
Een switch verbindt apparaten binnen een lokaal netwerk (LAN) en stuurt frames op basis van MAC-adressen naar de juiste poort.
- **VLANs:** Virtuele scheiding van netwerken op dezelfde fysieke switch.
- **Layer 3 Switch:** Kan ook routeren tussen VLANs.

### Layer 3: Routers
Verbindt verschillende netwerken en bepaalt de optimale route voor IP-pakketten. De **default gateway** is de eerste router die een pakket tegenkomt wanneer het naar een ander netwerk moet.

### Beveiliging: Firewalls & Proxy's
- **Firewall:** Filtert verkeer op basis van regels (IP, poort, protocol). Werkt vaak met *Stateful Inspection* (onthoudt uitgaande verzoeken om antwoorden door te laten).
- **Proxy:** Treedt op als tussenpersoon voor clients; verbergt interne IP's en kan content filteren.
- **NAT (Network Address Translation):** Vertaalt private IP's naar een publiek IP-adres (Many-to-one) of koppelt een publiek IP aan een interne server (One-to-one).

### Legacy Apparatuur
- **Hub:** Stuurt alle verkeer naar alle poorten (inefficiënt, veel collisies).
- **Bridge:** Verbindt twee LAN-segmenten.
- **Repeater:** Versterkt elektrische signalen over lange afstanden.

## 3. Praktijkscenario's

### Statische Routes in pfSense
Wanneer een nieuw subnet (`10.10.10.0/24`) achter een interne router wordt geplaatst, moet de centrale firewall (bijv. pfSense) hiervan op de hoogte zijn:
1. **Gateway aanmaken:** Voeg het IP van de interne router toe als nieuwe gateway op de LAN-interface.
2. **Static Route:** Routeer het subnet `10.10.10.0/24` via deze nieuwe gateway.
3. **Firewall Regels:** Sta verkeer vanaf het nieuwe subnet toe op de LAN-interface (standaard staat dit vaak op `LAN net` alleen).

::: warning Asymmetrische Routering
Zonder statische route bereiken pakketten vanaf het nieuwe subnet de firewall wel, maar weet de firewall niet waar het antwoord heen moet. Het pakket wordt dan naar de ISP gestuurd en gaat verloren.
:::
