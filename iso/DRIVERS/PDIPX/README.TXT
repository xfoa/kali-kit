This Driver is an IPX interface that talks to the Packet Driver.
If you want to load the Packet Driver at boot time and still use
Novell services.

Intel has made this driver freely copyable by all parties for all
purposes.  Intel does not warrant the fitness of PDIPX for any
particular task, not will Intel be liable for any damage caused
by the use or misuse of PDIPX.  Intel will not support PDIPX
in the event that it does not function.

If a problem is found please fax it to (801) 373-1599 attn: Colin Cook
or send SMTP mail to colin_cook@hf.ccm.intel.com
Intel will make any and all updates to PDIPX freely availble.

this read me is dated 9-28-92 and should be ziped with 
pdipx V1.03EC (920828)

FTP
attach to aurora.intel.com
download ~/pub/ipg/cook/pdipx.zip
---- or ------
BBS
(503) 645-6275
Select Network Enhancement Utilities
Select Utilities
Select NetSight Analyst
Download PDIPX.ZIP
---- or ------
US Mail
send a formated diskette and self addresed stamped disk mailer to

Intel Corp
Attn: Colin Cook
3311 N University Av #200
Provo UT, 84604


Notes:

PDIPX is a econfigurable driver.

In 802.3 (default) mode it requests Class 11 Type FFFF packets.

In in econfig mode is requests Class 1 Type ???? (defined by the ECONFIG
program) packets.

Clarkson Drivers starting at version 9 will accept requests for both class
1 and 11 packets.  (1 = DIX ethernet, type at byte 12. 11 = 802.3 ethernet,
type at byte 14 [Ssap Dsap])

If you are using the Clarkson Drivers you must have version 9 or above to
use 802.3 mode (do not use the -n option).

If you are using econfig mode and your network is using 802.3 you must use
the -n option on the Clarkson Drivers.

