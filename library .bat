@echo off
setlocal EnableExtensions DisableDelayedExpansion
chcp 65001 >nul
set "CONFIG=%~dp0library_repo.txt"
set "DEST=%~dp0Downloaded_Codes"
if not exist "%DEST%" mkdir "%DEST%"
if exist "%CONFIG%" set /p "REPO="<"%CONFIG%"
:setup
if defined REPO goto menu
cls
echo ==============================================
echo       IoT PRACTICAL CODE LIBRARY - SETUP
echo ==============================================
echo.
echo Enter your PUBLIC GitHub repository URL.
echo Example: https://github.com/TanjiroKamado63/My-IoT-Codes
 echo.
set /p "REPO=Repository URL: "
if not defined REPO goto setup
set "REPO=%REPO: =%"
set "REPO=%REPO:.git=%"
>"%CONFIG%" echo %REPO%
:menu
cls
echo ==================================================
echo               IoT PRACTICAL LIBRARY
echo ==================================================
echo.
echo   1. LED Blinking
echo   2. Telegram
echo   3. 4-Digit 7-Segment Display
echo   4. GPS Module
echo   5. Graph Plotting
echo   6. Practical 6 - 16.2
echo   7. RFID
echo   8. Fingerprint Interfacing
echo   9. Fingerprint Sensor
echo  10. Fingerprint Authentication
echo  11. MQTT
echo  12. Flask Relay
echo  13. CPU Usage and Memory
echo  14. Embedded RFID Fingerprint
echo.
echo   R. Change GitHub repository URL
echo   0. Exit
echo ==================================================
set "FILE="
set /p "CHOICE=Enter practical number: "
if "%CHOICE%"=="0" exit /b 0
if /i "%CHOICE%"=="R" (
  set "REPO="
  goto setup
)
if "%CHOICE%"=="1" set "FILE=P1-led"
if "%CHOICE%"=="2" set "FILE=P2 telegram.py"
if "%CHOICE%"=="3" set "FILE=P3 4digit7-segment"
if "%CHOICE%"=="4" set "FILE=P4 gps"
if "%CHOICE%"=="5" set "FILE=P5 graph"
if "%CHOICE%"=="6" set "FILE=P6-16 2"
if "%CHOICE%"=="7" set "FILE=P7 rfid"
if "%CHOICE%"=="8" set "FILE=P8 fingerprint interfacing.py"
if "%CHOICE%"=="9" set "FILE=P11 fingerprint sensor.py"
if "%CHOICE%"=="10" set "FILE=P12 Fingerprint Authentication.py"
if "%CHOICE%"=="11" set "FILE=P13 mqtt"
if "%CHOICE%"=="12" set "FILE=P14 flask relay"
if "%CHOICE%"=="13" set "FILE=P18 CPU Usage, Memory Us.py"
if "%CHOICE%"=="14" set "FILE=P19 Embedded RFIDFingerp.py"
if not defined FILE (
  echo.
  echo Invalid selection. Try again.
  pause
  goto menu
)
set "BRANCH=main"
set "REPOPATH=%REPO:https://github.com/=%"
if "%REPOPATH%"=="%REPO%" (
  echo.
  echo Please enter a github.com repository URL, not a file link.
  pause
  goto menu
)
set "BASE=https://raw.githubusercontent.com/%REPOPATH%/%BRANCH%"
set "URL=%BASE%/%FILE: =%%"
rem PowerShell safely encodes filenames with spaces and other URL characters.
powershell -NoProfile -Command "$name=$env:FILE; $base=$env:BASE; $url=$base+'/'+[uri]::EscapeDataString($name); $out=Join-Path $env:DEST $name; try { Invoke-WebRequest -Uri $url -OutFile $out -ErrorAction Stop; Write-Host ('Downloaded: '+$out); Start-Process notepad.exe -ArgumentList ('"'+$out+'"'); exit 0 } catch { Write-Host ('Download failed: '+$_.Exception.Message); exit 1 }"
if errorlevel 1 (
 echo.
 echo Check the repository URL, branch name, file spelling, and public visibility.
)
echo.
pause
goto menu
