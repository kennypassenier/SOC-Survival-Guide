:: #region cli-cmd
:: Start de klassieke Windows CLI vanuit een PowerShell-sessie
cmd
:: #endregion cli-cmd

:: #region cli-whoami
:: Toon de huidige gebruikerscontext (bijv. EC2AMAZ-MVQDHPB\cybrary)
whoami
:: #endregion cli-whoami

:: #region cli-help
:: Bekijk alle opties en switches van het dir-commando
help dir
:: #endregion cli-help

:: #region cli-cd
:: Navigeer naar de home-directory van de ingelogde gebruiker (C:\Users\cybrary)
cd %HOMEPATH%
:: #endregion cli-cd

:: #region cli-dir
:: Toon de inhoud van de huidige map
dir

:: Toon recursief alle submappen en pauzeer per scherm
dir /S /P

:: Filter op mappen of bestanden die beginnen met 'apple'
dir apple*

:: Geef een kale lijst van alle volledige paden (ideaal voor piping naar findstr)
dir /s /b
:: #endregion cli-dir

:: #region cli-tree
:: Toon de mappenstructuur onder de map 'one' (voeg /f toe voor bestanden, /a voor ASCII-tekens)
tree one
:: #endregion cli-tree

:: #region cli-mkdir-of-md
:: Maak drie mappen tegelijk aan
mkdir apple1 apple2 apple3

:: Maak een geneste mappenstructuur in één keer aan (werkt in Windows zonder extra vlag)
mkdir one\two\three
:: #endregion cli-mkdir-of-md

:: #region cli-echo-type-output-redirection
:: Schrijf tekst naar een nieuw bestand (aanhalingstekens zijn niet verplicht in CMD)
echo The cow says moo. > apple1\cow.txt

:: Lees de inhoud van het bestand
type apple1\cow.txt

:: Voeg de inhoud van cow.txt onderaan toe aan manycows.txt
type apple1\cow.txt >> apple3\manycows.txt
:: #endregion cli-echo-type-output-redirection

:: #region cli-copy-move-rename-of-ren
:: Kopieer een bestand onder een nieuwe naam
copy apple1\cow.txt apple2\notacow.txt

:: Hernoem een bestand
rename apple2\notacow.txt reallyacow.txt

:: Verplaats een bestand naar een andere map
move apple3\manycows.txt apple2
:: #endregion cli-copy-move-rename-of-ren

:: #region cli-del-of-erase-rmdir-of-rd
:: Verwijder een bestand direct (zonder bevestiging)
del apple2\manycows.txt

:: Verwijder een bestand veilig met bevestigingsvraag
del /p apple2\manycows.txt

:: Verwijder een niet-lege map inclusief alle submappen
rmdir /s one
:: #endregion cli-del-of-erase-rmdir-of-rd

:: #region cli-findstr-find
:: Zoek een woord in een specifiek bestand of in alle bestanden (*) in de huidige map
findstr "moo" notacow.txt
findstr "keyword" *

:: Combineer dir met findstr via pipes om paden te filteren
dir /s /b | findstr apple | findstr .txt

:: Tel het aantal gevonden .txt-bestanden met find /c
dir /s /b | findstr apple | findstr .txt | find /c ".txt"
:: #endregion cli-findstr-find

:: #region cli-doskey-history
:: Bekijk de commandogeschiedenis van het huidige venster
doskey /history
:: #endregion cli-doskey-history

:: #region cli-systeminfo-tasklist-date-time
:: Toon OS, versie, hotfixes, geheugen en processor
systeminfo
:: Toon alle actieve processen met PID
tasklist
:: /v voegt gebruiker, status en venstertitel toe
tasklist /v
:: /t toont alleen de datum, zonder te vragen om een nieuwe
date /t
time /t
:: #endregion cli-systeminfo-tasklist-date-time

:: #region cli-sc-more
:: Bekijk alle actieve services en drivers pagina voor pagina
sc query | more

:: Controleer de status van een specifieke service via de interne servicenaam (niet de weergavenaam)
sc query wscsvc
:: #endregion cli-sc-more

:: #region cli-net-share-user-localgroup-accounts
:: Toon alle subcommando's van net
net

:: Toon alle gedeelde mappen, inclusief verborgen administratieve shares (C$, IPC$, ADMIN$)
net share

:: Toon alle lokale gebruikersaccounts (of bekijk help met: net help user)
net user

:: Toon alle lokale groepen (elke groepsnaam begint met een *)
net localgroup

:: Bekijk het ingestelde wachtwoord- en vergrendelingsbeleid
net accounts

:: Tel nauwkeurig het aantal lokale groepen en verborgen shares met find /c
net localgroup | find /c "*"
net share | find /c "$"
:: #endregion cli-net-share-user-localgroup-accounts

:: #region cli-ipconfig-for-l-ping-sweep-ping-nslookup
:: Bekijk IP-adres, subnetmasker en default gateway
ipconfig

:: Ping sweep over een volledig /24-subnet (vervang x.y.z door de eerste 3 octetten)
for /L %a in (1,1,255) do @ping -n 1 -w 10 x.y.z.%a > nul && echo x.y.z.%a is up!

:: Test externe connectiviteit en DNS-resolutie via Google DNS (8.8.8.8)
ping 8.8.8.8
nslookup www.moo.com 8.8.8.8

:: Bekijk actieve netwerkverbindingen en luisterende poorten
netstat -ant
:: #endregion cli-ipconfig-for-l-ping-sweep-ping-nslookup

:: #region scenario-1-stap-1
:: Lijst alle bestanden recursief met volledig pad (/s = submappen, /b = kaal formaat)
dir /s /b
:: #endregion scenario-1-stap-1

:: #region scenario-1-stap-2
:: Filter de paden die "apple" bevatten en daarvan de .txt-bestanden (| stuurt uitvoer door naar het volgende commando)
dir /s /b | findstr apple | findstr .txt
:: #endregion scenario-1-stap-2

:: #region scenario-1-stap-3
:: Tel de overgebleven regels met find /c
dir /s /b | findstr apple | findstr .txt | find /c ".txt"
:: #endregion scenario-1-stap-3

:: #region scenario-2-stap-1
:: Welke gebruiker ben ik en welk systeem is dit?
whoami
systeminfo
:: #endregion scenario-2-stap-1

:: #region scenario-2-stap-2
:: Accounts, groepen, wachtwoordbeleid en gedeelde mappen
net user
net localgroup
net accounts
net share
:: #endregion scenario-2-stap-2

:: #region scenario-2-stap-3
:: Processen met gebruiker, services en netwerkverbindingen
tasklist /v
sc query | more
netstat -ant
:: #endregion scenario-2-stap-3

:: #region scenario-2-stap-4
:: Netwerkconfiguratie en een ping sweep om actieve hosts te vinden
ipconfig
for /L %a in (1,1,255) do @ping -n 1 -w 10 10.91.17.%a > nul && echo 10.91.17.%a is up!
:: #endregion scenario-2-stap-4
