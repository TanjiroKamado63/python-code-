@echo off
setlocal EnableExtensions DisableDelayedExpansion
title My Python Code Library
set "BASE=https://raw.githubusercontent.com/TanjiroKamado63/python-code-/main"
set "DEST=%USERPROFILE%\Documents\PythonCodeLibrary"
if not exist "%DEST%" mkdir "%DEST%"

:MENU
cls
echo ====================================
echo        MY PYTHON CODE LIBRARY
 echo ====================================
echo.
echo Type a filename, e.g. 8Iot or 8Iot.py
echo Type exit to quit.
echo.
set "NAME="
set /p "NAME=Enter Python filename: "
if not defined NAME goto MENU
if /I "%NAME%"=="exit" exit /b 0

rem Allow only simple names: letters, digits, underscores, and hyphens.
rem Disallow spaces, slashes, quotes, dots inside basename, and CMD metacharacters.
set "BASENAME=%NAME%"
if /I "%BASENAME:~-3%"==".py" set "BASENAME=%BASENAME:~0,-3%"
if not defined BASENAME goto INVALID
set "LIB_NAME=%BASENAME%"
powershell.exe -NoProfile -Command "if ($env:LIB_NAME -cmatch '^[A-Za-z0-9_-]+$') { exit 0 } else { exit 1 }" >nul 2>&1
if errorlevel 1 goto INVALID

set "FILE=%BASENAME%.py"
echo.
echo Downloading %FILE%...
curl.exe --fail --location --silent --show-error --output "%DEST%\%FILE%" "%BASE%/%FILE%"
if errorlevel 1 (
    echo.
    echo File not found or download failed. Check the GitHub filename.
    pause
    goto MENU
)
echo Opening %FILE% in Notepad...
notepad.exe "%DEST%\%FILE%"
goto MENU

:INVALID
echo Invalid filename. Use letters, numbers, underscore or hyphen only.
pause
goto MENU
