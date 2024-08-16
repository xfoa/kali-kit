Drivers
=======

This is a collection of drivers that can be used to get your network adapter
working in MS-DOS.

PKTDRVRS
  Crynwr's collection of network adapter packet drivers.

PDIPX
  IPX packet driver for use with Crynwr's packet drivers.

NOVELL
  A small collection of network adapter packet drivers from Novell Netware.

IPXODI
  IPX ODI driver for use with Novell's packet drivers.


Notes
-----

The combination I found worked best here is Crynwr's drivers with PDIPX.
Novell's drivers work fine with IPXODI, but mTCP and Watt-32 (the TCP/IP stack
used by Kali) don't seem to like to talk to it. The one thing that we do need
from IPXODI though is LSL, Novell's Link Support Layer that allows network
adapter packet drivers like NE1000 to talk to protocol packet drivers like IPX. 
