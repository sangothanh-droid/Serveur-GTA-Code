local lastRound = {}
local activeRound = {} -- [src] = true tant que la tournée est en cours

RegisterNetEvent('rp-postal:server:startRound', function()
    local src = source
    local now = os.time()

    if lastRound[src] and (now - lastRound[src]) < (Config.CooldownMs / 1000) then
        TriggerClientEvent('QBCore:Notify', src, 'Attendez un peu avant une nouvelle tournée.', 'error')
        return
    end
    if activeRound[src] then
        TriggerClientEvent('QBCore:Notify', src, 'Tournée déjà en cours.', 'error')
        return
    end

    activeRound[src] = true
    TriggerClientEvent('rp-postal:client:startRound', src, Config.Route)
end)

RegisterNetEvent('rp-postal:server:completeRound', function()
    local src = source
    if not activeRound[src] then
        return
    end
    activeRound[src] = nil
    lastRound[src] = os.time()

    local reward = #Config.Route * Config.PayPerStop
    exports['rp-job-core']:AddMoney(src, reward, 'cash')
    TriggerClientEvent('QBCore:Notify', src, ('Tournée terminée : +$%d'):format(reward), 'success')
end)

AddEventHandler('playerDropped', function()
    activeRound[source] = nil
end)
