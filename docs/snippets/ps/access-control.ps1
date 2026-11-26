#region acl
# Inspecteer alle toegangsregels (ACE's) van een map
Get-Acl -Path C:\Hall_of_Justice | Format-List

# Bekijk de leden van een lokale beveiligingsgroep
Get-LocalGroupMember -Group "Leaders"
Get-LocalGroupMember -Group "Administrators"
#endregion acl

#region backup
# Installeer Windows Server Backup op Windows Server
Install-WindowsFeature Windows-Server-Backup

# Controleer de status en laatste herstelpunten van Windows Server Backup
Get-WBSummary
#endregion backup
