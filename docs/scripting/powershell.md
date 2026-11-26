---
outline: [2, 3]
---

# PowerShell Referentie <Badge type="info" text="Windows" /> <Badge type="tip" text="Linux & macOS via pwsh" />

Alle PowerShell-cmdlets uit de kennisbank, met parameters.

::: info Gerelateerd
De CMD-tegenhanger staat in de [CMD-referentie](/scripting/cmd), de Linux-tegenhanger in de [BASH-referentie](/scripting/bash).
:::

## Hulp, modules & omgeving

### Get-Help {#ps-get-help}

Toont documentatie van een cmdlet.

| Parameter | Betekenis |
| :--- | :--- |
| `-Full` | Volledige help inclusief parameters en opmerkingen. |
| `-Examples` | Alleen de voorbeelden. |

<<< @/snippets/ps/system.ps1#help{powershell}

### Import-Module {#ps-import-module}

Laadt een module of lokaal script in de huidige sessie.

<<< @/snippets/ps/system.ps1#modules{powershell}

### Get-History & PSReadLine {#ps-get-history-psreadline}

`Get-History` toont de geschiedenis van de huidige sessie. `PSReadLine` bewaart commando's tussen sessies in een tekstbestand, waarvan het pad via `HistorySavePath` te vinden is.

<<< @/snippets/ps/system.ps1#history{powershell}

### Omgevingsvariabelen & Python {#ps-omgevingsvariabelen-python}

`$env:PATH -split ';'` toont elke map in het zoekpad op een eigen regel. Dat is handig om PATH-hijacking te beoordelen.

<<< @/snippets/ps/system.ps1#python{powershell}

## Bestanden, tekst & hashing

### Get-ChildItem, Select-String & Get-Content {#ps-search}

Bestanden zoeken, doorzoeken en lezen of schrijven.

| Parameter | Betekenis |
| :--- | :--- |
| `Get-ChildItem -Recurse -Filter <patroon>` | Zoekt recursief op bestandsnaam. |
| `Select-String -Path <bestanden> -Pattern <tekst>` | Zoekt tekst in bestanden, vergelijkbaar met `grep`. |
| `Set-Content` / `Add-Content` / `Get-Content` | Schrijft, voegt toe aan en leest een tekstbestand. |

<<< @/snippets/ps/file.ps1#search{powershell}

### Get-FileHash {#ps-get-filehash}

Berekent de hash van een bestand voor integriteitscontrole en threat-intel lookups.

| Parameter | Betekenis |
| :--- | :--- |
| `-Path <bestand>` | Bestand of wildcard-patroon. |
| `-Algorithm <naam>` | `SHA256` (standaard), `SHA1`, `SHA512` of `MD5`. |

<<< @/snippets/ps/file.ps1#hash{powershell}

### Alternate Data Streams (ADS) {#ps-alternate-data-streams-ads}

Ontdekt alle aanwezige Alternate Data Streams (inclusief onbekende streamnamen) op een NTFS-bestand en leest de inhoud van een specifieke stream uit.

**Parameters & Opties**

* `-Stream *`: Toont alle datastreams gekoppeld aan het bestand (zowel de standaard `:$DATA`-stream als verborgen ADS-streams).
* `-Stream <naam>`: Leest de inhoud van een specifieke benoemde stream.

<<< @/snippets/ps/windows-file-system.ps1#fs-get-item-stream-get-content-stream-power{powershell}

::: warning SOC-context (Zone.Identifier & Malware-detectie)
* Windows gebruikt ADS legitiem voor de `Zone.Identifier`-stream (*Mark of the Web*): elk bestand dat van internet is gedownload krijgt een `Zone.Identifier` (`ZoneId=3`), waarmee Windows waarschuwt bij het openen.
* Aanvallers misbruiken ADS om payloads of scripts onzichtbaar te verbergen achter legitieme bestanden. Met `Get-ChildItem -Recurse | Get-Item -Stream * | Where-Object Stream -ne ':$DATA'` spoor je als SOC-analist snel alle verborgen streams in een map op.
:::

## Processen, services, register & logs

### Get-ComputerInfo & Get-Process {#ps-process}

Toont systeeminformatie en actieve processen.

