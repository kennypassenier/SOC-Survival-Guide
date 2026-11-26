#region search
# Zoek recursief (-Recurse) bestanden waarvan de naam het patroon volgt (-Filter) en tel ze met .Count
(Get-ChildItem -Recurse -Filter *apple*.txt).Count

# Zoek de tekst "moo" in alle .txt-bestanden van de huidige map (vergelijkbaar met grep)
Select-String -Path *.txt -Pattern "moo"

# Set-Content schrijft een bestand en overschrijft de inhoud
Set-Content -Path .\log.txt -Value "Eerste regel"
# Add-Content voegt een regel toe aan het einde
Add-Content -Path .\log.txt -Value "Tweede regel"
# Get-Content leest het bestand
Get-Content -Path .\log.txt
#endregion search

#region hash
# -Algorithm kiest het hash-algoritme; SHA256 is de standaard
Get-FileHash -Path .\happypuppy.exe -Algorithm SHA256
Get-FileHash -Path .\happypuppy.exe -Algorithm MD5

# Hash alle .exe-bestanden in een map en toon alleen Hash en Path; -AutoSize past de kolombreedte aan
Get-FileHash -Path C:\Downloads\*.exe -Algorithm SHA256 | Format-Table Hash, Path -AutoSize
#endregion hash
