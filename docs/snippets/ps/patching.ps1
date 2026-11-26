#region windows-update
# Installeer de module PSWindowsUpdate (-Force slaat bevestigingsvragen over)
Install-Module -Name PSWindowsUpdate -Force
# Toon de reeds geïnstalleerde updates
Get-WindowsUpdate -IsInstalled

# Installeer alle beschikbare updates: -AcceptAll accepteert alles, -Install voert uit, -AutoReboot herstart zo nodig
Get-WindowsUpdate -AcceptAll -Install -AutoReboot

# Installeer één specifieke update op basis van het KB-nummer
Get-WindowsUpdate -Install -KBArticleID "KB5000000"
# Bewaar het KB-nummer in een variabele en verberg die update zodat hij niet meer wordt aangeboden
$HideList = "KB5000000"
Get-WindowsUpdate -KBArticleID $HideList -Hide
#endregion windows-update
