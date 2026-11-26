#region install
# 1. Installeer AD DS en beheertools
Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools

# 2. Promoveer server tot DC van nieuw forest 'legionofdoom.local'
Install-ADDSForest -DomainName "legionofdoom.local" -CreateDnsDelegation:$false -DatabasePath "C:\Windows\NTDS" -DomainMode "7" -DomainNetbiosName "LEGIONOFDOOM" -ForestMode "7" -InstallDns:$true -LogPath "C:\Windows\NTDS" -NoRebootOnCompletion:$False -SysvolPath "C:\Windows\SYSVOL" -Force:$true

# 3. Controleer na reboot de domeineigenschappen en DistinguishedName
Get-ADDomain
#endregion install

#region objectbeheer
# Maak een OU aan en controleer alle OU's
New-ADOrganizationalUnit -Name "Hall of Doom" -Path "DC=legionofdoom,DC=local"
Get-ADOrganizationalUnit -Filter ' Name -like "*" ' | Format-Table Name

# Maak een actief AD-gebruikersaccount aan en verifieer
New-ADUser -Name "Lex Luthor" -DisplayName "Lex Luthor" -GivenName "Lex" -Surname "Luthor" -SamAccountName "lex.luthor" -UserPrincipalName "lex.luthor@legionofdoom.local" -Path "OU=Hall of Doom,DC=legionofdoom,DC=local" -AccountPassword (Read-Host -AsSecureString "Input Password") -Enabled:$true
Get-ADUser -Filter ' Name -like "Lex*" '

# Maak een Global Security Group aan, voeg een gebruiker toe en controleer lidmaatschap
New-ADGroup -Name "Villains" -SamAccountName "Villains" -GroupCategory Security -GroupScope Global -DisplayName "Villains" -Path "OU=Hall of Doom,DC=legionofdoom,DC=local"
Add-ADGroupMember -Identity "Villains" -Members lex.luthor
Get-ADGroupMember -Identity "Villains"
#endregion objectbeheer

#region gpo
# Forceer onmiddellijke GPO-vernieuwing en genereer een RSoP-rapport
gpupdate /force
gpresult /Z

# Native PowerShell cmdlets uit de GroupPolicy-module
Invoke-GPUpdate -Force
Get-GPResultantSetOfPolicy -ReportType Html -Path "C:\Temp\rsop.html"
#endregion gpo