| Parameter | Betekenis |
| :--- | :--- |
| `Get-ComputerInfo -Property <patroon>` | Beperkt de uitvoer, bijvoorbeeld `*version` of `*hot*`. |
| `Sort-Object WorkingSet -Descending` | Sorteert op geheugengebruik. |
| `Select-Object -First <n>` | Beperkt de uitvoer tot de eerste *n* resultaten. |

<<< @/snippets/ps/os-management.ps1#process{powershell}

### Get-Service {#ps-get-service}

Haalt de status, interne servicenaam (`Name`) en weergavenaam (`DisplayName`) op van alle of specifieke Windows-services.

**Parameters & Opties**

* `-Name <servicenaam>`: Filtert op de interne servicenaam (bijv. `MyService` of `wuauserv`).
* `Where-Object Status -EQ "Running"`: Filtert op uitsluitend actieve services (`-EQ` = **EQ**uals).
* `Where-Object Status -NE "Running"`: Filtert op niet-actieve services zoals `Stopped`, `Paused` of `Starting` (`-NE` = **N**ot **E**quals).
* `Select-Object -Property * | Format-Table` (kortweg `select -Property * | FT`): Toont alle beschikbare objecteigenschappen in tabelvorm.

<<< @/snippets/ps/services.ps1#service-inventory{powershell}

::: tip Tips & valkuilen
* PowerShell gebruikt standaard de interne **servicenaam** (`wuauserv`, `spooler`, `MpsSvc`), niet de weergavenaam (`Windows Update`). Gebruik `-DisplayName` als je op de weergavenaam wilt zoeken.
* `Get-Service` toont in standaard Windows PowerShell 5.1 niet direct het uitvoerbare pad (`BinaryPathName`).
* **Modernere PowerShell-alternatieven voor Service-paden (zonder WMIC):**
  * In **PowerShell 7 (`pwsh`)** bevat `Get-Service` wél direct de eigenschap `BinaryPathName`: `Get-Service | Select-Object Name, StartType, BinaryPathName`.
  * In **alle Windows PowerShell-versies** is `Get-CimInstance Win32_Service` de moderne opvolger van `wmic service`:
<<< @/snippets/ps/services.ps1#service-unquoted-path{powershell}
  * **Windows CMD:** `sc qc <servicenaam>` (*Query Config*) toont direct het `BINARY_PATH_NAME` en de `SERVICE_START_NAME` van een specifieke service.
:::

### New-Service, Start-Service & Stop-Service {#ps-new-service-start-service-stop-service}

* `New-Service`: Registreert een nieuwe Windows-service in het register en bij de Service Control Manager (SCM).
* `Start-Service`: Start een gestopte service.
* `Stop-Service`: Stopt een actieve service (waarmee de status wordt gewist en de service bij herstart "schoon" begint).

**Parameters & Opties**

* `-Name <naam>`: Interne servicenaam.
* `-BinaryPathName "<pad>"`: Het pad naar het uitvoerbare `.exe`-bestand van de service.

<<< @/snippets/ps/services.ps1#service-lifecycle{powershell}

::: warning Let op
* Zelfs als je in PowerShell dubbele aanhalingstekens om `-BinaryPathName` zet, worden die aanhalingstekens **niet** opgeslagen in de `ImagePath`-waarde in het Windows-register (`HKLM\System\CurrentControlSet\Services\<Naam>`). Bevat het pad spaties, dan ontstaat er een **Unquoted Service Path**-kwetsbaarheid.
* Gebruik `Restart-Service -Name <naam>` om een service in één stap te herstarten, `Set-Service -Name <naam> -StartupType Disabled` om het opstarttype te wijzigen, en `Remove-Service -Name <naam>` (PowerShell 6+) of `sc.exe delete <naam>` om een service te verwijderen.
:::

### Get-ItemProperty (register) {#ps-get-itemproperty-register}

Leest registerwaarden. Controleer de `Run`-sleutels op onverwachte autostart-programma's (persistence).

<<< @/snippets/ps/os-management.ps1#registry{powershell}

### Get-WinEvent {#ps-get-winevent}

Leest event logs, ook uit een geëxporteerd `.evtx`-bestand.

