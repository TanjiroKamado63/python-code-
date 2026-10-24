@echo off
setlocal EnableExtensions DisableDelayedExpansion
title My Python Code Library
set "BASE=https://raw.githubusercontent.com/TanjiroKamado63/python-code-/main"
set "DEST=%USERPROFILE%\Documents\PythonCodeLibrary"
if not exist "%DEST%" mkdir "%DEST%" 2>nul
if not exist "%DEST%\" (
 echo Cannot create download folder: %DEST%
 pause
 exit /b 1
)
:MENU
cls
echo =====================================
echo       MY PYTHON CODE LIBRARY
echo =====================================
echo.
echo Files download to: %DEST%
echo Type a Python filename, e.g. 8Iot.py
echo Type EXIT to quit.
echo.
set "NAME="
set /p "NAME=Enter filename: "
if not defined NAME goto MENU
if /i "%NAME%"=="EXIT" exit /b 0
rem Only allow simple filenames ending in .py, with letters, numbers, underscore or hyphen.
powershell.exe -NoProfile -Command "if ($env:NAME -cmatch '^[A-Za-z0-9_-]+\.py$') {exit 0} else {exit 1}" >nul 2>&1
if errorlevel 1 (
 echo Invalid filename. Use only letters, numbers, - or _ and .py
 pause
 goto MENU
)
set "TARGET=%DEST%\%NAME%"
set "TEMPFILE=%DEST%\%NAME%.download"
if exist "%TEMPFILE%" del /q "%TEMPFILE%" >nul 2>&1
echo.
echo Downloading %NAME%...
curl.exe --fail --location --silent --show-error --connect-timeout 15 --max-time 60 --output "%TEMPFILE%" "%BASE%/%NAME%"
if errorlevel 1 (
 echo Download failed. Check your connection and GitHub filename.
 if exist "%TEMPFILE%" del /q "%TEMPFILE%" >nul 2>&1
 pause
 goto MENU
)
move /Y "%TEMPFILE%" "%TARGET%" >nul
if errorlevel 1 (
 echo Could not save the file.
 pause
 goto MENU
)
echo Downloaded: %TARGET%
:ACTION
echo.
echo 1. Open in Notepad
echo 2. Run with Python
echo 3. Show file in File Explorer
echo 4. Download another file
echo 0. Exit
echo.
set "ACTION="
set /p "ACTION=Choose: "
if "%ACTION%"=="1" (
 notepad.exe "%TARGET%"
 goto ACTION
)
if "%ACTION%"=="2" (
 echo Review code before running. Python programs can change files or settings.
 choice /M "Run this file"
 if errorlevel 2 goto ACTION
 where python >nul 2>&1
 if not errorlevel 1 (
   python "%TARGET%"
 ) else (
   where py >nul 2>&1
   if not errorlevel 1 (
     py "%TARGET%"
   ) else (
     echo Python is not installed or is not on PATH.
   )
 )
 pause
 goto ACTION
)
if "%ACTION%"=="3" (
 explorer.exe /select,"%TARGET%"
 goto ACTION
)
if "%ACTION%"=="4" goto MENU
if "%ACTION%"=="0" exit /b 0
echo Invalid choice.
goto ACTION
