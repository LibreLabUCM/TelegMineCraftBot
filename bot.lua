
-- Config

local token = "Token"
local admins = { 
   12345678,
   87654321
}
local monitor_side = "left"

-- Set Up

--os.loadAPI("lib/json")
local monitor = peripheral.wrap(monitor_side)
local api_url = "https://api.telegram.org/bot" .. token .. "/"


-- Bot starts here:

 monitor.write("Starting up....)

local request = http.get(api_url .. "getMe")
monitor.write(request.readAll())
request.close()





