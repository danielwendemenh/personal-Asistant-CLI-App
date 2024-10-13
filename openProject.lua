local json = require("cjson")


local function logTable(data)
    print(json.encode(data))
end

local settingsFile = "app_settings.json"
local keyToRetrieve = "projects-paths"

local function loadConfig()
    local absolutePath = arg[0]:match("^(.*[//])") or ""
    local settings = io.open(absolutePath .. "/" .. settingsFile, "r")
    if settings then
        local settings_content = settings:read("*a")
        local settingsDecoded = json.decode(settings_content) or {}
        settings:close()
        return settingsDecoded[keyToRetrieve]
    end
    return {}
end

local function deleteAllLines(filePath)
    local file = io.open(filePath, "w") -- Open the file in write mode
    if file then
        file:close() -- Close the file
    else
        print("Error: Unable to open file for writing.")
    end
end

local function saveConfig(config)
    local absolutePath = arg[0]:match("^(.*[//])") or ""
    local settings = io.open(absolutePath .. "/" .. settingsFile, "r+") -- Open file in read-write mode
    if settings then
        local settings_content = settings:read("*a")
        settings:close() -- Close the file after writing
        deleteAllLines(absolutePath .. "/" .. settingsFile)
        local settingsDecoded = json.decode(settings_content) or {}
        settingsDecoded[keyToRetrieve] = config
        settings = io.open(absolutePath .. "/" .. settingsFile, "r+")
        logTable(settingsDecoded)
        settings:write(json.encode(settingsDecoded))
        settings:close() -- Close the file after writing
    end
end

local function printUsage()
    print("Usage: pa open [-a <projectPath>] <projectName>")
end

local function listProjects()
    local projectPaths = loadConfig()
    local count = 0
    for projectName, projectPath in pairs(projectPaths) do
        count = count + 1
        print(count, "", projectName,'',projectPath)
    end
    print("total: ", count)
end

local args = { ... }
local projectPaths = loadConfig()
local projectPath
local projectName
local capturePath = false
local capturePojectNameToDelete = false
for i, argValue in ipairs(args) do
    if argValue == "-list" or argValue == "-l" then
        listProjects()
        os.exit(1)
    elseif argValue == "-d" then
        capturePojectNameToDelete = true
    elseif capturePojectNameToDelete and not projectName then
        projectName = string.lower(argValue)
        local selectedProjects = {}
        local updatedConfig = {}

        for key, value in pairs(projectPaths) do
            if key ~= projectName then
                updatedConfig[key] = value
            end
        end

        projectPaths = updatedConfig

        saveConfig(projectPaths)
        os.exit(1)
    elseif argValue == "set" then
        -- set a default projectName
    elseif argValue == "-add" or argValue == "-a" then
        capturePath = true
    elseif capturePath and not projectPath then
        projectPath = argValue
    elseif argValue ~= "open" then
        local parts = {}
        for part in argValue:gmatch("[^,]+") do
            table.insert(parts, part)
        end
        projectName = string.lower(parts[#parts])
        if not capturePath and projectPaths[projectName] then
			local open_command = { "code --new-window --goto", projectPaths[projectName] }
            os.execute(table.concat(open_command, " "))
        end
    end
end

if not projectName then
    printUsage()
    os.exit(1)
end

if projectPaths[projectName] then
	local open_command = { "code --new-window --goto", projectPaths[projectName] }
    os.execute(table.concat(open_command, " "))
    os.exit()
elseif projectPath then
    projectPaths[projectName] = projectPath
    saveConfig(projectPaths)
    print("Projects added successfully.")
    os.exit()
else
    print("Error: Project not found -", projectName)
end
