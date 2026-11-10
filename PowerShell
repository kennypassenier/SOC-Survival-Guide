# Windows PowerShell Cheat Sheet - SysAdmin & SOC Analyst Edition

Een uitgebreide naslaggids met essentiële PowerShell-cmdlets voor systeembeheer, objectfiltering, event log triage, proces- en netwerkinspectie, en snelle incident response.

---

## 1. Navigatie en Bestandsbeheer

| Cmdlet | Alias | Beschrijving | Voorbeeld |
| :--- | :--- | :--- | :--- |
| `Get-Location` | `pwd`, `gl` | Toont het huidige pad van de werkdirectory. | `Get-Location` |
| `Set-Location` | `cd`, `sl` | Wisselt van map of schijfletter. | `Set-Location -Path "D:\Logs"` |
| `Get-ChildItem` | `dir`, `ls`, `gci` | Geeft bestanden en mappen weer (`-Hidden` voor verborgen, `-Recurse` voor recursief). | `Get-ChildItem -Path C:\ -Hidden` |
| `New-Item` | `ni` | Maakt een nieuw bestand of nieuwe map aan (`-ItemType Directory` of `File`). | `New-Item -Path "C:\Incident\Evidence" -ItemType Directory -Force` |
| `Remove-Item` | `del`, `rm` | Verwijdert bestanden of mappen (`-Recurse` wist inclusief inhoud, `-Force` negeert read-only). | `Remove-Item -Path "C:\Temp\Old" -Recurse -Force` |
| `Copy-Item` | `copy`, `cp` | Kopieert bestanden of mappen naar een doelpad. | `Copy-Item -Path ".\app.log" -Destination "\\server\share\"` |
| `Move-Item` | `move`, `mv` | Verplaatst of hernoemt bestanden en mappen. | `Move-Item -Path "*.log" -Destination "C:\Archive\"` |
| `Get-ItemProperty` | `gp` | Haalt eigenschappen en metadata op van een bestand, map of registersleutel. | `Get-ItemProperty -Path "C:\Windows\System32\cmd.exe"` |
| `Get-FileHash` | *geen* | Berekent cryptografische hashwaarden (SHA256, MD5, SHA1) voor integriteits- en malwarechecks. | `Get-FileHash -Path ".\suspicious.exe" -Algorithm SHA256` |
| `Get-Item` (Streams) | *geen* | Toont Alternate Data Streams (ADS) op een NTFS-volume. | `Get-Item -Path "C:\Users\Public\*" -Stream *` |

---

## 2. Pipelining, Tekstfilteren en Objectverwerking

*PowerShell stuurt complete objecten door via de pipe, geen platte tekst.*

| Cmdlet | Alias | Beschrijving | Voorbeeld |
| :--- | :--- | :--- | :--- |
| `Where-Object` | `where`, `?` | Filtert objecten in de pipeline op basis van eigenschappen en operatoren (`-eq`, `-like`, `-match`). | `Get-Process \| Where-Object { $_.CPU -gt 10 }` |
| `Select-Object` | `select` | Selecteert specifieke properties van een object of berekent unieke rijen (`-Unique`). | `Get-Process \| Select-Object -Property Id, ProcessName, Path` |
| `Sort-Object` | `sort` | Sorteert pipeline-objecten op een of meerdere eigenschappen (`-Descending`). | `Get-Process \| Sort-Object -Property WS -Descending \| Select-Object -First 10` |
| `Measure-Object` | `measure` | Telt regels, woorden of berekent gemiddeldes, minima en maxima van numerieke velden. | `Get-ChildItem -File \| Measure-Object -Property Length -Sum` |
| `Select-String` | `sls` | Zoekt naar patronen of reguliere expressies in bestanden of tekststromen (PowerShell equivalent van `grep`). | `Select-String -Path "C:\Logs\*.log" -Pattern "Failed" -CaseSensitive:$false` |
| `ForEach-Object` | `foreach`, `%` | Voert een bewerking of scriptblock uit voor elk object in de pipeline. | `Get-Service \| ForEach-Object { $_.Name.ToUpper() }` |
| `Out-File` | *geen* | Schrijft object-uitvoer naar een bestand (vergelijkbaar met `>`, ondersteunt specifieke encoding). | `Get-Process \| Out-File -FilePath "C:\audit.txt" -Encoding utf8` |
| `Set-Clipboard` | `scb` | Kopieert pipeline-uitvoer rechtstreeks naar het Windows klembord. | `(Get-Process).Name \| Set-Clipboard` |
| `Export-Csv` | *geen* | Exporteert objectdata naar een gestructureerd CSV-bestand (`-NoTypeInformation`). | `Get-Service \| Export-Csv -Path ".\services.csv" -NoTypeInformation` |

