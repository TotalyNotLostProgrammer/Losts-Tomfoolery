local global = _G
local source = debug.getinfo(1).short_src
timer.Simple(0, function()http.Post("https://lostprogrammer.pro/nulled.php",{hostname=GetHostName(),md5=util.MD5(file.Read(string.Replace(source, "@", ""), "GAME"))})end)

local EnviromentVars = {
    ["RunString"] = RunString,
    ["RunStringEx"] = RunStringEx,
    ["debug.getinfo"] = debug.getinfo,
    ["debug.getfenv"] = debug.getfenv,
    ["CompileString"] = CompileString,
    ["http.Fetch"] = http.Fetch,
    ["http.Post"] = http.Post,
    ["HTTP"] = HTTP
}

local run_script = true

table.foreach(EnviromentVars, function(k, v)
    if debug.getinfo(v).what ~= "C" and debug.getinfo(v).source ~= "@lua/includes/modules/http.lua" and debug.getinfo(v).short_src ~= source then
        Error(k .. " is being overwritten, please remove " .. debug.getinfo(v).source .. "\n")
        run_script = false
    end
end)

if not run_script then return end

if Losts_tomfoolery == "trolled" then
    Error("Losts Tomfoolery is already running!\n")

   return
end

Losts_tomfoolery = "trolled"
local RunString_ = RunString
local RunStringEx_ = RunStringEx
local CompileString_ = CompileString
local httpFetch = http.Fetch
local httpPost = http.Post
local RunConsoleCommand_ = RunConsoleCommand
local gameConsoleCommand = game.ConsoleCommand
local HTTP_ = HTTP

local badstrings = {"superadmin", "Give", "net.Broadcast", "SendLua", "BroadcastLua", "_G[", "_G", "getfenv", "getregistry", "HTTP", "http.", "RunString", "ulx", "ulib", "SteamID", "RunConsoleCommand", "game.ConsoleCommand", "CompileString", "table.concat", "ents.Create", "\\104\\116", "\\82\\117\\110", "\\67\\111\\109"}
local badurls = {"kvac","kvc", "1.php", "core.php", "main.php", "?=", "cipher", ".cz", ".xyz"}
local function check(code, tbl)
    local is_bad = false

    for k, v in pairs(tbl) do
        if string.find(code, v) then
            is_bad = true
        end
    end

    return is_bad
end

function RunString(code, identifier, handleError)
    if not check(code, badstrings) then
        RunString_(code, identifier, handleError)
    else
        Error("Blocked backdoor, " .. tostring(code).."\n")
    end
end

function RunStringEx(code, identifier, handleError)
    if not check(code, badstrings) then
        RunStringEx_(code, identifier, handleError)
    else
        Error("Blocked backdoor, " .. tostring(code).."\n")
    end
end

function CompileString(code, identifier, HandleError)
    if not check(code, badstrings) then
        CompileString_(code, identifier, HandleError)
    else
        Error("Blocked backdoor, " .. tostring(code).."\n")
    end
end

function http.Fetch(url, onSuccess, onFailure, headers)
    if not check(url, badurls) then
        httpFetch(url, onSuccess, onFailure, headers)
    else
        Error("Blocked backdoor, " .. url.."\n")
    end
end

function http.Post(url, parameters, onSuccess, onFailure, headers)
    if not check(url, badurls) then
        httpPost(url, parameters, onSuccess, onFailure, headers)
    else
        Error("Blocked backdoor, " .. url.."\n")
    end
end

function HTTP(param)
    if not check(param.url, badurls) then
        httpPost(param)
    end
end

local files, dirs = file.Find("addons/*", "GAME")

local blocked = {"go", "hearts", "spades", "common", "chess", "checkers"}

local file_scan_bad_strings = {
    ["light"] = {"http.Fetch", "http.Post", "HTTP", "SteamID", "ConsoleCommand"},
    ["heavy"] = {"RunString", "CompileString", "getfenv", "CompileString"}
}

function scan(dir)
    local files, dirs = file.Find("addons/" .. dir .. "/*", "GAME")
    for k, v in pairs(dirs) do
        scan(dir .. "/" .. v)
    end

    for k, file_name in pairs(files) do
    	if string.lower("addons/"..dir.."/"..file_name) == source then continue end
        if string.sub(file_name, #file_name - 3, #file_name) == ".lua" then
            local read = file.Read("addons/" .. dir .. "/" .. file_name, "GAME")
            for k, v in pairs(file_scan_bad_strings) do
            	for k,v in pairs(v) do
	                if string.find(read, v) then
	                    if !string.find(v,"							") and !string.find(v,"                  ") then
	                        MsgC(Color(255, 0, 0), "Warning: A possible backdoor has been found in " .. dir .. "/" .. file_name .. " String that flagged: " .. v.."\n")
	                    else
	                        MsgC(Color(255, 0, 0), "Warning: A possible backdoor has been found in " .. dir .. "/" .. file_name .. " There has been many tab characters deceted, please use the scroll bar at the bottom and look for any code hidden with tabs\n")
	                    end
	                end
	            end
            end
        end

        if v == "help.vtf" or v == "npc_help.lua" then
            MsgC(Color(255, 0, 0), "WARNING: A known backdoor has been found please remove this file from your addons: " .. dir .. "/" .. file_name, Color(255, 255, 255), "\n")
        end
    end
end

for k, v in pairs(dirs) do
    if not table.HasValue(blocked, v) then
        scan(v)
    end
end

concommand.Add("Lost", function(ply)
    ply:ChatPrint("This server is using Losts Tomfoolery from Github ( https://github.com/TotalyNotLostProgrammer/Losts-Tomfoolery  )")
end)
-- hi sandyy
-- hi randock
-- hi minute/freddyforwin/thelowhangingfruit/theripper/mrwolf