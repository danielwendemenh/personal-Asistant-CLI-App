local lfs = require("lfs")
local currentDir = lfs.currentdir()
os.execute('ls')
io.write('folder to upload: ')
local folderName = io.read()
local tarFileName = folderName .. ".tar.gz"
local filePath = currentDir .. "\\".. folderName..".tar.gz"
local folderPath = currentDir .. "\\" .. folderName

-- Check if the folder exists
local attributes = lfs.attributes(folderPath)
if attributes and attributes.mode == "directory" then
    -- Tar the folder
    local tarCommand = 'tar -czvf  "' .. tarFileName .. '" "' .. folderName .. '"'

    -- Execute the tar command
    print('Converting folder to tar file... might take a while.')

    os.execute(tarCommand)
    
    local remoteFolder = "/Temp/"
    local winscpCommand = 'winscp.com /command "open sftp://root:Wdcft5432!@10.100.40.50:22" "put ' .. tarFileName .. ' ' .. remoteFolder .. '" "exit"'

    os.execute(winscpCommand)
    os.remove(tarFileName)

else
    print("Error: The specified folder does not exist.")
end
