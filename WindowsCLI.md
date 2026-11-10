# Windows Command Prompt (CMD) Cheat Sheet

Een overzichtelijke naslaggids met veelgebruikte commando's voor bestandsbeheer, tekstverwerking, systeembeheer en netwerkdiagnostiek in de klassieke Windows Command Prompt.

---

## 1. Navigatie en Bestandsbeheer

| Commando | Beschrijving | Voorbeeld |
| :--- | :--- | :--- |
| `cd` | Toont het huidige pad of wisselt van map (`/d` om tegelijk van schijfletter te wisselen). | `cd /d D:\Logs` |
| `dir` | Geeft een lijst weer van bestanden en submappen in de huidige directory. | `dir` |
| `dir /s` | Doorzoekt recursief de huidige map en alle onderliggende submappen. | `dir /s` |
| `dir /b` | Bare format: toont uitsluitend bestands- en mapnamen zonder headers of samenvatting. | `dir /b` |
| `dir /a` | Filtert op bestandskenmerken (`/a:h` voor verborgen, `/a:d` voor enkel mappen). | `dir /a:h` |
| `tree [pad]` | Geeft de mappenstructuur grafisch weer als een boomdiagram (`/f` toont ook bestanden). | `tree C:\Project /f` |
| `mkdir` of `md` | Maakt een nieuwe map aan (inclusief ontbrekende tussenliggende mappen). | `mkdir "Nieuwe Map\Submap"` |
| `rmdir` of `rd` | Verwijdert een lege map. Gebruik `/s /q` om recursief en stil te wissen. | `rmdir /s /q "Oude Map"` |
| `copy` | Kopieert een of meer bestanden naar een opgegeven bestemming. | `copy file.txt backup\` |
| `move` | Verplaatst bestanden of mappen, of hernoemt ze ter plaatse. | `move *.log archive\` |
| `del` | Verwijdert bestanden (`rm` is een PowerShell-alias). Gebruik `/f` voor read-only bestanden. | `del /f /q *.tmp` |
| `robocopy` | Geavanceerde bestandskopieer-tool voor back-ups en synchronisatie (`/mir` spiegelt mappen). | `robocopy C:\Bron D:\Doel /mir` |

---

## 2. Tekst Doorzoeken, Filteren en Pipelining

| Commando / Techniek | Beschrijving | Voorbeeld |
| :--- | :--- | :--- |
| `findstr "tekst" bestand` | Zoekt naar een letterlijke tekenreeks of reguliere expressie in een bestand. | `findstr "ERROR" app.log` |
| `findstr /s /i "term" *.*` | Zoekt recursief (`/s`) en hoofdletterongevoelig (`/i`) door alle bestanden in de structuur. | `findstr /s /i "password" *.conf` |
| `find /c "term"` | Telt het exacte aantal regels waarin de opgegeven term voorkomt. | `find /c "404" access.log` |
| `find /v "term"` | Filtert regels omgekeerd: toont alleen regels die de zoekterm **niet** bevatten. | `tasklist \| find /v "svchost"` |
| Pipe (`\|`) | Stuurt de standaarduitvoer (stdout) van het linkse commando door naar de invoer (stdin) van het rechtse commando. | `dir /s /b \| findstr /i "apple" \| findstr "\.txt$"` |
| Redirect (`>` en `>>`) | `>` overschrijft het doelbestand met de uitvoer; `>>` voegt de uitvoer toe aan het einde van het bestand. | `systeminfo > sys_audit.txt` |
| `clip` | Stuurt de output van een commando rechtstreeks naar het Windows klembord. | `dir /b \| clip` |

---

## 3. Systeembeheer en Processen

*Opmerking: voer de Command Prompt uit als Administrator voor opdrachten die verhoogde rechten vereisen.*

| Commando | Beschrijving | Voorbeeld |
| :--- | :--- | :--- |
| `systeminfo` | Geeft uitgebreide hardware- en OS-configuratie weer (hotfixes, RAM, BIOS, netwerkadapters). | `systeminfo` |
| `tasklist` | Toont alle actieve processen met Process ID (PID) en geheugengebruik. | `tasklist /svc` |
| `taskkill` | Beëindigt een proces via ID (`/pid`) of naam (`/im`). Voeg `/f` toe om forceren af te dwingen. | `taskkill /f /im notepad.exe` |
| `sc query` | Geeft de status van actieve services en apparaatstuurprogramma's weer. | `sc query state= all \| more` |
| `sc stop` / `sc start` | Stopt of start een specifieke Windows-service. | `sc stop wuauserv` |
| `sfc /scannow` | System File Checker: scant de integriteit van Windows-systeembestanden en herstelt beschadigingen. | `sfc /scannow` |
| `chkdsk` | Controleert een volume op bestandsfouten en slechte sectoren (`/f` repareert fouten direct). | `chkdsk C: /f` |
| `driverquery` | Genereert een tabel van alle geïnstalleerde stuurprogramma's. | `driverquery /fo table` |
| `date /t` & `time /t` | Toont de huidige systeemdatum en systeemtijd zonder prompt tot aanpassing. | `echo %date% %time%` |
| `doskey /history` | Geeft de geschiedenis weer van alle ingevoerde opdrachten in de huidige sessie (sneltoets: F7). | `doskey /history` |

---

## 4. Gebruikers- en Toegangsbeheer (`net` & context)

| Commando | Beschrijving | Voorbeeld |
| :--- | :--- | :--- |
| `net user` | Toont een lijst van alle lokale gebruikersaccounts. | `net user` |
| `net user [naam]` | Geeft gedetailleerde eigenschappen van een account (wachtwoordverloop, groepen, logontijden). | `net user Administrator` |
| `net localgroup` | Geeft een overzicht van alle lokale beveiligingsgroepen. | `net localgroup Administrators` |
| `net accounts` | Toont het lokale wachtwoordbeleid en accountvergrendelingsinstellingen. | `net accounts` |
| `net share` | Geeft actieve gedeelde netwerkmappen en printershares weer. | `net share` |
| `net help [commando]` | Opent de ingebouwde syntaxishulp voor specifieke `net`-opdrachten. | `net help user` |
| `whoami` | Toont de huidige gebruikersnaam en domeincontext (`/priv` toont de actieve privileges). | `whoami /priv` |

---

## 5. Netwerkdiagnostiek

| Commando | Beschrijving | Voorbeeld |
| :--- | :--- | :--- |
| `ipconfig /all` | Toont de volledige TCP/IP-configuratie van alle adapters (IP, subnet, gateway, DNS, MAC-adres). | `ipconfig /all` |
| `ipconfig /flushdns` | Leegt de lokale DNS-resolvercache om verouderde domeinverwijzingen te verwijderen. | `ipconfig /flushdns` |
| `ping [adres]` | Verzendt ICMP echo-requests om bereikbaarheid en latentie te testen (`-n` aantal, `-t` continu). | `ping -n 4 8.8.8.8` |
| `tracert [host]` | Brengt de router-hops en vertraging naar een bestemming in kaart via TTL-verhoging. | `tracert 1.1.1.1` |
| `nslookup [host]` | Vraagt DNS-records op bij de geconfigureerde of opgegeven DNS-server. | `nslookup www.google.com` |
| `netstat -ant` | Toont actieve netwerkverbindingen, listening poorten (numeriek) en TCP/UDP-statussen. | `netstat -ant` |
| `netstat -ano` | Toont poorten inclusief het proces-ID (PID) dat eigenaar is van de socket. | `netstat -ano \| findstr :80` |
| `route print` | Drukt de lokale IP-routeringstabel en persistente routes af. | `route print` |

---

## 6. Handige One-Liners en Automatisering

*   **Ping sweep over een lokaal /24 subnet:**
    Scant een IP-reeks (bijvoorbeeld `192.168.1.1` tot `192.168.1.254`) met een timeout van 10 ms en toont direct welke hosts reageren:
    ```cmd
    for /L %a in (1,1,254) do @ping -n 1 -w 10 192.168.1.%a >nul && echo 192.168.1.%a is online
    ```

*   **Zoeken naar luisterende poorten en het bijbehorende proces:**
    Vindt het proces-ID dat luistert op poort 8080:
    ```cmd
    netstat -ano | findstr :8080
    ```
    Koppel vervolgens het gevonden PID (bijvoorbeeld `4321`) aan het proces:
    ```cmd
    tasklist /fi "PID eq 4321"
    ```

*   **Recursief specifieke logbestanden opschonen:**
    Verwijdert stil alle `.tmp` en `.log` bestanden binnen een mapstructuur:
    ```cmd
    for /r "C:\Logs" %i in (*.tmp, *.log) do @del /f /q "%i"
    ```
