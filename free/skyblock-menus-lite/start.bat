@echo off
REM ===========================================================================
REM  SkyBlock Menus Lite - start.bat (Windows)
REM
REM  If the server dies immediately with "could not reserve enough space",
REM  lower MAX_RAM below. Leave at least 1 GB for Windows itself.
REM ===========================================================================
setlocal
title SkyBlock Menus Lite
cd /d "%~dp0"

set MIN_RAM=1G
set MAX_RAM=4G

REM The installer puts a portable Java in runtime\ when the machine has none.
set "JAVA=java"
if exist "%~dp0runtime\bin\java.exe" set "JAVA=%~dp0runtime\bin\java.exe"

if not exist "server.jar" goto nojar

REM Paper will not start until eula.txt says eula=true. Catch it here so the
REM window does not just flash and close on a first run.
REM EULA: asked once, in this window. Typing YES writes eula.txt.
findstr /C:"eula=true" "eula.txt" >nul 2>&1
if not errorlevel 1 goto eulaok

echo.
echo ================================================================
echo   Minecraft EULA
echo ================================================================
echo.
echo   Accept it to run this server:  https://aka.ms/MinecraftEULA
echo.
set "EULA_ANSWER="
set /p EULA_ANSWER=  Type YES to accept, or press Enter to quit:
if /I not "%EULA_ANSWER%"=="YES" goto eulano
> "eula.txt" echo eula=true
echo.
echo   EULA accepted. Starting the server...
echo.
:eulaok

where java >nul 2>&1
if errorlevel 1 if not exist "%~dp0runtime\bin\java.exe" goto nojava

"%JAVA%" -Xms%MIN_RAM% -Xmx%MAX_RAM% ^
 -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 ^
 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch ^
 -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M ^
 -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 ^
 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 ^
 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 ^
 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 ^
 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true ^
 -jar server.jar nogui

echo.
echo Server stopped. Press any key to close this window.
pause >nul
exit /b 0

:nojar
echo.
echo ================================================================
echo   server.jar is missing
echo ================================================================
echo.
echo   Run install.bat first - it downloads Paper into this folder.
echo.
echo ================================================================
echo.
pause
exit /b 1

:eulano
echo.
echo   EULA not accepted - nothing was started.
pause
exit /b 1

:nojava
echo.
echo ================================================================
echo   Java 25 is not installed
echo ================================================================
echo.
echo   Run  install.bat  again - it downloads a portable Java for
echo   this server automatically. Nothing to install by hand.
echo.
echo   Or install Java 25 yourself:
echo   https://adoptium.net/temurin/releases/?version=25
echo ================================================================
echo.
pause
exit /b 1
