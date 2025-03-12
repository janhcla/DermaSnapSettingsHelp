@echo off
setlocal enabledelayedexpansion

echo ==========================================
echo   Search for a specific folder on all mapped drives
echo ==========================================
echo.

cmd /k

:: Prompt the user to enter the target folder name
set /p TARGET="Enter the target folder name (e.g., MediaCapture): "
if "%TARGET%"=="" (
    echo No folder name entered. Exiting.
    pause
    exit /b
)
set "foundPath="

:: Loop over all mapped drives.
for /f "skip=1 tokens=2,3,*" %%A in ('net use ^| findstr /r "^[A-Z]: " ') do (
    set "drv=%%A"
    set "unc=%%B"
    if exist "!drv!\\" (
        echo Checking drive !drv! (UNC: !unc!)...
        for /f "delims=" %%F in ('dir "!drv!\%TARGET%" /s /b /ad 2^>nul ^| findstr /i /r /c:"\\%TARGET%$"') do (
            set "foundPath=%%F"
            set "foundDrv=!drv!"
            goto :ProcessFound2
        )
    )
)

:ProcessFound2
if not defined foundPath (
    echo.
    echo The folder "%TARGET%" was not found on any mapped drive.
    pause
    exit /b
)

:: Remove drive letter (e.g., "X:\") to get the relative path.
set "relPath=%foundPath:~3%"

:: Retrieve the UNC mapping for the found drive.
for /f "tokens=2 delims= " %%A in ('net use !foundDrv! ^| findstr /I /c:"!foundDrv!"') do set "UNC_MAPPING=%%A"

:: Parse UNC mapping (remove leading "\\" and split into server and share).
set "UNC_NO_SLASHES=%UNC_MAPPING:~2%"
for /f "tokens=1,2 delims=\" %%I in ("!UNC_NO_SLASHES!") do (
    set "serverName=%%I"
    set "shareName=%%J"
)

:: Resolve server IP address.
for /f "tokens=2 delims=[]" %%i in ('ping -4 -n 1 !serverName! ^| findstr "["') do set "serverIP=%%i"
if not defined serverIP set "serverIP=Unknown"

echo.
echo === Results ===
echo Server IP address:     !serverIP!
echo Share Name:            !shareName!
echo Target directory path: !relPath!
echo.
pause
endlocal
