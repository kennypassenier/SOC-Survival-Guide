# PowerShell Referentie

Dit naslagwerk bevat essentiële PowerShell-cmdlets en technieken voor systeembeheer en SOC-triage.

## 1. Basis & Systeem

### Hulp & Geschiedenis
Gebruik `Get-Help` voor documentatie en voorbeelden. De commandogeschiedenis wordt door `PSReadLine` persistent opgeslagen.

<<< @/snippets/ps/system.ps1#help{powershell}
<<< @/snippets/ps/system.ps1#history{powershell}

### Modules & Omgeving
Laad externe scripts of modules met `Import-Module`. Omgevingsvariabelen zoals de `PATH` zijn direct benaderbaar via `$env`.

<<< @/snippets/ps/system.ps1#modules{powershell}
<<< @/snippets/ps/system.ps1#python{powershell}

## 2. Bestandssysteem & Analyse

### Zoeken & Bewerken
`Get-ChildItem` en `Select-String` zijn de primaire tools voor het navigeren en doorzoeken van bestanden.

<<< @/snippets/ps/file.ps1#search{powershell}

### Alternate Data Streams (ADS)
Inspecteer NTFS-datastromen om verborgen data te ontdekken, cruciaal bij forensisch onderzoek.

<<< @/snippets/ps/file.ps1#ads{powershell}

### Hashing
Verifieer de integriteit van bestanden met `Get-FileHash`.

<<< @/snippets/ps/file.ps1#hash{powershell}

## 3. OS Management

### Processen & Systeeminfo
Monitor actieve processen en haal gedetailleerde hardware/OS informatie op.

<<< @/snippets/ps/os-management.ps1#process{powershell}

### Services
Beheer Windows-services en spoor configuratiefouten zoals *Unquoted Service Paths* op.

<<< @/snippets/ps/os-management.ps1#services{powershell}

### Register & Event Logs
Onderzoek persistence via registersleutels en analyseer Security logs.

<<< @/snippets/ps/os-management.ps1#registry{powershell}
<<< @/snippets/ps/os-management.ps1#eventlogs{powershell}

## 4. Security & Toegang

### ACL & Gebruikers
Controleer bestandsrechten en lokale groepslidmaatschappen.

<<< @/snippets/ps/access-control.ps1#acl{powershell}

### Microsoft Defender
Beheer antivirus-scans en inspecteer gedetecteerde dreigingen.

<<< @/snippets/ps/defender.ps1#defender{powershell}

## 5. Active Directory

### Installatie & Beheer
Setup van Domain Controllers en beheer van OUs, gebruikers en groepen.

<<< @/snippets/ps/ad.ps1#install{powershell}
<<< @/snippets/ps/ad.ps1#objectbeheer{powershell}

### Group Policy
Dwing updates af en genereer RSoP-rapporten.

<<< @/snippets/ps/ad.ps1#gpo{powershell}

## 6. Netwerk & Crypto

### Netwerkdiagnose
Test poorten, traceer routes en beheer de Windows Firewall.

<<< @/snippets/ps/network.ps1#network{powershell}

### Cryptografie
Versleutel berichten en verwerk Base64 data.

<<< @/snippets/ps/network.ps1#crypto{powershell}
