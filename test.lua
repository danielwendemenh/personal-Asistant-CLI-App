local socket = require("socket");
local posix = require("posix");
local settingsFile = "app_settings.json";
local ScriptKeys = "start-scripts";
local ProjectsKeys = "projects-paths";
local json = require("json");
local activeProcesses = {};
local settingsCache = nil;
local shouldExit = false;
local logFile = assert(io.open("app.log", "a"), "[ERROR] Unable to open log file.");
local function log(message)
	logFile:write(os.date("%Y-%m-%d %H:%M:%S") .. " " .. message .. "\n");
	logFile:flush();
end;
local function signalHandler()
	shouldExit = true;
	stopAllProcesses();
end;
pcall(function()
	posix.signal(posix.SIGINT, signalHandler);
end);
local function loadSettings()
	if settingsCache then
		return settingsCache;
	end;
	local absolutePath = arg[0] and arg[0]:match("^(.*[\\/])") or "";
	local settingsFilePath = absolutePath .. settingsFile;
	local settings, err = io.open(settingsFilePath, "r");
	if settings then
		local settingsContent = settings:read("*a");
		settings:close();
		local success, settingsDecoded = pcall(json.decode, settingsContent);
		if success and type(settingsDecoded) == "table" then
			settingsCache = settingsDecoded;
		else
			log("[ERROR] Failed to decode JSON settings.");
		end;
	else
		log("[ERROR] Failed to open settings file: " .. (err or "unknown error"));
	end;
	return settingsCache or {};
end;
local function atomicWrite(filename, content)
	local tmpFilename = filename .. ".tmp";
	local file, err = io.open(tmpFilename, "w");
	if file then
		file:write(content or "");
		file:close();
		os.rename(tmpFilename, filename);
	else
		log("[ERROR] Could not write to file: " .. (err or "unknown error"));
	end;
end;
local function saveActiveProcesses()
	local serializableProcesses = {};
	for key, data in pairs(activeProcesses) do
		if type(data) == "table" then
			serializableProcesses[key] = {
				status = data.status or "unknown",
				startTime = data.startTime or "unknown",
				projectName = data.projectName or "unknown",
				projectPath = data.projectPath or "unknown",
				pid = data.pid or nil
			};
		end;
	end;
	atomicWrite("processes.json", json.encode(serializableProcesses) or "{}");
end;
local function loadActiveProcesses()
	local file, err = io.open("processes.json", "r");
	if file then
		local content = file:read("*a");
		file:close();
		local success, processesDecoded = pcall(json.decode, content);
		if success and type(processesDecoded) == "table" then
			activeProcesses = processesDecoded;
		else
			log("[ERROR] Failed to decode processes file.");
		end;
	else
		log("[INFO] No saved processes file found.");
	end;
end;
local function determineCommand(fileName, runType)
	local settings = loadSettings();
	if settings[ScriptKeys] and settings[ScriptKeys][fileName] and settings[ScriptKeys][fileName][runType] then
		return settings[ScriptKeys][fileName][runType];
	else
		log("[WARN] Command not found for " .. tostring(fileName) .. " with run type " .. tostring(runType));
		return "yarn start";
	end;
end;
local function startProcess(app, runType)
	if not app then
		log("[ERROR] No application name provided.");
		return;
	end;
	local appConfig = (loadSettings())[ScriptKeys] and (loadSettings())[ScriptKeys][app];
	if not appConfig then
		log("[ERROR] No configuration found for app: " .. tostring(app));
		return;
	end;
	for key, _ in pairs(appConfig) do
		local projectPath = (loadSettings())[ProjectsKeys] and (loadSettings())[ProjectsKeys][key];
		if projectPath then
			local pid = posix.fork();
			if pid == 0 then
				posix.exec("/bin/sh", "-c", "cd " .. projectPath .. " && " .. determineCommand(key, runType));
				os.exit();
			elseif pid then
				activeProcesses[key] = {
					status = "running",
					startTime = os.date("%Y-%m-%d %H:%M:%S"),
					projectName = key,
					projectPath = projectPath,
					pid = pid
				};
				saveActiveProcesses();
			else
				log("[ERROR] Failed to fork process for: " .. tostring(key));
			end;
		else
			log("[ERROR] Path not found for project: " .. tostring(key));
		end;
	end;
end;
