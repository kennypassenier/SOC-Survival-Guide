# Nmap

Full-open or Connect scan.
Completes the TCP handshake, then terminates the connection.
(SYN, SYN/ACK, ACK, ACK, RST)
```bat
nmap -sT [ip]
nmap [ip] <-- non sudo default
```

SYN stealth scan or half-open scan.
Begins and then abruptly ends the 3-way handshake with a reset packet.
(SYN, SYN/ACK, RST)
If the connection doesn't complete, it's less likely to be logged on the target device.
Faster and lower bandwidth compared to the full-open/connect scan.
```bat
nmap -sS [ip]
sudo nmap [ip] <-- sudo default
```

## Arguments

Scan ports. Either single, range or comma-separated list.
```bat
-p [port]
```

Top ports. Only scan N-amount of ports (starting from 1)
```bat
--top-ports [amount]
-F <-- Fast or top 100 ports
```

Host discovery. 
Disables port-scanning.
```bat
-sn 
```

Disable host discovery
Treats all hsots as online.
```bat
-Pn 
```

OS and service fingerprinting
Tries to determine the OS or service based on their fingerprint. 
```bat
-O
-osscan-guess <-- more aggressive guesses
```

Network service and version detection.
Provide additional information about the host OS, identify vulnerable services
```bat
-sV
```

Timing.
Determine how long your scans take. 
0 is paranoid and the slowest
1 is sneaky
2 is polite
3 is normal
4 is aggressive
5 is insane and the fastest
```bat
-T[0-5]
```
