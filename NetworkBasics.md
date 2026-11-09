# Network basics

## Debugging a network

The first step in troubleshooting a network issue is to ensure the default gateway is correct and to test connectivity to that gateway. 

```bash
ping -c 4 192.168.0.1
```
Check the configuration of the network interface 
```bash
cat /etc/network/interfaces
```

Confirm the gateway
```bash
netstat -rn
```

## ARP

### Display all cached ARP entries.

```bash
arp -a
```

ARP entries are only stored for the local network. When pinging a device outside of the local subnet, it only stores the MAC+IP information of the router that's in between networks (gateway)

### Example of a simple ARP request

Device 1 and Device 2 are on the same subnet. 
D1 pings D2 through it's IP. 
What actually happens is that D1 sends an ARP-request through the network with destination Broadcast.
This arrives at all devices in the subnet.
The message in this request is "Who has a certain IP, tell the device with this IP".
D2 responds directly to the D1 IP with it's MAC address.
D2 then sends a similar ARP request to D1 (Not broadcast) because it expects D1 to send more traffic.
D1 responds with its MAC address.

### Example of a slightly more complex ARP request (between two subnets)

Device 1 and Device 3 are on a different subnet. 
The subnets are connected through a mutual router device. 
D1 pings D3.
This time D1 sends a similar ARP-request through the network with destination Broadcast.
But it's the router that responds with its own MAC address.
The router than sends an ARP-request to D1.
D1 responds with its MAC address to the router.

