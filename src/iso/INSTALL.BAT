@ECHO OFF

XCOPY /E DRIVERS C:\DRIVERS\
XCOPY /E TOOLS C:\TOOLS\
CHOICE Do you have a valid license key for Kali 1.4a? 
IF ERRORLEVEL 3 GOTO :END
IF ERRORLEVEL 2 GOTO :KALI_12
IF ERRORLEVEL 1 GOTO :KALI_14A
IF ERRORLEVEL 0 GOTO :END

:KALI_12
echo Okay, installing a cracked version of Kali v1.2. Sssshh! Don't tell anyone!
XCOPY /E KALI\DOS\KALI_12 C:\KALI\
GOTO :END

:KALI_14A
echo Cool, installing Kali v1.4a, which needs a valid license key
XCOPY /E KALI\DOS\KALI_14A C:\KALI\
GOTO :END

:END
