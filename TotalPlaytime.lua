PlaytimeDB = PlaytimeDB or {}
local cachingPlaytime = false
local clearingPlaytime = false
local baseTime = 0
local sessionStart = 0

local addonName, addonTable = ...
local L = addonTable.L

local supportedRegion = {
    ["us"] = true,
    ["de"] = true,
}

local Playtime = CreateFrame("Frame")
Playtime:RegisterEvent("PLAYER_LOGIN")
Playtime:RegisterEvent("PLAYER_LOGOUT")
Playtime:RegisterEvent("TIME_PLAYED_MSG")
print(L["TotalPlaytimeErfolg"])
print(L["Anleitung"])
print(L["Erklaerung"])

Playtime:SetScript("OnEvent", function(self, event, ...)
    return self[event] and self[event](self, ...)
end)

function Playtime:PLAYER_LOGIN()
    sessionStart = GetTime()
end

function Playtime:PLAYER_LOGOUT()
    SavePlaytime()
end

function Playtime:TIME_PLAYED_MSG(total, currentLevel)
    local p = UnitName("player")
    local r = GetRealmName()
    if clearingPlaytime then
        baseTime = total
        clearingPlaytime = false
    -- print("Basiszeit gesetzt auf: " .. baseTime) -- debug message
    else
        local adjustedTotal = total - baseTime
        PlaytimeDB[p .. " (" .. r .. ")"] = adjustedTotal
    -- print("Spielzeit gespeichert für " .. p .. " auf " .. r .. ": " .. SecondsToDays(adjustedTotal)) --debug message
    end
end

function SavePlaytime()
    cachingPlaytime = true
    RequestTimePlayed()
end

function ShowPlaytime()
    local totaltime = 0
    local currentPlayerKey = UnitName("player") .. " (" .. GetRealmName() .. ")"
    local sessionSeconds = math.floor(GetTime() - sessionStart)

    for player, time in pairs(PlaytimeDB) do
        local displayTime = time
        -- Addiert die seit dem Login vergangene Zeit temporär auf den aktuellen Charakter
        if player == currentPlayerKey then
            displayTime = displayTime + sessionSeconds
        end

        print("|cffaaaaaa" .. player .. ": " .. SecondsToDays(displayTime))
        totaltime = totaltime + displayTime
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
    if msg and (msg == 'clear' or msg == 'löschen') then
        print(L["Befehl /playtime clear oder /spielzeit löschen wurde erkannt."]) -- translation fehlt
        PlaytimeDB = {}
        print("Die Playtime-Datenbank wurde geleert.")
        clearingPlaytime = true
        SavePlaytime()
    else
        ShowPlaytime()
    end
end

local function spielzeitHandler(msg, editbox)
 --   print("spielzeitHandler aufgerufen mit msg: " .. tostring(msg))  -- debug message
    if msg and (msg == 'clear' or msg == 'löschen') then
        print("Befehl /spielzeit clear oder /spielzeit löschen wurde erkannt.")  -- translation fehlt
        PlaytimeDB = {}
        print("Die Playtime-Datenbank wurde geleert.")
        clearingPlaytime = true
        SavePlaytime()
    else
        ShowPlaytime()
    end
end

SlashCmdList["PLAYTIME"] = playtimeHandler
SlashCmdList["SPIELZEIT"] = spielzeitHandler