| Parameter | Betekenis |
| :--- | :--- |
| `-LogName <naam>` | Logboek zoals `Security`, `System` of `Application`. |
| `-Path <bestand>` | Leest een `.evtx`-bestand. |
| `-MaxEvents <n>` | Beperkt het aantal events. |
| `-FilterHashtable @{...}` | Snelle filtering op `LogName`, `ProviderName`, `Id` en meer. |

<<< @/snippets/ps/os-management.ps1#eventlogs{powershell}

### Processen en verbindingen uitgebreid {#ps-process-extended}

| Parameter | Betekenis |
| :--- | :--- |
| `Get-Process -IncludeUserName` | Toont de eigenaar van elk proces, vereist een verhoogde sessie. |
| `Get-CimInstance Win32_Process` | Geeft `CommandLine` en `ParentProcessId`. Een onverwachte ouder is verdacht. |
| `Get-NetTCPConnection` + `Get-Process -Id` | Koppelt een verbinding aan het programma via `OwningProcess`. |

<<< @/snippets/ps/os-management.ps1#process-extended{powershell}

### Events filteren met FilterHashtable {#ps-events-filter}

`-FilterHashtable` filtert aan de bron en is veel sneller dan `Where-Object`.

| Parameter | Betekenis |
| :--- | :--- |
| `LogName` | Het logboek: `Security`, `System` of `Application`. |
| `Id` | Het Event ID. 4625 = mislukte aanmelding, 4624 = geslaagde aanmelding, 7045 = service geïnstalleerd. |
| `StartTime` | Beperkt tot een tijdvenster, bijvoorbeeld `(Get-Date).AddHours(-1)`. |

<<< @/snippets/ps/os-management.ps1#events-filter{powershell}

### Persistence-checks {#ps-persistence}

Plekken waar een aanvaller op Windows toegang behoudt.

| Parameter | Betekenis |
| :--- | :--- |
| `Get-ScheduledTask` | Geplande taken. Filter met `Where-Object State -ne 'Disabled'`. |
| `Get-LocalUser \| Where-Object Enabled` | Alleen ingeschakelde accounts. |
| `Get-Service \| Where-Object StartType -eq 'Automatic'` | Services die automatisch starten. |
| `RunOnce`-sleutel | Voert een programma eenmalig uit bij de volgende aanmelding. |
| `Get-ChildItem -Force` | Toont ook verborgen en systeembestanden. |

<<< @/snippets/ps/os-management.ps1#persistence{powershell}

## Security & toegang

### Get-Acl & Get-LocalGroupMember {#ps-get-acl-get-localgroupmember}

Toont NTFS-rechten en groepslidmaatschap.

<<< @/snippets/ps/access-control.ps1#acl{powershell}

### Microsoft Defender-cmdlets {#ps-defender}

Beheert scans, signatures, uitsluitingen en detecties.

| Parameter | Betekenis |
| :--- | :--- |
| `Start-MpScan -ScanType <type>` | `QuickScan`, `FullScan` of `CustomScan` (met `-ScanPath`). |
| `Update-MpSignature` | Werkt de virusdefinities bij. |
| `Get-MpComputerStatus` | Toont onder meer de status van real-time protection. |
| `Get-MpPreference` | Toont instellingen, zoals `ExclusionPath`. |
| `Remove-MpPreference -ExclusionPath <pad>` | Verwijdert een uitsluiting. |
| `Get-MpThreatDetection` | Toont de detectiegeschiedenis. |

<<< @/snippets/ps/defender.ps1#defender{powershell}

### Windows Server Backup {#ps-windows-server-backup}

Installeert de back-uprol en toont de status van herstelpunten.

<<< @/snippets/ps/access-control.ps1#backup{powershell}

## Active Directory & Group Policy

### Install-WindowsFeature {#ps-install-windowsfeature}

Installeert de **Active Directory Domain Services (AD DS)** serverrol inclusief de bijbehorende grafische en PowerShell-beheertools op een Windows Server.

**Parameters & Opties**

* `-Name AD-Domain-Services`: De exacte rolnaam voor Active Directory Domain Services.
* `-IncludeManagementTools`: Installeert direct alle beheerconsoles (zoals *Active Directory Users and Computers* / `dsa.msc`) en de PowerShell `ActiveDirectory`-module.

