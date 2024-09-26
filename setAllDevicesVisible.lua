local state = arg[2]
print("state", state)

local MONGO_URI = "mongodb://127.0.0.1:27017/AlbariusDB"

-- Check if state is provided
if not state then
    print("Please provide the state.")
    os.exit(1)
end

-- Check if the state is a valid boolean
if string.lower(state) ~= "true" and string.lower(state) ~= "false" then
    print("Invalid state. Please provide either 'true' or 'false'.")
    os.exit(1)
end

-- Build and execute the mongosh  shell command
local mongoCommand = 'mongosh  ' .. MONGO_URI .. ' --eval "db.devices.update({}, { $set: { visible: ' .. state .. ' } }, { multi: true })"'
os.execute(mongoCommand)

print("Devices updated successfully.")
