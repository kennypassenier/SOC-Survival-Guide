# Work in progress

## Openstaande hoofdstukken
- IDS Basics
- Vulnerability Scanner Basics
- Patching Basics
- PowerShell Basics
- BASH Scripting Basics
- Python Basics
- Firewall Basics (opnieuw)

## IDS Basics 
### Commands used
Snort
```bash
sudo snort <--- Standaard draait dit Snort in sniffer modus.
sudo snort -T -c /etc/snort/snort.conf <--- -T betekent test en -c verwijst naar een configuratiebestand. Dit commando wordt gebruikt om het configuratiebestand te valideren. 
sudo snort -c /etc/snort/snort.conf <--- Draait snort in intrusion detection mode.
sudo snort -c /etc/snort/snort.conf -r sample.pcap <--- analyseert een packet capture file.
sudo snort -q -A console -c /etc/snort/snort.conf -r sample.pcap <--- -q is voor stille modus (geen startup bericht) -A console zegt Snort om ons alerts te tonen wanneer die gebeuren.
sudo snort -q -A console -c /etc/snort/snort.conf -r pcaps/apple.pcap <--- Andere packet capture file.
sudo snort -q -A console -c /etc/snort/snort.conf -r pcaps/apple.pcap | grep ICMP | grep PING <--- filter op ICMP paketten.
sudo snort -c /etc/snort/snort.conf -r sample.pcap -l /home/cybrary/Desktop <--- -l staat voor logging en stuurt alle info die normaal in de console komt naar een logfile.

sudo nano /etc/snort/rules/local.rules <--- Open het rules bestand met nano om zelf regels toe te voegen aan Snort
sudo snort -q -A console -c /etc/snort/rules/local.rules -i [interface] <--- -i vertelt welke interface er gebruikt moet worden om op te luisteren. We zetten specifiek local.rules omdat hij anders ALLE .rules bestanden uit die directory zou gebruiken.
wget http://[ip] <--- get request naar de http server met dit IP.
```
U2spewfoo
```bash
sudo u2spewfoo snort.log <--- Sinds de .log files van Snort in "unified2" formaat zijn, gebruiken we deze tool om de log bestanden uit te lezen.
```
```powershell
ipconfig <--- 10.111.2.29 wordt gebruikt op onze Windows VM.
netstat -ant | Select-String "listening" <--- Toont alle open poorten op de Windows machine.
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False <--- Zet de Windows Defender Firewall uit.
```

## Patching Basics
### Windows
```powershell
Install-Module -Name PSWindowsUpdate -Force <--- installeert de Windows Update PowerShell module.
Get-WindowsUpdate -IsInstalled <--- toont al de momenteel geinstalleerde updates.
Get-WindowsUpsdate
Get-WindowsUpdate -AcceptAll -Install -AutoReboot <--- Alle KB's installeren zonder user tussenkomst.
Get-WindowsUpdate -Install -[KBArticleID]
$HideList = "[KBArticleID] <--- article ID in een variabele steken.
Get-WindowsUpdate -KBArticleID $HideList -Hide  <--- Die variabele gebruiken om het juiste ID door te geven aan het commando.

```

### Linux
```bash
sudo apt update 
sudo apt list --upgradable | more
sudo apt -s upgrade <--- gesimuleerde upgrade.
sudo apt -s upgrade > simulated_upgrade.txt
sudo apt update && sudo apt upgrade
sudo apt install --only-upgrade [package1] [package2]
sudo apt-mark hold ufw <-- stopt apt om het pakket "ufw" te upgraden.
sudo apt-mark showhold <-- toont alle paketten die on-hold zijn.
sudo apt-mark unhold ufw <-- Haalt het pakket "ufw" weer van de lijst met paketten die on-hold zijn.

```

### Docker
```bash
sudo docker ps
sudo docker inspect mysql | grep MYSQL_VERSION
sudo docker stop mysql
sudo docker rm mysql
sudo docker pull mysql
sudo docker images
sudo docker run --name=mysql --restart=always -e MYSQL_ROOT_PASSWORD=cybrary -v /home/cybrary/mysql:/var/lib/mysql -d mysql
```

## PowerShell Basics
### Commands
```PowerShell
$hello = "Hello World"
$hello.Length
$hello.GetType()
$hello.Contains("Hello")
$a | Get-Member
$a | Get-Member | Measure-Object
$a | Get-Member | Measure-Object | Select-Object Count
Get-Command -Type Cmdlet | Measure-Object | Select-Object Count
Get-Help Get-Command
Update-Help
Get-Help Get-Command -Examples
Get-Alias -Definition Get-Alias
Set-Location C:\Users\cybrary
Get-ChildItem
Get-ChildItem C:\Windows\System32 *.dll | Measure-Object
Set-Location C:\Users\cybrary\Desktop
Set-Content Hello.txt "Hello"
Get-Content Hello.txt
Add-Content Hello.txt "Goodbye"
$Hello = Get-Content Hello.txt
New-Item File1.txt
Add-Content File1.txt "This is file 1."
Copy-Item File1.txt File2.txt
Move-Item File2.txt File3.txt
New-Item -ItemType Directory Folder1
Move-Item File*.* Folder1
Test-Path Folder1\File1.txt
Remove-Item -Recurse -Force Folder1
Get-ComputerInfo
Get-ComputerInfo -Property *version
Get-ComputerInfo -Property *hot*
Get-ComputerInfo -Property *mem*
Get-CimInstance -ClassName Win32_ComputerSystem
Get-CimInstance -ClassName Win32_Processor
Get-CimInstance -ClassName Win32_PhysicalMemory | Select-Object Capacity
Get-CimInstance -ClassName Win32_LogicalDisk
Get-CimInstance -ClassName Win32_UserAccount
Get-CimInstance -ClassName Win32_Group
Get-LocalUser
Get-LocalUser | Measure-Object | Select-Object Count
$Users = Get-LocalUser
$Users.Name
Get-LocalGroup
Get-LocalGroup | Measure-Object | Select-Object Count
$Groups = Get-LocalGroup
$Groups.Name
Get-Process -Verbose
Get-Service | Where-Object Status -EQ Running
Get-Service | Where-Object Status -EQ Stopped
Get-EventLog -LogName Application -Newest 10
Get-EventLog -LogName Security -EntryType FailureAudit
Get-EventLog -LogName Security -InstanceID 4625
$Errors = Get-EventLog -LogName System -EntryType Error
$Errors.Message

```


