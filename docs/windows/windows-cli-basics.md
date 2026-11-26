# Windows CLI Basics

De klassieke Windows-opdrachtregel voor navigatie, bestandsbeheer, systeeminformatie en netwerkdiagnose.

## Concepts

### Historie van Windows: Van PC-DOS naar PowerShell
* **1981 (PC-DOS / MS-DOS):** Microsoft ontwikkelde PC-DOS (*Disk Operating System*) als herwerking van *86-DOS* van Seattle Computer Products. Net als zijn voorganger CP/M was DOS volledig command-line-gestuurd zonder GUI of muisondersteuning.
* **1992 (Windows 3.1):** Introduceerde een grafische gebruikersinterface (GUI) met muis- en toetsenbordbediening, maar draaide nog steeds bovenop DOS als onderliggend besturingssysteem.
* **1995 (Windows 95):** De eerste Windows-versie die niet langer afhankelijk was van DOS als losstaand onderliggend OS, al bleef de DOS-opdrachtprompt behouden als standaard CLI.
* **Vandaag (PowerShell & CMD):** **PowerShell** heeft de klassieke Command Prompt grotendeels vervangen voor systeembeheer en automatisering. Toch blijft `cmd.exe` veelgebruikt voor snelle opdrachten, batchscripts en tijdens Red Team- of aanvalsanalyses waarbij ingebouwde systeemtools worden misbruikt (**"Living off the Land"** / LOLBins).

### Windows CLI vs. Linux CLI
* **Overeenkomsten:** Commando's zoals `cd`, `echo`, `more` en `mkdir` bestaan in beide werelden (al verschillen hun switches: Windows gebruikt meestal `/` zoals `/s`, terwijl Linux `-` of `--` gebruikt).
* **Windows-specifieke beheertools:** Hulpprogramma's zoals `net`, `tasklist` en `sc` zijn specifiek ontworpen voor de Windows-architectuur (services, lokale SAM-accounts en SMB-shares).
* **Hoofdlettergevoeligheid:** Bestandspaden en commando-switches in Windows zijn over het algemeen **niet hoofdlettergevoelig** (`dir /S /P` is gelijk aan `dir /s /p`), met enkele uitzonderingen zoals `findstr` (dat standaard wel hoofdlettergevoelig zoekt).

## Commands

De commando's voor dit onderwerp staan in de referentiepagina's, met parameters en voorbeelden:

- [cmd](/scripting/cmd#cmd-cmd)
- [whoami](/scripting/cmd#cmd-whoami)
- [help](/scripting/cmd#cmd-help)
- [cd](/scripting/cmd#cmd-cd)
- [dir](/scripting/cmd#cmd-dir)
- [tree](/scripting/cmd#cmd-tree)
- [mkdir (of md)](/scripting/cmd#cmd-mkdir-of-md)
- [echo, type & Output Redirection (>, >>)](/scripting/cmd#cmd-echo-type-output-redirection)
- [copy, move & rename (of ren)](/scripting/cmd#cmd-copy-move-rename-of-ren)
- [del (of erase) & rmdir (of rd)](/scripting/cmd#cmd-del-of-erase-rmdir-of-rd)
- [findstr & find](/scripting/cmd#cmd-findstr-find)
- [doskey /history](/scripting/cmd#cmd-doskey-history)
- [systeminfo, tasklist, date & time](/scripting/cmd#cmd-systeminfo-tasklist-date-time)
- [sc & more](/scripting/cmd#cmd-sc-more)
- [net (share, user, localgroup, accounts)](/scripting/cmd#cmd-net-share-user-localgroup-accounts)
- [ipconfig, for /L Ping Sweep, ping, nslookup & netstat](/scripting/cmd#cmd-ipconfig-for-l-ping-sweep-ping-nslookup)

## Scenarios

### Scenario 1: Bestanden Zoeken, Filteren & Tellen via Pipes in CMD
Wanneer je op een Windows-systeem snel specifieke bestanden in een diepe mappenstructuur wilt opsporen zonder Verkenner te gebruiken:

1. **Genereer een kale lijst van alle paden en submappen:**
   <<< @/snippets/cmd/windows-cli-basics.bat#scenario-1-stap-1{cmd}
2. **Filter de uitvoer stapsgewijs met `findstr`:**
   <<< @/snippets/cmd/windows-cli-basics.bat#scenario-1-stap-2{cmd}
   * *Valkuil:* Vergeet niet dat `findstr` hoofdlettergevoelig is; gebruik `findstr /i` als bestandsnamen hoofdletters kunnen bevatten.
3. **Tel het aantal gevonden overeenkomsten met `find /c`:**
   <<< @/snippets/cmd/windows-cli-basics.bat#scenario-1-stap-3{cmd}

### Scenario 2: Lokale Systeem- & Netwerkverkenning (Triage / Red Team "Living off the Land")
Een gestandaardiseerd overzicht om een Windows-host snel in kaart te brengen met uitsluitend ingebouwde CMD-tools:

1. **Controleer gebruikersidentiteit en systeemdetails:**
   <<< @/snippets/cmd/windows-cli-basics.bat#scenario-2-stap-1{cmd}
2. **Inventariseer lokale gebruikers, groepen, wachtwoordbeleid en gedeelde mappen:**
   <<< @/snippets/cmd/windows-cli-basics.bat#scenario-2-stap-2{cmd}
   * *Aandachtspunt:* Let bij `net share` op standaard administratieve shares (`C$`, `IPC$`, `ADMIN$`) én eventuele niet-standaard shares die door beheerders zijn aangemaakt.
3. **Controleer actieve processen, services en netwerkverbindingen:**
   <<< @/snippets/cmd/windows-cli-basics.bat#scenario-2-stap-3{cmd}
4. **Voer lokale netwerkdiscovery uit op het actieve subnet:**
   <<< @/snippets/cmd/windows-cli-basics.bat#scenario-2-stap-4{cmd}

## References

* **Interne Commandoreferenties (SOC Analyst Map):**
  * Zie `CMD.md` voor het volledige, categorische overzicht van alle Windows Command Prompt-commando's, switches en permutaties.
  * Zie `PowerShell.md` en `BASH.md` voor de moderne PowerShell-cmdlets en Linux-equivalenten.
* **Officiële Documentatie & Security Referenties:**
  * [Microsoft Learn: Windows Commands Reference](https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/windows-commands) — Officiële documentatie voor alle `cmd.exe`-commando's en switches.
  * [LOLBAS Project (Living Off The Land Binaries, Scripts and Libraries)](https://lolbas-project.github.io/) — Overzicht voor SOC-analisten van ingebouwde Windows-tools (`cmd.exe`, `certutil.exe`, `net.exe`, `sc.exe`) en hoe deze door aanvallers kunnen worden misbruikt.
