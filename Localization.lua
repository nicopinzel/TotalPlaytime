local _, namespace = ...

local L = setmetatable({}, { __index = function(t, k)
	local v = tostring(k)
	rawset(t, k, v)
	return v
end })

namespace.L = L

local LOCALE = GetLocale()

if LOCALE == "enUS" then
	-- English translations
    L["Gesamt Spielzeit: "] = "Total playtime: "
    L["Tage, "] = "Days, "
    L["Stunden, "] = "hours, "
    L["Minuten, "] = "minutes, "
    L["Sekunden."] = "seconds."
	L[" "] = " " -- [usSPACE, deLEERZEICHEN] for better readability in chatframe

return end

if LOCALE == "deDE" then
	-- German translations go here
	
return end