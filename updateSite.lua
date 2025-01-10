local reactAppPath = "C:\\Users\\Daniel\\Desktop\\personal\\Personal-Assistant-LTD\\frontend";
local expressAppPath = "C:\\Users\\Daniel\\Desktop\\personal\\Personal-Assistant-LTD\\backend";
local function runCommand(command)
	local handle = io.popen(command);
	local result = handle:read("*a");
	local exitCode = handle:close();
	if not exitCode then
		error("Command failed: " .. command .. "\nOutput: " .. result);
	end;
end;
runCommand("if exist \"" .. expressAppPath .. "\\public\\personalAssistant\" rmdir /s /q \"" .. expressAppPath .. "\\public\\personalAssistant\"");
runCommand("cd \"" .. reactAppPath .. "\" && npm run build");
runCommand("ren \"" .. reactAppPath .. "\\build\" \"personalAssistant\"");
runCommand("move \"" .. reactAppPath .. "\\personalAssistant\" \"" .. expressAppPath .. "\\public\\personalAssistant\"");
runCommand("cd \"" .. expressAppPath .. "\" && fly deploy");
print("React app built, existing 'client' replaced, and deployment started.");
