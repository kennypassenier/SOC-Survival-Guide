:: #region sysinfo
systeminfo
tasklist
tasklist /v
date /t
time /t
:: #endregion sysinfo

:: #region services
:: Bekijk alle actieve services pagina voor pagina
sc query | more

:: Controleer de status en configuratie van een specifieke service (interne naam)
sc query wscsvc
sc qc wscsvc

:: Toon naam, weergavenaam, status, PID en uitvoerbaar pad via WMIC
wmic service get name,displayname,started,processid,pathname

:: Filter op actief draaiende of niet-draaiende services
wmic service where Started=True get name,pathname
wmic service where Started=False get name,pathname

:: Detecteer kwetsbare Unquoted Service Paths (Auto-start, buiten C:\Windows, zonder quotes)
wmic service get name,pathname,startmode | findstr /i "auto" | findstr /i /v "c:\windows\\" | findstr /i /v """
:: #endregion services

:: #region net
:: Toon alle lokale gebruikersaccounts
net user

:: Toon alle lokale groepen of inspecteer de leden van een specifieke groep
net localgroup
net localgroup Leaders

:: Toon alle gedeelde mappen, inclusief verborgen administratieve shares (C$, IPC$, ADMIN$)
net share

:: Bekijk het lokale wachtwoord- en accountvergrendelingsbeleid
net accounts
:: #endregion net

:: #region backup
:: Maak een eenmalige back-up van C:\Sales op de D:-schijf
wbadmin start backup -backupTarget:D: -include:C:\Sales

:: Maak een volledige kritieke systeemback-up zonder bevestigingsprompt
wbadmin start backup -backupTarget:D: -allCritical -quiet
:: #endregion backup
