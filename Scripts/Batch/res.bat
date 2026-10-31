@echo off
title Resolution Switch
echo.
echo 1 - def (1920x1080)
echo 2 - 4:3 (1440x1080)
echo 3 - 32:27 (1280x1080)
echo.
set /p choice=Select option [1/2/3]: 

if "%choice%"=="1" (
    nircmd.exe setdisplay 1920 1080 32
    echo Switched to 1920x1080
) else if "%choice%"=="2" (
    nircmd.exe setdisplay 1440 1080 32
    echo Switched to 1440x1080
) else if "%choice%"=="3" (
    nircmd.exe setdisplay 1280 1080 32
    echo Switched to 1280x1080
) else (
    echo Invalid input.
)

echo.
pause
