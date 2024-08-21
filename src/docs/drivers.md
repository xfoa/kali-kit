---
title: An introduction to MS-DOS network drivers
author: '[foax](mailto:a@fo.ax)'
---

Networking in DOS can be a finnicky beast!
Here's a bunch of stuff I wish I'd known when I was setting it up.

# General notes

First, what does a network driver do, and why do we need them?
Network drivers provide an API for software to send and receive packets to and from the network.
This involves interacting with the network adapter, as well as dealing with 

There are a few diffrent kinds of network driver API used in DOS, but we'll only cover two here: Packet drivers (PD) and Open Data-Link Interface (ODI).
Other APIs -- like UNDI and NDIS -- are more relevant for PXE booting, which is beyond the scope of this guide.
We'll just focus on PD and ODI here, as these are the most relevant for getting games working in DOS.

# Packet drivers

Packet drivers provide an interface between the data-link layer (OSI layer 2) and the network adapter.
That is to say, a higher-level network (e.g. TCP/IP) driver can send its packets as lower-level data-link (e.g. Ethernet) frames to the PD, and the PD will handle sending those to the network adapter (and vice versa for receiving).
Packet drivers are a simple way of implementing low level of networking: listen on a software interrupt (usually in the range 0x60 - 0x80, with a few exceptions) that calls a function in a TSR or library that talks to the network adapter.

[Russel Nelson](http://russnelson.com/) of [Crynwr Software](http://crynwr.com/) has written a useful [suite of opensource DOS packet drivers](http://crynwr.com/drivers/00index.html) for many, many network adapters, which are included in this kit.

# ODI

ODI is a network driver API developed by Novell, based on the Link Support Layer (LSL) API from AT&T's Unix System V -- where most nice things come from ;) [[1]](https://www.pcmag.com/encyclopedia/term/odi).
Instead of a higher-level network (e.g. TCP/IP) driver having to know how to construct lower-level (e.g. Ethernet) frames and talking directly to the hardware driver, ODI decouples these two sides by providing a standard interface between them.
It allows multiple protocol drivers to interact with multiple data-link drivers.

```
+------------:+:------------------:+:------------------:+
| OSI Layer 3 | Transport Protocol | Transport Protocol |
+-------------+--------------------+--------------------+
| ODI         | Multiple Protocol Interface\            |
|             | Link Support Layer\                     |
|             | Multiple Link Interface\                |
+-------------+--------------------+--------------------+
| OSI Layer 2 | Data Link driver   | Data Link Driver   |
+-------------+--------------------+--------------------+
```

[TODO]: <> (Remove ``` code block tags once this Pandoc issue is fixed: https://github.com/jgm/pandoc/issues/8990)

## LSL

The Link Support Layer -- LSL --  is the glue that holds ODI together.

"[LSL] provides a common language between the transport layer and the data link layer and allows different transport protocols to run over one network adapter or one transport protocol to run on different network adapters." [[2]](https://www.pcmag.com/encyclopedia/term/lsl)

## MLID

A Multiple Link Interface Driver -- MLID -- is an data-link (e.g. Ethernet) driver that communicates with higher-level (e.g. TCP/IP) drivers via the LSL.
MLIDs handle writing and stripping data-link level frame headers.

# IPX/SPX

IPX/SPX is a transport/network protocol (at the same OSI levels as TCP/IP) that was used in the Novell NetWare OS.
The IPX part is the network level protocol (similar to IP), and the SPX part is the transport level protocol (similar to TCP).
IPX was far more popular than TCP/IP in DOS local area networks, so most DOS games use IPX.
Interestingly, Doom and many other games only use the IPX part, with their own protocol in place of SPX (similar to how UDP is used today).

::: Note
The included IPX drivers for PD and ODI are TSRs that remain in memory.
:::

# TCP/IP

Few applications and games in DOS use TCP/IP.
Kali is one of them, of course.

::: Note
TCP/IP drivers are generally not loaded as TSRs themselves, but rather compiled in to applications as libraries.
This is due to their complexity and therefore size -- only including required functions keeps memory usage lower.
:::

Two TCP/IP stacks that work like this are mTCP, and Watt-32 -- the latter of which is used in Kali.
mTCP is included in this kit for testing/debugging purposes.

## Shims

There are some useful shims available to convert between different network APIs.
Included in this kit are:

* IPXPD, a shim that provides an IPX interface that can talk to a packet driver.
* PDIPX, an older version of the IPXPD shim that is less reliable, but included for curiosity.
* ODIPKT, a shim to expose ODI on a packet driver interface

More can be found [here](https://www.shikadi.net/network/).

# Further reading and resources

* [Packet Driver on Wikipedia](https://en.wikipedia.org/wiki/PC/TCP_Packet_Driver)
* [DOS Packet Driver Specification v1.11](http://sininenankka.dy.fi/leetos/network_calls.txt)
* [Indiana University IT Servcies knowledgebase article on ODI](https://kb.iu.edu/d/acbt)
* [Networking FreeDOS -- ODI driver installation](https://home.mnet-online.de/willybilly/fdhelp-dos/en/hhstndrd/network/odi_ins.htm)
* [Novell's ODI LAN driver specifications](https://www.novell.com/developer/ndk/odi_lan_driver_components.html)
* [IPX/SPX on Wikipedia](https://en.wikipedia.org/wiki/IPX/SPX)
* [mTCP](https://www.brutman.com/mTCP/)
* [Watt-32 TCP/IP](https://www.watt-32.net/)

If any of the above links no longer work, it's worth checking if they are archived on the [Wayback Machine](https://web.archive.org/).
