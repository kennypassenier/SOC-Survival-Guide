#region process
# Toon alleen de gekozen eigenschappen: productnaam, versie en computernaam
Get-ComputerInfo | Select-Object WindowsProductName, OsVersion, CsName

# Sorteer processen aflopend op geheugengebruik (WorkingSet) en toon de eerste 15
Get-Process | Sort-Object WorkingSet -Descending | Select-Object -First 15
#endregion process

#region registry
# Lees de autostart-programma's van alle gebruikers; HKLM: is de registerhive HKEY_LOCAL_MACHINE.
# Onbekende programma's hier zijn een persistence-indicator
Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
#endregion registry

#region eventlogs
# De laatste 20 events uit het live Security-log (-MaxEvents beperkt het aantal)
Get-WinEvent -LogName Security -MaxEvents 20
# Hetzelfde uit een geëxporteerd .evtx-bestand (-Path), handig voor offline analyse
Get-WinEvent -Path .\Security.evtx -MaxEvents 20
#endregion eventlogs

#region process-extended
# -IncludeUserName toont de eigenaar van elk proces (vereist een verhoogde sessie)
Get-Process -IncludeUserName | Select-Object Name, Id, UserName
# Het commando waarmee een proces gestart is en zijn ouderproces. Een onverwachte ouder, zoals Word dat PowerShell start, is verdacht
Get-CimInstance Win32_Process | Select-Object Name, ProcessId, ParentProcessId, CommandLine
# Koppel verbindingen aan het programma: haal het proces op bij elke OwningProcess
Get-NetTCPConnection -State Established | ForEach-Object { [pscustomobject]@{ Port = $_.RemotePort; Address = $_.RemoteAddress; Process = (Get-Process -Id $_.OwningProcess).Name } }
#endregion process-extended

#region events-filter
# -FilterHashtable filtert aan de bron en is veel sneller dan Where-Object. Id 4625 = mislukte aanmelding
Get-WinEvent -FilterHashtable @{LogName='Security'; Id=4625} -MaxEvents 20
# StartTime beperkt tot een tijdvenster; Id 4624 = geslaagde aanmelding, hier het laatste uur
Get-WinEvent -FilterHashtable @{LogName='Security'; Id=4624; StartTime=(Get-Date).AddHours(-1)}
# Id 7045 in het System-log = nieuwe service geïnstalleerd, een persistence-indicator
Get-WinEvent -FilterHashtable @{LogName='System'; Id=7045}
#endregion events-filter

#region persistence
# Geplande taken die niet uitgeschakeld zijn
Get-ScheduledTask | Where-Object State -ne 'Disabled'
# Alleen ingeschakelde lokale accounts
Get-LocalUser | Where-Object Enabled
# Services die automatisch starten
Get-Service | Where-Object StartType -eq 'Automatic'
# RunOnce-sleutels voeren een programma eenmalig uit bij de volgende aanmelding
Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce"
# De opstartmap van de huidige gebruiker
Get-ChildItem "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup"
# -Force toont ook verborgen en systeembestanden
Get-ChildItem -Path C:\Users -Force -Recurse -Filter *.exe -ErrorAction SilentlyContinue
#endregion persistence
