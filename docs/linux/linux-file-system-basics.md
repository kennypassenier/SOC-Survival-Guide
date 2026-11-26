# Linux File System

Alles in Linux is een bestand, en alles hangt onder één root (`/`). Weten waar logs, configuratie en gebruikersdata staan, is de basis voor elk onderzoek.

## Concepts

### Mappenstructuur (FHS)

| Pad | Inhoud |
| :--- | :--- |
| `/` | De root van het bestandssysteem |
| `/etc` | Systeem- en serviceconfiguratie |
| `/var/log` | Logbestanden, zoals `auth.log` en `syslog` |
| `/home` | Persoonlijke mappen van gebruikers |
| `/root` | Home-map van root |
| `/tmp` | Tijdelijke bestanden, vaak gebruikt door malware |
| `/proc` | Live informatie over processen en de kernel |
| `/bin`, `/usr/bin` | Uitvoerbare programma's |
| `/dev` | Apparaatbestanden |
| `/mnt`, `/media` | Koppelpunten voor schijven |

### Rechten

`ls -l` toont rechten als `-rwxr-x---`: eigenaar, groep en anderen, elk met lezen (`r`), schrijven (`w`) en uitvoeren (`x`).

| Modus | Betekenis | Gebruik |
| :--- | :--- | :--- |
| `600` | Alleen de eigenaar leest en schrijft | Privé sleutels |
| `644` | Eigenaar schrijft, anderen lezen | Gewone bestanden |
| `750` | Eigenaar alles, groep lezen en uitvoeren | Scripts en mappen |
| `777` | Iedereen alles | Vermijden |

::: warning SUID en SGID
Bestanden met het SUID-bit draaien met de rechten van de eigenaar. Onverwachte SUID-bestanden zijn een bekende route naar privilege escalation.
:::

### Gebruikers en schijven

- Accounts staan in `/etc/passwd`, wachtwoordhashes in `/etc/shadow`.
- `sudo` verhoogt rechten per commando, `su` wisselt van gebruiker.
- Schijven en partities bekijk je met `lsblk` en `fdisk -l`.

## Commands

Parameters staan in de [BASH-referentie](/scripting/bash): [Navigatie](/scripting/bash#sh-navigatie), [Gebruikers](/scripting/bash#sh-gebruikers) en [Schijven](/scripting/bash#sh-schijven).

::: code-group

<<< @/snippets/bash/file.sh#structure{bash} [Structuur]

<<< @/snippets/bash/system.sh#users{bash} [Gebruikers]

<<< @/snippets/bash/os-management.sh#disk{bash} [Schijven]

:::
