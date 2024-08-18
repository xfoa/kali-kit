Drivers
=======

This is a collection of drivers that can be used to get a network adapter
working in MS-DOS.

PKTDRVRS
  Packet drivers for DOS. Includes:
   * Crynwr's suite of open source network adapter packet drivers
   * PDIPX, a shim that provides an IPX interface that can talk to a packet
     driver.

ODI
  Novell's ODI network driver stack. Includes:
    * A small collection of ODI network adapter drivers taken from Novell
      Netware
    * ODIPKT, a shim to expose ODI on a packet driver interface
    * IPXODI, an ODI driver for the IPX protocol

Notes
-----

The combination I found worked best is Crynwr's drivers with PDIPX. As it uses
less conventional memory than the ODI stack (and can be loaded high). Novell's
drivers work well too (at least with an NE1000), so it's up to you which you
would like to use. I find that the ODI stack is less flexible on where it loads
and how it's configured, so I prefer PD. That said, PDIPX might not play nicely
with SPX -- but it works fine with IPX, which is all you need if you're only
looking to play multiplayer games.

Be aware that ODIPKT will only load at softwrae interrupt 0x69, so if (for some
reason) you want to load both, use a different software interrupt for the real
packet driver (the example config uses 0x61).
