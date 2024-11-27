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
print("TotalPlaytime wurde erfolgreich gestartet!")
print("Gib: '/spielzeit' ein, um deine Gesamtspielzeit zu sehen!")
print("Du siehst die Zeit pro Charakter und insgesamt.")

Playtime:SetScript("OnEvent", function(self, event, ...)
    print("Event ausgelöst: " .. event)
    return self[event] and self[event](self, ...)
end)

function Playtime:PLAYER_LOGIN()
    print("PLAYER_LOGIN Event ausgelöst")
    SavePlaytime()
    -- Spielzeit in regelmäßigen Abständen anfragen
    self.timeSinceLastUpdate = 0
    self:SetScript("OnUpdate", function(self, elapsed)
        self.timeSinceLastUpdate = self.timeSinceLastUpdate + elapsed
        if self.timeSinceLastUpdate >= 30 then -- Alle 60 Sekunden
            SavePlaytime()
            self.timeSinceLastUpdate = 0
        end
    end)
end

function Playtime:PLAYER_LOGOUT()
    print("PLAYER_LOGOUT Event ausgelöst")
    SavePlaytime()
end

function Playtime:TIME_PLAYED_MSG(total, currentLevel)
    print("TIME_PLAYED_MSG Event ausgelöst mit total: " .. total .. " und currentLevel: " .. currentLevel)
    local p = UnitName("player")
    local r = GetRealmName()
    if clearingPlaytime then
        baseTime = total
        clearingPlaytime = false
        print("Basiszeit gesetzt auf: " .. baseTime)
    else
        local adjustedTotal = total - baseTime
        PlaytimeDB[p .. " (" .. r .. ")"] = adjustedTotal
        print("Spielzeit gespeichert für " .. p .. " auf " .. r .. ": " .. adjustedTotal)
    end
    ShowPlaytime()
end

function SavePlaytime()
    cachingPlaytime = true
    RequestTimePlayed()
    print("Spielzeit angefragt.")
end

function ShowPlaytime()
    local totaltime = 0
    for player, time in pairs(PlaytimeDB) do
        print("|cffaaaaaa" .. player .. ": " .. SecondsToDays(time))
        totaltime = totaltime + time
    end
    print("Gesamt Spielzeit: " .. SecondsToDays(totaltime))
end

function SecondsToDays(inputSeconds)
    local days = math.floor(inputSeconds / 86400)
    local hours = math.floor((inputSeconds % 86400) / 3600)
    local minutes = math.floor((inputSeconds % 3600) / 60)
    local seconds = math.floor(inputSeconds % 60)
    return days .. " Tage, " .. hours .. " Stunden, " .. minutes .. " Minuten, " .. seconds .. " Sekunden."
end

SLASH_PLAYTIME1 = '/playtime'
SLASH_SPIELZEIT1 = '/spielzeit'

local function playtimeHandler(msg, editbox)
    print("playtimeHandler aufgerufen mit msg: " .. tostring(msg))
    if msg and (msg == 'clear' or msg == 'löschen') then
        print("Befehl /playtime clear oder /spielzeit löschen wurde erkannt.")
        PlaytimeDB = {}
        print("Die Playtime-Datenbank wurde geleert.")
        for k, v in pairs(PlaytimeDB) do
            print("Eintrag in PlaytimeDB nach dem Löschen:", k, v)
        end
        clearingPlaytime = true
        SavePlaytime()
    else
        ShowPlaytime()
    end
end

local function spielzeitHandler(msg, editbox)
    print("spielzeitHandler aufgerufen mit msg: " .. tostring(msg))
    if msg and (msg == 'clear' or msg == 'löschen') then
        print("Befehl /spielzeit clear oder /spielzeit löschen wurde erkannt.")
        PlaytimeDB = {}
        print("Die Playtime-Datenbank wurde geleert.")
        for k, v in pairs(PlaytimeDB) do
            print("Eintrag in PlaytimeDB nach dem Löschen:", k, v)
        end
        clearingPlaytime = true
        SavePlaytime()
    else
        ShowPlaytime()
    end
end

SlashCmdList["PLAYTIME"] = playtimeHandler
SlashCmdList["SPIELZEIT"] = spielzeitHandler
