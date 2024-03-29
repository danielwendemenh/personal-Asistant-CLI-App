local json = require("json")
local MONGO_URI = "mongodb://127.0.0.1:27017/AlbariusDB"
print("Are you sure you want to delete the database? (yes/no)")
local answer = io.read()
if string.lower(answer) ~= "yes" and string.lower(answer) ~= "y" then
    print("Aborted.")
    os.exit(1)
end

local mongoCommand = 'mongo "' .. MONGO_URI .. '" --eval "var result = db.dropDatabase(); if (result) {\'Command executed successfully.\'  } else { print(\'Failed to execute the command..\'); }"'
local escapedMongoCommand = '"' .. mongoCommand:gsub('"', '\\"') .. '"'
os.execute(escapedMongoCommand)
os.execute(mongoCommand)