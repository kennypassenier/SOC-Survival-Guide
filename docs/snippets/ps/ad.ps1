#region gpo-cmdlets
# Native cmdlets uit de GroupPolicy-module
Invoke-GPUpdate -Force
Get-GPResultantSetOfPolicy -ReportType Html -Path "C:\Tempsop.html"
#endregion gpo-cmdlets
