# Windows Command Prompt (CMD) Cheat Sheet - SysAdmin & SOC Analyst Edition

Een uitgebreide naslaggids met geteste en geverifieerde commando's voor Windows-systeembeheer, lokale triage, auditing, proces- en servicediagnostiek, loganalyse via `wevtutil`, en netwerkforensiek in een klassieke CMD-omgeving.

---

## 1. Navigatie en Bestandsbeheer

| Commando | Beschrijving | Voorbeeld |
| :--- | :--- | :--- |
| `cd` | Toont het huidige pad of wisselt van map (`/d` om tegelijk van schijfletter te wisselen). | `cd /d D:\Logs` |
| `dir` | Geeft een lijst weer van bestanden en submappen in de huidige directory. | `dir` |
| `dir /s` | Doorzoekt recursief de huidige map en alle onderliggende submappen. | `dir /s` |
| `dir /b` | Bare format: toont uitsluitend bestands- en mapnamen zonder headers of samenvatting. | `dir /b` |
| `dir /a` | Filtert op bestandskenmerken (`/a:h` voor verborgen, `/a:s` voor systeembestanden). | `dir /a:h C:\` |
| `dir /r` | Toont Alternate Data Streams (ADS) gekoppeld aan bestanden (vaak gebruikt om payloads te verstoppen). | `dir /r C:\Users\Public` |
| `tree [pad]` | Geeft de mappenstructuur grafisch weer als een boomdiagram (`/f` toont ook bestanden). | `tree C:\Project /f` |
| `mkdir` / `md` | Maakt een nieuwe map aan (inclusief ontbrekende tussenliggende mappen). | `mkdir "C:\Incident\Evidence"` |
| `rmdir` / `rd` | Verwijdert een map. Gebruik `/s /q` om recursief en stil te wissen. | `rmdir /s /q "C:\Temp\Oud"` |
| `copy` | Kopieert een of meer bestanden naar een opgegeven bestemming. | `copy alert.log \\fileserver\share\` |
| `move` | Verplaatst bestanden of mappen, of hernoemt ze ter plaatse. | `move *.log C:\Archive\` |
| `del` | Verwijdert bestanden (`/f` forceert verwijdering van read-only bestanden). | `del /f /q *.tmp` |
| `robocopy` | Robuuste bestandskopieer-tool voor back-ups en synchronisatie (`/mir` spiegelt mappen, `/sec` bewaart ACL's). | `robocopy C:\Src D:\Backup /mir /sec` |

---

## 2. Tekst Doorzoeken, Filteren en Pipelining

| Commando / Techniek | Beschrijving | Voorbeeld |
| :--- | :--- | :--- |
| `findstr "tekst" bestand` | Zoekt naar een letterlijke tekenreeks of expressie in een bestand. | `findstr /i "mimikatz" log.txt` |
| `findstr /s /i "term" *.*` | Zoekt recursief (`/s`) en hoofdletterongevoelig (`/i`) door alle bestanden in de boomstructuur. | `findstr /s /i "password" *.xml *.config` |
| `find /c "term"` | Telt het aantal regels waarin de opgegeven term voorkomt. | `find /c "EventID: 4625" security_dump.txt` |
| `find /v "term"` | Filtert regels omgekeerd: toont alle regels die de zoekterm **niet** bevatten. | `tasklist \| find /v "svchost.exe"` |
| Pipe (`\|`) | Stuurt de standaarduitvoer (stdout) van het linkse commando door naar de invoer (stdin) van het rechtse. | `dir /s /b \| findstr /i "apple" \| findstr /i ".txt"` |
| Redirect (`>` en `>>`) | `>` overschrijft het doelbestand; `>>` voegt toe aan het einde; `2>&1` vangt ook foutmeldingen op. | `systeminfo > sys_audit.txt 2>&1` |
| `clip` | Stuurt de output van een commando rechtstreeks naar het Windows-klembord. | `ipconfig /all \| clip` |

---

## 3. Gebruikerscontext, Rechten en Sessies

| Commando | Beschrijving | Voorbeeld |
| :--- | :--- | :--- |
| `whoami` | Toont de huidige aangemelde gebruiker en diens domein- of machinecontext. | `whoami` |
| `whoami /priv` | Toont alle actieve privileges van het account (zoals `SeDebugPrivilege` of `SeImpersonatePrivilege`). | `whoami /priv` |
| `whoami /groups` | Geeft alle beveiligingsgroepen weer waar het account lid van is (handig voor privilege checks). | `whoami /groups` |
| `net user` | Toont alle lokale accounts op het systeem. | `net user` |
| `net user [naam]` | Geeft accountdetails: wachtwoordverloop, accountstatus, laatste logon en groepen. | `net user Administrator` |
| `net localgroup` | Geeft een overzicht van alle lokale groepen (`Administrators`, `Remote Desktop Users`). | `net localgroup Administrators` |
| `net accounts` | Toont het lokale wachtwoordbeleid, lockout-drempels en minimale wachtwoordlengte. | `net accounts` |
| `net session` | Toont actieve inkomende SMB-sessies (vereist Administrator-rechten; toont wie verbonden is). | `net session` |
| `query user` / `quser` | Toont alle aangemelde gebruikerssessies (lokaal en via RDP), sessie-ID's en idle-tijd. | `quser` |
| `runas /user:[account] cmd` | Start een proces onder een ander accountprofiel (vergelijkbaar met `su` op Linux). | `runas /user:DOMAIN\Admin "cmd.exe"` |

---

## 4. Systeembeheer, Processen en Services

*Voer de Command Prompt uit als Administrator voor commando's die verhoogde rechten vereisen.*

| Commando | Beschrijving | Voorbeeld |
| :--- | :--- | :--- |
| `systeminfo` | Uitgebreide systeemconfiguratie (OS-versie, BIOS, hotfixes, netwerkadapters, RAM). | `systeminfo` |
| `tasklist /v` | Toont alle draaiende processen met hun actieve gebruiker/context en sessietype. | `tasklist /v` |
| `tasklist /svc` | Koppelt elk proces-ID (PID) aan de specifieke Windows-services die erin draaien. | `tasklist /svc` |
| `tasklist /m` | Toont welke DLL-bestanden door een specifiek proces geladen zijn (DLL-injectie triage). | `tasklist /m ntdll.dll` |
| `taskkill /f /pid [PID]` | Beëindigt een proces geforceerd op basis van PID (`/t` sluit ook kindprocessen af). | `taskkill /f /t /pid 4321` |
| `sc query type= service state= all` | Geeft de status van alle Windows-services weer (zonder driver-overhead; spatie na `=` is verplicht). | `sc query type= service state= all` |
| `sc qc [servicename]` | Toont de binaire paden (`BINARY_PATH_NAME`) en opstartconfiguratie van een service. | `sc qc Spooler` |
| `sc stop` / `sc start` | Stopt of start een specifieke Windows-service. | `sc stop Spooler` |
| `schtasks /query /fo TABLE` | Toont alle geplande taken (Scheduled Tasks) in tabelvorm (`/v` toont het uitvoerbare pad). | `schtasks /query /fo TABLE /v` |
| `sfc /scannow` | Scant en herstelt corrupte Windows-systeembestanden. | `sfc /scannow` |
| `chkdsk C: /f` | Controleert en herstelt bestandsfouten op de C-schijf. | `chkdsk C: /f` |
| `driverquery /v` | Genereert een gedetailleerde lijst van alle geïnstalleerde stuurprogramma's en hun paden. | `driverquery /v /fo table` |
| `doskey /history` | Geeft de commandogeschiedenis weer van de huidige actieve sessie (sneltoets: F7). | `doskey /history` |

---

## 5. SOC & Forensisch: Event Logs, Autostarts en Triage

| Commando / Tool | Beschrijving | Voorbeeld |
| :--- | :--- | :--- |
| `wevtutil el` | Toont alle beschikbare Event Log providers op het systeem. | `wevtutil el \| findstr /i "sysmon"` |
| `wevtutil qe` | Doorzoekt event logs direct via de commandline (`/c` limiteert aantal, `/rd:true` start bij nieuwste). | `wevtutil qe Security /c:10 /rd:true /f:text` |
| `reg query` | Leest sleutels en waarden direct uit het Windows Register (cruciaal voor autoruns en persistence). | `reg query HKLM\Software\Microsoft\Windows\CurrentVersion\Run` |
| `certutil -hashfile` | Berekent cryptografische hashes (MD5, SHA1, SHA256) van verdachte bestanden voor threat intel checks. | `certutil -hashfile suspicious.exe SHA256` |
| `fltmc` | Toont actieve minifilter drivers (zoals antivirus-, EDR- en back-up filters). | `fltmc` |
| `auditpol /get /category:*` | Toont het actieve auditbeleid voor gebeurtenissen zoals accountlogins en objecttoegang. | `auditpol /get /category:*` |

---

## 6. Netwerkdiagnostiek, Luisterende Poorten en Firewall

| Commando | Beschrijving | Voorbeeld |
| :--- | :--- | :--- |
| `ipconfig /all` | Toont de volledige configuratie van alle netwerkadapters (IP, MAC, Gateway, DHCP, DNS). | `ipconfig /all` |
| `ipconfig /displaydns` | Toont de lokale DNS-resolver cache (onthult recent bezochte of aangeroepen domeinen). | `ipconfig /displaydns` |
| `ipconfig /flushdns` | Leegt de DNS-cache van de client. | `ipconfig /flushdns` |
| `arp -a` | Toont de lokale ARP-tabel met IP-naar-MAC toewijzingen (nuttig voor het opsporen van ARP spoofing). | `arp -a` |
| `netstat -ano` | Toont actieve netwerkverbindingen, open poorten en het bijbehorende Proces-ID (PID). | `netstat -ano` |
| `netstat -anob` | Toont actieve verbindingen inclusief de uitvoerbare binary die de socket opent (vereist Administrator). | `netstat -anob` |
| `route print` | Drukt de routeringstabel af (handig om ongewenste proxy-routes of VPN-leaks te vinden). | `route print` |
| `netsh advfirewall show allprofiles` | Toont de actieve configuratie en status van de Windows Defender Firewall. | `netsh advfirewall show allprofiles` |
| `netsh advfirewall firewall show rule` | Geeft regels weer van de firewall (`name=all` toont alles, kan gefilterd worden). | `netsh advfirewall firewall show rule name=all \| findstr /i "rule name"` |
| `tracert [host]` | Brengt tussenliggende hops en latentie naar het doelnetwerk in kaart. | `tracert 1.1.1.1` |
| `nslookup [host]` | Voert directe DNS-query's uit tegen geconfigureerde of specifieke DNS-servers. | `nslookup -type=TXT example.com 8.8.8.8` |

---

## 7. Handige One-Liners voor SysAdmins & SOC Analisten (CMD)

*   **Audit op mislukte inlogpogingen (Event ID 4625 - Brute Force triage):**
    Leest de nieuwste 5 mislukte aanmeldingen uit het Security Event Log:
    ```cmd
    wevtutil qe Security "/q:*[System[(EventID=4625)]]" /c:5 /rd:true /f:text
    ```

*   **Correlatie tussen luisterende poort, proces-ID en executable naam:**
    Vindt het PID dat luistert op poort 445 en koppelt dit direct aan het bijbehorende proces:
    ```cmd
    for /f "tokens=5" %a in ('netstat -ano ^| findstr :445 ^| findstr LISTENING') do @tasklist /fi "PID eq %a"
    ```

*   **Detecteren van verdachte uitvoerbare bestanden in tijdelijke gebruikersmappen:**
    Doorzoekt de gebruikers-tempmap betrouwbaar per extensie met een loop:
    ```cmd
    for %e in (exe bat vbs ps1) do @dir /s /b "%TEMP%\*.%e" 2>nul
    ```

*   **Snelle controle op veelgebruikte Run-sleutels in het register (Persistence check):**
    Toont autorun-sleutels voor zowel de lokale machine als het huidige gebruikersprofiel:
    ```cmd
    reg query HKLM\Software\Microsoft\Windows\CurrentVersion\Run & reg query HKCU\Software\Microsoft\Windows\CurrentVersion\Run
    ```

*   **Ping sweep over een lokaal /24 subnet:**
    Scant een IP-reeks (`192.168.1.1` tot `192.168.1.254`) met een veilige timeout van 100 ms en toont responsieve hosts:
    ```cmd
    for /L %a in (1,1,254) do @ping -n 1 -w 100 192.168.1.%a >nul && echo 192.168.1.%a is online
    ```

*   **Controleren op ongeciteerde servicespaden (Unquoted Service Path privilege escalation):**
    Zoekt via de ingebouwde query-tool naar services met spaties in het pad die niet geciteerd zijn:
    ```cmd
    powershell -NoProfile -Command "Get-CimInstance Win32_Service | Where-Object { $_.PathName -notmatch '^\"' -and $_.PathName -match ' ' -and$_.PathName -notmatch '^C:\\Windows\\' } | Select-Object Name, PathName"
    ```
