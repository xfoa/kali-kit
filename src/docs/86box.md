---
title: Networking using 86Box and VDE in Linux
author: '[foax](mailto:a@fo.ax)'
---

So you've got your favourite old PC running on 86Box, but DOS is a lonely place and you want it to talk to other computers.
Maybe you want to play old multiplayer games?
But networking is haaaaard, especially in Linux.
Don't worry, I got you boo.

# I don't want to read this guide

Cool, run:

```
./start-host-network.sh
```

from the [Kali Kit](https://github.com/xfoa/kali-kit/).
Feel free to come back here if something breaks!
Good luck! 💖

# Prerequisites

This guide assumes you're running 86Box on Linux.
Some of it will also be relevant to other emulators that can use VDE, like [QEMU](https://www.qemu.org/).
All of the host networking side outside of VDE is Linux-specific -- Windows is left as an exercise for the user.

Requirements on the Linux host (most distros will have packages for these):

* [86Box](https://86box.net/) -- The emulator we're running our DOS PC on
* [VDE](https://github.com/virtualsquare/vde-2) -- A program for creating virtual, distributed ethernet switches
* A kernel with [TUN/TAP](https://docs.kernel.org/networking/tuntap.html) support
* [iproute2](https://wiki.linuxfoundation.org/networking/iproute2) -- A suite of programs for confuring networking in Linux, from which we'll be using the `ip` command
* [iptables](https://www.netfilter.org/projects/iptables/index.html)
* [tcpdump](https://www.tcpdump.org/) -- A program that allows us to see packets on a network interface, useful for debugging

We'll use [mTCP](https://www.brutman.com/mTCP/) on the DOS guest to test our set up once we're done.

# 86Box

86Box has a plethora of options for different hardware configurations, and that certainly also applies to network hardware.
For this guide, we'll be using a combination of an emulated Novell NE1000 ISA network adapter, and VDE networking.
Other network adapters will also work, but this was the network card I used in my first PC, so this is what I got working first and tested with.
There are DOS drivers available for many different network adapters on the [Kali Kit](https://fo.ax/kali-kit/) CD.

To give your guest machine an NE1000 network adapter:

1. In 86Box, open `Tools` -> `Settings` -> `Network`.
2. From the `Adapter` drop-down, select `[ISA] Novell NE1000`.
3. We'll leave the `Mode` drop down as `Null Driver` for now.
4. Click `OK` and 86Box will reboot your guest, with a shiny new virtual NE1000 attached.

Now would be a good time to set up the DOS networking drivers. 
Luckily, there's handy a guide for that here: [Installing network drivers and Kali on MS-DOS](install.md).

# To VDE, or not to VDE

Unforunately, 86Box doesn't have a driver for Linux TUN/TAP devices yet (as of time of writing -- maybe you can write one).
Instead, we'll be using VDE distriubted ethernet switch with its own TAP device to connect the guest to the outside world.
The other options are SLiRP and PCAP, but both have been reported to not work as reliably as VDE in Linux.
Windows users will probably be best off with PCAP, though.

::: Aside
**"VDE?
TAP?
What are these things?"**
I hear you ask, slamming your fists down on the keyboard.

Think of VDE like a virtual network switch that programs can plug themselves directly into.
Packets are bridged between everything that's plugged into this "switch".

TAP is a way of getting programs to expose a virtual network interface to Linux.
It has two sides: the Linux interface side, and the program interface side.
I like to think of it like someone sitting at the edge of a lake with their feet in the water: the birds see your head, the fish see your feet; they both see you, even though they live in different worlds and see different parts of you.
A program can send and receive packets on a TAP device using a standard API, and Linux will see that same device as a Linux network interface (like `eth0`, etc.).

What we're going to do here is set up a VDE switch that has both 86Box and the program side of a TAP device plugged into it.
This means that 86Box will be bridged with a virtual interface visible to the OS, and we can use Linux's network tools to set up how traffic is routed from there.
:::

## Turning on the TAP

A handy script is provided in the [Kali Kit repo](https://github/xfoa/kali-kit/) to set up a TAP device on the next available number of a given base name.
E.g. if `86box` is given as a base name, and `86box0` already exists, it will create a TAP interface called `86box1`.
For more information, run:

```
bin/create-tap-device.sh --help
```

If you'd like to set up a TAP device manually, run:

```
ip tuntap add dev 86box0 mode tap user "$USER"
ip link set 86box0 up
ip a add 10.1.0.1/16 dev 86box0
```

The above CIDR is just a suggestion, and it can be any unused private subnet.

## Switching on VDE

We have our TAP device, we're now ready to create our VDE switch.
VDE creates a directory for the switch containing Unix socket files that programs can use to talk to the switch.
It also creates a management socket for the switch.

As for TAP, a handy script is provided to set up a VDE switch.
For more details run:

```
bin/start-vde.sh --help
```

If you'd like to start VDE manually, run:

```
vde_switch --mode 666 --numports 8 --tap 86box0 --mgmt /tmp/vde.86box0.mgmt --mgmtmode 666 -s /tmp/vde.86box0 --daemon
```

You should now have a VDE switch attached to a TAP device! Yay!

## Plugging everything together

We're now ready to connect 86Box to our VDE switch.
To do this:

1. In 86Box, open `Tools` -> `Settings` -> `Network`.
2. From the `Mode` dropdown, select `VDE`.
3. In the `VDE Socket` text box, put the location of the VDE switch folder, e.g. `/tmp/vde.86box0`.
4. Click `OK` and 86Box will reboot the guest.

You should now be able to send packets from DOS to an interface in Linux!
To test this, we'll try sending some IPX and TCP/IP packets from DOS, and see if they appear on the TAP device on the host using `tcpdump`.

First, on the host, run:

```
tcpdump -nnei 86box0
```

You'll probably see some multicast and RA packets from time to time, but these can be ignored.

On the DOS guest, make sure your network drivers and IPX are loaded, then run:

```
cd \DRIVERS\ODI
NETX
```

You should see some IPX packets appear on the TAP interface in `tcpdump`!

Unless you have a Novell NetWare server on your network, NETX will bail out, but if you saw packets in `tcpdump` it's served its purpose.

We can now test TCP/IP by pinging the TAP interface.
On the DOS guest, run:

```
cd \TOOLS\MTCP
PING 10.1.0.1
```

Replace `10.1.0.1` above with whatever IP you set previously on the TAP interface.

You should see a ping response in DOS, as well as ICMP packets in `tcpdump`.

# Accessing the internet

The easiest way to get packets from our TAP device onto the real network is to bridge it with a physical network interface.
This works fine when the physical interface is wired ethernet, but WiFi is a bit more complicated.
For WiFI, we'll instead route the packets to the physical interface using NAT.

## Wired

::: Caution
This method **will not** work with a WiFi interface.
See the WiFi section for more details.
:::

If you're using a wired network, you can add the TAP interface to a bridge, along with the wired interface.

First, create a bridge on the host:

```
ip link add br0 type bridge
```

Now attach the TAP and ethernet interfaces to it:

```
ip link set 86box0 master br0
ip link set eth0 master br0
```

Next add `eth0`'s IP address to the bridge:

```
ip a add 192.168.0.42/24 dev br0
```

Or run a DHCP client on it:

```
dhclient br0
```

Finally, bring up the bridge:

```
ip link set br0 up
```

## Wireless

*Sigh*.

Simple things rarely remain simple.

If you try to add a WiFi interface to a bridge, you'll notice that it doesn't work:

```
$ ip link set dev wlp0s20f3 master br0
Error: Device does not allow enslaving to a bridge.
```

::: Aside
This is because it's most common for WiFi interfaces on home networks to run in 3-address mode.
Why 3 addresses?
Well, because we don't need the 4th one...

WiFi isn't like wired ethernet, in that its relays aren't passive like switches.
WiFi interfaces can either be in Access Point mode (e.g. a WiFi router) or Station mode (e.g. a laptop or phone), with multiple STAs communicating via an AP.
Since STAs can't communicate with each other directly, a packet from one to another, not only needs to the MAC addresses where it originated and where it wants to end up, but also where it needs to go next.
Since in a simple home network with only one AP, we know there will only ever be one "hop", we can use 3 addresses for this: the source (e.g. STA1), the destination (e.g. STA2), and the AP in between.
From STA1 to AP, the from address will be the same as the source, and from AP to STA2 the to address will be the destination.

Things get a bit more complicated because APs can bridge with other APs.
If STA1 and STA2 are on two separate APs, we can no longer only use 3 addresses!
There will be a hop in the middle between AP1 and AP2 where the source address is STA1, the from address is AP1, the to address is AP2, and the destination address is STA2.

Anyhow, since this is all happening on layer-2, bridging gets tricky for 4-address mode, and implossible for 3-address mode.

*Note: I was a bit hesitant writing this explanation because WiFi is complicated and I couldn't find much good information about this online.
If you know about how WiFi works on layer-2, and see something incorrect in this section, shoot me an [e-mail](mailto:a@fo.ax) and I'll fix it!*
:::

Fear not though, with a bit of clever `iptables` magic we can still access the internet!

::: Caution
You will not be able to use your network's DHCP server with this method.
If you want to use DHCP, you will have to set up a DHCP server listening on the TAP interface to assign an address on the NATed subnet.
:::

We'll set up a new subnet for emulation guests, and use the host as a NAT gateway to the rest of the network.
When we set up the TAP interface earlier, we assigned it an IP and subnet (`10.1.0.1/16` in the example).
This will be the address that gets SNATed on packets we send out, and we'll DNAT from this address to our actual destination on packets we receive.

And of course, you've guessed it, we have a handy script for that!

```
bin/route-tap-to-gateway.sh --help
```

Or manually: first, make sure IPv4 forwarding is enabled on the host:

```
sysctl -w net.ipv4.ip_forward=1
```

Then add a masquerade rule on the host for the TAP interface's IP address:

```
iptables -t nat -A POSTROUTING -s 10.1.0.1/16 -o eth0 -j MASQUERADE
```

And finally, make sure that our FORWARD chains have will accept our packets if our default policy is strict:

```
iptables -A FORWARD -i eth0 -o 86box0 -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -i 86box0 -o eth0 -j ACCEPT
```

::: Warning
Make sure that default gateway on the DOS guest is set as the IP of the TAP interface *not* the outside network's gateway.
The guest won't be able to ARP IPs on the outside network as it's on a separate subnet behind NAT.
The DNS servers on the guest should match what is set on the host.
:::

## Testing internet access

```
cd \TOOLS\MTCP
ping 8.8.8.8
ping google.com
```

If both these tests work, then huzzah, you've connected DOS to the world!

If just the first ping command worked, there's an issue with DNS.
Make sure you're using the same DNS server(s) the host is using, and if that doesn't work, try using either Cloudflare (`1.1.1.1`) or Google (8.8.8.8, 8.8.4.4) public DNS servers.

If neither tests work, the first suspect is `net.ipv4.ip_forward`.
You can check this is enabled (1) on the host by running:

```
cat /proc/sys/net/ipv4/ip_forward
```

The next obvious suspect is `iptables`.
Check your `iptables` rules on the host for both the default table and the NAT table by running:

```
iptables -nvL
iptables -t nat -nvL
``` 

# Further reading and resources

* [VDE2](https://github.com/virtualsquare/vde-2)
* [Virtual Networking 101: bridging the gap to understanding TAP](https://blog.cloudflare.com/virtual-networking-101-understanding-tap)
* [Documentation about the netfilter/iptables project](https://www.netfilter.org/documentation/index.html)
* [Arch Linux Wiki: Network bridge](https://wiki.archlinux.org/title/Network_bridge)
* [86Box on Linux Slackware, how to enable networking with pcap?](https://unix.stackexchange.com/questions/724542/86box-on-linux-slackware-how-to-enable-networking-with-pcap)
* [iptables -- a comprehensive guide](https://sudamtm.medium.com/iptables-a-comprehensive-guide-276b8604eff1)
* [Network Address Translation](https://avinetworks.com/glossary/network-address-translation/)
* [Mikrotik Manual: Wireless Station Modes](https://wiki.mikrotik.com/wiki/Manual:Wireless_Station_Modes)
* [IEEE 802.11 (Wi-Fi) Addressing: Transit, Multicast, & Mesh](https://datatracker.ietf.org/meeting/111/materials/slides-111-babel-ieee-80211-wi-fi-addressing-transit-multicast-mesh-00)
