package.path = package.path .. ";C:/Users/DanielWendemeneh/AppData/Roaming/luarocks/share/lua/5.4/?.lua";
package.cpath = package.cpath .. ";C:/Users/DanielWendemeneh/AppData/Roaming/luarocks/lib/lua/5.4/?.dll";
local json = require("sonar");
local command = (arg[1] or ""):lower();
local args = {
	...
};
local function interactiveHelp()
	local helpMenu = {
		{
			"Watch",
			"Monitors files for changes and executes a command when a change is detected.",
			"Example: watch \"file.txt\" \"command-to-execute\""
		},
		{
			"Open",
			"Launches a project in Visual Studio Code.",
			"Example: open \"project-name\" (must add the path to the project in the openProject.bat file)"
		},
		{
			"Drop",
			"Removes a collection in MongoDB.",
			"Example: drop \"collection-name\" (must add the URI to the database in the dropCollection.bat file)"
		},
		{
			"SetVisible",
			"Sets all devices to be visible on the network.",
			"Example: setvisible \"true\" (must add the URI to the database in the dropCollection.bat file)"
		},
		{
			"Get",
			"Retrieves data from a collection in MongoDB.",
			"Example: get \"collection-name\" \"field-name\" \"field-value\" (must add the URI to the database in the readFromCollection.bat file)"
		},
		{
			"Shutdown",
			"Shuts down the computer.",
			"Example: shutdown"
		},
		{
			"Restart",
			"Restarts the computer.",
			"Example: restart"
		},
		{
			"Logout",
			"Logs out of the computer.",
			"Example: logout"
		},
		{
			"Goto",
			"Opens a folder in File Explorer.",
			"Example: goto \"folder-path\" (must add the path to the folder in the gotoFolder.bat file)"
		},
		{
			"Chillax",
			"Closes all work-related applications.",
			"Example: chillax"
		},
		{
			"--help",
			"Displays this help message.",
			""
		}
	};
	print("Interactive Help Menu:");
	for i, item in ipairs(helpMenu) do
		print(string.format("[%d] %s - %s", i, item[1], item[2]));
	end;
	print("Enter the number of the command for more details, or 0 to exit:");
	local choice = tonumber(io.read());
	if choice and choice > 0 and choice <= (#helpMenu) then
		local selected = helpMenu[choice];
		print(string.format("\n%s:\n%s\n%s\n", selected[1], selected[2], selected[3]));
	else
		print("Exiting help menu.");
	end;
	os.exit(0);
end;
local function executeScript(scriptName, additionalArgs)
	local scriptPath = (debug.getinfo(1, "S")).source:sub(2);
	local scriptDirectory = scriptPath:match("(.*[\\/])");
	local commandFilePath = scriptDirectory .. scriptName;
	local command = {
		"lua",
		commandFilePath,
		table.unpack(additionalArgs or {})
	};
	os.execute(table.concat(command, " "));
end;
local function executeScriptJs(scriptName, additionalArgs)
	local scriptPath = (debug.getinfo(1, "S")).source:sub(2);
	local scriptDirectory = scriptPath:match("(.*[\\/])");
	local commandFilePath = scriptDirectory .. scriptName;
	local command = {
		"node",
		commandFilePath,
		table.unpack(additionalArgs or {})
	};
	os.execute(table.concat(command, " "));
end;
if command == "--help" then
	interactiveHelp();
elseif command == "-v" then
	print("1.0.0v");
	os.exit(0);
elseif command == "out" then
	executeScript("exit.lua");
elseif command == "org" then
	executeScript("org.lua");
elseif command == "install" then
	executeScript("install.lua");
elseif command == "uninstall" then
	executeScript("uninstall.lua");
elseif command == "swap" then
	executeScript("swapServer.lua");
elseif command == "create" then
	executeScriptJs("createApp.js");
elseif command == "upload" then
	executeScript("uploadfile.lua");
elseif command == "purge" then
	executeScript("purgeDataBase.lua");
elseif command == "chillax" then
	executeScript("closeWork.lua");
elseif command == "open" then
	executeScript("openProject.lua", args);
elseif command == "setvisible" then
	executeScript("setAllDevicesVisible.lua", args);
elseif command == "drop" then
	executeScript("dropCollection.lua", args);
elseif command == "get" then
	executeScript("readFromCollection.lua", args);
elseif command == "shutdown" then
	os.execute("shutdown /s /f /t 0");
elseif command == "restart" then
	os.execute("shutdown /r /f /t 0");
elseif command == "logout" then
	os.execute("shutdown /l");
elseif command == "mongo" then
	executeScript("mongoManager.lua", args);
elseif command == "goto" then
	executeScript("gotoFolder.lua", args);
elseif command == "start" or command == "show" or command == "stop" then
	executeScript("startStopScript.lua", args);
elseif command == "updatesite" then
	executeScript("updateSite.lua", args);
else
	print("Invalid command. Supported commands: watch, open, drop, setvisible, get, shutdown, restart, logout, goto, start, stop, --help.");
	os.exit(1);
end;
os.exit(0);
