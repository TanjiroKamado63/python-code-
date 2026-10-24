@echo off
setlocal EnableExtensions DisableDelayedExpansion
title IoT Practical Library
set "REPO=TanjiroKamado63/python-code-"
set "BRANCH=main"
set "SAVE=%USERPROFILE%\Documents\IoTPracticalLibrary"
if not exist "%SAVE%" mkdir "%SAVE%"
:MENU
cls
echo ==============================================================
echo                      IoT PRACTICAL LIBRARY
echo ==============================================================
echo  1  - PRACTICAL 1  - LED BLINKING PATTERNS
echo  2  - PRACTICAL 2  - 4-DIGIT 7-SEGMENT DISPLAY (TM1637)
echo  3  - PRACTICAL 3  - ADS1015 ADS1115 ADC AND LIVE GRAPH
echo  4  - PRACTICAL 4  - GPS MODULE INTERFACING
echo  5  - PRACTICAL 5  - RFID RC522 READ WRITE
echo  6  - PRACTICAL 6  - 16x2 I2C LCD
echo  8  - PRACTICAL 8  - FINGERPRINT SENSOR ENROLLMENT
echo  9  - PRACTICAL 9  - FINGERPRINT DOOR LOCK (PRACTICAL 12)
echo 10  - PRACTICAL 10 - FLASK RELAY DASHBOARD (PRACTICAL 14)
echo 11  - PRACTICAL 11 - MQTT PUBLISHER SUBSCRIBER LED CONTROL
echo 12  - PRACTICAL 12 - EMBEDDED ACCESS CONTROL
echo ==============================================================
echo Type exit to quit.
echo.
set "CHOICE="
set /p "CHOICE=Which practical do you want? Enter number: "
if /I "%CHOICE%"=="exit" exit /b 0
set "NUMBER="
for %%N in (1 2 3 4 5 6 8 9 10 11 12) do if "%CHOICE%"=="%%N" set "NUMBER=%%N"
if not defined NUMBER (
 echo Invalid choice. Please enter a number shown above.
 pause
 goto MENU
)
echo.
echo Searching GitHub for Practical %NUMBER%...
set "LIB_REPO=%REPO%"
set "LIB_BRANCH=%BRANCH%"
set "LIB_NUMBER=%NUMBER%"
set "LIB_SAVE=%SAVE%"
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command ^
 "$ErrorActionPreference='Stop'; try {" ^
 " $repo=$env:LIB_REPO; $branch=$env:LIB_BRANCH; $num=$env:LIB_NUMBER; $dest=$env:LIB_SAVE;" ^
 " $headers=@{'User-Agent'='IoTPracticalLibrary'};" ^
 " $api='https://api.github.com/repos/'+$repo+'/git/trees/'+$branch+'?recursive=1';" ^
 " $tree=Invoke-RestMethod -Uri $api -Headers $headers;" ^
 " $files=@($tree.tree | Where-Object { $_.type -eq 'blob' -and $_.path -notmatch '(^|/)library( \([0-9]+\))?\.bat$' });" ^
 " $matches=@($files | Where-Object { $leaf=($_.path -split '/')[-1]; $leaf -match ('^(?i:PRACTICAL\s*'+$num+'(?!\d))\b') });" ^
 " if ($matches.Count -eq 0) { $matches=@($files | Where-Object { $leaf=($_.path -split '/')[-1]; $leaf -match ('^(?i:P'+$num+'(?!\d))(?=\D|$)') }) };" ^
 " if ($matches.Count -eq 0) { throw 'No matching practical file found in GitHub.' };" ^
 " if ($matches.Count -gt 1) { Write-Host 'Multiple matching files:'; $matches | ForEach-Object { Write-Host $_.path }; throw 'Please rename duplicate practical files to make the choice unique.' };" ^
 " $item=$matches[0]; $parts=$item.path -split '/'; $encoded=($parts | ForEach-Object { [Uri]::EscapeDataString($_) }) -join '/';" ^
 " $url='https://raw.githubusercontent.com/'+$repo+'/'+$branch+'/'+$encoded;" ^
 " $name=($item.path -split '/')[-1]; $out=Join-Path $dest $name;" ^
 " Write-Host ('Downloading: '+$item.path); Invoke-WebRequest -Uri $url -OutFile $out -UseBasicParsing;" ^
 " Write-Host ('Opening in Notepad: '+$name); Start-Process -FilePath 'notepad.exe' -ArgumentList ('"'+$out+'"') -Wait;" ^
 " } catch { Write-Host ('ERROR: '+$_.Exception.Message); exit 1 }"
if errorlevel 1 pause
goto MENU
