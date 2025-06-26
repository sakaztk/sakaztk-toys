@echo off
rundll32 user32.dll,LockWorkStation
exit /b %errorlevel%