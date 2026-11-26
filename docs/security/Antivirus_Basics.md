# Antivirus Basics

Endpoint security, malwaredetectie en Windows Defender.

## 1. Commando's & Scans

### Microsoft Defender via PowerShell
* **`Start-MpScan`**: Start een handmatige malwarescan (`-ScanPath` en `-ScanType`).
* **`Update-MpSignature`**: Werkt virusdefinities bij.
* **`Get-MpComputerStatus`**: Toont de Defender-status.

<<< @/snippets/ps/defender.ps1#scan{powershell}

## 2. Malwaredetectie Technieken

| Techniek | Werking | Voor- en Nadelen |
| :--- | :--- | :--- |
| **1. Signature-based** | Zoekt naar bekende hashes/patronen. | Zeer snel, laag false-positive rate; mist zero-days. |
| **2. Heuristic** | Evalueert gedrag en code in een sandbox. | Detecteert onbekende varianten; resource-intensief. |
| **3. Behavior-based** | Monitort acties in real-time. | Sterk tegen polymorfe malware; vereist goede baseline. |
| **4. AI / ML** | Autonome leermodellen in de cloud. | Proactieve bescherming; afhankelijk van telemetrie. |

## 3. Quarantaine & Uitsluitingen
- Verdachte bestanden worden geïsoleerd in **Quarantaine** om verdere verspreiding te voorkomen.
- **Exclusions** sluiten mappen of processen uit van scanning (let op misbruik door aanvallers).
