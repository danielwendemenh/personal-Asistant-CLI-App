-- Lua script
-- local mongoURI = "mongodb://10.100.40.50:27017/AlbariusDB"
local mongoURI = "mongodb://127.0.0.1:27017/AlbariusDB"

local collectionName = arg[2]

-- Check if a collection name is provided
if not collectionName or collectionName == "" then
    print("Please provide a collection name to drop.")
    os.exit(1)
end

-- Drop the specified collection using the mongosh  shell
local cmdCommand = 'mongosh  ' .. mongoURI .. ' --eval "db.' .. collectionName .. '.drop()"'
os.execute(cmdCommand)

print('Collection \'' .. collectionName .. '\' dropped successfully.')
