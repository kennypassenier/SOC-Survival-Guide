#region fs-get-item-stream-get-content-stream-power
# Ontdek alle Alternate Data Streams van notasecret.txt
Get-Item .\notasecret.txt -Stream *

# Lees de inhoud van de verborgen stream 'secret' uit
Get-Item .\notasecret.txt | Get-Content -Stream secret
#endregion fs-get-item-stream-get-content-stream-power

#region scenario-1-stap-1
# Toon alle streams van het bestand, ook de verborgen
Get-Item .\notasecret.txt -Stream *
#endregion scenario-1-stap-1

#region scenario-1-stap-2
# In PowerShell:
Get-Item .\notasecret.txt | Get-Content -Stream secret
#endregion scenario-1-stap-2
