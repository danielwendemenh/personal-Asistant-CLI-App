local processNames = {
    "Code.exe",
    "MongoDBCompass.exe",
    "slack.exe",
    "cmd.exe",
}
local function closeWindowByTitle(windowTitle)
    os.execute('taskkill /FI "WINDOWTITLE eq ' .. windowTitle .. '"')
end
local function killProcess(processName)
    os.execute('taskkill /F /IM ' .. processName)
end
local function killProcesses()
    for _, processName in ipairs(processNames) do
        killProcess(processName)
    end

end
killProcesses()
