local socket = require("socket");
local settingsFile = "app_settings.json";
local ScriptKeys = "start-scripts";
local ProjectsKeys = "projects-paths";
local json = require("json");
local activeProcesses = {};
local settingsCache = nil;
local shouldExit = false;
local function signalHandler()
	shouldExit = true;
	stopAllProcesses();
end;
pcall(function()
	local posix = require("posix");
	posix.signal(posix.SIGINT, signalHandler);
end);
local function loadSettings()
	if not settingsCache then
		local absolutePath = arg[0]:match("^(.*[\\/])") or "";
		local settings, err = io.open(absolutePath .. settingsFile, "r");
		if not settings then
			print("Error opening settings file: " .. (err or "unknown error"));
			return nil;
		end;
		local settingsContent = settings:read("*a");
		settings:close();
		local success, settingsDecoded = pcall(json.decode, settingsContent);
		if success then
			settingsCache = settingsDecoded or {};
		else
			print("Error decoding JSON settings: " .. tostring(settingsDecoded));
		end;
	end;
	return settingsCache;
end;
local function loadActiveProcesses()
	local file, err = io.open("active_processes.json", "r");
	if not file then
		print("No previous active processes to load, creating a new file.");
		local newFile, createErr = io.open("active_processes.json", "w");
		if newFile then
			newFile:write(json.encode({}));
			newFile:close();
		else
			print("Failed to create active processes file: " .. (createErr or "unknown error"));
		end;
		return;
	end;
	local content = file:read("*a");
	file:close();
	local success, processData = pcall(json.decode, content);
	if success and processData then
		activeProcesses = processData;
	else
		print("Failed to load active processes: " .. (processData or "Unknown error"));
	end;
end;
local function saveActiveProcesses()
	local processData = {};
	for key, process in pairs(activeProcesses) do
		processData[key] = process;
	end;
	local file, err = io.open("active_processes.json", "w");
	if file then
		pcall(function()
			file:write(json.encode(processData));
		end);
		file:close();
	else
		print("Failed to save active processes: " .. (err or "unknown error"));
	end;
end;
local function loadConfig(fileName)
	local settings = loadSettings();
	if settings then
		return settings[ScriptKeys] and settings[ScriptKeys][fileName];
	end;
	return nil;
end;
local function loadProject(project)
	local settings = loadSettings();
	if settings then
		return settings[ProjectsKeys] and settings[ProjectsKeys][project];
	end;
	return nil;
end;
local function determineCommand(fileName, runType)
	local baseCommand = "yarn start";
	local commands = {
		server = {
			default = baseCommand .. ":devEnv",
			dev = baseCommand .. ":devEnv",
			test = baseCommand .. ":testEnv"
		},
		default = {
			dev = baseCommand .. ":devEnv",
			test = baseCommand .. ":testEnv"
		}
	};
	return commands[fileName] and commands[fileName][runType] or commands.default[runType] or baseCommand;
end;
local function startProcess(app, runType)
	local appConfig = loadConfig(app);
	if not appConfig then
		print("No configuration found for file: " .. app);
		return;
	end;
	for key, value in pairs(appConfig) do
		local project = loadProject(key);
		if project then
			local command = "cd " .. project .. " && " .. determineCommand(key, runType);
			local process, err = io.popen(command, "r");
			if process then
				activeProcesses[key] = process;
			else
				print("Failed to start process for file: " .. key .. ". Error: " .. (err or "unknown error"));
			end;
		else
			print("Path not found for project: " .. key);
		end;
	end;
end;
local function checkProcesses()
	while not shouldExit do
		for key, process in pairs(activeProcesses) do
			local output = process:read("*l");
			if output then
				print("[" .. key .. "] " .. output);
			end;
		end;
		socket.sleep(0.5);
	end;
end;
local function stopAllProcesses()
	saveActiveProcesses();
	for key, process in pairs(activeProcesses) do
		if process then
			process:close();
		end;
		activeProcesses[key] = nil;
	end;
end;
local function listProcesses()
	print("Active processes:");
	for key, process in pairs(activeProcesses) do
		print("- " .. key);
	end;
end;
local function processCommand(command, fileName, runType)
	local validCommands = {
		start = true,
		stop = true,
		show = true,
		restart = true,
		status = true
	};
	if not command or (not validCommands[command]) then
		print("Invalid command. Use 'start', 'stop', 'show', 'restart', or 'status'.");
		return;
	end;
	if command == "start" then
		if fileName and fileName ~= "" then
			startProcess(fileName, runType);
			checkProcesses();
		else
			print("Error: No file name provided for the start command.");
		end;
	elseif command == "stop" then
		stopAllProcesses();
	elseif command == "show" then
		listProcesses();
	elseif command == "restart" then
		stopAllProcesses();
		if fileName and fileName ~= "" then
			startProcess(fileName, runType);
			checkProcesses();
		else
			print("Error: No file name provided for the restart command.");
		end;
	elseif command == "status" then
		listProcesses();
	end;
end;
loadActiveProcesses();
local command = (arg[1] or ""):lower();
local fileName = arg[2];
local runType = arg[3] or "default";
processCommand(command, fileName, runType);
