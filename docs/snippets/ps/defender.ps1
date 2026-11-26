#region defender
# Scan één specifieke map: -ScanType CustomScan combineert met -ScanPath (vereist een verhoogde sessie)
Start-MpScan -ScanPath C:\Evil\ -ScanType CustomScan

# Werk eerst de virusdefinities bij
Update-MpSignature
# QuickScan controleert alleen de plekken waar malware vaak zit; FullScan scant alles
Start-MpScan -ScanType QuickScan

# Is real-time protection aan en hoe recent zijn de signatures?
Get-MpComputerStatus | Select-Object RealTimeProtectionEnabled, AntivirusSignatureLastUpdated
# Toon de uitgesloten mappen; onverwachte uitsluitingen zijn verdacht
(Get-MpPreference).ExclusionPath
# Verwijder een uitsluiting
Remove-MpPreference -ExclusionPath "C:\Evil"
# Toon de detectiegeschiedenis
Get-MpThreatDetection
#endregion defender
