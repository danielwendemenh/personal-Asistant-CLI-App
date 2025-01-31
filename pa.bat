@echo off
setlocal

:: Get the directory of the batch script
set "DIRNAME=%~dp0"

if "%1"=="install" (
    call "%DIRNAME%install.bat"
) else if "%1"=="uninstall" (
    call "%DIRNAME%uninstall.bat"
) else (
    echo (%DIRNAME%)
    lua "%DIRNAME%personalAssistant.lua" %*
)

endlocal
