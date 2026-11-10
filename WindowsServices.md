# Windows Services: Beheer, Triage & Unquoted Service Paths

Een uitgebreide samenvatting van Windows Services op basis van het labmateriaal, aangevuld met diepgaande achtergrond over Service Architecture, Service Accounts, Privilege Escalation (Unquoted Service Paths) en vergelijkingen tussen GUI, CLI, WMIC en moderne PowerShell/CIM methodes.

---

## 1. Introductie & Windows Service Architectuur

Windows Services zijn programma's die op de achtergrond draaien zonder dat een interactieve gebruikerssessie vereist is. Ze starten doorgaans op wanneer het besturingssysteem boot en blijven actief ongeacht wie zich aan- of afmeldt.

Het centrale beheerorgaan voor services is de **Service Control Manager (SCM)**, die als een RPC-server draait binnen het proces `services.exe`.

### Belangrijke Service-eigenschappen

* **Service Name:** De unieke interne sleutelnaam van de service (bijvoorbeeld `BITS`). Deze naam wordt gebruikt in het register, bij command-line tools (`sc`, `Get-Service`) en script-automatisering.
* **Display Name:** De gebruiksvriendelijke weergavenaam in de GUI (bijvoorbeeld `Background Intelligent Transfer Service`).
* **Description:** Een samenvatting van het functionele doel van de service binnen het besturingssysteem.
* **Path to Executable (`ImagePath`):** Het absolute pad naar de binary, inclusief eventuele commandline-argumenten of parameters waarmee de service wordt aangeroepen.
* **Process ID (PID):** Het proces-ID waarmee de service momenteel in het geheugen actief is. Alleen actieve (`Running`) services hebben een PID.
* **Startup Type:**
  * **Automatic:** De service start automatisch tijdens het bootproces.
  * **Automatic (Delayed Start):** Start kort nadat het bootproces voltooid is. Dit verlaagt de belasting op de CPU en schijf tijdens de initiële systeemstart.
  * **Trigger Start:** De service start pas wanneer zich een specifieke systeemgebeurtenis voordoet (bijvoorbeeld een apparaat dat wordt aangesloten of een netwerkpoort die wordt geopend).
  * **Manual:** Start uitsluitend wanneer een gebruiker, script of afhankelijke applicatie hier expliciet om vraagt.
  * **Disabled:** De service kan onder geen beding starten zolang deze status behouden blijft.

---

## 2. Service Accounts & Privileges

In het tabblad **Log On** van de SCM of via de configuratie-eigenschap `StartName` wordt bepaald onder welke beveiligingscontext de service draait:

* **LocalSystem (`NT AUTHORITY\SYSTEM`):**
  Het meest krachtige account op een Windows-machine. Heeft volledige toegang tot alle lokale bronnen, registerinstellingen en het bestandssysteem, en presenteert zich op het netwerk als het computeraccount van de machine (`DOMAIN\MACHINE$`). Misbruik van een service die als LocalSystem draait leidt direct tot een volledige compromittering van de lokale host.
* **Local Service (`NT AUTHORITY\LOCAL SERVICE`):**
  Een account met minimale lokale rechten (vergelijkbaar met een standaard niet-bevoorrechte gebruiker) dat anoniem toegang zoekt tot netwerkbronnen.
* **Network Service (`NT AUTHORITY\NETWORK SERVICE`):**
  Heeft minimale lokale rechten zoals Local Service, maar authenticeert zich op het domein/netwerk met de computercredentials (`DOMAIN\MACHINE$`).
* **Custom User / Service Account:**
  Een specifiek lokaal of domeinaccount. Het principe van *Least Privilege* dicteert dat services bij voorkeur draaien onder een dedicated account dat uitsluitend rechten heeft op de mappen en registersleutels die strikt noodzakelijk zijn.

---

## 3. Beheer via GUI: Service Control Manager (`services.msc`)

De grafische interface van de SCM is te openen via de zoekbalk of door het uitvoeren van `services.msc`.

### Tabbladen in de Service Eigenschappen

1. **General:**
   * Toont Service Name, Display Name en Description.
   * Toont het uitvoerbare pad (`Path to executable`).
   * Biedt knoppen om de actuele toestand te beheren: *Start*, *Stop*, *Pause*, *Resume*.
   * Bevat een veld voor handmatige *Startup parameters*.
2. **Log On:**
   * Configuratie van het service-account (Local System versus specifiek gebruikersaccount).
   * Schakelaar *Allow service to interact with desktop* (grotendeels uitgeschakeld om security-redenen).
3. **Recovery:**
   * Bepaalt welke acties Windows onderneemt wanneer een service onverwacht crasht:
     * *First failure*, *Second failure*, *Subsequent failures*.
     * Mogelijke acties: *Take No Action*, *Restart the Service*, *Run a Program*, *Restart the Computer*.
   * Bevat tellers voor het resetten van de foutstatus na een ingesteld aantal dagen.
