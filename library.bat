@echo off
setlocal EnableExtensions DisableDelayedExpansion
title IoT Practical Library
set "BASE=https://raw.githubusercontent.com/TanjiroKamado63/python-code-/main"
set "DEST=%USERPROFILE%\Documents\IoTPracticalLibrary"
if not exist "%DEST%" mkdir "%DEST%"
:MENU
cls
echo ======================================
echo          IoT PRACTICAL LIBRARY
echo ======================================
echo Available: 1 2 3 4 5 6 8 9 10 11 12
echo Type a number or exit.
echo.
set "N="
set /p "N=Enter practical number: "
if /I "%N%"=="exit" exit /b 0
set "FILE="
if "%N%"=="1" set "FILE=PRACTICAL 1 — LED BLINKING PATTERNS"
if "%N%"=="2" set "FILE=PRACTICAL 2 — 4-DIGIT 7-SEGMENT DISPLAY (TM1637)"
if "%N%"=="3" set "FILE=PRACTICAL3 — ADS1015ADS1115 ADC AND LIVE GRAPH"
if "%N%"=="4" set "FILE=PRACTICAL 4 — GPS MODULE INTERFACING"
if "%N%"=="5" set "FILE=PRACTICAL 5 —RFID RC522 READ WRITE"
if "%N%"=="6" set "FILE=PRACTICAL 6 — 16×2 I2C LCD"
if "%N%"=="8" set "FILE=PRACTICAL 8 — FINGERPRINT SENSOR ENROLLMENT"
if "%N%"=="9" set "FILE=PRACTICAL 9 — FINGERPRINT-AUTHENTICATED DOOR LOCK (PRACTICAL 12)"
if "%N%"=="10" set "FILE=PRACTICAL 10 — FLASK WEB DASHBOARD TO CONTROL RELAY (PRACTICAL 14)"
if "%N%"=="11" set "FILE=PRACTICAL 11 — MQTT PUBLISHER SUBSCRIBER LED CONTROL"
if "%N%"=="12" set "FILE=PRACTICAL 12 — EMBEDDED ACCESS CONTROL"
if not defined FILE (
 echo Invalid number or practical not available.
 pause
 goto MENU
)
set "OUT=%DEST%\Practical_%N%.txt"
echo.
echo Downloading practical %N%...
rem Use PowerShell to URL-encode the Unicode filename, including em dash and multiplication sign.
powershell.exe -NoProfile -Command "$ErrorActionPreference='Stop'; $name=$env:FILE; $base=$env:BASE; $out=$env:OUT; $url=$base+'/'+[Uri]::EscapeDataString($name); Invoke-WebRequest -Uri $url -OutFile $out -UseBasicParsing" 
if errorlevel 1 (
 echo.
 echo Download failed. Check the exact GitHub filename and whether the repository is public.
 pause
 goto MENU
)
echo Opening practical %N% in Notepad...
notepad.exe "%OUT%"
goto MENU