---

## 3. Gebruikerscontext, Privileges en Sessies

| Cmdlet / Techniek | Beschrijving | Voorbeeld |
| :--- | :--- | :--- |
| `[Security.Principal.WindowsIdentity]::GetCurrent()` | Toont de actieve identiteit, het security-SID en de authenticatiemethode. | `[Security.Principal.WindowsIdentity]::GetCurrent().Name` |
| Admin Privileges Check | Controleert direct of de huidige PowerShell-sessie met administratorrechten draait. | `([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)` |
| `whoami /priv` | Toont actieve accountprivileges via Windows CLI context (zoals `SeDebugPrivilege`). | `whoami /priv` |
| `Get-LocalUser` | Toont een overzicht van alle lokale accounts op het systeem, inclusief status. | `Get-LocalUser \| Select-Object Name, Enabled, LastLogon, PasswordExpires` |
| `Get-LocalGroup` | Geeft alle lokale beveiligingsgroepen weer. | `Get-LocalGroup` |
| `Get-LocalGroupMember` | Toont welke gebruikers en groepen lid zijn van een specifieke lokale groep. | `Get-LocalGroupMember -Group "Administrators"` |
| `Disable-LocalUser` | Schakelt een verdacht of gecompromitteerd lokaal account onmiddellijk uit. | `Disable-LocalUser -Name "suspect_user"` |
| `Get-CimInstance Win32_LogonSession` | Geeft inzicht in alle actieve logon-sessies op het endpoint (interactief en netwerk). | `Get-CimInstance Win32_LogonSession \| Select-Object LogonId, StartTime, LogonType` |

---

## 4. Systeembeheer, Processen en Services

*Gebruik de moderne `*-CimInstance` cmdlets in plaats van de verouderde `*-WmiObject`.*

| Cmdlet | Alias | Beschrijving | Voorbeeld |
| :--- | :--- | :--- | :--- |
| `Get-Process` | `ps`, `gps` | Geeft alle actieve processen weer inclusief memory footprint en ID. | `Get-Process -Name "powershell"` |
| `Get-Process` (Path inspectie) | *geen* | Haalt de werkelijke binary path en bestandsversie op van draaiende processen. | `Get-Process \| Select-Object Id, ProcessName, Path, Company` |
| `Stop-Process` | `kill`, `spp` | Beëindigt processen geforceerd op basis van PID of naam (`-Force`). | `Stop-Process -Id 4321 -Force` |
| `Get-Service` | `gsv` | Geeft de status van alle Windows services weer (`Running`, `Stopped`). | `Get-Service \| Where-Object { $_.Status -eq "Running" }` |
| `Restart-Service` | *geen* | Herstart een specifieke service. | `Restart-Service -Name "wuauserv" -Force` |
| `Get-CimInstance Win32_Service` | *geen* | Haalt diepgaande service-eigenschappen op, zoals binary path en service account. | `Get-CimInstance Win32_Service \| Select-Object Name, State, StartMode, PathName, StartName` |
| `Get-ScheduledTask` | *geen* | Toont alle geregistreerde Scheduled Tasks op het systeem. | `Get-ScheduledTask \| Where-Object { $_.State -ne "Disabled" }` |
| `Get-ScheduledTaskInfo` | *geen* | Geeft informatie over de laatste uitvoering en de volgende geplande starttijd van een taak. | `Get-ScheduledTask -TaskName "DailyBackup" \| Get-ScheduledTaskInfo` |
| `Get-HotFix` | *geen* | Toont alle geïnstalleerde Windows updates en hotfixes met installatiedatum. | `Get-HotFix \| Sort-Object InstalledOn -Descending` |

