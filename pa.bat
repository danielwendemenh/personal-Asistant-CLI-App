@echo off
setlocal

:: Get the short (ASCII-only) path of the batch script directory
for %%I in ("%~dp0") do set "DIRNAME=%%~sI"
set "LUA_PATH=%APPDATA%\luarocks\share\lua\5.4\?.lua;%APPDATA%\luarocks\share\lua\5.4\?\init.lua;;"
set "LUA_CPATH=%APPDATA%\luarocks\lib\lua\5.4\?.dll;;"

lua "%DIRNAME%personalAssistant.lua" %*

endlocal