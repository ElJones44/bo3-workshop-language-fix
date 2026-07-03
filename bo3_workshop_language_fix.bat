@echo off
setlocal enabledelayedexpansion

set "ROOT=C:\Program Files (x86)\Steam\steamapps\workshop\content\311210"
set "LOGFILE=%TEMP%\changed_folders_%RANDOM%.txt"
if exist "%LOGFILE%" del "%LOGFILE%"

set /p "LANG=Please enter the language prefix to use (e.g. ge, fr, it): "

if "%LANG%"=="" (
    echo No prefix entered. Exiting.
    pause
    goto :eof
)

echo.
echo Using prefix "%LANG%" - scanning "%ROOT%" ...
echo.

set "CHANGE_COUNT=0"

for /d %%D in ("%ROOT%\*") do call :processFolder "%%D"

echo.
echo ================= Summary =================
if !CHANGE_COUNT!==0 (
    echo No folders were changed.
) else (
    echo !CHANGE_COUNT! folder^(s^) were changed:
    type "%LOGFILE%"
)
echo =============================================

if exist "%LOGFILE%" del "%LOGFILE%"
pause
goto :eof


:processFolder
set "FOLDER=%~1"
set "NEED_FF="
set "NEED_XPAK="
set "SRC_FF="
set "SRC_FF_NAME="
set "FALLBACK_FF="
set "SRC_XPAK="
set "SRC_XPAK_NAME="
set "FALLBACK_XPAK="

rem ================= .ff =================
set "FOUND_TARGET_FF="
for %%F in ("!FOLDER!\!LANG!*.ff") do set "FOUND_TARGET_FF=1"

if not defined FOUND_TARGET_FF (
    for %%F in ("!FOLDER!\en*.ff") do (
        if not defined SRC_FF (
            set "SRC_FF=%%F"
            set "SRC_FF_NAME=%%~nF"
        )
    )
    if not defined SRC_FF (
        for %%F in ("!FOLDER!\*.ff") do (
            if not defined SRC_FF (
                set "SRC_FF=%%F"
                set "SRC_FF_NAME=%%~nF"
                set "FALLBACK_FF=1"
            )
        )
    )
    if defined SRC_FF set "NEED_FF=1"
)

rem ================= .xpak =================
set "FOUND_TARGET_XPAK="
for %%F in ("!FOLDER!\!LANG!*.xpak") do set "FOUND_TARGET_XPAK=1"

if not defined FOUND_TARGET_XPAK (
    for %%F in ("!FOLDER!\en*.xpak") do (
        if not defined SRC_XPAK (
            set "SRC_XPAK=%%F"
            set "SRC_XPAK_NAME=%%~nF"
        )
    )
    if not defined SRC_XPAK (
        for %%F in ("!FOLDER!\*.xpak") do (
            if not defined SRC_XPAK (
                set "SRC_XPAK=%%F"
                set "SRC_XPAK_NAME=%%~nF"
                set "FALLBACK_XPAK=1"
            )
        )
    )
    if defined SRC_XPAK set "NEED_XPAK=1"
)

if not defined NEED_FF if not defined NEED_XPAK goto :eof

echo Folder: !FOLDER!

if defined NEED_FF (
    set "REST=!SRC_FF_NAME:~2!"
    set "SRCPREFIX=!SRC_FF_NAME:~0,2!"
    if defined FALLBACK_FF (
        echo   - will create !LANG!!REST!.ff  ^(no "en" file found, using fallback "!SRCPREFIX!" file: !SRC_FF_NAME!.ff^)
    ) else (
        echo   - will create !LANG!!REST!.ff  ^(copied from en!REST!.ff^)
    )
)

if defined NEED_XPAK (
    set "REST2=!SRC_XPAK_NAME:~2!"
    set "SRCPREFIX2=!SRC_XPAK_NAME:~0,2!"
    if defined FALLBACK_XPAK (
        echo   - will create !LANG!!REST2!.xpak  ^(no "en" file found, using fallback "!SRCPREFIX2!" file: !SRC_XPAK_NAME!.xpak^)
    ) else (
        echo   - will create !LANG!!REST2!.xpak  ^(copied from en!REST2!.xpak^)
    )
)

set /p "CONFIRM=Proceed with the above change(s) for this folder? (Y/N): "
if /i not "!CONFIRM!"=="Y" (
    echo   Skipped.
    echo.
    goto :eof
)

set "DID_SOMETHING="

if defined NEED_FF (
    set "REST=!SRC_FF_NAME:~2!"
    copy "!SRC_FF!" "!FOLDER!\!LANG!!REST!.ff" >nul
    echo   Created !LANG!!REST!.ff
    set "DID_SOMETHING=1"
)
if defined NEED_XPAK (
    set "REST2=!SRC_XPAK_NAME:~2!"
    copy "!SRC_XPAK!" "!FOLDER!\!LANG!!REST2!.xpak" >nul
    echo   Created !LANG!!REST2!.xpak
    set "DID_SOMETHING=1"
)

if defined DID_SOMETHING (
    set /a CHANGE_COUNT+=1
    echo !FOLDER!>>"%LOGFILE%"
)

echo.
goto :eof