---

## 5. SOC & Incident Response: Event Logs, Autostarts en Register

| Cmdlet | Beschrijving | Voorbeeld |
| :--- | :--- | :--- |
| `Get-WinEvent -FilterHashtable` | Zeer snelle methode om Windows Event Logs query-gestuurd uit te lezen op basis van LogName en EventID. | `Get-WinEvent -FilterHashtable @{LogName='Security'; Id=4625} -MaxEvents 10` |
| `Get-ItemProperty` (Registry Persistence) | Doorzoekt klassieke autorun-locaties in het Windows Register op verdachte scripts of binaries. | `Get-ItemProperty "HKLM:\Software\Microsoft\Windows\CurrentVersion\Run"` |
| `Get-ItemProperty` (Current User Run) | Inspecteert de autorun-sleutels van de actieve gebruiker. | `Get-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"` |
| `Get-WinEvent` (Tijdsbereik) | Filtert logs binnen een specifiek incident-tijdframe via StartTime en EndTime. | `Get-WinEvent -FilterHashtable @{LogName='System'; Level=2; StartTime=(Get-Date).AddHours(-4)}` |
| `Get-CimInstance Win32_StartupCommand` | Toont programma's en commando's die automatisch opstarten via register en startup mappen. | `Get-CimInstance Win32_StartupCommand \| Select-Object Name, Command, Location, User` |
| `Test-Path` | Controleert snel of een specifiek bestand, map of registersleutel fysiek bestaat. | `Test-Path -Path "C:\Windows\System32\drivers\etc\hosts"` |

---

## 6. Netwerkdiagnostiek, Luisterende Poorten en Sockets

| Cmdlet | Alias | Beschrijving | Voorbeeld |
| :--- | :--- | :--- | :--- |
| `Get-NetIPAddress` | *geen* | Toont alle geconfigureerde IPv4- en IPv6-adressen per interface. | `Get-NetIPAddress -AddressFamily IPv4` |
| `Get-NetIPConfiguration` | `gip` | Overzicht van IP-adressen, default gateways en DNS-servers (PowerShell variant van `ipconfig`). | `Get-NetIPConfiguration` |
| `Clear-DnsClientCache` | *geen* | Leegt de lokale DNS-resolvercache (equivalent van `ipconfig /flushdns`). | `Clear-DnsClientCache` |
| `Get-DnsClientCache` | *geen* | Inspecteert recent opgevraagde DNS records in de lokale resolvercache. | `Get-DnsClientCache \| Select-Object Entry, Data, TimeToLive` |
| `Test-NetConnection` | `tnc` | Test netwerkbereikbaarheid en controleert of een specifieke TCP-poort open staat. | `Test-NetConnection -ComputerName "1.1.1.1" -Port 53` |
| `Test-Connection` | *geen* | Verzendt ICMP echo-requests (`ping`) met gestructureerde output. | `Test-Connection -ComputerName "8.8.8.8" -Count 2 -Quiet` |
| `Get-NetTCPConnection` | *geen* | Toont alle actieve en luisterende TCP-verbindingen inclusief lokaal/extern IP, poort en OwningProcess (PID). | `Get-NetTCPConnection -State Listen` |
| `Get-NetUDPEndpoint` | *geen* | Geeft een overzicht van actieve UDP-sockets en het bijbehorende PID. | `Get-NetUDPEndpoint` |
| `Get-NetRoute` | *geen* | Drukt de actieve IP-routeringstabel af. | `Get-NetRoute -AddressFamily IPv4` |
| `Get-NetFirewallRule` | *geen* | Filtert en toont regels uit de Windows Defender Firewall. | `Get-NetFirewallRule -Enabled True -Direction Inbound` |

