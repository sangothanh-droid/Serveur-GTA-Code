local QBCore = exports['qb-core']:GetCoreObject()
local downed = {} -- [src] = true

local function isOnDutyMedic(src)
    local jobName, onDuty = exports['rp-job-core']:GetPlayerJob(src)
    return jobName == Config.JobName and onDuty
end

RegisterNetEvent('rp-ambulance:server:playerDowned', function()
    downed[source] = true
end)

RegisterNetEvent('rp-ambulance:server:revive', function(targetId)
    local src = source
    if not isOnDutyMedic(src) then
        TriggerClientEvent('QBCore:Notify', src, 'Vous devez être ambulancier en service pour ça.', 'error')
        return
    end
    if not downed[targetId] then
        TriggerClientEvent('QBCore:Notify', src, "Ce joueur n'est pas à terre.", 'error')
        return
    end

    downed[targetId] = nil
    TriggerClientEvent('rp-ambulance:client:revive', targetId)
    TriggerClientEvent('QBCore:Notify', src, 'Patient relevé.', 'success')
end)

RegisterNetEvent('rp-ambulance:server:heal', function(targetId)
    local src = source
    if not isOnDutyMedic(src) then
        TriggerClientEvent('QBCore:Notify', src, 'Vous devez être ambulancier en service pour ça.', 'error')
        return
    end

    local Medic = QBCore.Functions.GetPlayer(src)
    local Target = QBCore.Functions.GetPlayer(targetId)
    if not Medic or not Target then
        return
    end

    if Target.PlayerData.money.cash >= Config.HealCost then
        Target.Functions.RemoveMoney('cash', Config.HealCost, 'ambulance-heal')
        Medic.Functions.AddMoney('cash', Config.HealCost, 'ambulance-heal')
        TriggerClientEvent('QBCore:Notify', src, ('Soin effectué : +$%d'):format(Config.HealCost), 'success')
    else
        TriggerClientEvent('QBCore:Notify', src, 'Soin effectué gratuitement (patient sans le sou).', 'success')
    end

    TriggerClientEvent('rp-ambulance:client:healed', targetId, Config.HealAmount)
end)

RegisterNetEvent('rp-ambulance:server:requestVehicleSpawn', function()
    local src = source
    if not isOnDutyMedic(src) then
        TriggerClientEvent('QBCore:Notify', src, 'Vous devez être ambulancier en service pour ça.', 'error')
        return
    end

    TriggerClientEvent('rp-ambulance:client:spawnVehicle', src, Config.SpawnVehicleModel, Config.Hospital.coords, 0.0)
end)

AddEventHandler('playerDropped', function()
    downed[source] = nil
end)
