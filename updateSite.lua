-- Define the directories
local reactAppPath = "C:\\Users\\Daniel\\Desktop\\personal\\Personal-Assistant-LTD\\frontend"
local expressAppPath = "C:\\Users\\Daniel\\Desktop\\personal\\Personal-Assistant-LTD\\backend"

-- Function to run shell commands and wait for completion
local function runCommand(command)
    local handle = io.popen(command)
    local result = handle:read("*a")
    local exitCode = handle:close()

    if not exitCode then
        error("Command failed: " .. command .. "\nOutput: " .. result)
    end
end

-- Step 0: Remove the existing 'client' folder in the backend if it exists
runCommand('if exist "' .. expressAppPath .. '\\sites\\personalAssistant" rmdir /s /q "' .. expressAppPath .. '\\sites\\personalAssistant"')

-- Step 1: Build the React app (combine cd and npm command)
runCommand('cd "' .. reactAppPath .. '" && npm run build')

-- Step 2: Rename the build folder to 'client'
runCommand('ren "' .. reactAppPath .. '\\build" "personalAssistant"')

-- Step 3: Move the 'client' folder to the Express app directory
runCommand('move "' .. reactAppPath .. '\\personalAssistant" "' .. expressAppPath .. '\\sites\\personalAssistant"')

-- Step 4: Navigate into the Express app directory and deploy using Fly.io
runCommand('cd "' .. expressAppPath .. '" && fly deploy')

print("React app built, existing 'client' replaced, and deployment started.")
