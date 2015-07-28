
-- Config
local bot_path = "/custom/bot" -- Without "bot.lua", not ending in "/"
local token = "Token" -- Telegram bot token (from @BotFather )
local admins = { -- Telegram ID's of admin users
    12345678,
    87654321
}
local monitor_side = "none" -- Where is the monitor? "left", "right"? If no monitor, use: "none"
local LONG_POLLING_TIMEOUT = 20

-- Set Up
os.loadAPI(bot_path .. "/lib/json")
local api_url = "https://api.telegram.org/bot" .. token .. "/"
if monitor_side ~= "none" then
    local mon = peripheral.wrap(monitor_side)
    term.redirect(mon)
end
term.clear()
term.setCursorPos(1, 1)


-- Bot starts here:

local function printWithFormat(...) --http://www.computercraft.info/forums2/index.php?/topic/11771-print-coloured-text-easily/
    local s = "&1"
    for k, v in ipairs(arg) do
        s = s .. v
    end
    s = s .. "&0"

    local fields = {}
    local lastcolor, lastpos = "0", 0
    for pos, clr in s:gmatch"()&(%x)" do
        table.insert(fields, {s:sub(lastpos + 2, pos - 1), lastcolor})
        lastcolor, lastpos = clr , pos
    end

    for i = 2, #fields do
        term.setTextColor(2 ^ (tonumber(fields[i][2], 16)))
        io.write(fields[i][1])
    end
end


local function api_request(method, parameters)
    local request = http.post(api_url .. method, parameters)
    if request ~= nil then
        local jsonResult = json.decode(request.readAll())
        if jsonResult["ok"] == true then
            if jsonResult["result"] == nil then return false end
            return jsonResult["result"]
        else
            return false
        end
    else
        return false
    end
end

local function run_event(msg)
    if msg["text"] ~= nil then
        printWithFormat("" .. msg["from"]["first_name"] .. ": " .. msg["text"])
    end
end

local function run()
    local last_message_update_id = 0
    while (true) do
        local result = api_request("getUpdates?offset=".. (last_message_update_id + 1) .. "&timeout=" .. LONG_POLLING_TIMEOUT, {
            offset = last_message_update_id + 1,
            limit = 100,
            timeout = LONG_POLLING_TIMEOUT
        })
        for key,update in ipairs(result) do
            if update["update_id"] > last_message_update_id then
                last_message_update_id = update["update_id"]
            end
            run_event(update["message"])
        end
    end
end

print("Starting up....")
local result = api_request("getMe")
if result then
    print("User: " .. result["username"])
    print("Name: " .. result["first_name"])
    print("ID: " .. result["id"])
else
    print("Error!")
end
print("Waiting for input:")
print("")

run()