---

## 7. One-Liners voor SysAdmins & SOC Analisten

*   **Correlatie tussen open poorten, PID, procesnaam en het binaire pad:**
    Koppelt elke luisterende TCP-poort direct aan het uitvoerbare bestand:
    ```powershell
    Get-NetTCPConnection -State Listen | Select-Object LocalAddress, LocalPort, OwningProcess, @{Name="ProcessName";Expression={(Get-Process -Id $_.OwningProcess -ErrorAction SilentlyContinue).ProcessName}}, @{Name="Path";Expression={(Get-Process -Id $_.OwningProcess -ErrorAction SilentlyContinue).Path}} | Format-Table -AutoSize
    ```

*   **Snelle audit op mislukte inlogpogingen (Event ID 4625):**
    Haalt de laatste 10 mislukte inlogpogingen op met timestamp en event-details via XML-parsing:
    ```powershell
    Get-WinEvent -FilterHashtable @{LogName='Security'; Id=4625} -MaxEvents 10 | ForEach-Object { $xml = [xml]$_.ToXml(); [PSCustomObject]@{ TimeCreated =$_.TimeCreated; TargetUser = ($xml.Event.EventData.Data \vert{} Where-Object {$_.Name -eq 'TargetUserName' }).'#text'; Workstation = ($xml.Event.EventData.Data \vert{} Where-Object {$_.Name -eq 'WorkstationName' }).'#text'; SourceIP = ($xml.Event.EventData.Data \vert{} Where-Object {$_.Name -eq 'IpAddress' }).'#text' } } | Format-Table -AutoSize
    ```

*   **Controleren op Unquoted Service Paths (Privilege Escalation triage):**
    Vindt services waarvan het pad spaties bevat maar niet tussen aanhalingstekens staat, buiten `C:\Windows`:
    ```powershell
    Get-CimInstance Win32_Service | Where-Object { $_.PathName -notmatch '^"' -and $_.PathName -match ' ' -and$_.PathName -notmatch '^C:\\Windows\\' } | Select-Object Name, State, PathName | Format-List
    ```

*   **Opsporen van verdachte binaries in tijdelijke gebruikersmappen:**
    Doorzoekt recursief de `TEMP`-directory naar uitvoerbare bestanden en scripts (met correcte wildcard op het pad):
    ```powershell
    Get-ChildItem -Path "$env:TEMP\*" -Include *.exe, *.dll, *.bat, *.ps1, *.vbs -Recurse -File -ErrorAction SilentlyContinue | Select-Object FullName, Length, LastWriteTime
    ```

*   **Top 10 processen gesorteerd op RAM-gebruik (Working Set):**
    Geeft direct de zwaarste processen weer in megabytes:
    ```powershell
    Get-Process | Sort-Object -Property WS -Descending | Select-Object -First 10 ProcessName, Id, @{Name="RAM (MB)";Expression={[math]::Round($_.WS / 1MB, 2)}} | Format-Table -AutoSize
    ```

*   **Geheugen- en bestandshashcontrole van actieve processen:**
    Berekent on-the-fly de SHA256-hash van alle draaiende executables voor vergelijking met threat intel:
    ```powershell
    Get-Process | Where-Object { $_.Path } | ForEach-Object { [PSCustomObject]@{ ProcessName = $_.ProcessName; Id =$_.Id; Path = $_.Path; Hash = (Get-FileHash -Path$_.Path -Algorithm SHA256).Hash } } | Format-Table -AutoSize
    ```

*   **Universele subnet ping sweep (werkt op PowerShell 5.1 en 7+):**
    Scant een IP-reeks van 1 tot 254 via .NET Ping sockets met een snelle timeout van 150 ms per host:
    ```powershell
    1..254 | ForEach-Object { $ip = "192.168.1.$_"; $ping = New-Object System.Net.NetworkInformation.Ping; if ($ping.Send($ip, 150).Status -eq 'Success') { [PSCustomObject]@{ IPAddress =$ip; Status = "Online" } } } | Format-Table -AutoSize
    ```
