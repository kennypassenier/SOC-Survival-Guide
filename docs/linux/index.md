# Linux

Linux draait de meeste servers, firewalls en security-appliances. Deze sectie bevat de basis om een systeem te verkennen en logs te lezen.

## Onderwerpen

| Pagina | Inhoud | Wanneer gebruiken |
| :--- | :--- | :--- |
| [Linux CLI Basics](/linux/linux-cli-basics) | Navigatie, bestandsbeheer, pagers en redirection | Dagelijks werken in de shell |
| [Linux File System](/linux/linux-file-system-basics) | Mappenstructuur (FHS), gebruikers, rechten en schijven | Weten waar logs en configuratie staan |

## Belangrijke locaties

| Pad | Inhoud |
| :--- | :--- |
| `/var/log` | Logbestanden, zoals `auth.log` en `syslog` |
| `/etc` | Systeem- en serviceconfiguratie |
| `/home` | Persoonlijke mappen van gebruikers |
| `/tmp` | Tijdelijke bestanden, vaak gebruikt door malware |
| `/proc` | Live informatie over processen en kernel |

## Related

- [BASH Referentie](/scripting/bash) voor alle commando's per taak.
- [Firewall Basics](/security/firewall-basics) voor `iptables`.
- [Cryptografie](/security/cryptography-basics) voor OpenSSL.
