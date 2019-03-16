@echo off
REM echo running script "%~f0"
REM echo with argument "%*"
REM pause
pushd %~dp0
PowerShell -ExecutionPolicy RemoteSigned -File mimehandler.ps1 "%*"
popd
