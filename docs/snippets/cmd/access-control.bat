:: #region icacls
:: Toon de ACL (alle ACE's) van een specifieke map
icacls Hall_of_Justice

:: Toon recursief alle ACL's van alle onderliggende submappen en bestanden
icacls Hall_of_Justice /t

:: Geef groep 'Leaders' Modify-rechten met overerving op submappen en bestanden
icacls C:\Leadership /grant "Leaders:(OI)(CI)M"

:: Schakel overerving uit met behoud van rechten en verwijder BUILTIN\Users
icacls C:\Leadership /inheritance:d
icacls C:\Leadership /remove "BUILTIN\Users"
:: #endregion icacls

:: #region ads
:: Schrijf verborgen data naar een Alternate Data Stream achter notasecret.txt
echo "Verborgen boodschap" > notasecret.txt:secret

:: Lees de inhoud van de Alternate Data Stream uit
more < notasecret.txt:secret

:: Toon alle Alternate Data Streams in de huidige map met dir /r
dir /r
:: #endregion ads