<<< @/snippets/ps/windows-active-directory.ps1#ad-install-windowsfeature{powershell}

### Install-ADDSForest {#ps-install-addsforest}

Promoveert een Windows Server tot de eerste **Domain Controller (DC)** van een volledig nieuw Active Directory **Forest** en **Root Domain**, en installeert direct de geïntegreerde DNS-serverrol.

**Parameters & Opties**

* `-DomainName "<fqdn>"`: De DNS-naam van het nieuwe root-domein (bijv. `"legionofdoom.local"`).
* `-CreateDnsDelegation:$false`: Slaat het aanmaken van een DNS-delegatie naar een bovenliggende DNS-zone over.
* `-DatabasePath "<pad>"`: Locatie van de AD-database (`NTDS.dit`, standaard `"C:\Windows\NTDS"`).
* `-LogPath "<pad>"`: Locatie van de AD-transactielogboeken (standaard `"C:\Windows\NTDS"`).
* `-SysvolPath "<pad>"`: Locatie van de `SYSVOL`-map voor Group Policy-objecten en logonscripts (standaard `"C:\Windows\SYSVOL"`).
* `-DomainMode "7"` & `-ForestMode "7"`: Stelt het *Domain Functional Level* en *Forest Functional Level* in (niveau `7` = Windows Server 2016).
* `-DomainNetbiosName "<naam>"`: De NetBIOS-naam van het domein (maximaal **15 tekens**, bijv. `"LEGIONOFDOOM"`).
* `-InstallDns:$true`: Installeert en configureert de DNS-serverrol op deze Domain Controller.
* `-NoRebootOnCompletion:$False`: Herstart de server automatisch zodra de promotie is voltooid.
* `-Force:$true`: Voert de promotie uit zonder interactieve bevestigingsprompts (vraagt alleen nog om het **DSRM**-wachtwoord).

<<< @/snippets/ps/windows-active-directory.ps1#ad-install-addsforest{powershell}

::: tip Tips & valkuilen
* Bewaar het **Directory Services Restore Mode (DSRM)**-wachtwoord veilig; dit is het lokale herstelwachtwoord waarmee een beheerder kan inloggen wanneer de Active Directory-database offline hersteld of gerepareerd moet worden.
* Een NetBIOS-domeinnaam mag **maximaal 15 tekens** lang zijn.
* **Modernere Domeinnaamgeving & Best Practices:** Gebruik in productieomgevingen bij voorkeur **geen `.local`**-top-level domain (dit conflicteert met mDNS/Bonjour op Linux en macOS). Gebruik in plaats daarvan een subdomein van een geregistreerd bedrijfsdomein, zoals `ad.bedrijf.nl` of `corp.bedrijf.be`. Voor het toevoegen van een extra Domain Controller aan een bestaand domein gebruik je `Install-ADDSDomainController`.
:::

### Get-ADDomain {#ps-get-addomain}

Toont de eigenschappen van het huidige Active Directory-domein, waaronder de **Distinguished Name (`DistinguishedName`)**, NetBIOS-naam, DNS-root en FSMO-rolhouders.

<<< @/snippets/ps/windows-active-directory.ps1#ad-get-addomain{powershell}

::: details Aanvullende Verificatie-cmdlets
Gebruik `Get-ADForest` om het volledige forest (inclusief alle vertrouwde domeinen en Global Catalogs) te inspecteren, en `Get-ADDomainController -Filter *` om alle Domain Controllers op te vragen.

:::

### New-ADOrganizationalUnit & Get-ADOrganizationalUnit {#ps-new-adorganizationalunit-get-adorganizat}

* `New-ADOrganizationalUnit`: Maakt een nieuwe **Organizational Unit (OU)** aan binnen een opgegeven domein- of ouderpad.
* `Get-ADOrganizationalUnit`: Zoekt en toont bestaande Organizational Units op basis van een filter.

**Parameters & Opties**

* `-Name "<naam>"`: De naam van de nieuwe OU (spaties zijn toegestaan, bijv. `"Hall of Doom"`).
* `-Path "<DN>"`: De *Distinguished Name* van de bovenliggende container of OU (bijv. `"DC=legionofdoom,DC=local"`).
* `-Filter ' Name -like "*" '`: Filterexpressie die alle OU's ophaalt.

