#region snort-run
# Sniffer-modus (standaard)
sudo snort

# Valideer het configuratiebestand (-T = test, -c = configuratiebestand)
sudo snort -T -c /etc/snort/snort.conf

# Intrusion detection-modus
sudo snort -c /etc/snort/snort.conf
#endregion snort-run

#region snort-pcap
# Analyseer een packet capture (-r = lees uit bestand)
sudo snort -c /etc/snort/snort.conf -r sample.pcap

# Stille modus (-q) met alerts op de console (-A console)
sudo snort -q -A console -c /etc/snort/snort.conf -r sample.pcap

# Filter de alerts op ICMP-pings
sudo snort -q -A console -c /etc/snort/snort.conf -r pcaps/apple.pcap | grep ICMP | grep PING

# Schrijf logs naar een map (-l) in plaats van naar de console
sudo snort -c /etc/snort/snort.conf -r sample.pcap -l /home/cybrary/Desktop
#endregion snort-pcap

#region snort-rules
# Voeg eigen regels toe
sudo nano /etc/snort/rules/local.rules

# Live luisteren op een interface (-i) met uitsluitend local.rules
sudo snort -q -A console -c /etc/snort/rules/local.rules -i eth0

# Testverkeer genereren richting de HTTP-server
wget http://192.168.0.20
#endregion snort-rules

#region snort-u2spewfoo
# Lees Snort-logs in unified2-formaat uit
sudo u2spewfoo snort.log
#endregion snort-u2spewfoo
