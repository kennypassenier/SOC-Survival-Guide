# SOC Survival Guide

Persoonlijk naslagwerk voor de SOC-analist: CLI-referenties (PowerShell, BASH, CMD), netwerkmodellen, Windows, Linux, security en tools.

**Site:** <https://kennypassenier.github.io/SOC-Survival-Guide/>

## Inhoud

| Sectie | Onderwerpen |
| :--- | :--- |
| `docs/networking` | OSI- en TCP/IP-model, packet lifecycle, adressering, VPN, troubleshooting |
| `docs/windows` | CLI, bestandssysteem, services, Active Directory, Group Policy |
| `docs/linux` | CLI en bestandssysteem |
| `docs/security` | Access control, firewalls, antivirus, back-up, cryptografie |
| `docs/tools` | Wireshark en Nmap |
| `docs/scripting` | Centrale referenties voor PowerShell, BASH en CMD |
| `docs/snippets` | Herbruikbare codevoorbeelden met `#region`-blokken |

## Lokaal draaien

```powershell
npm install
npm run docs:dev
```

De site draait dan op <http://localhost:5173/SOC-Survival-Guide/>. Met `npm run docs:build` maak je de productiebuild.

## Opzet

- Commando's staan één keer in `docs/snippets/` en worden met `<<< @/snippets/<map>/<bestand>#<regio>{taal}` in de pagina's ingesloten.
- Uitleg en parameters per commando staan in de referenties onder `docs/scripting/`.
- Pushen naar `main` publiceert de site automatisch via GitHub Actions.
