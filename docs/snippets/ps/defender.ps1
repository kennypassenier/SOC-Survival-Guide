#region defender
# Voer een gerichte Custom Scan uit op een specifieke map (vereist Admin)
Start-MpScan -ScanPath C:\Evil\ -ScanType CustomScan

# Werk signatures bij en start een snelle systeemscan
Update-MpSignature
Start-MpScan -ScanType QuickScan

# SOC Triage: controleer Defender-status, exclusions en detectiegeschiedenis
Get-MpComputerStatus | Select-Object RealTimeProtectionEnabled, AntivirusSignatureLastUpdated
(Get-MpPreference).ExclusionPath
Remove-MpPreference -ExclusionPath "C:\Evil"
Get-MpThreatDetection
#endregion defender
