

local _, namespace = ...

local L = setmetatable({}, { __index = function(t, k)
	local v = tostring(k)
	rawset(t, k, v)
	return v
end })

namespace.L = L

local LOCALE = GetLocale()
print("Localization.lua geladen") -- debug ausgabe  -- translation fehlt
print("LOCALE: " .. LOCALE)  -- debug ausgabe -- translation fehlt
if LOCALE == "enUS" then
	-- English translations
    L["GesamtSpielzeit"] = "Total playtime: "
    L["Tage"] = " Days, "
    L["Stunden"] = " hours, "
    L["Minuten"] = " minutes, "
    L["Sekunden"] = " seconds. "
	L[" "] = " "
	L["TotalPlaytimeErfolg"] = "TotalPlaytime was successfully initialised! "
	L["Anleitung"] = "Type: '/playtime' to see your overall playtime! "
	L["Erklaerung"] = "You'll see your playtime per character and overall. "	
	L["Die Playtime-Datenbank wurde geleert."] = "The Playtime-Database was cleared. "
	print("english localization was loaded")

return end

if LOCALE == "deDE" then 
	-- German translations 
	L["GesamtSpielzeit"] = "Gesamt Spielzeit: " 
	L["Tage"] = " Tage, " 
	L["Stunden"] = " Stunden, " 
	L["Minuten"] = " Minuten, " 
	L["Sekunden"] = " Sekunden. " 
	L[" "] = " " 
	L["TotalPlaytimeErfolg"] = "TotalPlaytime wurde erfolgreich gestartet! " 
	L["Anleitung"] = "Gib: '/spielzeit' ein, um deine Gesamtspielzeit zu sehen! " 
	L["Erklaerung"] = "Du siehst die Zeit pro Charakter und insgesamt. " 
	print("deutsch lokalisierung wurde geladen")  -- debug message
return end