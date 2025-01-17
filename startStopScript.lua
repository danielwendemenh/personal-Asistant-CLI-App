local settingsFile = "app_settings.json";
local ScriptKeys = "start-scripts";
local ProjectsKeys = "projects-paths";
local json = require("json");
local activeProcesses = {};
local settingsCache = nil;

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

local function saveActiveProcesses()
	local absolutePath = arg[0]:match("^(.*[\\/])") or "";
	local file = io.open(absolutePath .. "active_processes.json", "w");
	if file then
		file:write(json.encode(activeProcesses));
		file:close();
	else
		print("Failed to save active processes: " .. (err or "unknown error"));
	end;
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
	local appConfig = (loadSettings())[ScriptKeys] and (loadSettings())[ScriptKeys][app];
	if not appConfig then
		print("No configuration found for file: " .. app);
		return;
	end;
	for key, value in pairs(appConfig) do
		local project = (loadSettings())[ProjectsKeys] and (loadSettings())[ProjectsKeys][key];
		if project then
			local command = "cd " .. project .. " && " .. determineCommand(key, runType);
			local process, err = io.popen(command, "r");
			if process then
				activeProcesses[key] = {
					projectName = key,
					status = "running",
					startTime = os.date("%Y-%m-%d %H:%M:%S")
				};
			else
				print("Failed to start process for file: " .. key .. ". Error: " .. (err or "unknown error"));
			end;
		else
			print("Path not found for project: " .. key);
		end;
	end;
	saveActiveProcesses();
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
		else
			print("Error: No file name provided for the start command.");
		end;
	elseif command == "stop" then
		print("Command: stop all processes");
		for key, process in pairs(activeProcesses) do
			process:close();
		end;
		activeProcesses = {};
	elseif command == "show" then
		print("Command: show active processes");
		for key, process in pairs(activeProcesses) do
			print("- " .. key .. " | Status: " .. process.status .. " | Started at: " .. process.startTime);
		end;
	elseif command == "restart" then
		if fileName and fileName ~= "" then
			processCommand("stop");
			processCommand("start", fileName, runType);
		else
			print("Error: No file name provided for the restart command.");
		end;
	elseif command == "status" then
		print("Command: status");
		for key, process in pairs(activeProcesses) do
			print("- " .. key .. " | Status: " .. process.status .. " | Started at: " .. process.startTime);
		end;
	end;
	saveActiveProcesses();
end;
local command = (arg[1] or ""):lower();
local fileName = arg[2];
local runType = arg[3] or "default";

processCommand(command, fileName, runType);
