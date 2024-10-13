#!/bin/bash

# Change to the directory where the script is located
cd "$(dirname "$0")"

# Uninstall Lua and LuaRocks using apt (or another package manager)
echo "Uninstalling Lua and LuaRocks..."
sudo apt remove lua luarocks -y

# Note: Chocolatey is not available on Linux, so we skip uninstalling it.

echo "Uninstallation complete."
