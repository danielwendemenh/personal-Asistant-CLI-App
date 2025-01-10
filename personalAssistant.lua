local command = arg[1]:lower();
local args = {
	...
};
if string.lower(command) == "--help" then
	print("Supported commands:");
	print("Watch - Monitors files for changes and executes a command when a change is detected.");
	print("Example: watch \"file.txt\" \"command-to-execute\"");
	print("Open - Launches a project in Visual Studio Code.");
	print("Example: open \"project-name\" (must add the path to the project in the openProject.bat file)");
	print("Drop - Removes a collection in MongoDB.");
	print("Example: drop \"collection-name\" (must add the URI to the database in the dropCollection.bat file)");
	print("SetVisible - Sets all devices to be visible on the network.");
	print("Example: setvisible \"true\" (must add the URI to the database in the dropCollection.bat file)");
	print("Get - Retrieves data from a collection in MongoDB.");
	print("Example: get \"collection-name\" \"field-name\" \"field-value\" (must add the URI to the database in the readFromCollection.bat file)");
	print("Shutdown - Shuts down the computer.");
	print("Example: shutdown");
	print("Restart - Restarts the computer.");
	print("Example: restart");
	print("Logout - Logs out of the computer.");
	print("Example: logout");
	print("Goto - Opens a folder in File Explorer.");
	print("Example: goto \"folder-path\" (must add the path to the folder in the gotoFolder.bat file)");
	print("Chillax - Closes all work-related applications.");
	print("Example: chillax");
	print("--help - Displays this help message.");
	print("Watch - Monitors files for changes and executes a command when a change is detected.");
	print("Example: watch \"file.txt\" \"command-to-execute\"");
	os.exit(0);
end;
local scriptPath = (debug.getinfo(1, "S")).source:sub(2);
local scriptDirectory = scriptPath:match("(.*[\\/])");
print(unpack(args));
local commandFilePath;
if string.lower(command) == "-v" then
	print("1.0.0v");
	os.exit(1);
elseif string.lower(command) == "out" then
	commandFilePath = scriptDirectory .. "exit.lua";
	os.execute("lua \"" .. commandFilePath);
elseif string.lower(command) == "org" then
	commandFilePath = scriptDirectory .. "org.lua";
	os.execute("lua \"" .. commandFilePath);
elseif string.lower(command) == "install" then
	commandFilePath = scriptDirectory .. "install.lua";
	os.execute("lua \"" .. commandFilePath);
elseif string.lower(command) == "uninstall" then
	commandFilePath = scriptDirectory .. "uninstall.lua";
	os.execute("lua \"" .. commandFilePath);
elseif string.lower(command) == "swap" then
	commandFilePath = scriptDirectory .. "swapServer.lua";
	os.execute("lua \"" .. commandFilePath);
elseif string.lower(command) == "upload" then
	commandFilePath = scriptDirectory .. "uploadfile.lua";
	os.execute("lua \"" .. commandFilePath);
elseif string.lower(command) == "purge" then
	commandFilePath = scriptDirectory .. "purgeDataBase.lua";
	os.execute("lua \"" .. commandFilePath);
elseif string.lower(command) == "chillax" then
	commandFilePath = scriptDirectory .. "closeWork.lua";
	os.execute("lua \"" .. commandFilePath);
elseif string.lower(command) == "open" then
	commandFilePath = scriptDirectory .. "openProject.lua";
	local command2 = {
		"lua",
		commandFilePath,
		unpack(args)
	};
	os.execute(table.concat(command2, " "));
elseif string.lower(command) == "setvisible" then
	commandFilePath = scriptDirectory .. "setAllDevicesVisible.lua";
	local command2 = {
		"lua",
		commandFilePath,
		unpack(args)
	};
	os.execute(table.concat(command2, " "));
elseif string.lower(command) == "drop" then
	commandFilePath = scriptDirectory .. "dropCollection.lua";
	local command2 = {
		"lua",
		commandFilePath,
		unpack(args)
	};
	os.execute(table.concat(command2, " "));
elseif string.lower(command) == "get" then
	commandFilePath = scriptDirectory .. "readFromCollection.lua";
	local command2 = {
		"lua",
		commandFilePath,
		unpack(args)
	};
	os.execute(table.concat(command2, " "));
elseif string.lower(command) == "shutdown" then
	os.execute("shutdown /s /f /t 0");
elseif string.lower(command) == "restart" then
	os.execute("shutdown /r /f /t 0");
elseif string.lower(command) == "logout" then
	os.execute("shutdown /l");
elseif string.lower(command) == "mongo" then
	commandFilePath = scriptDirectory .. "mongoManager.lua";
	local command2 = {
		"lua",
		commandFilePath,
		unpack(args)
	};
	os.execute(table.concat(command2, " "));
elseif string.lower(command) == "goto" then
	commandFilePath = scriptDirectory .. "gotoFolder.lua";
	local command2 = {
		"lua",
		commandFilePath,
		unpack(args)
	};
	os.execute(table.concat(command2, " "));
elseif string.lower(command) == "start" then
	commandFilePath = scriptDirectory .. "startStopScript.lua";
	local startCommand = {
		"lua",
		commandFilePath,
		unpack(args)
	};
	os.execute(table.concat(startCommand, " "));
elseif string.lower(command) == "show" then
	commandFilePath = scriptDirectory .. "startStopScript.lua";
	local startCommand = {
		"lua",
		commandFilePath,
		unpack(args)
	};
	os.execute(table.concat(startCommand, " "));
elseif string.lower(command) == "stop" then
	commandFilePath = scriptDirectory .. "startStopScript.lua";
	local stopCommand = {
		"lua",
		commandFilePath,
		unpack(args)
	};
	os.execute(table.concat(stopCommand, " "));
elseif string.lower(command) == "updatesite" then
	commandFilePath = scriptDirectory .. "updateSite.lua";
	local stopCommand = {
		"lua",
		commandFilePath,
		unpack(args)
	};
	os.execute(table.concat(stopCommand, " "));
else
	print("Invalid command. Supported commands: watch, open, drop, setvisible, get, shutdown, restart, logout, goto, start, stop, --help.");
	os.exit(1);
end;
os.exit();
