@echo off
setlocal EnableExtensions DisableDelayedExpansion
title IoT Practical Code Library
set "BASE=https://raw.githubusercontent.com/TanjiroKamado63/python-code-/main"
set "OUT=%~dp0Downloaded_Codes"
if not exist "%OUT%" mkdir "%OUT%"
:menu
cls
echo =============================================
echo          IoT PRACTICAL CODE LIBRARY
echo =============================================
echo  1. LED Blinking
echo  2. Telegram
echo  3. 4-Digit 7-Segment Display
echo  4. GPS Module
echo  5. Graph Plotting
echo  6. Practical 6 - 16.2
echo  7. RFID
echo  8. Fingerprint Interfacing
echo  9. Fingerprint Sensor
echo 10. Fingerprint Authentication
echo 11. MQTT
echo 12. Flask Relay
echo 13. CPU Usage and Memory
echo 14. Embedded RFID Fingerprint
echo  0. Exit
echo =============================================
set "choice="
set /p "choice=Enter practical number: "
if "%choice%"=="0" exit /b 0
set "remote="
set "local="
if "%choice%"=="1"  (set "remote=P1-led" & set "local=P1-led.txt")
if "%choice%"=="2"  (set "remote=P2 telegram.py" & set "local=P2 telegram.py")
if "%choice%"=="3"  (set "remote=P3 4digit7-segment" & set "local=P3 4digit7-segment.txt")
if "%choice%"=="4"  (set "remote=P4 gps" & set "local=P4 gps.txt")
if "%choice%"=="5"  (set "remote=P5 graph" & set "local=P5 graph.txt")
if "%choice%"=="6"  (set "remote=P6-16 2" & set "local=P6-16 2.txt")
if "%choice%"=="7"  (set "remote=P7 rfid" & set "local=P7 rfid.txt")
if "%choice%"=="8"  (set "remote=P8 fingerprint interfacing.py" & set "local=P8 fingerprint interfacing.py")
if "%choice%"=="9"  (set "remote=P11 fingerprint sensor.py" & set "local=P11 fingerprint sensor.py")
if "%choice%"=="10" (set "remote=P12 Fingerprint Authentication.py" & set "local=P12 Fingerprint Authentication.py")
if "%choice%"=="11" (set "remote=P13 mqtt" & set "local=P13 mqtt.txt")
if "%choice%"=="12" (set "remote=P14 flask relay" & set "local=P14 flask relay.txt")
if "%choice%"=="13" (set "remote=P18 CPU Usage, Memory Us.py" & set "local=P18 CPU Usage, Memory Us.py")
if "%choice%"=="14" (set "remote=P19 Embedded RFIDFingerp.py" & set "local=P19 Embedded RFIDFingerp.py")
if not defined remote (
 echo Invalid choice. Please enter 0 to 14.
 pause
 goto menu
)
echo Downloading selected practical...
powershell.exe -NoProfile -Command "$ErrorActionPreference='Stop'; $url=$env:BASE+'/'+[uri]::EscapeDataString($env:remote); Invoke-WebRequest -Uri $url -OutFile ($env:OUT+'\'+$env:local) -UseBasicParsing" 
if errorlevel 1 (
 echo.
 echo Download failed. Check internet connection and GitHub filename.
 if exist "%OUT%\%local%" del /q "%OUT%\%local%" >nul 2>&1
 pause
 goto menu
)
notepad.exe "%OUT%\%local%"
goto menu
