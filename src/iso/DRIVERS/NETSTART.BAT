@ECHO OFF
SET DRIVERS=C:\DRIVERS

REM Packet driver section

REM Remember to change the hardware interrupt and base address below to match
REM your card! Remove -n switch to use Ethernet II frames
LH %DRIVERS%\PKTDRVRS\NE1000.COM -n 0x60 3 0x300
LH %DRIVERS%\PKTDRVRS\IPXPD.COM

REM ODI section
REM To use ODI drivers, use these lines instead

REM LH %DRIVERS\ODI\LSL.COM
REM LH %DRIVERS%\ODI\NOVELL\NE1000.COM
REM LH %DRIVERS%\ODI\IPXODI.COM
REM LH %DRIVERS%\ODI\ODIPKT30.COM

SET MTCPCFG=C:\TOOLS\MTCP\MTCP.CFG
