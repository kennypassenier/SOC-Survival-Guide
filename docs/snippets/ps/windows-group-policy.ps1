#region gpo-gpupdate
# Forceer het direct opnieuw toepassen van alle Computer- en User-policies
gpupdate /force
#endregion gpo-gpupdate

#region gpo-gpresult
# Genereer een volledig gedetailleerd RSoP-rapport in de console (inclusief Administrative Templates)
gpresult /Z
#endregion gpo-gpresult

#region gpo-import-module-new-adorganizationalunit-a
# Voeg gebruiker 'cybrary' toe aan Domain Admins en verifieer
Add-ADGroupMember -Identity "Domain Admins" -Members "cybrary"
Get-ADGroupMember -Identity "Domain Admins"

# Maak een hoofd-OU en een geneste sub-OU aan voor gelaagde GPO-toepassing
New-ADOrganizationalUnit -Name "Cybrary" -Path "DC=cybrary,DC=local"
New-ADOrganizationalUnit -Name "Engineering" -Path "OU=Cybrary,DC=cybrary,DC=local"
#endregion gpo-import-module-new-adorganizationalunit-a

#region scenario-1-stap-1
# Pas de lokale policy direct toe zonder te wachten op de verversingscyclus
gpupdate /force
#endregion scenario-1-stap-1

#region scenario-2-stap-1
# Bouw een OU-hiërarchie met een geneste OU voor gelaagde GPO-toepassing
New-ADOrganizationalUnit -Name "Cybrary" -Path "DC=cybrary,DC=local"
New-ADOrganizationalUnit -Name "Engineering" -Path "OU=Cybrary,DC=cybrary,DC=local"
#endregion scenario-2-stap-1
