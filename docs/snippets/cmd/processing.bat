:: #region echo
:: Toon de actieve systeem- en gebruikers-PATH-variabelen
echo %PATH%

:: Schrijf tekst naar een nieuw bestand en voeg daarna extra tekst toe
echo The cow says moo. > apple1\cow.txt
type apple1\cow.txt >> apple3\manycows.txt

:: Bekijk het lokale Windows hosts-bestand
type C:\Windows\System32\drivers\etc\hosts

:: Lees lange uitvoer pagina voor pagina
sc query | more
:: #endregion echo

:: #region search
:: Zoek een woord in een specifiek bestand of in alle bestanden (*) in de huidige map
findstr "moo" notacow.txt
findstr /i "error" *.log

:: Combineer dir met findstr via pipes en tel het resultaat met find /c
dir /s /b | findstr apple | findstr .txt | find /c ".txt"

:: Tel lokale groepen (elke regel begint met *) en verborgen shares ($)
net localgroup | find /c "*"
net share | find /c "$"
:: #endregion search

:: #region certutil
:: Bereken de SHA-256 (of MD5) hash van een verdacht uitvoerbaar bestand
certutil -hashfile happypuppy.exe SHA256
certutil -hashfile happypuppy.exe MD5

:: Codeer en decodeer bestanden via Base64
certutil -encode message.enc message.base64
certutil -decode message.base64 message.enc
:: #endregion certutil

:: #region script
:: Start een Python-script op Windows
python caesar.py
py caesar.py

:: Genereer een modern Ed25519 asymmetrisch sleutelpaar
ssh-keygen -t ed25519
:: #endregion script
