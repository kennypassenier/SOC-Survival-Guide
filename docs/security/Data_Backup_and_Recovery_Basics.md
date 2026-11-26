# Data Backup and Recovery Basics

Strategieën voor back-up, herstel, RPO en Business Continuity.

## 1. Commando's & Windows Server Backup

### Windows Server Backup (`wbadmin`)
* **`Install-WindowsFeature`**: Installeert de backup-functie via PowerShell.
* **`wbadmin start backup`**: Voert een eenmalige back-up uit.
* **`wbadmin.msc`**: Opent de grafische back-upconsole.

<<< @/snippets/ps/system.sh#backup{powershell}

## 2. Back-up Typen

| Type | Wat wordt opgeslagen? | Herstelbenodigdheid |
| :--- | :--- | :--- |
| **Full** | Alle geselecteerde data. | Alleen de laatste Full back-up. |
| **Differential** | Wijzigingen sinds de laatste Full back-up. | Laatste Full + laatste Differential. |
| **Incremental** | Wijzigingen sinds de vorige back-up. | Laatste Full + alle Incremental back-ups. |
| **Bare Metal** | Het volledige systeem (OS, apps, data). | Herstel naar nieuwe hardware. |

## 3. Best Practices & De 3-2-1-1-0 Regel
- **3** kopieën van data, op **2** verschillende media, waarvan **1** extern (*offsite*), **1** *offline/immutable* (tegen ransomware), met **0** fouten na tests.
- **RPO (Recovery Point Objective)**: Maximale acceptabele hoeveelheid dataverlies in tijd.
