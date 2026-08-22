local spots = {}
for i = 1, #Config.FishingSpots do
    spots[i] = { ready = true }
end

local rawFish = {} -- [src] = quantité pêchée en attente de vente

RegisterNetEvent('rp-fisherman:server:catch', function(spotIndex)
    local src = source
    local spot = spots[spotIndex]
    if not spot or not spot.ready then
        TriggerClientEvent('QBCore:Notify', src, "Ce coin de pêche n'a pas encore de poisson.", 'error')
        return
    end

    spot.ready = false
    SetTimeout(Config.RegrowTimeMs, function()
        spot.ready = true
    end)

    rawFish[src] = (rawFish[src] or 0) + Config.YieldPerCatch
    TriggerClientEvent('QBCore:Notify', src, 'Poisson attrapé.', 'success')
end)

RegisterNetEvent('rp-fisherman:server:sell', function()
    local src = source
    local fish = rawFish[src] or 0
    if fish <= 0 then
        TriggerClientEvent('QBCore:Notify', src, "Vous n'avez pas de poisson à vendre.", 'error')
        return
    end

    rawFish[src] = 0
    local reward = fish * Config.PricePerUnit
    exports['rp-job-core']:AddMoney(src, reward, 'cash')
    TriggerClientEvent('QBCore:Notify', src, ('%d poisson(s) vendu(s) : +$%d'):format(fish, reward), 'success')
end)

AddEventHandler('playerDropped', function()
    rawFish[source] = nil
end)
