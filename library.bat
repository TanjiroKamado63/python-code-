@echo off
setlocal EnableExtensions DisableDelayedExpansion
title Python Practical Library
set "LIB_DIR=%USERPROFILE%\Documents\IoTPracticalLibrary"
if not exist "%LIB_DIR%" mkdir "%LIB_DIR%"
:MENU
cls
echo ============================================
echo          PYTHON PRACTICAL LIBRARY
echo ============================================
echo Type the practical's filename (with or without extension).
echo Example: PRACTICAL 1 - LED BLINKING PATTERNS
echo Type exit to quit.
echo.
set "PRACTICAL_NAME="
set /p "PRACTICAL_NAME=Enter practical name: "
if not defined PRACTICAL_NAME goto MENU
if /I "%PRACTICAL_NAME%"=="exit" exit /b 0
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command ^
  "$ErrorActionPreference='Stop';" ^
  "$wanted=$env:PRACTICAL_NAME.Trim();" ^
  "$api='https://api.github.com/repos/TanjiroKamado63/python-code-/contents/';" ^
  "try {" ^
  "  $items=@(Invoke-RestMethod -Uri $api -Headers @{'User-Agent'='IoTPracticalLibrary'});" ^
  "  $matches=@($items | Where-Object { $_.type -eq 'file' -and ($_.name -ieq $wanted -or [IO.Path]::GetFileNameWithoutExtension($_.name) -ieq $wanted) });" ^
  "  if ($matches.Count -eq 0) { Write-Host 'No matching file found on GitHub.' -ForegroundColor Yellow; Write-Host 'Check spelling, spaces, and punctuation.'; exit 2 };" ^
  "  if ($matches.Count -gt 1) { Write-Host 'Multiple files match. Enter the full filename including extension:' -ForegroundColor Yellow; $matches | ForEach-Object { Write-Host ('  ' + $_.name) }; exit 3 };" ^
  "  $item=$matches[0];" ^
  "  $dest=Join-Path $env:LIB_DIR $item.name;" ^
  "  Write-Host ('Downloading: ' + $item.name);" ^
  "  Invoke-WebRequest -Uri $item.download_url -OutFile $dest -UseBasicParsing;" ^
  "  Write-Host 'Opening in Notepad...';" ^
  "  Start-Process -FilePath notepad.exe -ArgumentList ('\"' + $dest + '\"') -Wait;" ^
  "} catch { Write-Host ('Error: ' + $_.Exception.Message) -ForegroundColor Red; exit 1 }"
echo.
pause
goto MENU
