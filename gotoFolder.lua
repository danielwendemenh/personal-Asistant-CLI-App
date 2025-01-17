-- Lua script to open a folder in File Explorer
local folderToFind = arg[2]

if not folderToFind then
    folderToFind = ''
end

-- Check if the folder exists
local folderPath = "C:/Users/Daniel/" .. folderToFind
local cmdCommand = "explorer " .. folderPath

local fileAttributes = io.popen("dir " .. folderPath):read("*all")

if fileAttributes and string.find(fileAttributes, "File Not Found") == nil then
    os.execute(cmdCommand)
else
print("Folder not found.")
end
