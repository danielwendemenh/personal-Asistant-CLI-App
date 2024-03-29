local json = require("json")
-- local MONGO_URI = "mongodb://10.100.40.50:27017/AlbariusDB"
local MONGO_URI = "mongodb://localhost:27017/AlbariusDB"
local COMMAND = arg[1] 
local COLLECTION_NAME = arg[2]
local FIELD_NAME = arg[3]   
local FIELD_VALUE = arg[4] 
local conditionStr = '{}'

COLLECTION_NAME = COLLECTION_NAME or "devices"
FIELD_NAME = FIELD_NAME  or nil
FIELD_VALUE = FIELD_VALUE or nil

if FIELD_NAME and #FIELD_NAME > 0  and FIELD_VALUE and #FIELD_VALUE >0 then
        local   CONDITION ={}
        CONDITION[FIELD_NAME] = FIELD_VALUE
        conditionStr  = json.encode(CONDITION)
end

if not COLLECTION_NAME or #COLLECTION_NAME == 0 then
        COLLECTION_NAME = 'devices'
end

local mongoCommand = 'mongo "' .. MONGO_URI .. '" --eval "var result = db[\'' .. COLLECTION_NAME .. '\'].find(' .. conditionStr .. '); if (result) { printjson(result.toArray()); } else { print(\'No matching document found.\'); }"'
local escapedMongoCommand = '"' .. mongoCommand:gsub('"', '\\"') .. '"'
os.execute(escapedMongoCommand)
os.execute(mongoCommand)
