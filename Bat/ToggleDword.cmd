@echo off
set reg_key="HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
set reg_reg_data="ShowSecondsInSystemClock"

if "%~1"=="" (
    goto toggle_reg_data
) else if "%~1"=="on" (
    set reg_data=1 & goto set_reg_data
) else if "%~1"=="1" (
    set reg_data=1 & goto set_reg_data
) else if "%~1"=="off" (
    set reg_data=0 & goto set_reg_data
) else if "%~1"=="0" (
    set reg_data=0 & goto set_reg_data
)
echo Bad Argument.
goto :eof

:toggle_reg_data
for /f "tokens=2*" %%i in ('reg query %reg_key% /v %reg_reg_data% 2^>Nul') do Set "CURRENT=%%j"
if 0x0==%CURRENT% (
    set reg_data=1
) else (
    set reg_data=0
)

:set_reg_data
reg add %reg_key% /v %reg_reg_data% /t REG_DWORD /d %reg_data% /f