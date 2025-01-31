local function command_exists(command)
	return os.execute("where " .. command .. " >nul 2>nul") == 0;
end;
local function install_package(package)
	if not command_exists(package) then
		print(package .. " not found. Installing...");
		os.execute("npm install -g " .. package);
	else
		print(package .. " is already installed.");
	end;
end;
local function create_directory(path)
	if not os.execute(("mkdir " .. path .. " >nul 2>nul")) == 0 then
		print("Directory already exists or could not be created: " .. path);
	else
		print("Created directory: " .. path);
	end;
end;
local function create_and_start_project(framework, project_name, base_path)
	local cli_tool = "";
	local create_command = "";
	local start_command = "";
	local project_path = base_path .. "\\" .. project_name;
	if framework == "react" then
		cli_tool = "create-react-app";
		create_command = "npx create-react-app " .. project_path;
		start_command = "cd " .. project_path .. " && npm start";
	elseif framework == "angular" then
		cli_tool = "@angular/cli";
		create_command = "ng new " .. project_name .. " --directory " .. project_path;
		start_command = "cd " .. project_path .. " && ng serve";
	elseif framework == "vue" then
		cli_tool = "@vue/cli";
		create_command = "vue create " .. project_name .. " --preset default --no-git --skipGetStarted --path " .. project_path;
		start_command = "cd " .. project_path .. " && npm run serve";
	elseif framework == "svelte" then
		cli_tool = "degit";
		create_command = "npx degit sveltejs/template " .. project_path;
		start_command = "cd " .. project_path .. " && npm install && npm run dev";
	elseif framework == "next" then
		cli_tool = "create-next-app";
		create_command = "npx create-next-app " .. project_path;
		start_command = "cd " .. project_path .. " && npm run dev";
	elseif framework == "express" then
		cli_tool = "express-generator";
		create_command = "npx express-generator " .. project_path;
		start_command = "cd " .. project_path .. " && npm install && npm start";
	elseif framework == "nuxt" then
		cli_tool = "create-nuxt-app";
		create_command = "npx create-nuxt-app " .. project_path;
		start_command = "cd " .. project_path .. " && npm run dev";
	else
		print("Unsupported framework: " .. framework);
		return;
	end;
	install_package(cli_tool);
	print("Creating " .. framework .. " project: " .. project_name);
	os.execute(create_command);
	print("Starting " .. framework .. " development server...");
	os.execute(start_command);
end;
local function main()
	if not command_exists("node") or (not command_exists("npm")) then
		print("Node.js and npm are required. Please install them first.");
		return;
	end;
	local base_path = "C:\\Users\\Daniel\\Desktop\\personal\\pa_projects";
	create_directory(base_path);
	print("Select a framework:");
	print("1. React");
	print("2. Express");
	print("3. Angular");
	print("4. Vue");
	print("5. Svelte");
	print("6. Next.js");
	print("7. Nuxt.js");
	io.write("Enter the number of your choice: ");
	local choice = tonumber(io.read());
	local framework = "";
	if choice == 1 then
		framework = "react";
	elseif choice == 2 then
		framework = "express";
	elseif choice == 3 then
		framework = "angular";
	elseif choice == 4 then
		framework = "vue";
	elseif choice == 5 then
		framework = "svelte";
	elseif choice == 6 then
		framework = "next";
	elseif choice == 7 then
		framework = "nuxt";
	else
		print("Invalid choice. Exiting.");
		return;
	end;
	io.write("Enter the name of your project: ");
	local project_name = io.read();
	create_and_start_project(framework, project_name, base_path);
end;
main();
