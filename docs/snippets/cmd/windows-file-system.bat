:: #region fs-dir-x-cd-met-spaties
:: Navigeer naar een map met spaties via dubbele aanhalingstekens
cd "Program Files (x86)"

:: Bekijk de 8.3 korte namen van mappen op C:\ (bijv. PROGRA~1 en PROGRA~2)
dir /x C:\
:: #endregion fs-dir-x-cd-met-spaties

:: #region fs-echo-path-cd-homepath-sysdm
:: Toon alle actieve zoekpaden in de PATH-omgevingsvariabele
echo %PATH%

:: Open het System Properties-venster vanaf de opdrachtprompt
sysdm
:: #endregion fs-echo-path-cd-homepath-sysdm

:: #region fs-echo-bestand-stream-type-bestand-stream
:: Maak een normaal tekstbestand aan
echo This is not a secret. > notasecret.txt

:: Verberg tekst in een Alternate Data Stream genaamd 'secret' achter het bestand
echo The password is MUSTARD1234 > notasecret.txt:secret

:: Controleer bestandsgrootte en reguliere inhoud (blijven ogenschijnlijk ongewijzigd)
dir notasecret.txt
type notasecret.txt

:: Lees de verborgen stream rechtstreeks uit in CMD (als de streamnaam bekend is)
type notasecret.txt:secret
:: #endregion fs-echo-bestand-stream-type-bestand-stream

:: #region fs-type-c-windows-system32-drivers-etc-host
:: Bekijk de inhoud van het lokale hosts-bestand
type C:\Windows\System32\drivers\etc\hosts
:: #endregion fs-type-c-windows-system32-drivers-etc-host

:: #region scenario-1-stap-1
:: Ga naar de home-map, maak een onschuldig bestand en schrijf een geheim in een verborgen stream (:secret)
cd %HOMEPATH%
echo This is not a secret. > notasecret.txt
echo The password is MUSTARD1234 > notasecret.txt:secret
:: #endregion scenario-1-stap-1

:: #region scenario-1-stap-2
:: dir en type tonen niets van de verborgen stream en de bestandsgrootte verandert niet
dir notasecret.txt
type notasecret.txt
:: #endregion scenario-1-stap-2

:: #region scenario-1-stap-3
:: Of in CMD (alleen als je de exacte streamnaam al weet):
type notasecret.txt:secret
:: #endregion scenario-1-stap-3

:: #region scenario-2-stap-1
:: Controleer het hosts-bestand op onverwachte koppelingen tussen naam en IP-adres
type C:\Windows\System32\drivers\etc\hosts
:: #endregion scenario-2-stap-1

:: #region scenario-2-stap-2
:: Controleer of een beschrijfbare map vóór System32 in het zoekpad staat
echo %PATH%
:: #endregion scenario-2-stap-2
