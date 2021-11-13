local ply = LocalPlayer()
local LuaMem = 0
local NewMemory = 0

local blink_gc_memory = CreateClientConVar("blink_gc_memory", "768432", true, false, "Sets the amount of KB! before manually running a garbage collection.")
local blink_gc_enable = CreateClientConVar("blink_gc_enable", "1", true, false, "Activates Blink's Garbage Collection, if loaded disable, it will not load the rest of the script.")
local blink_gc_print = CreateClientConVar("blink_gc_print", "0", true, false, "Shows you your active memory being used in console.")

if not(blink_gc_enable:GetBool()) then return end -- if it's disabled, dont load the rest on launch

local function EasyPrint(message)
	if not(blink_gc_print:GetBool()) then return end
	
	MsgC(Color(115, 148, 248), message.. "\n")
end
--EasyPrint("Active Lua Memory : ".. math.Round(collectgarbage("count")/1024).. " MBytes.")

local function ClearLuaMemory()
	if not(blink_gc_enable:GetBool()) then return end
	local LuaMem = collectgarbage("count")

	EasyPrint("Active Lua Memory : ".. math.Round(LuaMem/1024).. " MB.")
	if LuaMem >= math.Clamp(blink_gc_memory:GetInt(), 262144, 978944) then
		collectgarbage("collect")
		local NewMemory = collectgarbage("count")
		EasyPrint("Removed ".. math.Round((LuaMem - NewMemory)/1024).. " MB from active memory.")
	end
end
--timer.Remove("Aggro_Lua_GC") -- For refreshing
timer.Create("Aggro_Lua_GC", 60, 0, function() ClearLuaMemory() end)
--ClearLuaMemory()

local function PrintCurrentLuaMemory()
	local LuaMem = collectgarbage("count")
	MsgC(Color(155, 148, 248), "Active Lua Memory : ".. math.Round(LuaMem/1024).. " MB.")
end
concommand.Add("blink_gc_luamemory", function() PrintCurrentLuaMemory() end)