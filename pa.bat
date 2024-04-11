
@echo off
if "%1"=="install" (
    call install.bat
) else if "%1"=="uninstall" (
    call uninstall.bat
) else (
    
    lua C:\Users\Daniel\Desktop\personal\personalAsistantCLI\personalAssistant.lua %*
)