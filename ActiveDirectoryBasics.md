# Active Directory Basics

## AD installation through PowerShell

```powershell
Install-windows Feature -Name AD-Domain-Services -IncludeManagementTools

Install-ADDSForest -DomainName "legionofdoom.local" -CreateDnsDelegation:$false -DatabasePath "C:\windows\NTDS" -DomainMode
"7" -DomainNetbiosName "LEGIONOFDOOM" -ForestMode "7" -InstallDns:$true -LogPath "C:\windows\NTDS" -NoRebootOnCompletion:
False -SysvolPath "C:\Windows\SYSVOL" -Force: $true

Get-ADDomain

New-ADOrganizationalUnit -Name "Hall of Doom" -Path "DC=legionofdoom,DC=local"

Get-ADOrganizationalUnit -Filter ' Name -like "*" ' | Format-table Name

New-ADUser -Name "Lex Luthor" -DisplayName "Lex Luthor" -GivenName "Lex" -Surname "Luthor" -SamAccountName "lex.luthor" -
UserPrincipalName lex.luthor@legionofdoom.local -Path "OU=Hall of Doom, DC=legionofdoom, DC=local" -AccountPassword (Read-host
-AsSecureString "Input Password") -Enabled: $true

Get-ADuser -Filter ' Name -like "Lex*" '

New-ADGroup -Name "Villains" -SamAccountName "Villains" -GroupCategory Security -GroupScope Global -DisplayName "Villains"
-Path "OU=Hall of Doom,DC=legionofdoom,DC=local"

Get-ADGroup -Filter ' Name -like "Villains" '

Add-ADGroupMember -Identity "Villains" -Members lex.luthor

Get-ADGroupMember -Identity "Villains"

I
```
