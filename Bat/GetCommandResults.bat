@echo off
setlocal ENABLEDELAYEDEXPANSION
cd /d %~dp0
cls

set ymd=%date:~-10,4%%date:~-5,2%%date:~-2,2%
set logfile=%~dpn0_%ymd%.log

set cmd[1]=ping 127.1
set cmd[2]=tracert microsoft.com || tracert google.com
set cmd_total=2

>> %logfile% echo Started %date% %time%.
>> %logfile% echo.

for /L %%i in (1,1,%cmd_total%) do (
    cls & echo Processing... %%i/%cmd_total%
    >> %logfile% echo ##### !cmd[%%i]! #####
    >> %logfile% !cmd[%%i]!
    >> %logfile% echo.
)

>> %logfile% echo Done %date% %time%.
>> %logfile% echo.
