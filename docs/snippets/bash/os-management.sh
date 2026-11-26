#region logs
sudo who
sudo last
sudo last -n 20 -a
sudo lastb
sudo journalctl -f
sudo journalctl -u sshd
#endregion logs

#region process
ps -e
ps aux | grep sshd
ls -la /proc/1
#endregion process

#region systemctl
systemctl list-units --type=service
systemctl status sshd
sudo systemctl start sshd
sudo systemctl stop sshd
sudo systemctl restart sshd
#endregion systemctl

#region disk
sudo fdisk -l | grep dev | grep -v loop
sudo df -h
lsblk
lsblk -f
du -sh /var/log/*
#endregion disk
