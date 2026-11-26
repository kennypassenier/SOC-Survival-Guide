# PowerShell.md — Windows PowerShell Referentie

Centraal naslagwerk voor alle PowerShell-cmdlets, parameters, pipelines en moderne alternatieven uit de Cybrary SOC Analyst-modules, aangevuld voor systeembeheerders en SOC-analisten.

> **Legenda:** Reguliere cmdlets en voorbeelden zijn rechtstreeks afkomstig uit het cursusmateriaal. Moderne vervangers van verouderde tools (zoals `Get-CimInstance` voor `WMIC`), extra SOC-triage-cmdlets en cross-platform nuances zijn gemarkeerd met **[Aanvullend]**.

## Inhoudsopgave
1. [Hulp, Geschiedenis, Scripting & Modules](#1-hulp-geschiedenis-scripting--modules)
2. [Bestandssysteem, Zoeken, Alternate Data Streams & Hashing](#2-bestandssysteem-zoeken-alternate-data-streams--hashing)
3. [Systeeminfo, Processen, Services, Register & Event Logs](#3-systeeminfo-processen-services-register--event-logs)
4. [Toegangscontrole (ACL's), Lokale Gebruikers & Back-up](#4-toegangscontrole-acls-lokale-gebruikers--back-up)
5. [Active Directory & Group Policy Beheer](#5-active-directory--group-policy-beheer)
6. [Microsoft Defender Antivirus (Beheer & SOC Triage)](#6-microsoft-defender-antivirus-beheer--soc-triage)
7. [Netwerkconfiguratie, Firewall, VPN & Cryptografie](#7-netwerkconfiguratie-firewall-vpn--cryptografie)

---

## 1. Hulp, Geschiedenis, Scripting & Modules

### `Get-Help`, `Get-History` & `Import-Module`
* **Doel:**
  * `Get-Help`: Toont documentatie, syntaxis, parameters en praktijkvoorbeelden voor elke PowerShell-cmdlet.
  * `Get-History`: Toont de uitgevoerde commando's in de huidige sessie (persistent bewaard door `PSReadLine` in het bestand `(Get-PSReadlineOption).HistorySavePath`).
  * `Import-Module`: Laadt een PowerShell-module of lokaal `.ps1`-hulpscript in de actieve sessie.
* **Parameters & Opties:**
  * `-Full` / `-Examples` bij `Get-Help`: Toont alle parameterbeschrijvingen of concrete gebruiksvoorbeelden.
* **Praktijkgebruik & Permutaties:**
  ```powershell
  # Bekijk de volledige help en voorbeelden van een cmdlet
  Get-Help Get-ChildItem -Full
  Get-Help Start-MpScan -Examples

  # Laad een lokaal script of module in de huidige sessie
  Import-Module .\Install-AD.ps1

  # Bekijk commandogeschiedenis (en het pad waar PSReadLine alle sessies opslaat)
  Get-History
  (Get-PSReadlineOption).HistorySavePath
  ```

### `python` / `py` & Omgevingsvariabelen (`$env:PATH`)
* **Doel:**
  * `python` / `py`: Voert Python-scripts uit vanuit PowerShell.
  * `$env:PATH`: Leest de huidige Windows `PATH`-omgevingsvariabele uit als string.
* **Praktijkgebruik:**
  ```powershell
  # Voer een Python-script uit
  python caesar.py

  # [Aanvullend] Toon alle mappen in de PATH-omgevingsvariabele overzichtelijk onder elkaar
  $env:PATH -split ';'
  ```

---

## 2. Bestandssysteem, Zoeken, Alternate Data Streams & Hashing

### `Get-ChildItem`, `Get-Content`, `Set-Content`, `Add-Content` & `Select-String`
* **Doel:**
  * `Get-ChildItem` (aliassen `ls`, `dir`, `gci`): Somt bestanden en submappen op.
  * `Get-Content` (aliassen `cat`, `gc`, `type`): Leest de inhoud van een bestand regel voor regel uit.
  * `Set-Content` (`>`) & `Add-Content` (`>>`): Schrijft nieuwe inhoud naar een bestand (overschrijvend) of voegt tekst toe (*append*).
  * `Select-String` (alias `sls`): Doorzoekt bestanden of gepipete uitvoer op tekstpatronen of reguliere expressies (PowerShell-equivalent van `grep` en `findstr`).
* **Parameters & Opties:**
  * `-Recurse`: Doorzoekt alle onderliggende submappen.
  * `-Force`: Toont ook verborgen en systeembestanden.
  * `-Filter "<patroon>"`: Filtert bestandsnamen snel op bestandssysteemniveau.
* **Praktijkgebruik & Permutaties:**
  ```powershell
  # Zoek recursief naar alle .txt-bestanden met 'apple' in de naam en tel ze
  (Get-ChildItem -Recurse -Filter *apple*.txt).Count

  # Doorzoek alle tekstbestanden in de huidige map op een patroon
  Select-String -Path *.txt -Pattern "moo"

  # Schrijf en lees tekstbestanden
  Set-Content -Path .\log.txt -Value "Eerste regel"
  Add-Content -Path .\log.txt -Value "Tweede regel"
  Get-Content -Path .\log.txt
  ```

### `Get-Item -Stream` & `Get-Content -Stream` (Alternate Data Streams)
* **Doel:** Inspecteert alle NTFS **Alternate Data Streams (ADS)** die aan een bestand gekoppeld zijn en leest de verborgen inhoud van een specifieke stream uit.
* **Parameters & Opties:**
  * `-Stream *`: Toont alle datastromen van een bestand (inclusief de standaard `:$DATA`-stream en verborgen streams zoals `Zone.Identifier` of `secret`).
  * `-Stream <naam>`: Leest de inhoud van de opgegeven specifieke datastroom.
* **Praktijkgebruik & Permutaties:**
  ```powershell
  # Ontdek alle Alternate Data Streams van notasecret.txt
  Get-Item .\notasecret.txt -Stream *

  # Lees de inhoud van de verborgen stream 'secret' uit
  Get-Item .\notasecret.txt | Get-Content -Stream secret

  # [Aanvullend] SOC Triage: spoor alle niet-standaard ADS-streams recursief op in een map
  Get-ChildItem -Recurse | Get-Item -Stream * | Where-Object Stream -ne ':$DATA'
  ```

### `Get-FileHash`
* **Doel:** Berekent de cryptografische hashwaarde van één of meerdere bestanden voor integriteitsverificatie en malware-analyse (VirusTotal/SIEM-lookups).
* **Parameters & Opties:**
  * `-Path <pad>`: Het pad naar het doelbestand (accepteert wildcards zoals `*.exe`).
  * `-Algorithm <algoritme>`: Specificeert het hash-algoritme (`SHA256` is standaard, ondersteunt ook `SHA1`, `SHA384`, `SHA512`, `MD5`).
* **Praktijkgebruik & Permutaties:**
  ```powershell
  # Bereken de SHA-256 (standaard) en MD5-hash van een bestand
  Get-FileHash -Path .\happypuppy.exe -Algorithm SHA256
  Get-FileHash -Path .\happypuppy.exe -Algorithm MD5

  # [Aanvullend] Bereken direct de SHA-256 hash van alle uitvoerbare bestanden in een map
  Get-FileHash -Path C:\Downloads\*.exe -Algorithm SHA256 | Format-Table Hash, Path -AutoSize
  ```

---

## 3. Systeeminfo, Processen, Services, Register & Event Logs

### `Get-ComputerInfo` & `Get-Process`
* **Doel:**
  * `Get-ComputerInfo`: Haalt uitgebreide hardware-, OS-, BIOS- en patchgegevens op (modern PowerShell-equivalent van `systeminfo`).
  * `Get-Process` (alias `ps`, `gps`): Toont alle actief draaiende processen, hun PID, CPU-tijd en geheugengebruik.
* **Praktijkgebruik:**
  ```powershell
  # Haal specifieke OS- en hotfix-informatie op
  Get-ComputerInfo | Select-Object WindowsProductName, OsVersion, CsName

  # Toon alle actieve processen gesorteerd op geheugengebruik
  Get-Process | Sort-Object WorkingSet -Descending | Select-Object -First 15
  ```

### `Get-Service`, `New-Service`, `Start-Service`, `Stop-Service` & `Get-CimInstance Win32_Service`
* **Doel:**
  * `Get-Service`: Haalt status, interne servicenaam (`Name`) en weergavenaam (`DisplayName`) van Windows-services op.
  * `New-Service`: Registreert een nieuwe Windows-service in het register en bij de Service Control Manager (SCM).
  * `Start-Service` / `Stop-Service` / `Restart-Service` **[Aanvullend]**: Start, stopt of herstart een service.
  * `Get-CimInstance Win32_Service` **[Aanvullend]**: Moderne vervanger van `wmic service` om volledige service-metadata op te halen, inclusief `PathName`, `StartMode`, `StartName` en `ProcessId`.
* **Parameters & Opties:**
  * `-Name <naam>`: Interne servicenaam (bijv. `MyService`, `wuauserv`, `MpsSvc`).
  * `-BinaryPathName "<pad>"`: Pad naar het uitvoerbare `.exe`-bestand bij `New-Service`.
  * `Where-Object Status -EQ "Running"` / `-NE "Running"`: Filtert op wel (`-EQ` = **EQ**uals) of niet (`-NE` = **N**ot **E**quals) actieve services.
* **Praktijkgebruik & Permutaties:**
  ```powershell
  # Filter op actief draaiende of niet-actieve services
  Get-Service | Where-Object Status -EQ "Running"
  Get-Service | Where-Object Status -NE "Running"

  # Inspecteer alle eigenschappen van een specifieke service in tabelvorm
  Get-Service -Name MyService | Select-Object -Property * | Format-Table

  # Registreer en start een nieuwe Windows-service
  New-Service -Name MyService -BinaryPathName "C:\Program Files\my service\WindowsService1.exe"
  Start-Service -Name MyService
  Stop-Service -Name MyService

  # [Aanvullend] Moderne vervanger van WMIC om kwetsbare Unquoted Service Paths op te sporen
  Get-CimInstance Win32_Service | Where-Object {
      $_.StartMode -eq 'Auto' -and
      $_.PathName -notlike 'C:\Windows\*' -and$_.PathName -notlike '"*"*'
  } | Select-Object Name, StartMode, PathName
  ```

### `Get-ItemProperty` (Register) & `Get-WinEvent` (Windows Event Logs `.evtx`) **[Aanvullend]**
* **Doel:**
  * `Get-ItemProperty`: Leest waarden uit Windows Registry-sleutels (bijv. om persistence in `Run`-sleutels te controleren).
  * `Get-WinEvent`: Leest zowel live Windows-gebeurtenislogboeken (*Security*, *System*, *Application*) als offline `.evtx`-bestanden uit.
* **Praktijkgebruik:**
  ```powershell
  # Inspecteer autostart-programma's in het Windows-register (Persistence check)
  Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"

  # Lees de laatste 20 gebeurtenissen uit het Security-logboek of een geëxporteerd .evtx-bestand
  Get-WinEvent -LogName Security -MaxEvents 20
  Get-WinEvent -Path .\Security.evtx -MaxEvents 20
  ```

---

## 4. Toegangscontrole (ACL's), Lokale Gebruikers & Back-up

### `Get-Acl`, `Set-Acl` & `Get-LocalGroupMember`
* **Doel:**
  * `Get-Acl`: Haalt de Access Control List (eigenaar en alle ACE's) op van een bestand, map of registersleutel.
  * `Set-Acl` **[Aanvullend]**: Past een gewijzigd ACL-object toe op een doelmap of -bestand.
  * `Get-LocalGroupMember` **[Aanvullend]**: Toont alle leden van een lokale Windows-groep (modern equivalent van `net localgroup`).
* **Praktijkgebruik:**
  ```powershell
  # Inspecteer alle toegangsregels (ACE's) van een map
  Get-Acl -Path C:\Hall_of_Justice | Format-List

  # Bekijk de leden van een lokale beveiligingsgroep
  Get-LocalGroupMember -Group "Leaders"
  Get-LocalGroupMember -Group "Administrators"
  ```

### `Install-WindowsFeature`, `Enable-WindowsOptionalFeature` & `Get-WBSummary` (Back-up)
* **Doel:**
  * `Install-WindowsFeature`: Installeert serverrollen en -features op **Windows Server** (zoals `Windows-Server-Backup` of `AD-Domain-Services`).
  * `Enable-WindowsOptionalFeature` **[Aanvullend]**: Het equivalent van `Install-WindowsFeature` op **Windows 10/11 client-edities**.
  * `Get-WBSummary` **[Aanvullend]**: Toont de samenvatting en status van uitgevoerde Windows Server Backups.
* **Praktijkgebruik:**
  ```powershell
  # Installeer Windows Server Backup op Windows Server
  Install-WindowsFeature Windows-Server-Backup

  # [Aanvullend] Controleer de status en laatste herstelpunten van Windows Server Backup
  Get-WBSummary
  ```

---

## 5. Active Directory & Group Policy Beheer

### AD DS Installatie & Domeininspectie (`Install-WindowsFeature`, `Install-ADDSForest`, `Get-ADDomain`)
* **Doel:**
  * `Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools`: Installeert de Active Directory Domain Services-rol inclusief alle GUI- en PowerShell-beheertools.
  * `Install-ADDSForest`: Promoveert een Windows Server tot de eerste Domain Controller van een nieuw AD Forest en Root Domain (inclusief DNS).
  * `Get-ADDomain`: Toont de domeineigenschappen, waaronder de `DistinguishedName` (bijv. `DC=legionofdoom,DC=local`), NetBIOS-naam en FSMO-rollen.
* **Parameters & Opties (`Install-ADDSForest`):**
  * `-DomainName "<fqdn>"`: DNS-naam van het nieuwe root-domein.
  * `-DomainNetbiosName "<naam>"`: NetBIOS-naam (maximaal **15 tekens**).
  * `-DomainMode "7"` & `-ForestMode "7"`: Functional Level (niveau `7` = Windows Server 2016).
  * `-DatabasePath`, `-LogPath`, `-SysvolPath`: Paden voor `NTDS.dit` en `SYSVOL` (standaard `C:\Windows\NTDS` en `C:\Windows\SYSVOL`).
  * `-InstallDns:$true` & `-CreateDnsDelegation:$false`: Installeert de geïntegreerde DNS-server zonder delegatie.
  * `-NoRebootOnCompletion:$False` & `-Force:$true`: Herstart automatisch na voltooiing zonder bevestigingsprompts (vraagt enkel om het **DSRM**-herstelwachtwoord).
* **Praktijkgebruik:**
  ```powershell
  # 1. Installeer AD DS en beheertools
  Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools

  # 2. Promoveer server tot DC van nieuw forest 'legionofdoom.local'
  Install-ADDSForest -DomainName "legionofdoom.local" -CreateDnsDelegation:$false -DatabasePath "C:\Windows\NTDS" -DomainMode "7" -DomainNetbiosName "LEGIONOFDOOM" -ForestMode "7" -InstallDns:$true -LogPath "C:\Windows\NTDS" -NoRebootOnCompletion:$False -SysvolPath "C:\Windows\SYSVOL" -Force:$true

  # 3. Controleer na reboot de domeineigenschappen en DistinguishedName
  Get-ADDomain
  ```

### AD Objectbeheer: OUs, Users & Groups
* **Doel:**
  * `New-ADOrganizationalUnit` & `Get-ADOrganizationalUnit`: Maakt en inspecteert Organizational Units (waarop GPO's gekoppeld kunnen worden).
  * `New-ADUser` & `Get-ADUser`: Maakt en inspecteert Active Directory-gebruikersaccounts.
  * `New-ADGroup`, `Get-ADGroup`, `Add-ADGroupMember` & `Get-ADGroupMember`: Maakt en beheert AD Security/Distribution Groups en hun leden.
* **Belangrijke Parameters:**
  * `-Path "<DN>"`: *Distinguished Name* van de bovenliggende container of OU (bijv. `"OU=Hall of Doom,DC=legionofdoom,DC=local"`).
  * `-AccountPassword (Read-Host -AsSecureString "Input Password")` & `-Enabled:$true`: Vraagt veilig om een wachtwoord en activeert het nieuwe account direct.
  * `-GroupCategory Security` & `-GroupScope Global` (of `DomainLocal` / `Universal`).
* **Praktijkgebruik & Permutaties:**
  ```powershell
  # Maak een OU aan en controleer alle OU's
  New-ADOrganizationalUnit -Name "Hall of Doom" -Path "DC=legionofdoom,DC=local"
  Get-ADOrganizationalUnit -Filter ' Name -like "*" ' | Format-Table Name

  # Maak een actief AD-gebruikersaccount aan en verifieer
  New-ADUser -Name "Lex Luthor" -DisplayName "Lex Luthor" -GivenName "Lex" -Surname "Luthor" -SamAccountName "lex.luthor" -UserPrincipalName "lex.luthor@legionofdoom.local" -Path "OU=Hall of Doom,DC=legionofdoom,DC=local" -AccountPassword (Read-Host -AsSecureString "Input Password") -Enabled:$true
  Get-ADUser -Filter ' Name -like "Lex*" '

  # Maak een Global Security Group aan, voeg een gebruiker toe en controleer lidmaatschap
  New-ADGroup -Name "Villains" -SamAccountName "Villains" -GroupCategory Security -GroupScope Global -DisplayName "Villains" -Path "OU=Hall of Doom,DC=legionofdoom,DC=local"
  Add-ADGroupMember -Identity "Villains" -Members lex.luthor
  Get-ADGroupMember -Identity "Villains"
  ```

### Group Policy in PowerShell (`gpupdate`, `gpresult`, `Invoke-GPUpdate`, `Get-GPResultantSetOfPolicy`)
* **Praktijkgebruik:**
  ```powershell
  # Forceer onmiddellijke GPO-vernieuwing en genereer een RSoP-rapport
  gpupdate /force
  gpresult /Z

  # [Aanvullend] Native PowerShell cmdlets uit de GroupPolicy-module
  Invoke-GPUpdate -Force
  Get-GPResultantSetOfPolicy -ReportType Html -Path "C:\Temp\rsop.html"
  ```

---

## 6. Microsoft Defender Antivirus (Beheer & SOC Triage)

### `Start-MpScan`, `Update-MpSignature`, `Get-MpComputerStatus`, `Get-MpThreatDetection` & `Remove-MpPreference`
* **Doel:**
  * `Start-MpScan`: Start vanaf de CLI een malwarescan met Microsoft Defender Antivirus.
  * `Update-MpSignature` **[Aanvullend]**: Werkt de antivirus-signatures direct bij.
  * `Get-MpComputerStatus` **[Aanvullend]**: Controleert of *Real-time Protection*, *Behavior Monitoring* en *Tamper Protection* actief zijn en hoe oud de signatures zijn.
  * `Get-MpThreatDetection` & `Get-MpThreat` **[Aanvullend]**: Haalt gedetecteerde dreigingen, ernstniveaus en getroffen bestandspaden op voor SOC-onderzoek.
  * `Get-MpPreference` & `Remove-MpPreference` **[Aanvullend]**: Inspecteert of verwijdert geconfigureerde scan-uitsluitingen (*Exclusions*).
* **Parameters & Opties (`Start-MpScan`):**
  * `-ScanPath <pad>`: Doelmap of -bestand (bijv. `C:\Evil\`).
  * `-ScanType <type>`: `CustomScan` (voor specifiek pad), `QuickScan` **[Aanvullend]** of `FullScan` **[Aanvullend]**.
* **Praktijkgebruik & Permutaties:**
  ```powershell
  # Voer een gerichte Custom Scan uit op een specifieke map (vereist Admin)
  Start-MpScan -ScanPath C:\Evil\ -ScanType CustomScan

  # [Aanvullend] Werk signatures bij en start een snelle systeemscan
  Update-MpSignature
  Start-MpScan -ScanType QuickScan

  # [Aanvullend] SOC Triage: controleer Defender-status, exclusions en detectiegeschiedenis
  Get-MpComputerStatus | Select-Object RealTimeProtectionEnabled, AntivirusSignatureLastUpdated
  (Get-MpPreference).ExclusionPath
  Remove-MpPreference -ExclusionPath "C:\Evil"
  Get-MpThreatDetection
  ```

---

## 7. Netwerkconfiguratie, Firewall, VPN & Cryptografie

### Netwerkdiagnose & Firewall (`Test-NetConnection`, `Get-NetIPAddress`, `New-NetFirewallRule`, `Get-VpnConnection`) **[Aanvullend]**
* **Doel:** Moderne object-georiënteerde PowerShell-cmdlets voor IP-configuratie, poort- en routetests, Windows Defender Firewall-regels en VPN-status.
* **Praktijkgebruik & Permutaties:**
  ```powershell
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
  ```

### Cryptografie & Encoding (`Protect-CmsMessage`, `Unprotect-CmsMessage`, `[Convert]::ToBase64String`) **[Aanvullend]**
* **Doel:** Versleutelt en ontsleutelt berichten met behulp van certificaten (*Cryptographic Message Syntax*) en voert Base64-conversies uit in PowerShell.
* **Praktijkgebruik:**
  ```powershell
  # Versleutel en ontsleutel een bericht met een certificaat
  Protect-CmsMessage -To "certificaat.cer" -Path .\message.txt -OutFile .\message.enc
  Unprotect-CmsMessage -Path .\message.enc

  # Base64-encoding en -decoding van binaire bestanden in PowerShell
  [Convert]::ToBase64String([IO.File]::ReadAllBytes("message.enc")) > message.base64
  [IO.File]::WriteAllBytes("message.enc", [Convert]::FromBase64String((Get-Content .\message.base64 -Raw)))
  ```