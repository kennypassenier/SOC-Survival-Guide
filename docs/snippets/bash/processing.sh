#region cat
echo "This is file 1" > file1.txt
echo "Appended line" >> file1.txt
cat file1.txt
less -SN /var/log/syslog
sudo tail -f /var/log/syslog
#endregion cat

#region grep
# Filter loopback-devices weg uit schijfuitvoer
sudo fdisk -l | grep dev | grep -v loop

# Zoek naar mislukte SSH-logins in actieve en geroteerde .gz-logs
sudo grep -i "failed password" /var/log/auth.log
sudo zgrep -i "failed password" /var/log/auth.log*.gz
#endregion grep

#region encoding
# Codeer een binair bestand naar Base64 en decodeer terug
base64 message.enc > message.base64
base64 -d message.base64 > message.enc

# Voer een Caesar shift (+5) uit op tekst
echo "Bring Caesar a Salad!" | tr 'A-Za-z' 'F-ZA-Ef-za-e'
#endregion encoding