<<< @/snippets/ps/windows-active-directory.ps1#ad-new-adorganizationalunit-get-adorganizat{powershell}

### New-ADUser & Get-ADUser {#ps-new-aduser-get-aduser}

* `New-ADUser`: Maakt een nieuw Active Directory-gebruikersaccount aan binnen een specifieke OU en activeert dit direct.
* `Get-ADUser`: Zoekt en inspecteert AD-gebruikersaccounts op basis van een filter of naam.

**Parameters & Opties**

* `-Name "<volledige naam>"`: De weergave-/objectnaam in AD (bijv. `"Lex Luthor"`).
* `-DisplayName "<naam>"`, `-GivenName "<voornaam>"`, `-Surname "<achternaam>"`: Persoonsgegevens voor het gebruikersobject.
* `-SamAccountName "<logon>"`: De klassieke pre-Windows 2000 logon name (bijv. `"lex.luthor"`).
* `-UserPrincipalName "<upn>"`: De moderne logon name in e-mailformaat (`lex.luthor@legionofdoom.local`).
* `-Path "<OU_DN>"`: De exacte locatie (OU) waarin het account wordt geplaatst (bijv. `"OU=Hall of Doom,DC=legionofdoom,DC=local"`).
* `-AccountPassword (Read-Host -AsSecureString "Input Password")`: Vraagt veilig en gemaskeerd naar het wachtwoord.
* `-Enabled:$true`: Activeert het account direct (zonder deze vlag maakt `New-ADUser` standaard een uitgeschakeld account aan).

<<< @/snippets/ps/windows-active-directory.ps1#ad-new-aduser-get-aduser{powershell}

::: warning SOC-triage & Extra User-cmdlets
* `Get-ADUser -Identity lex.luthor -Properties *`: Toont alle attributen van een gebruiker (waaronder `LastLogonDate`, `PasswordLastSet`, `MemberOf` en `LockedOut`).
* `Unlock-ADAccount -Identity lex.luthor` & `Disable-ADAccount -Identity lex.luthor`: Account ontgrendelen of bij een incident direct blokkeren.
:::

### New-ADGroup, Get-ADGroup, Add-ADGroupMember & Get-ADGroupMember {#ps-new-adgroup-get-adgroup-add-adgroupmembe}

* `New-ADGroup`: Maakt een nieuwe Active Directory-groep aan (Security of Distribution, met scope Global, DomainLocal of Universal).
* `Get-ADGroup`: Zoekt groepen op in Active Directory.
* `Add-ADGroupMember`: Voegt één of meer gebruikers of groepen toe als lid van een AD-groep.
* `Get-ADGroupMember`: Toont alle huidige leden van een opgegeven AD-groep.

**Parameters & Opties**

* `-GroupCategory Security` (of `Distribution`): Bepaalt of de groep gebruikt wordt voor toegangsrechten (`Security`) of e-maillijsten (`Distribution`).
* `-GroupScope Global` (of `DomainLocal` / `Universal`): Bepaalt het bereik van de groep binnen het domein of forest.
* `-Identity "<groepsnaam>"`: De naam of DN van de doelgroep.
* `-Members <account>`: Eén of meer gebruikers-/groepsnamen (kommagescheiden).

<<< @/snippets/ps/windows-active-directory.ps1#ad-new-adgroup-get-adgroup-add-adgroupmembe{powershell}

::: details Linux- en Cloud-equivalenten
* **Cloud (Microsoft Entra ID / Azure AD):** Het cloud-equivalent van on-premises Active Directory is **Microsoft Entra ID**, beheerd via PowerShell met de `Microsoft.Graph`-module (`New-MgUser`, `New-MgGroup`, `New-MgGroupMember`).
* **Linux (Debian/Ubuntu & Arch):** Lokale groepen en gebruikers beheer je met `groupadd`, `usermod -aG <groep> <gebruiker>` en `getent group <groep>`. Voor centrale domeinauthenticatie op Linux worden **FreeIPA** of **Samba Active Directory DC** gebruikt.
:::

