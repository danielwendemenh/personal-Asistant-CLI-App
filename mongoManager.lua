local mongoBinPath = "./mongodb-database-tools-windows/bin";
local mongoDumpPath = "/mongodump.exe";
local mongoRetorePath = "/mongorestore.exe";
local args = {
	...
};
local scriptPath = (debug.getinfo(1, "S")).source:sub(2);
local scriptDirectory = scriptPath:match("(.*[\\/])");
local backupsFolder = scriptDirectory .. "DB_backups" .. "/";
local lfs = require("lfs");
local action = args[2];
local backup_name = args[3];
if not lfs.attributes(backupsFolder) then
	lfs.mkdir(backupsFolder);
end;
local function listDirectoryContents(directory)
	local count = 0;
	for file in lfs.dir(directory) do
		if file ~= "." and file ~= ".." then
			count = count + 1;
			print(count, " ", file);
		end;
	end;
	print("total: ", count);
end;
local function deleteFileOrDirectory(path)
	print("Deleting:", path);
	local res = os.execute("rmdir /s /q " .. path);
	if res or res == 0 then
		print("Deleted:", path);
	else
		print("Failed to delete:", path);
		print("Error message:", error_message);
	end;
end;
function runMongoDBCommand(command)
	local status = os.execute("cd " .. scriptDirectory .. " && " .. command);
	if status == true or status == 0 then
		local dumpDir = scriptDirectory .. "dump";
		os.rename(dumpDir, backup_name);
		print("Command executed successfully.");
	else
		print("Failed to execute the command.");
	end;
end;
if action and action == "-l" then
	listDirectoryContents(backupsFolder);
	return;
end;
if action and action == "backup" then
	if not backup_name then
		backup_name = backupsFolder .. os.date("%Y-%m-%d-%H-%M-%S");
	else
		backup_name = backupsFolder .. "/" .. backup_name;
	end;
	local commandTemp = scriptDirectory .. mongoBinPath .. mongoDumpPath;
	runMongoDBCommand(commandTemp);
end;
if not backup_name then
	print("Please provide a backup name.");
	return;
else
	backup_name = backupsFolder .. backup_name;
end;
if action and action == "restore" then
	if not backup_name then
		print("Please provide a backup name.");
		return;
	end;
	local dumpDir = scriptDirectory .. "dump";
	os.rename(backup_name, dumpDir);
	if not lfs.attributes(dumpDir) then
		print("The specified backup directory does not exist.");
		return;
	end;
	local commandTemp = scriptDirectory .. mongoBinPath .. mongoRetorePath;
	print(commandTemp);
	os.execute("cd " .. scriptDirectory .. " && " .. commandTemp);
	os.rename(dumpDir, backup_name);
end;
if action and action == "-d" and backup_name then
	if lfs.attributes(backup_name, "mode") == "directory" then
		deleteFileOrDirectory(backup_name);
	else
		print("The specified backup directory does not exist.");
	end;
end;
