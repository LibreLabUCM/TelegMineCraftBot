
-- Config
local bot_path = "/custom/bot" -- Without "bot.lua", not ending in "/"
local token = "Token" -- Telegram bot token (from @BotFather )
local admins = { -- Telegram ID's of admin users
   12345678,
   87654321
}
local monitor_side = "left" -- Where is the monitor? "left", "right"? If no monitor, use: "none"


-- Set Up
os.loadAPI(bot_path .. "/lib/json")
local api_url = "https://api.telegram.org/bot" .. token .. "/"
if mon ~= "none" then
  local mon = peripheral.wrap(monitor_side)
  term.redirect(mon)
end
term.clear()
term.setCursorPos(1, 1)


-- Bot starts here:
print("Starting up....")
local request = http.get(api_url .. "getMe")
if request ~= nil then
  local jsonResult = json.decode(request.readAll())
  if jsonResult["ok"] == true then
    result = jsonResult["result"]
    print("User: " .. result["username"])
    print("Name: " .. result["first_name"])
    print("ID: " .. result["id"])
  else
    print("Error!")
  end
  request.close()
else
  print("Error!")
end
