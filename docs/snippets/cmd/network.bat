:: #region network-extra
:: Toon elke router (hop) op de route naar de bestemming
tracert 8.8.8.8

:: -a alle verbindingen en poorten, -n numeriek (geen DNS-opzoeking), -o PID van het proces
netstat -ano

:: Maak een inkomende firewallregel; dir = richting, action = allow of block, protocol/localport = verkeer
netsh advfirewall firewall add rule name="Allow SSH" dir=in action=allow protocol=TCP localport=22
:: #endregion network-extra
