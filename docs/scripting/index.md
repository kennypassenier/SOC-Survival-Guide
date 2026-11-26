# CLI Referentie

De drie shells die je als SOC-analist het vaakst gebruikt.

| Shell | Gebruik je op | Sterk in |
| :--- | :--- | :--- |
| [PowerShell](/scripting/powershell) | Windows (ook Linux en macOS via `pwsh`) | Objecten in de pipeline, Active Directory, Defender, event logs, remote triage |
| [BASH](/scripting/bash) | Linux, macOS, WSL | Tekstverwerking met pipes, logs, netwerk, recon, cryptografie |
| [CMD](/scripting/cmd) | Windows, ook op systemen zonder PowerShell | Legacy-omgevingen, `net`, `sc`, `icacls`, korte one-liners |

## Equivalenten per taak

Wat je op het ene platform doet, heeft meestal een directe tegenhanger op het andere. Gebruik deze tabel om snel te schakelen tijdens een onderzoek.

| Taak | PowerShell | BASH | CMD |
| :--- | :--- | :--- | :--- |
| Huidige gebruiker en groepen | `whoami /groups` | `id` | `whoami /groups` |
| Hulp bij een commando | `Get-Help` | `man`, `--help` | `help` |
| Bestanden tonen | `Get-ChildItem` | `ls -la` | `dir` |
| Tekst zoeken in bestanden | `Select-String` | `grep` | `findstr` |
| Bestandshash berekenen | `Get-FileHash` | `sha256sum` | `certutil -hashfile` |
| Processen tonen | `Get-Process` | `ps aux` | `tasklist` |
| Services beheren | `Get-Service` | `systemctl` | `sc` |
| Logs onderzoeken | `Get-WinEvent` | `journalctl` | `wevtutil` |
| Rechten bekijken | `Get-Acl` | `ls -l`, `getfacl` | `icacls` |
| IP-configuratie | `Get-NetIPConfiguration` | `ip a` | `ipconfig /all` |
| Poort of verbinding testen | `Test-NetConnection` | `nc -zv` | `telnet`, `ping` |
| Open verbindingen | `Get-NetTCPConnection` | `ss -tulpn` | `netstat -ano` |
| DNS opvragen | `Resolve-DnsName` | `dig`, `nslookup` | `nslookup` |
| Gebruikers beheren | `Get-LocalUser` | `useradd`, `usermod` | `net user` |

## Voorbeelden naast elkaar

Dezelfde taak in drie shells. Kies het tabblad van het platform dat je onderzoekt.

### Bestandshash berekenen

::: code-group

<<< @/snippets/ps/file.ps1#hash{powershell} [PowerShell]

<<< @/snippets/bash/security.sh#hashes{bash} [BASH]

<<< @/snippets/cmd/processing.bat#certutil{cmd} [CMD]

:::

### Logs onderzoeken

::: code-group

<<< @/snippets/ps/os-management.ps1#eventlogs{powershell} [PowerShell]

<<< @/snippets/bash/os-management.sh#logs{bash} [BASH]

<<< @/snippets/cmd/os-management.bat#eventlog{cmd} [CMD]

:::

### Netwerkverbindingen bekijken

::: code-group

<<< @/snippets/ps/network.ps1#connections{powershell} [PowerShell]

<<< @/snippets/bash/network.sh#connections{bash} [BASH]

<<< @/snippets/cmd/network.bat#network-extra{cmd} [CMD]

:::

## Wat is waar te vinden

- **Identiteit en rechten:** wie ben ik, wat mag ik, hoe wissel ik van account.
- **Bestanden en tekstverwerking:** navigeren, zoeken, filteren, hashen en encoderen.
- **Systeembeheer:** processen, services, logs, schijven en het register.
- **Netwerk en security:** interfaces, DNS, firewallregels, VPN, recon en packet capture.
- **Active Directory en Group Policy:** alleen in PowerShell en CMD.
- **Patchbeheer, IDS en scripting:** in BASH en PowerShell.

::: tip Kies de juiste shell
Begin bij de shell van het systeem dat je onderzoekt. Op Windows geeft PowerShell objecten terug die je kunt filteren en sorteren, terwijl CMD volstaat voor een snelle controle of op een kaal systeem.
:::

## Related

De achtergrond bij de commando's staat op de themapagina's: [Windows CLI Basics](/windows/windows-cli-basics), [Linux CLI Basics](/linux/linux-cli-basics) en [Network Troubleshooting](/networking/network-troubleshooting-basics).
