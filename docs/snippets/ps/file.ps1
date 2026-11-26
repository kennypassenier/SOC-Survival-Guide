#region search
# Zoek recursief naar alle .txt-bestanden met 'apple' in de naam en tel ze
(Get-ChildItem -Recurse -Filter *apple*.txt).Count

# Doorzoek alle tekstbestanden in de huidige map op een patroon
Select-String -Path *.txt -Pattern "moo"

# Schrijf en lees tekstbestanden
Set-Content -Path .\log.txt -Value "Eerste regel"
Add-Content -Path .\log.txt -Value "Tweede regel"
Get-Content -Path .\log.txt
#endregion search

#region ads
# Ontdek alle Alternate Data Streams van notasecret.txt
Get-Item .\notasecret.txt -Stream *

# Lees de inhoud van de verborgen stream 'secret' uit
Get-Item .\notasecret.txt | Get-Content -Stream secret

# SOC Triage: spoor alle niet-standaard ADS-streams recursief op in een map
Get-ChildItem -Recurse | Get-Item -Stream * | Where-Object Stream -ne ':$DATA'
#endregion ads

#region hash
# Bereken de SHA-256 (standaard) en MD5-hash van een bestand
Get-FileHash -Path .\happypuppy.exe -Algorithm SHA256
Get-FileHash -Path .\happypuppy.exe -Algorithm MD5

# Bereken direct de SHA-256 hash van alle uitvoerbare bestanden in een map
Get-FileHash -Path C:\Downloads\*.exe -Algorithm SHA256 | Format-Table Hash, Path -AutoSize
#endregion hash
