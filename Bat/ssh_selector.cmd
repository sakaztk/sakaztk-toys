@echo off
setlocal enabledelayedexpansion
title SSH Quick Selector

set "CONFIG_PATH=%USERPROFILE%\.ssh\config"

if not exist "%CONFIG_PATH%" (
    echo [Error] .ssh/config file not found at %CONFIG_PATH%
    pause
    exit /b
)

:menu
cls
echo ==========================================
echo   SSH Host Selector
echo ==========================================
echo  [l] View config
echo  [e] Edit config
echo  [q] Quit
echo.

set count=0
for /f "tokens=2" %%a in ('findstr /i "^Host " "%CONFIG_PATH%"') do (
    :: Skip wildcard entries
    echo %%a | findstr "*" >nul
    if errorlevel 1 (
        set /a count+=1
        set "host[!count!]=%%a"
        echo  [!count!] %%a
    )
)

if %count%==0 (
    echo No hosts found in your config file.
    pause
    exit /b
)
echo ==========================================
set /p choice="Enter number to connect: "

if /i "%choice%"=="q" exit /b
if /i "%choice%"=="l" (
    echo.
    echo --- Contents of %CONFIG_PATH% ---
    type "%CONFIG_PATH%"
    echo.
    pause
    goto menu
)
if /i "%choice%"=="e" (
    start notepad "%CONFIG_PATH%"
    goto menu
)

set "target=!host[%choice%]!"
if "%target%"=="" (
    echo.
    echo [Error] Invalid selection.
    timeout /t 2 >nul
    goto menu
)

echo.
echo Connecting to %target%...
ssh %target%

echo.
echo Connection closed.
pause
goto menu
