local QBCore = exports['qb-core']:GetCoreObject()
local cuffed = {} -- [src] = true

local function isOnDutyPolice(src)
    local jobName, onDuty = exports['rp-job-core']:GetPlayerJob(src)
    return jobName == Config.JobName and onDuty
end

RegisterNetEvent('rp-police:server:cuff', function(targetId, state)
    local src = source
    if not isOnDutyPolice(src) then
        TriggerClientEvent('QBCore:Notify', src, "Vous devez être policier en service pour ça.", 'error')
        return
    end
    if not QBCore.Functions.GetPlayer(targetId) then
        return
    end

    cuffed[targetId] = state or nil
    TriggerClientEvent('rp-police:client:setCuffed', targetId, state)
    TriggerClientEvent('QBCore:Notify', src, state and 'Suspect menotté.' or 'Suspect libéré.', 'success')
end)

RegisterNetEvent('rp-police:server:search', function(targetId)
    local src = source
    if not isOnDutyPolice(src) then
        TriggerClientEvent('QBCore:Notify', src, "Vous devez être policier en service pour ça.", 'error')
        return
    end
    if not cuffed[targetId] then
        TriggerClientEvent('QBCore:Notify', src, "Ce joueur n'est pas menotté.", 'error')
        return
    end

    local TargetPlayer = QBCore.Functions.GetPlayer(targetId)
    if not TargetPlayer then
        return
    end

    local lines = { ('-- Inventaire de %s --'):format(GetPlayerName(targetId)) }
    local empty = true
    for _, item in pairs(TargetPlayer.PlayerData.items or {}) do
        if item then
            empty = false
            table.insert(lines, ('%s x%d'):format(item.label, item.amount))
        end
    end
    if empty then
        table.insert(lines, '(vide)')
    end

    for _, line in ipairs(lines) do
        TriggerClientEvent('chat:addMessage', src, { args = { '^3[FOUILLE]', line } })
    end
end)

RegisterNetEvent('rp-police:server:ticket', function(targetId, amount, reason)
    local src = source
    if not isOnDutyPolice(src) then
        TriggerClientEvent('QBCore:Notify', src, "Vous devez être policier en service pour ça.", 'error')
        return
    end

    amount = math.floor(tonumber(amount) or 0)
    if amount <= 0 then
        TriggerClientEvent('QBCore:Notify', src, 'Montant invalide.', 'error')
        return
    end

    local Officer = QBCore.Functions.GetPlayer(src)
    local Target = QBCore.Functions.GetPlayer(targetId)
    if not Officer or not Target then
        return
    end

    if Target.PlayerData.money.bank < amount then
        TriggerClientEvent('QBCore:Notify', src, "Le suspect n'a pas assez d'argent en banque.", 'error')
        return
    end

    Target.Functions.RemoveMoney('bank', amount, 'police-ticket')
    Officer.Functions.AddMoney('bank', amount, 'police-ticket')

    local message = ('%s verbalise %s : $%d (%s)'):format(
        GetPlayerName(src), GetPlayerName(targetId), amount, reason)
    TriggerClientEvent('chat:addMessage', -1, { args = { '^3[POLICE]', message } })
end)

RegisterNetEvent('rp-police:server:impound', function(netId)
    local src = source
    if not isOnDutyPolice(src) then
        TriggerClientEvent('QBCore:Notify', src, "Vous devez être policier en service pour ça.", 'error')
        return
    end

    local veh = NetworkGetEntityFromNetworkId(netId)
    if not DoesEntityExist(veh) then
        return
    end

    TriggerClientEvent('rp-police:client:deleteVehicle', -1, netId)

    local Officer = QBCore.Functions.GetPlayer(src)
    if Officer then
        Officer.Functions.AddMoney('cash', Config.ImpoundReward, 'police-impound')
    end
    TriggerClientEvent('QBCore:Notify', src, ('Véhicule mis en fourrière : +$%d'):format(Config.ImpoundReward), 'success')
end)

RegisterNetEvent('rp-police:server:requestVehicleSpawn', function()
    local src = source
    if not isOnDutyPolice(src) then
        TriggerClientEvent('QBCore:Notify', src, "Vous devez être policier en service pour ça.", 'error')
        return
    end

    TriggerClientEvent('rp-police:client:spawnVehicle', src, Config.SpawnVehicleModel, Config.Station.coords, 0.0)
end)

AddEventHandler('playerDropped', function()
    cuffed[source] = nil
end)
