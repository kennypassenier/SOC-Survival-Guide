#region process
# Haal specifieke OS- en hotfix-informatie op
Get-ComputerInfo | Select-Object WindowsProductName, OsVersion, CsName

# Toon alle actieve processen gesorteerd op geheugengebruik
Get-Process | Sort-Object WorkingSet -Descending | Select-Object -First 15
#endregion process

#region services
# Filter op actief draaiende of niet-actieve services
Get-Service | Where-Object Status -EQ "Running"
Get-Service | Where-Object Status -NE "Running"

# Inspecteer alle eigenschappen van een specifieke service in tabelvorm
Get-Service -Name MyService | Select-Object -Property * | Format-Table

# Registreer en start een nieuwe Windows-service
New-Service -Name MyService -BinaryPathName "C:\Program Files\my service\WindowsService1.exe"
Start-Service -Name MyService
Stop-Service -Name MyService

# Moderne vervanger van WMIC om kwetsbare Unquoted Service Paths op te sporen
Get-CimInstance Win32_Service | Where-Object {
    $_.StartMode -eq 'Auto' -and
    $_.PathName -notlike 'C:\Windows\*' -and
    $_.PathName -notlike '"*"*'
} | Select-Object Name, StartMode, PathName
#endregion services

#region registry
# Inspecteer autostart-programma's in het Windows-register (Persistence check)
Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
#endregion registry

#region eventlogs
# Lees de laatste 20 gebeurtenissen uit het Security-logboek of een geëxporteerd .evtx-bestand
Get-WinEvent -LogName Security -MaxEvents 20
Get-WinEvent -Path .\Security.evtx -MaxEvents 20
#endregion eventlogs
