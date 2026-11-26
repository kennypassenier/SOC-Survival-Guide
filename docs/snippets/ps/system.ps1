#region help
# Bekijk de volledige help en voorbeelden van een cmdlet
Get-Help Get-ChildItem -Full
Get-Help Start-MpScan -Examples
#endregion help

#region modules
# Laad een lokaal script of module in de huidige sessie
Import-Module .\Install-AD.ps1
#endregion modules

#region history
# Bekijk commandogeschiedenis (en het pad waar PSReadLine alle sessies opslaat)
Get-History
(Get-PSReadlineOption).HistorySavePath
#endregion history

#region python
# Voer een Python-script uit
python caesar.py

# Toon alle mappen in de PATH-omgevingsvariabele overzichtelijk onder elkaar
$env:PATH -split ';'
#endregion python
