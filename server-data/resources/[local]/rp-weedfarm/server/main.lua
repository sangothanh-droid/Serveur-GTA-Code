local spots = {}
for i = 1, #Config.PlantSpots do
    spots[i] = { ready = true }
end

local rawYield = {} -- [src] = quantité récoltée en attente de vente

RegisterNetEvent('rp-weedfarm:server:harvest', function(spotIndex)
    local src = source
    local spot = spots[spotIndex]
    if not spot or not spot.ready then
        TriggerClientEvent('QBCore:Notify', src, "Ce plant n'est pas encore prêt.", 'error')
        return
    end

    local gang = exports['rp-crime-core']:GetPlayerGang(src)
    if not gang then
        TriggerClientEvent('QBCore:Notify', src, 'Vous devez appartenir à un gang pour faire ça.', 'error')
        return
    end

    spot.ready = false
    SetTimeout(Config.RegrowTimeMs, function()
        spot.ready = true
    end)

    rawYield[src] = (rawYield[src] or 0) + Config.YieldPerHarvest
    TriggerClientEvent('QBCore:Notify', src, 'Récolte effectuée.', 'success')
end)

RegisterNetEvent('rp-weedfarm:server:startProcessing', function()
    local src = source
    local yield = rawYield[src] or 0
    if yield <= 0 then
        TriggerClientEvent('QBCore:Notify', src, 'Rien à traiter.', 'error')
        return
    end
    TriggerClientEvent('rp-weedfarm:client:startProcessing', src, Config.ProcessTimeMs)
end)

RegisterNetEvent('rp-weedfarm:server:finishProcessing', function(success)
    local src = source
    if not success then
        return
    end

    local yield = rawYield[src] or 0
    if yield <= 0 then
        return
    end
    rawYield[src] = 0

    local reward = yield * Config.PricePerUnit
    exports['rp-crime-core']:AddMoney(src, reward, 'cash')

    local gang = exports['rp-crime-core']:GetPlayerGang(src)
    if gang then
        exports['rp-gangs']:AddReputation(gang, math.floor(yield / 5) * Config.RepGainPer5Units, src)
    end

    TriggerClientEvent('QBCore:Notify', src, ('%d unité(s) vendue(s) : +$%d'):format(yield, reward), 'success')
end)

AddEventHandler('playerDropped', function()
    rawYield[source] = nil
end)
