@echo off
rem Vytvori zastupce Onoseto s ikonou na plose, v nabidce Start a ve slozce aplikace.
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0aplikace\vytvor-zastupce.ps1"
echo.
pause
