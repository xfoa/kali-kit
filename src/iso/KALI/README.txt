Kali
====

Here are a few versions of Kali.

DOS\KALI_14A
  Kali v1.4a
  The latest version that ran in MS-DOS. Use this version if you have a
  registration key for DOS Kali. Unfortunately, registration keys for Kali II
  and Kali 95 won't work for the DOS version, and there doesn't appear to be a
  license key generator online. If you're using a registration key you've found
  online, be aware that Kali will refuse to connect to a server where another
  user is using the same serial number.

DOS\KALI_12
  Kali v1.2 cracked by DiNK!
  Use this version if you don't have a registration key. You can set the serial
  number to any value and avoid the issue serial number collisions. There are a
  few bugs in this one that were fixed in later versions, but I've found it to
  to be stable and reliable. This is the best option for DOS if you don't have
  a real registration key.

Windows\kali2613.exe
  Kali II v2.613
  The final and current version of Kali. This version requires Windows 95 and
  will not run in DOS. I'm including it here for completeness, and as some DOS
  games will work fine in Windows 95 and can use this version. This is the only
  version that can use the server tracker.


General notes
-------------

Different versions of Kali can't connect to each other reliably. Different
versions of Kali for DOS will outright refuse to connect. Kali for DOS will
appear to connect to Kali II, but traffic appears to only be uni-directional.
Kchat will actually connect between Kali for DOS and Kali II.

Likewise, Kali for DOS can't use the tracker located at tracker.kali.net:2213.

You will need a packet driver installed at a software interrupt in one of the
following ranges to use Kali:

  * 0x60 - 0x66
  * 0x68 - 0x6f
  * 0x78 - 0x7e

A full guide for setting up Kali with a Novell NE1000 network adapter is
included in the DOCS directory of this kit.


Extras
------

DOS\DOOM
  Kalidoom
  An optimised multiplayer driver for Doom. Improves netplay speeds over Kali.

DOS\DUKE3D
  Kommit
  An optimised multiplayer driver for Duke Nukem 3D. Improves netplay speeds
  over Kali.
