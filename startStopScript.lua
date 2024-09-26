local settingsFile = "app_settings.json"
local keyToRetrieve = "projects-paths"
local json = require("json") -- Assuming you have a JSON library available

local activeProcess = nil

-- Function to load the config and retrieve the path
local function loadConfig(fileName)
	local absolutePath = arg[0]:match("^(.*[\\/])") or ""
	local settings = io.open(absolutePath .. settingsFile, "r")
	if settings then
		local settings_content = settings:read("*a")
		local settingsDecoded = json.decode(settings_content) or {}
		settings:close()
		return settingsDecoded[keyToRetrieve] and settingsDecoded[keyToRetrieve][fileName]
	end
	return nil
end

-- Function to determine the command based on fileName and runType
local function determineCommand(fileName, runType)
	local baseCommand = "yarn install && yarn start"

	if fileName == "server" then
		if runType == nil then
			return baseCommand .. ":dev"
		elseif runType == "dev" then
			return baseCommand .. ":devEnv"
		elseif runType == "test" then
			return baseCommand .. ":testEnv"
		end
	else
		if runType == "dev" then
			return baseCommand .. ":devEnv"
		elseif runType == "test" then
			return baseCommand .. ":testEnv"
		else
			return baseCommand
		end
	end
end

-- Function to navigate to the path and start the command
local function startProcess(fileName, runType)
	local path = loadConfig(fileName)
	if path then
		local command = "cd " .. path .. " && " .. determineCommand(fileName, runType)
		-- Use os.execute instead of io.popen to avoid broken pipe issues
		os.execute(command)
		print("Started process for file: " .. fileName .. " with command: " .. command)
	else
		print("Path not found for file: " .. fileName)
	end
end

-- Function to stop the active process
local function stopProcess()
	if activeProcess then
		activeProcess:close()
		activeProcess = nil
		print("Process stopped")
	else
		print("No active process to stop")
	end
end

-- Determine if the command is start or stop
local command = arg[1]:lower()
local fileName = arg[2]
local runType = arg[3] -- dev, test, or nil

if command == "start" then
	if fileName then
		startProcess(fileName, runType)
	else
		print("Error: No file name provided for the start command.")
	end
elseif command == "stop" then
	stopProcess()
else
	print("Invalid command. Use 'start' or 'stop'.")
end
