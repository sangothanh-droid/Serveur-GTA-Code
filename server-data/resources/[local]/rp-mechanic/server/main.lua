local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('rp-mechanic:server:repair', function(netId)
    local src = source
    local jobName, onDuty = exports['rp-job-core']:GetPlayerJob(src)

    if jobName ~= Config.JobName then
        TriggerClientEvent('QBCore:Notify', src, "Vous n'êtes pas mécanicien.", 'error')
        return
    end
    if not onDuty then
        TriggerClientEvent('QBCore:Notify', src, 'Vous devez être en service (/duty).', 'error')
        return
    end

    local veh = NetworkGetEntityFromNetworkId(netId)
    if not DoesEntityExist(veh) then
        return
    end

    TriggerClientEvent('rp-mechanic:client:startRepair', src, netId, Config.RepairTimeMs)
end)

RegisterNetEvent('rp-mechanic:server:finishRepair', function(netId, success)
    local src = source
    if not success then
        return
    end

    TriggerClientEvent('rp-mechanic:client:applyRepair', src, netId)
    exports['rp-job-core']:AddMoney(src, math.random(Config.PayMin, Config.PayMax), 'cash')
    TriggerClientEvent('QBCore:Notify', src, 'Réparation payée.', 'success')
end)