4. **Dependencies:**
   * Biedt een overzicht van de systeemcomponenten en andere services die vereist zijn om deze specifieke service te starten (*This service depends on the following system components*).
   * Toont tevens welke andere services stoppen als deze service wordt uitgeschakeld (*The following system components depend on this service*).
   * Essentieel bij root-cause analyses van gestopte services.

### Beheer op afstand
In het linkernavigatiedeel kan via een rechtermuisklik op **Services (Local)** gekozen worden voor **Connect to another computer**. Mits er beheerpermissies en RPC/SMB-netwerktoegang zijn, kan de beheerder hiermee services op een extern doelsysteem live auditen en beheren.

---

## 4. Beheer via Opdrachtregel & PowerShell

### PowerShell: `Get-Service`
Standaard toont `Get-Service` de kolommen `Status`, `Name` en `DisplayName`.

<pre>
# Alle services weergeven
Get-Service

# Filteren op uitsluitend actieve services
Get-Service | Where-Object Status -EQ "Running"

# Filteren op gestopte of gepauzeerde services
Get-Service | Where-Object Status -NE "Running"

# Alle beschikbare objecteigenschappen in tabelvorm bekijken
Get-Service | Select-Object -Property * | Format-Table

# Starten en stoppen van een service
Stop-Service -Name "MyService"
Start-Service -Name "MyService"
</pre>

*Beperking van `Get-Service`:* Standaard bevat het object dat door `Get-Service` wordt geretourneerd in Windows PowerShell 5.1 niet direct het binaire bestandspad (`PathName`).

---

### Command-line inspectie: WMIC (Legacy)
In het lab wordt WMIC gebruikt om het pad (`PathName`) en gerelateerde procesinformatie te achterhalen.

<pre>
# Alle service-eigenschappen gepagineerd doorbladeren
wmic service | more

# Service name combineren met het executable pad
wmic service get name,pathname

# Filteren op actieve/niet-actieve services
wmic service where Started=True get name,pathname
wmic service where Started=False get name,pathname

# Uitgebreide triage inclusief PID
wmic service get name,displayname,started,processid,pathname
</pre>

---

### Moderne PowerShell methode: `Get-CimInstance`
Aangezien WMIC officieel verouderd is, is de moderne en toekomstvaste manier om binaire paden en service-eigenschappen op te vragen via de WMI/CIM-provider in PowerShell:

<pre>
# Ophalen van servicenaam, status, startmodus en executable pad
Get-CimInstance Win32_Service | Select-Object Name, State, StartMode, PathName, ProcessId

# Filteren op services die actief zijn en buiten C:\Windows liggen
Get-CimInstance Win32_Service | Where-Object { $_.State -eq "Running" -and $_.PathName -notmatch "^C:\\Windows" } | Select-Object Name, PathName, ProcessId
</pre>

---

## 5. Vulnerability Deep Dive: Unquoted Service Paths

Een **Unquoted Service Path** is een kwetsbaarheid waarbij het pad naar de executable van een service spaties bevat, maar niet tussen aanhalingstekens (`" "`) staat in de configuratie.

### Hoe het besturingssysteem paden interpreteert
Wanneer Windows een service aanroept, probeert de subsystem-parser het pad te ontleden. Als er geen aanhalingstekens om het pad staan, splitst de parser het pad bij **elke spatie** en interpreteert het linkerdeel als een executable en het rechterdeel als argumenten.

Stel dat een service als volgt is geconfigureerd:
<pre>
C:\Program Files\my service\WindowsService1.exe
</pre>

Windows zoekt tijdens het starten van de service achtereenvolgens naar de volgende bestanden op de schijf:

1. `C:\Program.exe` (met argument: `Files\my service\WindowsService1.exe`)
2. `C:\Program Files\my.exe` (met argument: `service\WindowsService1.exe`)
3. `C:\Program Files\my service\WindowsService1.exe` (het beoogde bestand)

