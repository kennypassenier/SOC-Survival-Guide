:: #region backup
:: Eenmalige back-up: start backup begint de taak, -backupTarget is de doelschijf, -include de te bewaren map
wbadmin start backup -backupTarget:D: -include:C:\Sales

:: -allCritical neemt alle voor herstel kritieke volumes mee, -quiet slaat de bevestigingsvraag over
wbadmin start backup -backupTarget:D: -allCritical -quiet
:: #endregion backup

:: #region eventlog
:: qe = query events voor het Security-log, /c:20 = 20 events, /rd:true = nieuwste eerst, /f:text = leesbare tekst
wevtutil qe Security /c:20 /rd:true /f:text
:: #endregion eventlog

:: #region triage
:: Toon alle geplande taken in detail; /fo LIST = lijstvorm, /v = verbose
schtasks /query /fo LIST /v

:: Lees de autostart-programma's van alle gebruikers uit het register
reg query HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run

:: Toon het uitvoerbare bestand achter elke verbinding (vereist een verhoogde prompt)
netstat -b

:: /svc toont welke services in elk proces draaien (vooral nuttig bij svchost.exe)
tasklist /svc

:: Toon gebruiker, groepen en privileges in één overzicht
whoami /all

:: Toon wie er via het netwerk op dit systeem is aangemeld
net session

:: Toon de details van één account, zoals laatste aanmelding en groepen
net user administrator
:: #endregion triage
