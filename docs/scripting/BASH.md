# BASH & Linux Referentie

Essentiële commando's voor Linux-beheer en security-analyse op Debian, Ubuntu en Arch Linux.

## 1. Identiteit & Privileges

Controleer wie je bent en wat je mag. Gebruik `sudo` voor beheertaken.

<<< @/snippets/bash/system.sh#identity{bash}
<<< @/snippets/bash/system.sh#sudo{bash}

### Gebruikersbeheer
Beheer accounts en groepslidmaatschappen.

<<< @/snippets/bash/system.sh#users{bash}

## 2. Navigatie & Bestanden

### Basis navigatie
<<< @/snippets/bash/file.sh#navigation{bash}

### Bestanden overzicht
Gebruik `ls -latr` om de nieuwste wijzigingen direct onderaan te zien.

<<< @/snippets/bash/file.sh#ls{bash}

### Bestandsoperaties
<<< @/snippets/bash/file.sh#file-ops{bash}

### Permissies & ACL
<<< @/snippets/bash/file.sh#permissions{bash}

## 3. Tekstverwerking & Analyse

### Bekijken & Bewerken
<<< @/snippets/bash/processing.sh#cat{bash}

### Zoeken (Grep)
Gebruik `zgrep` voor gecomprimeerde logs in `/var/log`.

<<< @/snippets/bash/processing.sh#grep{bash}

### Encoding
<<< @/snippets/bash/processing.sh#encoding{bash}

## 4. Systeembeheer

### Logs & Monitoring
<<< @/snippets/bash/os-management.sh#logs{bash}

### Processen & Services
<<< @/snippets/bash/os-management.sh#process{bash}
<<< @/snippets/bash/os-management.sh#systemctl{bash}

### Schijfbeheer
<<< @/snippets/bash/os-management.sh#disk{bash}

## 5. Netwerk & Security

### Netwerkconfiguratie
<<< @/snippets/bash/network.sh#network-config{bash}

### DNS & Connectiviteit
<<< @/snippets/bash/network.sh#dns{bash}

### Firewall (iptables) & VPN
<<< @/snippets/bash/firewall.sh#iptables{bash}
<<< @/snippets/bash/firewall.sh#vpn{bash}

## 6. Recon & Packet Capture

### Nmap & Verkenning
<<< @/snippets/bash/recon.sh#nmap{bash}

### Capture & Traffic
<<< @/snippets/bash/recon.sh#capture{bash}

### Protocollen (SMB/FTP)
<<< @/snippets/bash/recon.sh#smb{bash}

## 7. Cryptografie

<<< @/snippets/bash/security.sh#openssl{bash}
<<< @/snippets/bash/security.sh#hashes{bash}