### Exploitation Scenario (Local Privilege Escalation)
Indien een kwaadwillende gebruiker schrijfrechten heeft op de root van de systeemschijf (`C:\`) of in de map `C:\Program Files\`:

1. De aanvaller plaatst een kwaadaardige binary met de naam `C:\Program.exe`.
2. Zodra de service herstart (of het systeem herstart), start Windows `C:\Program.exe` in plaats van de legitieme applicatie.
3. Omdat services veelal draaien onder `LocalSystem`, wordt de code van de aanvaller direct uitgevoerd met de hoogste privileges op het systeem.

---

## 6. Lab Walkthrough: Reproduceren & Exploiteren

### Stap 1: Controleren op kwetsbare services via CMD / WMIC
In een command prompt (`cmd.exe`) wordt gezocht naar kwetsbare auto-start services:

<pre>
wmic service get name,pathname,startmode | findstr /i "auto" | findstr /i /v "c:\windows\\" | findstr /i /v \"
</pre>

*Analyse van de filters:*
* `findstr /i "auto"`: Selecteert alleen services die automatisch starten bij boot.
* `findstr /i /v "c:\windows\\"`: Filtert de standaard Windows-systeemmappen weg (deze zijn doorgaans niet schrijfbaar voor gewone gebruikers).
* `findstr /i /v \"`: Filtert regels weg die al netjes omsloten zijn door aanhalingstekens.

*Modern PowerShell equivalent:*
<pre>
Get-CimInstance Win32_Service | Where-Object { $_.StartMode -eq "Auto" -and $_.PathName -notmatch '^"' -and $_.PathName -match ' ' -and $_.PathName -notmatch '^C:\\Windows\\' } | Select-Object Name, PathName, StartMode
</pre>

---

### Stap 2: Het aanmaken van een kwetsbare service
Vanuit PowerShell (Admin) wordt een custom service geconfigureerd:

<pre>
# Wisselen naar de Desktop
Set-Location -Path "C:\Users\cybrary\Desktop"

# Een mapstructuur met spaties aanmaken
New-Item -Path "C:\Program Files\my service" -ItemType Directory -Force

# De originele binary kopiëren
Copy-Item -Path ".\WindowsService1.exe" -Destination "C:\Program Files\my service\"

# De service aanmaken
New-Service -Name "MyService" -BinaryPathName "C:\Program Files\my service\WindowsService1.exe"
</pre>

*Belangrijk detail:* Hoewel de parameter `-BinaryPathName` in PowerShell tussen quotes wordt gezet om de spatie in de commandline te verwerken, slaat Windows de string in het register **zonder** quotes op:
`C:\Program Files\my service\WindowsService1.exe`.

---

### Stap 3: Verifiëren van de initiële uitvoering
Start de service en inspecteer het Application Log in de Event Viewer (`eventvwr.msc`):

<pre>
# Starten van de service
Start-Service -Name "MyService"

# Controleren van de status
Get-Service -Name "MyService"
</pre>

In de Event Viewer onder **Windows Logs > Application** verschijnen gebeurtenissen met:
* **Event ID:** `0`
* **Source:** `SimpleService`
* **Message:** De reguliere notificatie afkomstig van `WindowsService1.exe`.

---

### Stap 4: De exploitatie uitvoeren
De aanvaller misbruikt de eerste spatie na `C:\Program`:

<pre>
# Kopieer de kwaadaardige service binary naar de root als Program.exe
Copy-Item -Path ".\EvilWindowsService.exe" -Destination "C:\Program.exe"

# Herstart de service
Stop-Service -Name "MyService"
Start-Service -Name "MyService"
</pre>

Wanneer `Start-Service` wordt aangeroepen, detecteert Windows het bestand `C:\Program.exe` en voert dit uit met de rechten van de service.

Bij een refresh in de Event Viewer tonen de nieuwe logregels met Event ID `0` en Source `SimpleService` nu het afwijkende bericht dat afkomstig is van `EvilWindowsService.exe`.

---

## 7. Remediation & Hardening

Om Unquoted Service Paths structureel te verhelpen, moet het pad in het Windows Register worden geciteerd.

### Registersleutel locatie
Alle services bevinden zich in het register onder:
<pre>
HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\&lt;ServiceName&gt;
</pre>

### Handmatig herstellen via Regedit
1. Open `regedit.exe`.
2. Navigeer naar `HKLM\SYSTEM\CurrentControlSet\Services\MyService`.
3. Zoek de waarde `ImagePath` (van het type `REG_EXPAND_SZ`).
4. Pas de waarde aan door expliciet aanhalingstekens toe te voegen:
<pre>
"C:\Program Files\my service\WindowsService1.exe"
</pre>

### Geautomatiseerd herstellen via PowerShell
<pre>
# Het registerpad definiëren
$RegPath = "HKLM:\SYSTEM\CurrentControlSet\Services\MyService"

# De gecorrigeerde waarde met quotes instellen
Set-ItemProperty -Path $RegPath -Name "ImagePath" -Value '"C:\Program Files\my service\WindowsService1.exe"'
</pre>

### Aanvullende mitigerende maatregelen
* **Strikte NTFS-permissies:** Zorg dat reguliere gebruikers geen schrijfrechten hebben op de root van de systeemschijf (`C:\`) of in directory-paden waar applicaties worden geïnstalleerd.
* **Service Account Hardening:** Laat services niet standaard draaien onder `LocalSystem` tenzij dit strikt noodzakelijk is. Maak gebruik van Group Managed Service Accounts (gMSA) of virtuele service accounts met beperkte privileges.
