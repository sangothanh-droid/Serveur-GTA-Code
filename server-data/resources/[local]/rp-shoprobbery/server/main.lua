local shopCooldowns = {}
local pendingRobberies = {}

RegisterNetEvent('rp-shoprobbery:server:attempt', function(shopIndex)
    local src = source
    local shop = Config.Shops[shopIndex]
    if not shop then
        return
    end

    local now = os.time()
    if shopCooldowns[shopIndex] and (now - shopCooldowns[shopIndex]) < (Config.CooldownMs / 1000) then
        TriggerClientEvent('QBCore:Notify', src, "Ce magasin vient d'être braqué récemment.", 'error')
        return
    end

    local gang = exports['rp-crime-core']:GetPlayerGang(src)
    if not gang then
        TriggerClientEvent('QBCore:Notify', src, 'Vous devez appartenir à un gang pour faire ça.', 'error')
        return
    end

    shopCooldowns[shopIndex] = now
    pendingRobberies[src] = shopIndex

    exports['rp-crime-core']:AlertPolice(shop.coords, ('Braquage signalé : %s'):format(shop.label))
    TriggerClientEvent('rp-shoprobbery:client:startProgress', src, Config.RobTimeMs)
end)

RegisterNetEvent('rp-shoprobbery:server:finish', function(success)
    local src = source
    local shopIndex = pendingRobberies[src]
    pendingRobberies[src] = nil
    if not shopIndex or not success then
        return
    end

    local reward = math.random(Config.RewardMin, Config.RewardMax)
    exports['rp-crime-core']:AddMoney(src, reward, 'cash')

    local gang = exports['rp-crime-core']:GetPlayerGang(src)
    if gang then
        exports['rp-gangs']:AddReputation(gang, Config.RepGain, src)
    end

    TriggerClientEvent('QBCore:Notify', src, ('Braquage réussi : +$%d'):format(reward), 'success')
end)

AddEventHandler('playerDropped', function()
    pendingRobberies[source] = nil
end)
