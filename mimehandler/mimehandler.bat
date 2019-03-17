@echo off
REM echo running script "%~f0"
REM echo with argument "%*"
REM pause
pushd %~dp0
PowerShell -ExecutionPolicy Unrestricted -File magnet_add.ps1 "%*"
popd
