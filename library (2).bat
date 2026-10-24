@echo off
setlocal DisableDelayedExpansion
title My Python Code Library
set "BASE=https://raw.githubusercontent.com/TanjiroKamado63/python-code-/main"
set "SAVE=%USERPROFILE%\Documents\PythonCodeLibrary"
if not exist "%SAVE%" mkdir "%SAVE%"
:START
cls
echo ================================
echo       MY PYTHON CODE LIBRARY
echo ================================
echo.
set "NAME="
set /p "NAME=Enter Python filename (or exit): "
if /i "%NAME%"=="exit" exit /b
if not defined NAME goto START
rem Restrict names to safe simple Python filenames (letters, digits, underscore, hyphen, dot).
echo(%NAME%| findstr /r /i "^[a-z0-9_-][a-z0-9_.-]*$" >nul
if errorlevel 1 (
  echo Invalid filename. Use letters, numbers, underscore, hyphen or dot.
  pause
  goto START
)
if /i not "%NAME:~-3%"==".py" set "NAME=%NAME%.py"
set "TARGET=%SAVE%\%NAME%"
echo.
echo Downloading %NAME%...
curl.exe --fail --location --silent --show-error --output "%TARGET%.download" "%BASE%/%NAME%"
if errorlevel 1 (
  if exist "%TARGET%.download" del "%TARGET%.download"
  echo File not found or download failed.
  pause
  goto START
)
move /y "%TARGET%.download" "%TARGET%" >nul
if errorlevel 1 (
  echo Could not save the file.
  pause
  goto START
)
echo Opening in Notepad...
notepad "%TARGET%"
goto START
