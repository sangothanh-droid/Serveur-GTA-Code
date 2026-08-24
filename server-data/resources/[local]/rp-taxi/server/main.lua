local lastFare = {}
local pendingFares = {}

RegisterNetEvent('rp-taxi:server:requestFare', function()
    local src = source
    local now = os.time()

    if lastFare[src] and (now - lastFare[src]) < (Config.CooldownMs / 1000) then
        TriggerClientEvent('QBCore:Notify', src, 'Attendez un peu avant une nouvelle course.', 'error')
        return
    end
    if pendingFares[src] then
        TriggerClientEvent('QBCore:Notify', src, 'Course déjà en cours.', 'error')
        return
    end

    local dest = Config.Destinations[math.random(#Config.Destinations)]
    pendingFares[src] = true
    TriggerClientEvent('rp-taxi:client:startFare', src, dest.coords, dest.label)
end)

RegisterNetEvent('rp-taxi:server:completeFare', function()
    local src = source
    if not pendingFares[src] then
        return
    end
    pendingFares[src] = nil
    lastFare[src] = os.time()

    local reward = math.random(Config.PayMin, Config.PayMax)
    exports['rp-job-core']:AddMoney(src, reward, 'cash')
    TriggerClientEvent('QBCore:Notify', src, ('Course terminée : +$%d'):format(reward), 'success')
end)

AddEventHandler('playerDropped', function()
    pendingFares[source] = nil
end)
