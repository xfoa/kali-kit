---
title: Installing network drivers and Kali on MS-DOS
author: '[foax](mailto:a@fo.ax)'
---

# Network drivers

Unsurprisingly, Kali needs to be able to talk to the network adapter in DOS.
This is done by using appropriate network drivers for your hardware.
The example configurations included on the [Kali Kit](https://fo.ax/kali-kit) CD will work with a Novell NE1000 network adapter, but there are drivers included for many, many others (both ISA and PCI).
See [An introduction to MS-DOS network drivers](drivers.md) if you're not familiar with how network drivers work in DOS. 

::: Tip
Do you have a Novell NE1000 network adapter?
Congratulations, you don't need to do any configuration!
Run `INSTALL.BAT` from the root directory of the CD, and everything should work out of the box.
All you need to do is set the IP network you want to use in Kali's `WATTCP.CFG` file (and optionally mTCP if you want to use the TCP/IP tools there).
You can then add `NETSTART.BAT` to your `AUTOEXEC.BAT`.
:::

::: Tip
Not using a Novell NE1000?
Don't worry, you can still use `INSTALL.BAT`!
Just follow the instructions below to use the appropriate driver for your hardware.
You can then configure `WATTCP.CFG` and add `NETSTART.BAT` to your `AUTOEXEC.BAT`.
:::

## Packet driver or ODI?

Both PD and ODI drivers are included on the [Kali Kit](https:fo.ax/kali-kit) CD.
If you're not sure which you want, I would recommend going with PD, as the memory footprint is smaller and they can be loaded high.

::: Caution
PD and the older version of the IPX shim (`PDIPX.COM`) don't work well with old games or SPX.
Use the newer version (`IPXPD.COM`) and everything should work.
If you have issues with PD, try ODI instead.
:::

::: Note
Both PD and ODI can use 802.3 (headers with length field) or the older Ethernet II (headers with type field) frames.
By default, the `NETSTART.BAT` script for PD and `NET.CFG` for ODI use 802.3, but if you want to talk to devices that speak Ethernet II, this can be changed.
Examples are provided in these files to change this.
:::

## Packet driver

Packets drivers can be found in the `DRIVERS\PKTDRVRS` directory. 
If you want to use packet driver based network drivers:

1. Copy the `DRIVERS\PKTDRVRS` directory and `DRIVERS\NETSTART.BAT` file to your hard drive.
2. Locate the appropriate packet driver for your network adapteri in `PKTDRVRS`.
3. Replace the line that runs `NE1000.COM` in `NETSTART.BAT` with the packet driver for your network adapter.
   Remember to set the hardware IRQ and base memory address to those used by your adapter.
4. Add `NETSTART.BAT` to your `AUTOEXEC.BAT` file.

::: Note
Kali will autodetect the software IRQ that the packet driver is listening at.
:::

::: Warning
If you want to use mTCP's TCP/IP tools, you will need to set the packet driver's software interrupt in the `MTCP.CFG` file.
:::

## ODI 

A few common ODI data-link drivers are included on the [Kali Kit](https://fo.ax/kali-kit) CD.
If you can't find a driver for a network adapter you want to use here, many more are available on the [Novell Netware 4.11 Operating System CD](https://archive.org/details/novellnetware4.11networksoftware).

If you want to use ODI based network drivers:

1. Copy the `DRIVERS\ODI` directory and `DRIVERS\NETSTART.BAT` file to your hard drive.
2. Locate the appropriate ODI MLID for your network adapter in `ODI\NOVELL`, or copy one from the NetWare CD.
3. Comment out the packet driver section in `NETSTART.BAT` and uncomment the ODI section.
4. Replace the line that runs `NOVELL\NE1000.COM` in `NETSTART.BAT` with the MLID for your network adapter.
5. Add `NETSTART.BAT` to your `AUTOEXEC.BAT` file.

::: Note
Kali will autodetect the software IRQ that ODIPKT is listening at.
:::

::: Warning
If you want to use mTCP's TCP/IP tools, you will need to set ODIPKT's software interrupt (0x69) in the `MTCP.CFG` file.
:::

### NET.CFG configuration

NET.CFG configures how ODI is run, including protocols used, hardware parameters, etc.
The supplied NET.CFG should work with most network adapters, but if you want to modify this see the documentation on the [Novell Netware 4.11 Online Documentation](https://archive.org/details/novellnetware4.11networksoftware) CD.

# Kali

Finally, we're here!
There are two versions of Kali for DOS available on the [Kali Kit](https://fo.ax/kali-kit) CD:

* v1.4a -- this was the final version of Kali released for DOS.
  Use this if you have a valid Kali for DOS license key.
* v1.2 -- this is a slightly older version that has a license crack by DiNK! applied.
  Use this version if you don't have a valid license key for Kali for DOS.

::: Note
Kali v1.2 has a few bugs that were fixed in v1.4a.
These are generally minor, and in my testing I never encountered any issues.
You can use v1.4a without a license key, but your session will be limited to 20 minutes.
:::

::: Warning
Kali II license keys are available for free on [Kali.net](https://kali.net), but they *will not* work on Kali for DOS.
:::

::: Caution
License keys for Kali for DOS do exist online, but Kali detects if a license key is being used by more than one user connected to a server, and will not connect if this is so.
:::

The `INSTALL.BAT` script will ask you which version of Kali you want to install, and will copy it to `C:\KALI`.

## Kali configuration

The final step is configuring Kali.
There are two files you need to modify: `KALI.CFG` and `WATTCP.CFG`.
See comments in these files for more info.

::: Note
Kali does not include a DHCP client.
IP setup must be done statically in `WATTCP.CFG`.
:::

::: Caution
Make sure `ppp = 1` is *not* set in `WATTCP.CFG`.
Kali will not try to use network drivers at all if it is!
:::

You should now be all done!
Start or connect to a Kali server and play!

# Installing Kali II on Windows

::: Warning
Kali II will only work on Windows 95 or above.
It does not support Windows 3.1.
:::

Installing Kali II in Windows is simple.
For Windows 95, first make sure that the TCP/IP protocol is installed in `Control Panel` -> `Network`.
If not, add it.
Then run the `kali2613.exe` installer program, which can be found in `KALI\Windows` on the [Kali Kit](https://fo.ax/kali-kit) CD.

# Additional Tools

## mTCP

::: Tip
mTCP is *not* required to run Kali! It's only included for connectivity testing and debugging.
:::

::: Note
mTCP's TCP/IP configuration is completely separate from Kali's.
You can even run it on a different IP or subnet if you want!
:::

The `TOOLS\MTCP` directory contains a collection of tools that use the [mTCP](https://www.brutman.com/mTCP/) TCP/IP library.
Among these are implementations of common network tools such as `ping`, `nc`, and `telnet`.
There's also a tool (`PKTTOOL.EXE`) that will display info about any packet drivers present in memory, as well as their packet statistics.

To install mTCP tools:

1. Copy the `TOOLS\MTCP` directory to your hard drive.
2. Edit the `MTCP.CFG` file with your IP network and packet driver IRQ settings.
3. Add the line `SET MTCPCFG=C:\MTCP\MTCP.CFG` to your `AUTOEXEC.BAT`.
   If necessary, modify the mTCP directory to where you installed it.

::: Warning
If you're using ODI, you will need to use the ODIPKT shim to expose a packet driver interface.
This shim listens at software interrupt 0x69, which can't be changed.
Modify `MTCP.CFG` to use this interrupt to use mTCP with ODI.
An example is given in `MTCP_ODI.CFG`.
:::

::: Caution
If you're using an emulator, and the host machine uses a WiFi adapter to connect to the internet, you will not be able to use your network's DHCP server.
This is because WiFi commonly uses 3-address mode, which can't be bridged to a regular ethernet interface.
If your WiFI adapter *and* your base station are set up to use 4-address mode, bridging will work -- otherwise your best option is to either use a static IP configuration for mTCP, or set up a DHCP on the host machine for a separate subnet that uses NAT for DOS guests.
More information can be found in [Networking using 86Box and VDE in Linux](86box.md).
:::

# Further reading and resources

* [Kali Official Homepage](https://kali.net)
* [mTCP](https://www.brutman.com/mTCP/)
* [Maraakate.org -- Kali Downloads](https://maraakate.org/Kali/downloads.html)
* [Novell Netware 4.11 Online Documentation](https://archive.org/details/novellnetware4.11networksoftware)
* [Ralf Brown's Interrupt List](https://www.cs.cmu.edu/~ralf/files.html)
* [IEEE 802.11 (Wi-Fi) Addressing: Transit, Multicast, and Mesh](https://datatracker.ietf.org/meeting/111/materials/slides-111-babel-ieee-80211-wi-fi-addressing-transit-multicast-mesh-00)