### Veelgebruikte Werkwoorden (Verbs)
Microsoft hanteert een vaste lijst van goedgekeurde werkwoorden (`Get-Verb`). Dit zijn de meest voorkomende:

* **`Get`** — Haalt informatie of een object op (`Get-Process`)
* **`Set`** — Wijzigt een bestaande instelling of eigenschap (`Set-ExecutionPolicy`)
* **`New`** — Maakt een nieuw object, bestand of item aan (`New-Item`)
* **`Remove`** — Verwijdert iets (`Remove-Item`)
* **`Start`** — Start een proces, service of taak (`Start-Service`)
* **`Stop`** — Stopt een proces, service of taak (`Stop-Process`)
* **`Restart`** — Herstart iets (`Restart-Computer`)
* **`Enable` / `Disable`** — Zet een functie of account aan of uit (`Enable-NetAdapter`)
* **`Add` / `Clear`** — Voegt iets toe of maakt iets leeg (`Add-Content`, `Clear-Host`)
* **`Test`** — Controleert een status of verbinding (`Test-Connection`)
* **`Invoke`** — Voert een actie, script of webverzoek uit (`Invoke-WebRequest`)
* **`Export` / `Import`** — Schrijft data weg of laadt data in (`Export-Csv`)
* **`Select` / `Where` / `Sort`** — Filtert en ordent objecten in de pipeline (`Where-Object`)

---

### Veelgebruikte Naamwoorden (Nouns)
Naamwoorden zijn altijd in het **enkelvoud** en beschrijven het onderdeel van het systeem dat je beheert:

* **`Item`** — Bestanden, mappen of registersleutels (`Get-Item`, `Remove-Item`)
* **`ChildItem`** — De inhoud van een map of container (`Get-ChildItem`, vergelijkbaar met `ls`/`dir`)
* **`Content`** — De tekstuele inhoud van een bestand (`Get-Content`, `Set-Content`)
* **`Process`** — Actieve programma's en processen (`Get-Process`, `Stop-Process`)
* **`Service`** — Achtergrondservices in Windows (`Get-Service`, `Restart-Service`)
* **`Object`** — Algemene data-objecten in de pipeline (`Select-Object`, `Sort-Object`)
* **`Command` / `Help`** — PowerShell's eigen ingebouwde hulpsysteem (`Get-Command`, `Get-Help`)
* **`NetAdapter` / `NetIPAddress`** — Netwerkkaarten en IP-configuratie (`Get-NetIPAddress`)
* **`Computer`** — Het systeem zelf (`Restart-Computer`, `Get-ComputerInfo`)
* **`Module`** — Uitbreidingspakketten voor PowerShell (`Install-Module`, `Import-Module`)
* **`ADUser` / `LocalUser`** — Gebruikersaccounts in Active Directory of lokaal (`Get-LocalUser`)

## BASH Scripting Basics
### Commandsls -la | grep -v '^d' | wc -l <-- count files in current directory
```bash
#!/bin/bash <-- begin altijd met deze shebang om ervoor te zorgen dat linux het script uitvoert met de correcte shell
ls -la <-- prints files
ls -la | grep -v '^d' <-- search for things that do NOT start with lowercase "d" (directory listings start with lower-case "d" for "directory"
ls -la | grep -v '^d' | wc -l <-- count each line
ls -la | grep '^d' | wc -l <-- Hetzelfde, maar dan voor directories ipv files
find . -maxdepth 1 -type f <-- find all files in current directory
find . -maxdepth 1 -type f -exec du -h {} \;  <-- Kijken hoe groot die files zijn
find . -maxdepth 1 -type f -exec du -h {} \; | sort -r <-- Sorteer de gevonden files
find . -maxdepth 1 -type f -exec du -h {} \; | sort -r | head -5  <-- toon enkel de eerste vijf resultaten
for ((a=1; a<=10; a++)); do echo $a; done | sort -r <-- sorteert als een string
for ((a=1; a<=10; a++)); do echo $a; done | sort -rh <-- sorteert als een nummer
echo{1..5} <-- brace expansion maakt alle items tussen twee compatibele items automatisch zelf aan
echo{a..c}{1..3} <-- brace expansion is combineerbaar met meerdere opties
for a in {1..254} ;do (ping -c 1 X.X.X.$a | grep "bytes from" &) ; done
names=('John' 'Fred' 'Sally' 'Billy' 'Charlie') <-- array aanmaken
echo ${names[@]}  <-- print alles uit de array in één keer uit
echo ${!names[@]} <-- print enkel de indices
echo ${#names[@]} <-- print de size van de array
for name in ${names[@]}; do echo $name; done <-- print alle items uit de array via een for loop
names[2]='Tom' <-- veranderd item 2 in de array
mapfile -t fruits < "fruits.txt" <-- zet de info van het txt bestand in de "fruits" variabele

if [ ! -d "$backup" ]
then
  mkdir "$backup"
fi 
```
Als pipes ("|") niet beschikbaar zijn, zoals voor het "du" commando, dan werkt "-exec {} \;" wel
