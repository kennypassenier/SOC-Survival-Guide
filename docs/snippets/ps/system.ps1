#region help
# -Full toont beschrijving, alle parameters, voorbeelden en opmerkingen
Get-Help Get-ChildItem -Full
# -Examples toont alleen de voorbeelden
Get-Help Start-MpScan -Examples
#endregion help

#region modules
# Laad een lokaal script of module in de huidige sessie; de functies erin zijn daarna beschikbaar
Import-Module .\Install-AD.ps1
#endregion modules

#region history
# Commando's van de huidige sessie
Get-History
# Pad naar het tekstbestand waarin PSReadLine de commando's van alle sessies bewaart
(Get-PSReadlineOption).HistorySavePath
#endregion history

#region python
# Voer een Python-script uit
python caesar.py

# Splits het PATH op de puntkomma (-split) zodat elke map op een eigen regel staat
$env:PATH -split ';'
#endregion python
