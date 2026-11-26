:: #region svc-wmic-service
:: Toon alle service-details pagina voor pagina
wmic service | more

:: Toon uitsluitend servicenaam en uitvoerbaar pad
wmic service get name,pathname

:: Filter op actief draaiende of niet-draaiende services
wmic service where Started=True get name,pathname
wmic service where Started=False get name,pathname

:: Toon naam, weergavenaam, status, Process ID en pad (alleen actieve services hebben een PID)
wmic service get name,displayname,started,processid,pathname

:: Detecteer kwetsbare Unquoted Service Paths (automatisch startend, buiten C:\Windows, zonder quotes)
wmic service get name,pathname,startmode | findstr /i "auto" | findstr /i /v "c:\windows\\" | findstr /i /v """
:: #endregion svc-wmic-service

:: #region scenario-1-stap-1
:: Zoek services met Auto-start buiten C:\Windows waarvan het pad geen aanhalingstekens heeft
wmic service get name,pathname,startmode | findstr /i "auto" | findstr /i /v "c:\windows\\" | findstr /i /v """
:: #endregion scenario-1-stap-1
