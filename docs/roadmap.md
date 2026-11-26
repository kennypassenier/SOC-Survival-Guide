# Roadmap

Onderwerpen die in de kennisbank nog ontbreken en die je als SOC-analist in de praktijk nodig hebt. De pagina's worden geschreven aan de hand van de wekelijkse cursusvoortgang. De lopende aantekeningen staan op [Work in progress](/Work_In_Progress).

## Status

| Onderwerp | Status | Doel |
| :--- | :--- | :--- |
| Incident response | <Badge type="warning" text="Gepland" /> | Fases, triage-checklist, containment en communicatie |
| Logging & detectie | <Badge type="warning" text="Gepland" /> | Windows Event ID's, Sysmon, syslog en wat je daarin zoekt |
| MITRE ATT&CK | <Badge type="warning" text="Gepland" /> | Tactieken en technieken als vocabulaire voor detecties |
| IDS Basics | <Badge type="info" text="In uitwerking" /> | Snort, regels en packet captures |
| Patching Basics | <Badge type="info" text="In uitwerking" /> | Windows, Linux en containers |
| Vulnerability Scanner Basics | <Badge type="warning" text="Gepland" /> | Scannen, prioriteren en rapporteren |
| Python Basics | <Badge type="warning" text="Gepland" /> | Scripts voor analyse en automatisering |
| Firewall Basics (herziening) | <Badge type="info" text="In uitwerking" /> | Uitbreiden met regelbeheer en logging |

## Wat per onderwerp erin komt

### Incident response

- De fases: voorbereiding, detectie, containment, eradication, recovery en lessons learned.
- Een triage-checklist voor een verdacht systeem, met verwijzingen naar de CLI-referentie.
- Wat je bewaart als bewijs en in welke volgorde je data verzamelt.

### Logging & detectie

- Belangrijke Windows Event ID's, zoals 4624 en 4625 (aanmelden), 4688 (procescreatie) en 7045 (service-installatie).
- Linux-logs: `auth.log`, `syslog` en het systemd-journal.
- Sysmon en wat het toevoegt aan standaardlogging.

### MITRE ATT&CK

- De tactieken van Initial Access tot Impact.
- Hoe bestaande pagina's aansluiten, bijvoorbeeld [Windows Services](/windows/windows-services) bij persistence en privilege escalation.

## Verbeteringen aan bestaande pagina's

- [Access Control](/security/access-control-basics), [Firewall](/security/firewall-basics) en de cryptografiepagina's verder uitbreiden.
- Diagrammen toevoegen aan [Packet Lifecycle](/networking/packet-lifecycle).
- Een glossarium met afkortingen (AGDLP, LSDOU, PDU, SAM, ACE).

::: tip
Een onderwerp dat gereed is, verhuist van deze lijst naar de zijbalk van de juiste sectie.
:::
