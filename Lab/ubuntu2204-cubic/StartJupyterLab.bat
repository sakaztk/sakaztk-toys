@echo off
pushd %~dp0

net session >nul 2>&1
if %errorlevel% neq 0 (
    echo reraunch with admin privilages... 
    powershell -Command "Start-Process '%~f0' -Verb runAs"
    exit /b
)
jupyter lab
popd