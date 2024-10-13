local command = arg[1]:lower()  -- Get the first argument and convert to lowercase
local args = {...}               -- Get all arguments

-- Print the command
print("Command:", command)

-- Print the additional arguments
if #args > 0 then
    print("Arguments:")
    for i, v in ipairs(args) do
        print(i, v)
    end
else
    print("No additional arguments provided.")
end

if string.lower(command) == "--help" then
    print("Supported commands:")
    -- ... (rest of the help message)
    os.exit(0)
end

local scriptPath = debug.getinfo(1, "S").source:sub(2)
local scriptDirectory = scriptPath:match("(.*[//])")
local commandFilePath

if string.lower(command) == "-v" then
    print("1.0.0v")
    os.exit(1)

elseif string.lower(command) == "org" then
    commandFilePath = scriptDirectory .. "org.lua"
    os.execute('lua "' .. commandFilePath .. '"')
elseif string.lower(command) == "install" then
    commandFilePath = scriptDirectory .. "install.lua"
    os.execute('lua "' .. commandFilePath .. '"')
elseif string.lower(command) == "uninstall" then
    commandFilePath = scriptDirectory .. "uninstall.lua"
    os.execute('lua "' .. commandFilePath .. '"')
elseif string.lower(command) == "swap" then
    commandFilePath = scriptDirectory .. "swapServer.lua"
    os.execute('lua "' .. commandFilePath .. '"')

elseif string.lower(command) == "purge" then
    commandFilePath = scriptDirectory .. "purgeDataBase.lua"
    os.execute('lua "' .. commandFilePath .. '"')
elseif string.lower(command) == "chillax" then
    commandFilePath = scriptDirectory .. "closeWork.lua"
    os.execute('lua "' .. commandFilePath .. '"')
elseif string.lower(command) == "open" then
    commandFilePath = scriptDirectory .. "openProject.lua"
    local command2 = {'lua', commandFilePath}
    for _, v in ipairs(args) do
        table.insert(command2, v)
    end
    os.execute(table.concat(command2, " "))
elseif string.lower(command) == "shutdown" then
    os.execute("shutdown /s /f /t 0")
elseif string.lower(command) == "restart" then
    os.execute("shutdown /r /f /t 0")
elseif string.lower(command) == "logout" then
    os.execute("shutdown /l")
elseif string.lower(command) == "goto" then
    commandFilePath = scriptDirectory .. "gotoFolder.lua"
    local command2 = {'lua', commandFilePath}
    for _, v in ipairs(args) do
        table.insert(command2, v)
    end
    os.execute(table.concat(command2, " "))
else
    print("Invalid command. Supported commands: watch, open, drop, setvisible, get, shutdown, restart, logout, goto, --help.")
    os.exit(1)
end
os.exit()
