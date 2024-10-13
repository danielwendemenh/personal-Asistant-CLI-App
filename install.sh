#!/bin/bash

# Install Chocolatey (via curl, since Chocolatey is primarily for Windows)
echo "Chocolatey is a Windows package manager. Installing Chocolatey on Linux is not supported."

# You might want to use a package manager available on your system instead.
# For example, using apt (for Debian/Ubuntu-based systems) to install Lua and LuaRocks:
echo "Installing Lua and LuaRocks using apt..."
sudo apt update
sudo apt install lua5.3 luarocks -y

echo "Installation complete."
