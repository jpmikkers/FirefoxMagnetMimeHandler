@echo off
REM echo running script "%~f0"
REM echo with argument "%*"
REM pause
pushd %~dp0
PowerShell -ExecutionPolicy Unrestricted -File mimehandler.ps1 "%*"
popd
