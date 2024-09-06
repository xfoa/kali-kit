@ECHO OFF

ECHO Installing ODI and Packet Drivers to C:\DRIVERS ...
XCOPY /E DRIVERS C:\DRIVERS\ > NUL
ECHO Installing network tools to C:\TOOLS ...
XCOPY /E TOOLS C:\TOOLS\ > NUL
CHOICE Do you have a valid license key for Kali 1.4a? 
IF ERRORLEVEL 2 GOTO :KALI_12
IF ERRORLEVEL 1 GOTO :KALI_14A
IF ERRORLEVEL 0 GOTO :END

:KALI_12
echo Okay, installing a cracked version of Kali v1.2 to C:\KALI. Sssshh! Don't tell anyone!
XCOPY /E KALI\DOS\KALI_12 C:\KALI\ > NUL
GOTO :AUTOEXEC

:KALI_14A
echo Cool, installing Kali v1.4a to C:\KALI, which needs a valid license key.
XCOPY /E KALI\DOS\KALI_14A C:\KALI\ > NUL
GOTO :AUTOEXEC

:AUTOEXEC
ECHO Would you like the network drivers to be loaded on boot (this modifies
ECHO AUTOEXEC.BAT)? 
CHOICE
IF ERRORLEVEL 2 GOTO :END
IF ERRORLEVEL 1 GOTO :EDIT_AE
IF ERRORLEVEL 0 GOTO :END

:EDIT_AE
ECHO CALL C:\DRIVERS\NETSTART.BAT >> C:\AUTOEXEC.BAT

:END
