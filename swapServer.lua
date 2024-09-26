-- Command to connect to the server
local connectCommand = 'putty.exe -ssh root@10.100.40.50 -pw Wdcft5432! -m commands.txt'

-- Write the command to change directory into a file
local file = io.open("commands.txt", "w")
file:write("cd /Temp/ \n")
file:write("tar -xvzf GlobalSearxhWithFetcher.tar.gz\n")
file:write("cp -rf Albarius /opt/\n")
file:write("pm2 restart all\n")
file:close()

-- Execute the Putty command
os.execute(connectCommand)



