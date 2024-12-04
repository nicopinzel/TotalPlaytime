PlaytimeDB = PlaytimeDB or {}
local cachingPlaytime = false
local clearingPlaytime = false
local baseTime = 0

local addonName, addonTable = ...
local L = addonTable.L

local supportedRegion = {
    ["us"] = true,
    ["de"] = true,
}
local o = ChatFrame_DisplayTimePlayed
ChatFrame_DisplayTimePlayed = function(...)
    if cachingPlaytime then
        cachingPlaytime = false
        return
    end
    return o(...)
end

local Playtime = CreateFrame("Frame")
Playtime:RegisterEvent("PLAYER_LOGIN")
Playtime:RegisterEvent("PLAYER_LOGOUT")
Playtime:RegisterEvent("TIME_PLAYED_MSG")
print(L["TotalPlaytimeErfolg"])
print(L["Anleitung"])
print(L["Erklaerung"])

Playtime:SetScript("OnEvent", function(self, event, ...)
  --  print("Event ausgelöst: " .. event)  -- translation fehlt
    return self[event] and self[event](self, ...)
end)

function Playtime:PLAYER_LOGIN()
  --  print("PLAYER_LOGIN Event ausgelöst")  -- translation fehlt
    SavePlaytime()
    -- Spielzeit in regelmäßigen Abständen anfragen  -- translation fehlt
    self.timeSinceLastUpdate = 0
    self:SetScript("OnUpdate", function(self, elapsed)
        self.timeSinceLastUpdate = self.timeSinceLastUpdate + elapsed
        if self.timeSinceLastUpdate >= 10 then -- Alle 10 Sekunden wird aktualisiert
            SavePlaytime()
            self.timeSinceLastUpdate = 0
        end
    end)
end

function Playtime:PLAYER_LOGOUT()
 --   print("PLAYER_LOGOUT Event ausgelöst")  -- translation fehlt
    SavePlaytime()
end

function Playtime:TIME_PLAYED_MSG(total, currentLevel)
 --   print("TIME_PLAYED_MSG Event ausgelöst mit total: " .. total .. " und currentLevel: " .. currentLevel) -- translation fehlt
    local p = UnitName("player")
    local r = GetRealmName()
    if clearingPlaytime then
        baseTime = total
        clearingPlaytime = false
    -- print("Basiszeit gesetzt auf: " .. baseTime) -- debug message -- translation missing
    else
        local adjustedTotal = total - baseTime
        PlaytimeDB[p .. " (" .. r .. ")"] = adjustedTotal
     --   print("Spielzeit gespeichert für " .. p .. " auf " .. r .. ": " .. SecondsToDays(adjustedTotal)) -- translation fehlt
    end
end

function SavePlaytime()
    cachingPlaytime = true
    RequestTimePlayed()
 --   print("Spielzeit angefragt.") -- translation fehlt
end

function ShowPlaytime()
    local totaltime = 0
    for player, time in pairs(PlaytimeDB) do
        print("|cffaaaaaa" .. player .. ": " .. SecondsToDays(time))
        totaltime = totaltime + time
    end
    print(L["GesamtSpielzeit"] .. SecondsToDays(totaltime))
end

function SecondsToDays(inputSeconds)
    local days = math.floor(inputSeconds / 86400)
    local hours = math.floor((inputSeconds % 86400) / 3600)
    local minutes = math.floor((inputSeconds % 3600) / 60)
    local seconds = math.floor(inputSeconds % 60)
    return days .. L["Tage"] .. hours .. L["Stunden"] .. minutes .. L["Minuten"] .. seconds .. L["Sekunden"]
end

SLASH_PLAYTIME1 = '/playtime'
SLASH_SPIELZEIT1 = '/spielzeit'

local function playtimeHandler(msg, editbox)
   -- print("playtimeHandler aufgerufen mit msg: " .. tostring(msg))  -- translation fehlt
    if msg and (msg == 'clear' or msg == 'löschen') then
        print(L["Befehl /playtime clear oder /spielzeit löschen wurde erkannt."]) -- translation fehlt
        PlaytimeDB = {}
        print("Die Playtime-Datenbank wurde geleert.")  -- translation fehlt
        clearingPlaytime = true
        SavePlaytime()
    else
        ShowPlaytime()
    end
end

local function spielzeitHandler(msg, editbox)
 --   print("spielzeitHandler aufgerufen mit msg: " .. tostring(msg))  -- translation fehlt
    if msg and (msg == 'clear' or msg == 'löschen') then
        print("Befehl /spielzeit clear oder /spielzeit löschen wurde erkannt.")  -- translation fehlt
        PlaytimeDB = {}
        print("Die Playtime-Datenbank wurde geleert.")  -- translation fehlt
        clearingPlaytime = true
        SavePlaytime()
    else
        ShowPlaytime()
    end
end

SlashCmdList["PLAYTIME"] = playtimeHandler
SlashCmdList["SPIELZEIT"] = spielzeitHandler
