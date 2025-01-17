local lfs = require("lfs")
local currentWorkingDirectory = lfs.currentdir()
local createdFolders = {}
local foldersWithFiles = {}  -- Table to store folders with "_files" in their name
local function organizeFiles(directory)
     lfs.dir(directory)
      for item in lfs.dir(directory) do
        local itemPath = directory .. "/" .. item
        local mode = lfs.attributes(itemPath, "mode")
        if mode == "directory" then
            if string.find(item, "_files") then
                foldersWithFiles[item] = true
            end
            createdFolders[item] = true
        end
    end
    for file in lfs.dir(directory) do
        if file ~= "." and file ~= ".."   then
            local filepath = directory .. "/" .. file
            local mode = lfs.attributes(filepath, "mode")
            if mode == "file" then
                local extension = string.match(file, "%.([^%.]+)$")
                if extension and not extension== 'gitignore'and not extension == 'json'  then
                    local folderName = string.lower(extension) .. "_files"
                    local folderPath = directory .. "/" .. folderName
                    local mode = lfs.attributes(folderPath, "mode")
                    if mode == "directory" then
                    createdFolders[folderPath] = true
                    end
                    if not string.find(directory,folderName) then 
                        if  createdFolders[folderPath] == nil then
                            lfs.mkdir(folderPath)
                            createdFolders[folderPath] = true
                        end
                    end
                    os.rename(filepath, folderPath .. "/" .. file)
                
                end
            elseif mode == "directory" then
                organizeFiles(filepath)
            end
        end
    end
end

print(("Organizing files in directory: %s"):format( lfs.currentdir()))
organizeFiles( lfs.currentdir())



local function organizeFiles2(directory)
    for item in lfs.dir(directory) do
        local itemPath = directory .. "/" .. item
        local mode = lfs.attributes(itemPath, "mode")
        if mode == "directory" then
            if string.find(item, "_files") then
                foldersWithFiles[item] = true
            end
            createdFolders[item] = true
        end
    end
    for file in lfs.dir(directory) do
        if file ~= "." and file ~= ".." then
            local filepath = directory .. "/" .. file
            local mode = lfs.attributes(filepath, "mode")
            if mode == "file" then
                local extension = string.match(file, "%.([^%.]+)$")
                if extension and not (extension == 'gitignore' or extension == 'json') then
                    local folderName = string.lower(extension) .. "_files"
                    local folderPath = directory .. "/" .. folderName
                    local mode = lfs.attributes(folderPath, "mode")
                    if mode == "directory" then
                        createdFolders[folderPath] = true
                    end
                    if not string.find(directory, folderName) then
                        if createdFolders[folderPath] == nil then
                            lfs.mkdir(folderPath)
                            createdFolders[folderPath] = true
                        end
                    end
                    os.rename(filepath, folderPath .. "/" .. file)
                end
            elseif mode == "directory" then
                organizeFiles(filepath)
            end
        end
    end
end
organizeFiles2( lfs.currentdir())
