PlaytimeDB = PlaytimeDB or {}
local cachingPlaytime = true

local addonName, addonTable = ... 
local L = addonTable.L

local supportedRegion = {
	["us"] = true,
	["de"] = true,
}
local o = ChatFrame_DisplayTimePlayed
ChatFrame_DisplayTimePlayed = function(...)
	if (cachingPlaytime) then
		cachingPlaytime = false
		return
	end
	return o(...)
end

local Playtime = CreateFrame("Frame")
Playtime:RegisterEvent("PLAYER_LOGIN")
Playtime:RegisterEvent("PLAYER_LOGOUT")
Playtime:RegisterEvent("TIME_PLAYED_MSG")

Playtime:SetScript("OnEvent", function(self, event, ...)
return self[event] and self[event](self, ...)
end)

function Playtime:PLAYER_LOGIN()
	SavePlaytime()
end

function Playtime:PLAYER_LOGOUT()
	SavePlaytime()
end

function Playtime:TIME_PLAYED_MSG(total, currentLevel)
	local p = UnitName("player")	
	local r = GetRealmName()
	PlaytimeDB[p.." ("..r..")"] = total
end

function SavePlaytime()
	cachingPlaytime = true
	RequestTimePlayed()
end

function ShowPlaytime()
	SavePlaytime()
	
	local totaltime = 0
	for player,time in pairs(PlaytimeDB) do
print("|cffaaaaaa"..player..": "..SecondsToDays(time) )
		totaltime = totaltime + time
	end

	print(L["Gesamt Spielzeit: "]..SecondsToDays(totaltime) )
end

function SecondsToDays(inputSeconds)
 Cdays = math.floor(inputSeconds/86400)
 Chours = math.floor((bit.mod(inputSeconds,86400))/3600)
 Cminutes = math.floor(bit.mod((bit.mod(inputSeconds,86400)),3600)/60)
 Cseconds = math.floor(bit.mod(bit.mod((bit.mod(inputSeconds,86400)),3600),60))
 return Cdays.. L[" "] ..  L["Tage, "] ..Chours.. L[" "] .. L["Stunden, "] ..Cminutes.. L[" "] .. L["Minuten, "] ..Cseconds.. L[" "] .. L["Sekunden."]
end

SLASH_PLAYTIME1 = '/playtime';
SLASH_SPIELZEIT1 = '/spielzeit';


local function playtimeHandler(msg, editbox)
	if msg and (msg == 'clear') then
		PlaytimeDB = {}
		SavePlaytime()
	else
		ShowPlaytime()
	end
end

local function spielzeitHandler(msg, editbox)
	if msg and (msg == 'clear') then
		PlaytimeDB = {}
		SavePlaytime()
	else
		ShowPlaytime()
	end
end

SlashCmdList["PLAYTIME"] = playtimeHandler;
SlashCmdList["SPIELZEIT"] = spielzeitHandler;