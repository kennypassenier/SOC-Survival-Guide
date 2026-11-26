# Antivirus & Endpoint Security

Antivirus detecteert en blokkeert malware op een endpoint. Moderne producten combineren meerdere detectiemethoden en sturen telemetrie naar een centrale console.

## Concepts

### Detectietechnieken

| Techniek | Werking | Voor- en nadelen |
| :--- | :--- | :--- |
| **Signature-based** | Zoekt naar bekende hashes en patronen | Snel en weinig false positives, maar mist onbekende malware |
| **Heuristisch** | Beoordeelt code en gedrag, vaak in een sandbox | Vindt onbekende varianten, maar vraagt meer resources |
| **Behavior-based** | Bewaakt acties in real time | Sterk tegen polymorfe malware, vereist een goede baseline |
| **Machine learning** | Modellen getraind op grote datasets, vaak in de cloud | Proactief, afhankelijk van telemetrie |

### Quarantaine en uitsluitingen

- Verdachte bestanden gaan naar **quarantaine**: ze worden geïsoleerd en kunnen niet meer worden uitgevoerd.
- **Exclusions** sluiten mappen of processen uit van scans. Aanvallers voegen soms een exclusion toe om hun tools te beschermen.

::: warning Controleer exclusions
Een uitsluiting voor een map als `C:\Temp` of `C:\Users\Public` is een rode vlag. Bekijk de lijst met `(Get-MpPreference).ExclusionPath`.
:::

## Commands

Parameters staan in de [Defender-cmdlets](/scripting/powershell#ps-defender).

<<< @/snippets/ps/defender.ps1#defender{powershell}

## SOC use

- Detecties zijn een startpunt, geen eindpunt: zoek naar de aanleiding en andere getroffen hosts.
- Uitgeschakelde real-time protection of verouderde signatures is zelf een bevinding.
- Combineer met [Windows Services](/windows/windows-services) en het register voor persistence-checks.
