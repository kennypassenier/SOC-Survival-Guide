#region acl
# Toon de volledige ACL van een map (alle ACE's: wie heeft welke rechten); Format-List toont alles onder elkaar
Get-Acl -Path C:\Hall_of_Justice | Format-List

# Leden van een lokale groep (-Group)
Get-LocalGroupMember -Group "Leaders"
# De Administrators-groep hoort een korte, bekende lijst te hebben
Get-LocalGroupMember -Group "Administrators"
#endregion acl

#region backup
# Installeer de back-uprol op Windows Server
Install-WindowsFeature Windows-Server-Backup

# Toon de status van de laatste back-up en de beschikbare herstelpunten
Get-WBSummary
#endregion backup
