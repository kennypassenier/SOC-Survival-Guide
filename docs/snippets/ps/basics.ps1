#region basics-variables
# Variabelen beginnen met $; alles in PowerShell is een object
$hello = "Hello World"
# Eigenschap: het aantal tekens
$hello.Length
# Methode GetType() toont het type van het object (String)
$hello.GetType()
# Methode Contains() geeft True of False
$hello.Contains("Hello")
#endregion basics-variables

#region basics-discovery
# Tel alle cmdlets: Measure-Object telt de objecten, Select-Object Count toont alleen die kolom
Get-Command -Type Cmdlet | Measure-Object | Select-Object Count
# Basishulp bij een cmdlet
Get-Help Get-Command
# Werk de helpbestanden bij (vereist internet en beheerdersrechten)
Update-Help
# -Examples toont alleen de voorbeelden
Get-Help Get-Command -Examples
# Zoek welke alias naar de cmdlet Get-Alias verwijst
Get-Alias -Definition Get-Alias
# Get-Member toont alle eigenschappen en methoden van een object
$hello | Get-Member
# Tel hoeveel leden het object heeft
$hello | Get-Member | Measure-Object | Select-Object Count
#endregion basics-discovery

#region basics-files
# Ga naar een map (alias: cd)
Set-Location C:\Users\cybrary\Desktop
# Zoek alle .dll-bestanden in System32 en tel ze
Get-ChildItem C:\Windows\System32 *.dll | Measure-Object
# Schrijf een bestand (overschrijft) en voeg daarna een regel toe
Set-Content Hello.txt "Hello"
Add-Content Hello.txt "Goodbye"
# Lees het bestand in een variabele
$content = Get-Content Hello.txt
# Maak een leeg bestand aan
New-Item File1.txt
# Kopieer en hernoem/verplaats
Copy-Item File1.txt File2.txt
Move-Item File2.txt File3.txt
# Maak een map aan en verplaats alle File*.*-bestanden erheen
New-Item -ItemType Directory Folder1
Move-Item File*.* Folder1
# Controleer of een pad bestaat (True of False)
Test-Path Folder1\File1.txt
# Verwijder de map met inhoud; -Recurse neemt submappen mee, -Force verwijdert ook verborgen en alleen-lezen bestanden
Remove-Item -Recurse -Force Folder1
#endregion basics-files

#region basics-system-info
# Alle systeeminformatie
Get-ComputerInfo
# -Property beperkt de uitvoer; * is een wildcard: alle eigenschappen die op "version" eindigen
Get-ComputerInfo -Property *version
# Eigenschappen met "hot" in de naam, zoals hotfixes
Get-ComputerInfo -Property *hot*
# Eigenschappen over geheugen
Get-ComputerInfo -Property *mem*
# WMI/CIM-klassen geven hardwaredetails: systeem, processor, geheugenmodules en schijven
Get-CimInstance -ClassName Win32_ComputerSystem
Get-CimInstance -ClassName Win32_Processor
Get-CimInstance -ClassName Win32_PhysicalMemory | Select-Object Capacity
Get-CimInstance -ClassName Win32_LogicalDisk
#endregion basics-system-info

#region basics-accounts
# Alle gebruikers en groepen via CIM (ook domeinaccounts)
Get-CimInstance -ClassName Win32_UserAccount
Get-CimInstance -ClassName Win32_Group
# Lokale gebruikers in een variabele en alleen hun namen tonen
$users = Get-LocalUser
$users.Name
# Tel de lokale gebruikers
Get-LocalUser | Measure-Object | Select-Object Count
# Hetzelfde voor lokale groepen
$groups = Get-LocalGroup
$groups.Name
Get-LocalGroup | Measure-Object | Select-Object Count
#endregion basics-accounts

#region basics-logs
# -Verbose toont extra uitleg bij het uitvoeren
Get-Process -Verbose
# Filter services op status
Get-Service | Where-Object Status -EQ Running
Get-Service | Where-Object Status -EQ Stopped
# -Newest toont de laatste 10 events uit het Application-log
Get-EventLog -LogName Application -Newest 10
# Mislukte audits in het Security-log
Get-EventLog -LogName Security -EntryType FailureAudit
# Event ID 4625 = mislukte aanmelding
Get-EventLog -LogName Security -InstanceID 4625
# Bewaar alle fouten uit het System-log en lees de berichten
$errors = Get-EventLog -LogName System -EntryType Error
$errors.Message
#endregion basics-logs
