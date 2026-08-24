local QBCore = exports['qb-core']:GetCoreObject()
local ambiance = nil -- { expiresAt }
local lastLaunch = {} -- [src] = os.time()

local function isOnDutyDj(src)
    local jobName, onDuty = exports['rp-job-core']:GetPlayerJob(src)
    return jobName == Config.JobName and onDuty
end

RegisterNetEvent('rp-nightclub:server:start', function()
    local src = source
    if not isOnDutyDj(src) then
        TriggerClientEvent('QBCore:Notify', src, 'Vous devez être DJ en service pour ça.', 'error')
        return
    end

    local now = os.time()
    if lastLaunch[src] and (now - lastLaunch[src]) < (Config.CooldownMs / 1000) then
        TriggerClientEvent('QBCore:Notify', src, "Attendez avant de relancer l'ambiance.", 'error')
        return
    end

    local dist = #(GetEntityCoords(GetPlayerPed(src)) - Config.Club.coords)
    if dist > Config.Club.radius then
        TriggerClientEvent('QBCore:Notify', src, 'Vous devez être dans la boîte de nuit.', 'error')
        return
    end

    lastLaunch[src] = now
    ambiance = { expiresAt = now + math.floor(Config.DurationMs / 1000) }

    TriggerClientEvent('chat:addMessage', -1,
        { args = { '^5[NIGHTCLUB]', ('%s lance une ambiance à %s !'):format(GetPlayerName(src), Config.Club.label) } })

    for _, playerId in ipairs(QBCore.Functions.GetPlayers()) do
        local ped = GetPlayerPed(playerId)
        if ped and ped ~= 0 and #(GetEntityCoords(ped) - Config.Club.coords) <= Config.Club.radius then
            TriggerClientEvent('rp-nightclub:client:ambianceStarted', playerId)
        end
    end
end)

CreateThread(function()
    while true do
        Wait(Config.TickMs)

        if ambiance then
            if os.time() >= ambiance.expiresAt then
                ambiance = nil
            else
                for _, playerId in ipairs(QBCore.Functions.GetPlayers()) do
                    local ped = GetPlayerPed(playerId)
                    if ped and ped ~= 0 and #(GetEntityCoords(ped) - Config.Club.coords) <= Config.Club.radius then
                        local Player = QBCore.Functions.GetPlayer(playerId)
                        if Player then
                            Player.Functions.AddMoney('cash', Config.BonusPerTick, 'nightclub-ambiance')
                        end
                    end
                end
            end
        end
    end
end)

AddEventHandler('playerDropped', function()
    lastLaunch[source] = nil
end)
