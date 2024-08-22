@ECHO OFF
SET DRIVERS=C:\DRIVERS

REM Packet driver section

REM Remember to change the hardware interrupt and base address below to match
REM your card!

REM Add -n switch to packet driver to use 802.3 frames
LH %DRIVERS%\PKTDRVRS\NE1000.COM 0x60 3 0x300
LH %DRIVERS%\PKTDRVRS\IPXPD.COM

REM ODI section
REM To use ODI drivers, use these lines instead

REM LH %DRIVERS\ODI\LSL.COM
REM LH %DRIVERS%\ODI\NOVELL\NE1000.COM
REM LH %DRIVERS%\ODI\IPXODI.COM
REM LH %DRIVERS%\ODI\ODIPKT30.COM

REM mTCP section

SET MTCPCFG=C:\TOOLS\MTCP\MTCP.CFG
