local json = require("dkjson") 
local settingsFile = "app_settings.json";
local keyToRetrieve = "projects-paths";
local sep = package.config:sub(1, 1);
local function getAbsolutePath()
	return arg[0]:match("^(.*[\\/])") or "";
end;
local function readConfig()
	local absolutePath = getAbsolutePath();
	local filePath = absolutePath .. settingsFile;
	local file = io.open(filePath, "r");
	if file then
		local content = file:read("*a");
		file:close();
		return json.decode(content) or {};
	else
		print("Error: Unable to open settings file at path:", filePath);
		return {};
	end;
end;
local function writeConfig(config)
	local absolutePath = getAbsolutePath();
	local filePath = absolutePath .. settingsFile;
	local file = io.open(filePath, "w");
	if file then
		file:write(json.encode(config));
		file:close();
	else
		print("Error: Unable to write to settings file at path:", filePath);
	end;
end;
local function listProjects()
	local config = (readConfig())[keyToRetrieve] or {};
	local count = 0;
	for projectName, projectPath in pairs(config) do
		count = count + 1;
		print(count, "-", projectName, "->", projectPath);
	end;
	print("Total projects:", count);
end;
local function deleteProject(projectName)
	local config = readConfig();
	local projects = config[keyToRetrieve] or {};
	if projects[projectName] then
		projects[projectName] = nil;
		config[keyToRetrieve] = projects;
		writeConfig(config);
		print("Project deleted successfully:", projectName);
	else
		print("Error: Project not found -", projectName);
	end;
end;
local function addOrUpdateProject(projectName, projectPath)
	local config = readConfig();
	local projects = config[keyToRetrieve] or {};
	projects[projectName] = projectPath;
	config[keyToRetrieve] = projects;
	writeConfig(config);
	print("Project added/updated successfully:", projectName);
end;
local function openProject(projectName)
	local projects = (readConfig())[keyToRetrieve] or {};
	local projectPath = projects[projectName];
	if projectPath then
		local command = "code " .. projectPath;
		os.execute(command);
	else
		print("Error: Project not found -", projectName);
	end;
end;
local function printUsage()
	print("Usage: pa [-list | -add <projectPath> <projectName> | -d <projectName> | open <projectName>]");
end;
local args = {
	...
};
if #args == 0 then
	printUsage();
	os.exit(1);
end;
local command = args[1];
local action = args[2];
if action == "-list" or action == "-l" then
	listProjects();
elseif action == "-d" and args[3] then
	deleteProject(args[3]:lower());
elseif action == "-add" or action == "-a" then
	if args[3] and args[4] then
		addOrUpdateProject(args[4]:lower(), args[3]);
	else
		print("Error: Missing project path or name for add command.");
	end;
elseif command == "open" and action then
	openProject(action:lower());
else
	printUsage();
end;
