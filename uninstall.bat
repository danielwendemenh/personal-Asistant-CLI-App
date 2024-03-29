@echo off
cd /d "%~dp0"
choco uninstall lua -y
choco uninstall luarocks -y
cd "%~dp0"
powershell -ExecutionPolicy Bypass -File "uninstallChoco.ps1"
