@echo off
chcp 1252 >nul
setlocal EnableDelayedExpansion
REM ---------------------------------------------------------
REM DermaSnap - Auto-find MediaCapture Folder (Version 1)
REM Søg automatisk efter mappen "MediaCapture" på et SMB-share.
REM ---------------------------------------------------------

REM Forudindstillet target folder
set "TARGET_FOLDER=MediaCapture"

REM Initialiser variable
set "FOUND_SHARE="
set "FOUND_SERVER="

REM 1) Forsøg først at finde en netværksmapping via "net use"
for /f "skip=1 tokens=2,*" %%A in ('net use ^| find "\\"') do (
    set "UNC=%%A"
    REM Fjern de to første backslashes og opdel i server og share
    for /f "tokens=1,2 delims=\ " %%i in ("!UNC:~2!") do (
         set "SERVER=%%i"
         set "SHARE=%%j"
    )
    REM Test om mappen findes med pushd
    pushd "\\!SERVER!\!SHARE!\%TARGET_FOLDER%" 2>nul
    if not errorlevel 1 (
         popd
         set "FOUND_SHARE=!SHARE!"
         set "FOUND_SERVER=!SERVER!"
         goto :FOUND
    )
)

:FOUND
REM 2) Hvis ingen netværksmapping blev fundet, gennemgå de lokale shares med "net share"
if not defined FOUND_SHARE (
    for /f "skip=2 tokens=1" %%S in ('net share') do (
        REM Udeluk kun IPC$, men accepter f.eks. F$
        if /I not "%%S"=="IPC$" (
            set "SHARE=%%S"
            pushd "\\%computername%\!SHARE!\%TARGET_FOLDER%" 2>nul
            if not errorlevel 1 (
                 popd
                 set "FOUND_SHARE=!SHARE!"
                 set "FOUND_SERVER=%computername%"
                 goto :FOUND2
            )
        )
    )
)
:FOUND2

if not defined FOUND_SHARE (
    echo [FEJL] Kunne ikke finde mappen "%TARGET_FOLDER%" på nogen SMB-share.
    pause
    exit /B 1
)

REM Hent serverens IP ved at pinge den fundne server (tvinger IPv4 med -4)
for /f "tokens=2 delims=[]" %%i in ('ping -4 -n 1 !FOUND_SERVER! ^| find "Pinging"') do set "SERVER_IP=%%i"

echo ============================================
echo DermaSnap - Udfyldningsformular
echo ============================================
echo Server IP: %SERVER_IP%
echo SMB Share: %FOUND_SHARE%
echo Full Path: \\%SERVER_IP%\%FOUND_SHARE%\%TARGET_FOLDER%
echo ============================================
pause
exit /B 0
