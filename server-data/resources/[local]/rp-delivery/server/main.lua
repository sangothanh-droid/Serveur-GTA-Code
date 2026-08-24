local lastDelivery = {}
local pendingDeliveries = {}

RegisterNetEvent('rp-delivery:server:load', function()
    local src = source
    local now = os.time()

    if lastDelivery[src] and (now - lastDelivery[src]) < (Config.CooldownMs / 1000) then
        TriggerClientEvent('QBCore:Notify', src, 'Attendez un peu avant un nouveau chargement.', 'error')
        return
    end
    if pendingDeliveries[src] then
        TriggerClientEvent('QBCore:Notify', src, 'Livraison déjà en cours.', 'error')
        return
    end

    local drop = Config.DropPoints[math.random(#Config.DropPoints)]
    pendingDeliveries[src] = true
    TriggerClientEvent('rp-delivery:client:startDelivery', src, drop.coords, drop.label)
end)

RegisterNetEvent('rp-delivery:server:complete', function()
    local src = source
    if not pendingDeliveries[src] then
        return
    end
    pendingDeliveries[src] = nil
    lastDelivery[src] = os.time()

    local reward = math.random(Config.PayMin, Config.PayMax)
    exports['rp-job-core']:AddMoney(src, reward, 'cash')
    TriggerClientEvent('QBCore:Notify', src, ('Livraison effectuée : +$%d'):format(reward), 'success')
end)

AddEventHandler('playerDropped', function()
    pendingDeliveries[source] = nil
end)
