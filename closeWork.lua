
local processNames = {
    "code",               -- Visual Studio Code
    "mongodb-compass",    -- MongoDB Compass
    "slack",              -- Slack
    "gnome-terminal",      -- Terminal (use as needed)
}

-- Function to kill a process by its name
local function killProcess(processName)
    os.execute('killall ' .. processName)
end

-- Function to kill all processes in the processNames table
local function killProcesses()
    for _, processName in ipairs(processNames) do
        killProcess(processName)
    end
end

-- Execute the function to kill the processes
killProcesses()
