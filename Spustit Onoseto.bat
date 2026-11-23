@echo off
rem Spusti Onoseto jako samostatne okno (Microsoft Edge / Chrome), jinak ve vychozim prohlizeci.
setlocal
set "APP=%~dp0aplikace\onoseto.html"
if not exist "%APP%" (
  echo Soubor aplikace nebyl nalezen: "%APP%"
  pause
  exit /b 1
)
set "URL="
for /f "usebackq delims=" %%U in (`powershell -NoProfile -Command "[Uri]::new($env:APP).AbsoluteUri"`) do set "URL=%%U"
if not defined URL set "URL=%APP%"

set "BROWSER="
for %%K in (HKLM HKCU) do (
  if not defined BROWSER reg query "%%K\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\msedge.exe" >nul 2>&1 && set "BROWSER=msedge"
)
for %%K in (HKLM HKCU) do (
  if not defined BROWSER reg query "%%K\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\chrome.exe" >nul 2>&1 && set "BROWSER=chrome"
)

if defined BROWSER (
  start "" %BROWSER% --app="%URL%" --start-maximized
) else (
  start "" "%APP%"
)
endlocal
