# Network Troubleshooting Basics

## Steps used in exercise: 

### Exercise 1
´´´bash 
ip a
netstat -r
ping -c 4 1912.168.1.1
ping -c 4 8.8.8.8
ping -c 4 www.google.com
cat /etc/network/interfaces
cat /etc/resolv.conf
cat "nameserver 1922.168.1.5" > /etc/resolv.conf
ping -c 4 www.google.com
´´´
### Exercise 2
```bash
udhcpc

```
Enable the DHCP server in pfsense
### Exercise 3
```bash
smbclient -L FILESERVER -U cybrary
ping FILESERVER
```
Add an A record to the clab.local dns zone
On the client pc, add the following to the /etc/resolv.conf file
````bash
echo "search clab.local" >> /etc/resolv.conf
smbclient -L FILESERVER -U cybrary <--- list the available smb shares as user cybrary 
```
### Exercise 4
```bash
echo "192.168.1.20 FILESERVER" >> /etc/hosts
```
Turn on IPSEC tunnel in pfsense to resolve the issue
