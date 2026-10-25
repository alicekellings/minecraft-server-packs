@echo off
REM ===========================================================================
REM  Double-click this file. That is the whole install step.
REM
REM  Installs into this folder by default. To install into an existing server
REM  folder instead, drag that folder onto this file, or run from a terminal:
REM
REM      install.bat "D:\servers\my-server"
REM
REM  Safe to run more than once - files that already match are skipped.
REM ===========================================================================
setlocal
title Server setup
cd /d "%~dp0"

if "%~1"=="" (
    powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0installer\install.ps1"
) else (
    powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0installer\install.ps1" -Target "%~1"
)

echo.
pause
