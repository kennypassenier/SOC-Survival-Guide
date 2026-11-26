#region ad-install-windowsfeature
# Installeer de AD DS-rol inclusief alle beheertools
Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools
#endregion ad-install-windowsfeature

#region ad-install-addsforest
# Maak een nieuw AD-forest en root-domein aan en promoveer de server tot Domain Controller
Install-ADDSForest -DomainName "legionofdoom.local" -CreateDnsDelegation:$false -DatabasePath "C:\Windows\NTDS" -DomainMode "7" -DomainNetbiosName "LEGIONOFDOOM" -ForestMode "7" -InstallDns:$true -LogPath "C:\Windows\NTDS" -NoRebootOnCompletion:$False -SysvolPath "C:\Windows\SYSVOL" -Force:$true
#endregion ad-install-addsforest

#region ad-get-addomain
# Bekijk de domeininformatie en de Distinguished Name (bijv. DC=legionofdoom,DC=local)
Get-ADDomain
#endregion ad-get-addomain

#region ad-new-adorganizationalunit-get-adorganizat
# Maak een nieuwe Organizational Unit aan
New-ADOrganizationalUnit -Name "Hall of Doom" -Path "DC=legionofdoom,DC=local"

# Controleer alle aangemaakte OU's in tabelformaat
Get-ADOrganizationalUnit -Filter ' Name -like "*" ' | Format-Table Name
#endregion ad-new-adorganizationalunit-get-adorganizat

#region ad-new-aduser-get-aduser
# Maak een nieuw actief AD-gebruikersaccount aan in een specifieke OU
New-ADUser -Name "Lex Luthor" -DisplayName "Lex Luthor" -GivenName "Lex" -Surname "Luthor" -SamAccountName "lex.luthor" -UserPrincipalName "lex.luthor@legionofdoom.local" -Path "OU=Hall of Doom,DC=legionofdoom,DC=local" -AccountPassword (Read-Host -AsSecureString "Input Password") -Enabled:$true

# Zoek een gebruiker op naam
Get-ADUser -Filter ' Name -like "Lex*" '
#endregion ad-new-aduser-get-aduser

#region ad-new-adgroup-get-adgroup-add-adgroupmembe
# Maak een nieuwe Global Security Group aan binnen een OU
New-ADGroup -Name "Villains" -SamAccountName "Villains" -GroupCategory Security -GroupScope Global -DisplayName "Villains" -Path "OU=Hall of Doom,DC=legionofdoom,DC=local"

# Controleer of de groep bestaat
Get-ADGroup -Filter ' Name -like "Villains" '

# Voeg gebruiker 'lex.luthor' toe aan de groep 'Villains'
Add-ADGroupMember -Identity "Villains" -Members lex.luthor

# Controleer alle leden van de groep 'Villains'
Get-ADGroupMember -Identity "Villains"
#endregion ad-new-adgroup-get-adgroup-add-adgroupmembe

#region scenario-1-stap-1
# Installeer de AD DS-rol met de beheertools
Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools
#endregion scenario-1-stap-1

#region scenario-1-stap-2
# Promoveer de server tot eerste domain controller van een nieuw forest, inclusief DNS
Install-ADDSForest -DomainName "legionofdoom.local" -CreateDnsDelegation:$false -DatabasePath "C:\Windows\NTDS" -DomainMode "7" -DomainNetbiosName "LEGIONOFDOOM" -ForestMode "7" -InstallDns:$true -LogPath "C:\Windows\NTDS" -NoRebootOnCompletion:$False -SysvolPath "C:\Windows\SYSVOL" -Force:$true
#endregion scenario-1-stap-2

#region scenario-1-stap-3
# Controleer na de herstart de domeineigenschappen
Get-ADDomain
#endregion scenario-1-stap-3

#region scenario-2-stap-1
# 1. Maak de Organizational Unit aan
New-ADOrganizationalUnit -Name "Hall of Doom" -Path "DC=legionofdoom,DC=local"

# 2. Maak het actieve gebruikersaccount aan in de nieuwe OU
New-ADUser -Name "Lex Luthor" -DisplayName "Lex Luthor" -GivenName "Lex" -Surname "Luthor" -SamAccountName "lex.luthor" -UserPrincipalName "lex.luthor@legionofdoom.local" -Path "OU=Hall of Doom,DC=legionofdoom,DC=local" -AccountPassword (Read-Host -AsSecureString "Input Password") -Enabled:$true

# 3. Maak een Global Security Group aan en voeg de gebruiker toe
New-ADGroup -Name "Villains" -SamAccountName "Villains" -GroupCategory Security -GroupScope Global -DisplayName "Villains" -Path "OU=Hall of Doom,DC=legionofdoom,DC=local"
Add-ADGroupMember -Identity "Villains" -Members lex.luthor

# 4. Verifieer het resultaat
Get-ADGroupMember -Identity "Villains"
#endregion scenario-2-stap-1
