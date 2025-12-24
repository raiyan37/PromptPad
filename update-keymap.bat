@echo off
title Macropad Auto-Watcher - Monitoring Downloads...

REM Set your paths here - CHANGE THESE TO MATCH YOUR SYSTEM
set "DOWNLOADS_PATH=%USERPROFILE%\Downloads"
set "QMK_KEYMAP_PATH=C:\Users\sunny\qmk_firmware\keyboards\macropad_v2\keymaps\default"

echo ==========================================
echo    Macropad Auto-Watcher ACTIVE
echo ==========================================
echo.
echo Monitoring Downloads folder for keymap.c...
echo Press Ctrl+C to stop monitoring
echo.

:MONITOR_LOOP
REM Check if keymap.c exists in Downloads
if exist "%DOWNLOADS_PATH%\keymap.c" (
    echo.
    echo *** keymap.c detected! ***
    echo Processing automatically in 3 seconds...
    echo (Press Ctrl+C to cancel)
    
    REM Give user a moment to cancel if needed
    timeout /t 3 /nobreak >nul
    
    REM Check if file still exists (user might have moved it)
    if exist "%DOWNLOADS_PATH%\keymap.c" (
        call :PROCESS_KEYMAP
    ) else (
        echo File was moved or deleted, continuing to monitor...
    )
)

REM Wait 2 seconds before checking again
timeout /t 2 /nobreak >nul
goto MONITOR_LOOP

:PROCESS_KEYMAP
echo.
echo ==========================================
echo Processing keymap.c...
echo ==========================================

REM Check if QMK folder exists
if not exist "%QMK_KEYMAP_PATH%" (
    echo ERROR: QMK keymap folder not found at %QMK_KEYMAP_PATH%
    echo Please check the path and update this script.
    pause
    goto MONITOR_LOOP
)

REM Backup existing keymap.c
if exist "%QMK_KEYMAP_PATH%\keymap.c" (
    echo Creating backup of existing keymap.c...
    copy "%QMK_KEYMAP_PATH%\keymap.c" "%QMK_KEYMAP_PATH%\keymap_backup_%date:~-4,4%%date:~-10,2%%date:~-7,2%_%time:~0,2%%time:~3,2%%time:~6,2%.c" >nul 2>&1
    if errorlevel 1 (
        echo Warning: Could not create backup
    ) else (
        echo Backup created successfully
    )
)

REM Copy new keymap.c
echo Copying new keymap.c to QMK folder...
copy "%DOWNLOADS_PATH%\keymap.c" "%QMK_KEYMAP_PATH%\keymap.c"

if errorlevel 1 (
    echo ERROR: Failed to copy keymap.c
    echo Continuing to monitor...
    goto MONITOR_LOOP
)

echo SUCCESS: keymap.c updated!

REM Clean up - delete from Downloads
echo Cleaning up Downloads folder...
del "%DOWNLOADS_PATH%\keymap.c"

REM Auto-compile option
echo.
echo Auto-compiling firmware...
cd /d "C:\Users\sunny\qmk_firmware"
qmk compile -kb macropad_v2 -km default

if errorlevel 1 (
    echo.
    echo Compilation failed! Check for errors above.
    echo Continuing to monitor for new files...
    echo.
    goto MONITOR_LOOP
)

echo.
echo *** Compilation successful! ***
echo *** Ready to flash to your macropad ***
echo.

REM Optional: Auto-flash (commented out for safety)
REM echo Put your macropad in bootloader mode and press any key...
REM pause >nul
REM qmk flash -kb macropad_v2 -km default

echo Continuing to monitor for new keymap files...
echo.
goto MONITOR_LOOP