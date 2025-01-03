#!/bin/bash

# Inform about Chocolatey
echo "Chocolatey is a Windows package manager. Installing Chocolatey on Linux is not supported."

# Install Lua and LuaRocks
echo "Installing Lua and LuaRocks using apt..."
sudo apt update
sudo apt install lua5.3 luarocks -y

# Define paths
INSTALL_DIR="/home/daniel/Desktop/personalAsistantCLI"
BASHRC="$HOME/.bashrc"

# Make pa.sh executable
chmod +x "$INSTALL_DIR/pa.sh"
echo "Made pa.sh executable."

# Add INSTALL_DIR to PATH if it's not already there
if ! grep -q "$INSTALL_DIR" "$BASHRC"; then
    echo "export PATH=\"$INSTALL_DIR:\$PATH\"" >> "$BASHRC"
    echo "Added $INSTALL_DIR to PATH."
else
    echo "$INSTALL_DIR is already in PATH."
fi

# Add alias for pa to ~/.bashrc if it's not already there
if ! grep -q "alias pa=" "$BASHRC"; then
    echo "alias pa=\"$INSTALL_DIR/pa.sh\"" >> "$BASHRC"
    echo "Created alias 'pa' for $INSTALL_DIR/pa.sh."
else
    echo "Alias 'pa' already exists."
fi

# Reload .bashrc to apply changes
echo "Reloading .bashrc..."
source "$BASHRC"

echo "Installation complete."