### Domeinscript importeren en OU-hiërarchie opbouwen {#ps-domeinscript-importeren-en-ou-hi-rarchie}

* `Import-Module .\Install-AD.ps1`: Laadt een lokaal PowerShell-script of -module in de huidige sessie (zoals het hulpscript met `Invoke-ADInstaller -DomainName cybrary.local`).
* `New-ADOrganizationalUnit`: Maakt een hiërarchie van Organizational Units (OU's) aan waarop domein-GPO's gekoppeld kunnen worden (bijv. `Cybrary` en een geneste sub-OU `Engineering`).
* `Add-ADGroupMember` & `Get-ADGroupMember`: Voegt een gebruiker toe aan `"Domain Admins"` en controleert het groepslidmaatschap (vereist na aanpassing een *Sign out* en opnieuw inloggen voordat het nieuwe Kerberos-toegangstoken actief wordt).

<<< @/snippets/ps/windows-group-policy.ps1#gpo-import-module-new-adorganizationalunit-a{powershell}

### Group Policy-cmdlets {#ps-group-policy-cmdlets}

Native alternatieven voor `gpupdate` en `gpresult`. De CMD-varianten staan onder [Group Policy & Active Directory](/scripting/cmd#cmd-gpupdate).

<<< @/snippets/ps/ad.ps1#gpo-cmdlets{powershell}

## Netwerk & cryptografie

### Netwerkcmdlets {#ps-netwerkcmdlets}

Vervangen `ipconfig`, `netstat`, `arp`, `route`, `nslookup` en `telnet`.

| Parameter | Betekenis |
| :--- | :--- |
| `Get-NetAdapter` | Netwerkadapters en hun status. |
| `Get-NetIPAddress -AddressFamily IPv4` | IP-adressen. |
| `Get-NetRoute` | Routeringstabel. |
| `Get-NetNeighbor` | ARP-cache. |
| `Get-NetTCPConnection -State <status>` | Verbindingen, bijvoorbeeld `Established` of `Listen`. |
| `Test-NetConnection -ComputerName <host> -Port <poort>` | Test een TCP-poort. Met `-TraceRoute` ook de route. |
| `Resolve-DnsName <naam> -Type <type>` | Vraagt DNS-records op. |
| `Clear-DnsClientCache` | Leegt de DNS-cache van de client. |
| `New-NetFirewallRule` | Maakt een firewallregel (`-Direction`, `-LocalPort`, `-Protocol`, `-Action`). |
| `Get-VpnConnection` / `Get-NetIPsecMainModeSA` | Toont VPN-verbindingen en IPsec Security Associations. |

<<< @/snippets/ps/network.ps1#network{powershell}

<<< @/snippets/ps/network.ps1#connections{powershell}

### Versleutelen & Base64 {#ps-versleutelen-base64}

`Protect-CmsMessage` versleutelt met een certificaat. Voor Base64 gebruik je .NET-methoden.

<<< @/snippets/ps/network.ps1#crypto{powershell}

## Patchbeheer & basisoefeningen

### PSWindowsUpdate {#ps-pswindowsupdate}

Updatebeheer vanaf de command line.

| Parameter | Betekenis |
| :--- | :--- |
| `Get-WindowsUpdate -IsInstalled` | Toont geïnstalleerde updates. |
| `-AcceptAll -Install -AutoReboot` | Installeert alle updates zonder interactie en herstart zo nodig. |
| `-KBArticleID <KB>` | Beperkt de actie tot één update. |
| `-Hide` | Verbergt een update zodat die niet meer wordt aangeboden. |

<<< @/snippets/ps/patching.ps1#windows-update{powershell}

### Basisoefeningen {#ps-basisoefeningen}

Variabelen, objecten, bestanden, systeeminformatie, accounts en logs.

<<< @/snippets/ps/basics.ps1#basics-variables{powershell}
<<< @/snippets/ps/basics.ps1#basics-discovery{powershell}
<<< @/snippets/ps/basics.ps1#basics-files{powershell}
<<< @/snippets/ps/basics.ps1#basics-system-info{powershell}
<<< @/snippets/ps/basics.ps1#basics-accounts{powershell}
<<< @/snippets/ps/basics.ps1#basics-logs{powershell}
