:: #region network
:: Controleer lokale netwerkinstellingen, DNS-resolutie en route naar doelhost
ipconfig /all
nslookup google.com
tracert 8.8.8.8

:: Toon alle actieve verbindingen en poorten numeriek (plus PID met -ano)
netstat -ant
netstat -ano

:: Voer een ping sweep uit over een volledig /24-subnet vanuit CMD
for /L %a in (1,1,255) do @ping -n 1 -w 10 10.91.17.%a > nul && echo 10.91.17.%a is up!

:: Voeg een inkomende Windows Firewall-regel toe voor SSH (TCP 22)
netsh advfirewall firewall add rule name="Allow SSH" dir=in action=allow protocol=TCP localport=22
:: #endregion network

:: #region gpo
:: Forceer onmiddellijke verversing van alle Group Policies
gpupdate /force

:: Genereer een gedetailleerd RSoP-overzicht in de console of als HTML-rapport
gpresult /Z
gpresult /H C:\Temp\rsop.html
:: #endregion gpo
