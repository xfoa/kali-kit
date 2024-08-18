Drivers
=======

This is a collection of drivers that can be used to get a network adapter
working in MS-DOS.

PKTDRVRS
  Crynwr's suite of network adapter packet drivers. Also contains PDIPX, a shim
  that provides an IPX interface that can talk to a packet driver.

ODI
  Novell's ODI network driver stack. Includes:
    * ODIPKT, a shim to expose ODI on a packet driver interface
    * IPXODI, an ODI driver for the IPX protocol
    * A small collection of ODI network adapter drivers from Novell Netware

Notes
-----

The combination I found worked best is Crynwr's drivers with PDIPX. As it uses
less conventional memory. Novell's drivers work fine too (at least with an
NE1000), so it's up to you which you would like to use. I fin dthat the ODI
stack is less flexible on where it loads and configuration. Be aware that ODIPKT
will only load at softwrae interrupt 0x69, so if (for some reason) you want to
load both, use a different software interrupt for the real packet driver (the
example config uses 0x61).
