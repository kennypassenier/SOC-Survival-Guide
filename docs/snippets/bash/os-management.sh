#region logs
# Wie is er nu aangemeld?
sudo who
# Aanmeldgeschiedenis uit /var/log/wtmp
sudo last
# -n 20: laatste 20 regels; -a: toon het hostadres in de laatste kolom
sudo last -n 20 -a
# Mislukte aanmeldpogingen (brute-force sporen)
sudo lastb
# Volg het systemd-journal live (-f = follow)
sudo journalctl -f
# Toon alleen de logs van de SSH-service (-u = unit)
sudo journalctl -u sshd
#endregion logs

#region process
# Alle processen (-e = every process)
ps -e
# Processen met gebruiker en resourcegebruik (aux), gefilterd op sshd
ps aux | grep sshd
# Live informatie van proces 1 (init/systemd) uit het /proc-bestandssysteem
ls -la /proc/1
#endregion process

#region systemctl
# Toon alle services (--type=service)
systemctl list-units --type=service
# Status, laatste logregels en PID van de SSH-service
systemctl status sshd
# Start, stop en herstart de service
sudo systemctl start sshd
sudo systemctl stop sshd
sudo systemctl restart sshd
#endregion systemctl

#region disk
# Toon partities en laat apparaten met "loop" (snap-images) weg
sudo fdisk -l | grep dev | grep -v loop
# -h: toon groottes leesbaar (GB, MB)
sudo df -h
# Blokapparaten en hun koppelpunten als boom
lsblk
# -f: voeg het bestandssysteem, label en UUID toe
lsblk -f
# -s: toon alleen het totaal per item, -h: leesbaar
du -sh /var/log/*
#endregion disk

#region logs-extended
# --since filtert op tijd; ook "today" of "2026-01-01 08:00" werkt
sudo journalctl --since "1 hour ago"
# -p err: alleen fouten en erger. -b: alleen sinds de laatste boot
sudo journalctl -p err -b
# --no-pager schrijft alles naar de terminal, handig om door te pipen of op te slaan
sudo journalctl -u sshd --since today --no-pager
# -x: toon ook systeemherstarts en afsluitingen in de aanmeldgeschiedenis
sudo last -x
# --sort=-%mem sorteert aflopend op geheugengebruik; head -10 toont de top 10
ps aux --sort=-%mem | head -10
# -eo kiest de kolommen (pid, ouder-pid, gebruiker, commando); --forest tekent de proces-boom
ps -eo pid,ppid,user,cmd --forest
# lsof -i toont open netwerkverbindingen met het proces; -P en -n slaan poort- en hostnaamopzoeking over
sudo lsof -i -P -n
#endregion logs-extended

#region persistence
# Cron-taken van de huidige gebruiker
crontab -l
# Systeembrede cron-taken
sudo ls -la /etc/cron.d /etc/cron.daily
# Geplande systemd-timers, ook inactieve (--all)
systemctl list-timers --all
# Alle services die bij het opstarten starten
systemctl list-unit-files --state=enabled
# Publieke SSH-sleutels die zonder wachtwoord mogen aanmelden; onbekende sleutels zijn een persistence-indicator
cat ~/.ssh/authorized_keys
#endregion persistence
