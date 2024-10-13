#!/bin/bash

# Check the first argument
if [ "$1" == "install" ]; then
    # Call the install script
    ./install.sh
elif [ "$1" == "uninstall" ]; then
    # Call the uninstall script
    ./uninstall.sh
else
    # Execute the Lua script with all arguments
    lua /home/daniel/Dev/Personal/personalAsistantCLI/personalAssistant.lua "$@"
fi
