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
    L["Sekunden. "] = "seconds. "
	L[" "] = " " -- [usSPACE, deLEERZEICHEN] for better readability in chatframe
	L["TotalPlaytime wurde erfolgreich gestartet! "] = "TotalPlaytime was successfully initialised! "
	L["Gib: '/spielzeit' ein, um deine Gesamtspielzeit zu sehen! "] = "Type: '/playtime' to see your overall playtime! "
	L["Du siehst die Zeit pro Charakter und insgesamt. "] = "You'll see your playtime per character and overall. "	

return end

if LOCALE == "deDE" then
	-- German translations go here
	
return end