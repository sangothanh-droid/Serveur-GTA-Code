local QBCore = exports['qb-core']:GetCoreObject()

-- Webhook Discord pour l'annonce des points chauds (laisser vide pour désactiver).
local DiscordWebhook = GetConvar('rp_gangwar_discord_webhook', '')

local hotzone = nil -- { gangId, label, coords, radius, expiresAt }

local function sendDiscordLog(message)
    if DiscordWebhook == '' then
        return
    end
    PerformHttpRequest(DiscordWebhook, function() end, 'POST',
        json.encode({ content = message }),
        { ['Content-Type'] = 'application/json' })
end

local function announceHotzone(gangId, gang)
    hotzone = {
        gangId = gangId,
        label = gang.territory.label,
        coords = gang.territory.coords,
        radius = gang.territory.radius,
        expiresAt = os.time() + math.floor(Config.HotzoneDurationMs / 1000),
    }

    local msg = ('🔥 Point chaud activé sur "%s" (territoire %s) pendant %d minutes : réputation de gang boostée pour qui y reste !')
        :format(gang.territory.label, gang.label, math.floor(Config.HotzoneDurationMs / 60000))

    TriggerClientEvent('chat:addMessage', -1, { args = { '^1[GANGWAR]', msg } })
    TriggerClientEvent('rp-gangwar-events:client:setHotzone', -1, hotzone.coords, hotzone.label)
    sendDiscordLog(msg)
end

local function pickRandomTerritory()
    local Gangs = exports['rp-gangs']:GetAllGangs()
    local ids = {}
    for gangId in pairs(Gangs) do
        table.insert(ids, gangId)
    end
    if #ids == 0 then
        return
    end
    local chosen = ids[math.random(#ids)]
    announceHotzone(chosen, Gangs[chosen])
end

CreateThread(function()
    while true do
        Wait(Config.IntervalMs)
        if not hotzone then
            pickRandomTerritory()
        end
    end
end)

CreateThread(function()
    while true do
        Wait(Config.TickMs)

        if hotzone then
            if os.time() >= hotzone.expiresAt then
                TriggerClientEvent('chat:addMessage', -1,
                    { args = { '^1[GANGWAR]', ('Le point chaud sur "%s" est terminé.'):format(hotzone.label) } })
                TriggerClientEvent('rp-gangwar-events:client:clearHotzone', -1)
                hotzone = nil
            else
                for _, playerId in ipairs(QBCore.Functions.GetPlayers()) do
                    local ped = GetPlayerPed(playerId)
                    if ped and ped ~= 0 then
                        local dist = #(GetEntityCoords(ped) - hotzone.coords)
                        if dist <= hotzone.radius then
                            local gang = exports['rp-crime-core']:GetPlayerGang(playerId)
                            if gang then
                                exports['rp-gangs']:AddReputation(gang, Config.RepBonusPerTick, playerId)
                            end
                        end
                    end
                end
            end
        end
    end
end)

exports('GetActiveHotzone', function()
    return hotzone
end)
