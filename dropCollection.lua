local mongoURI = "mongodb://127.0.0.1:27017/AlbariusDB";
local collectionName = arg[2];
if not collectionName or collectionName == "" then
	print("Please provide a collection name to drop.");
	os.exit(1);
end;
local cmdCommand = "mongosh  " .. mongoURI .. " --eval \"db." .. collectionName .. ".drop()\"";
os.execute(cmdCommand);
print("Collection '" .. collectionName .. "' dropped successfully.");
