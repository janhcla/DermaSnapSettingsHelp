@echo off
setlocal enabledelayedexpansion

echo ==========================================
echo   Searching for "MediaCapture" folder
echo ==========================================
echo.

cmd /k

:: Set the target folder name (hardcoded)
set "TARGET=MediaCapture"
set "foundPath="

:: Loop over all mapped drives (detected via net use)
for /f "skip=1 tokens=2,3,*" %%A in ('net use ^| findstr /r "^[A-Z]: " ') do (
    set "drv=%%A"
    set "unc=%%B"
    if exist "!drv!\\" (
        echo Checking drive !drv! (UNC: !unc!)...
        rem Look for a folder that ends with \MediaCapture
        for /f "delims=" %%F in ('dir "!drv!\%TARGET%" /s /b /ad 2^>nul ^| findstr /i /r /c:"\\%TARGET%$"') do (
            set "foundPath=%%F"
            set "foundDrv=!drv!"
            goto :ProcessFound
        )
    )
)

:ProcessFound
if not defined foundPath (
    echo.
    echo The folder "%TARGET%" was not found on any mapped drive.
    pause
    exit /b
)

:: Calculate the relative path by removing the drive letter, colon and backslash.
:: E.g. if foundPath = "X:\Data\MediaCapture" then relative path = "Data\MediaCapture"
set "relPath=%foundPath:~3%"

:: Retrieve the UNC mapping for the drive where the folder was found.
for /f "tokens=2 delims= " %%A in ('net use !foundDrv! ^| findstr /I /c:"!foundDrv!"') do set "UNC_MAPPING=%%A"

:: Parse UNC mapping; expected format: \\ServerName\ShareName
set "UNC_NO_SLASHES=%UNC_MAPPING:~2%"
for /f "tokens=1,2 delims=\" %%I in ("!UNC_NO_SLASHES!") do (
    set "serverName=%%I"
    set "shareName=%%J"
)

:: Resolve the server's IP address (using ping)
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
