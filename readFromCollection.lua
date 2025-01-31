local json = require("simplejson");
local MONGO_URI = "mongodb://localhost:27017/AlbariusDB";
local COMMAND = arg[1] or "get";
local COLLECTION_NAME = arg[2] or "devices";
local FIELD_NAME = arg[3] or nil;
local FIELD_VALUE = arg[4] or nil;
local function sanitize(value)
	return value:gsub("[^%w_]", "");
end;
COLLECTION_NAME = sanitize(COLLECTION_NAME);
FIELD_NAME = FIELD_NAME and sanitize(FIELD_NAME) or nil;
FIELD_VALUE = FIELD_VALUE or nil;
if not COLLECTION_NAME or #COLLECTION_NAME == 0 then
	COLLECTION_NAME = "devices";
end;
local conditionStr = "{}";
if FIELD_NAME and #FIELD_NAME > 0 then
	if FIELD_VALUE and #FIELD_VALUE > 0 then
		if FIELD_NAME == "_id" and FIELD_VALUE:match("^%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x$") then
			conditionStr = string.format("{ \"%s\": ObjectId('\"%s\"') }", FIELD_NAME, FIELD_VALUE);
		else
			local CONDITION = {};
			CONDITION[FIELD_NAME] = FIELD_VALUE;
			conditionStr = json.encode(CONDITION);
		end;
	else
		conditionStr = string.format("{ \"%s\": { \"$exists\": true } }", FIELD_NAME);
	end;
else
	conditionStr = "{}";
end;
local mongoCommand = "";
if COMMAND == "get" then
	mongoCommand = "mongosh \"" .. MONGO_URI .. "\" --eval \"var result = db['" .. COLLECTION_NAME .. "'].find(" .. conditionStr .. "); if (result) { printjson(result.toArray()); } else { print('No matching document found.'); }\"";
elseif COMMAND == "delete" then
	mongoCommand = "mongosh \"" .. MONGO_URI .. "\" --eval \"var result = db['" .. COLLECTION_NAME .. "'].deleteMany(" .. conditionStr .. "); print(result.deletedCount + ' document(s) deleted.');\"";
elseif COMMAND == "update" then
	local updateValue = "{ $set: { \"updated\": true } }";
	mongoCommand = "mongosh \"" .. MONGO_URI .. "\" --eval \"var result = db['" .. COLLECTION_NAME .. "'].updateMany(" .. conditionStr .. ", " .. updateValue .. "); print(result.modifiedCount + ' document(s) updated.');\"";
else
	print("Invalid command. Supported commands are: get, delete, update.");
	os.exit(1);
end;
print("MongoDB query command:", mongoCommand);
os.execute(mongoCommand);
