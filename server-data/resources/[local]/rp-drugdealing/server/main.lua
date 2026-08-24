local lastSale = {}

RegisterNetEvent('rp-drugdealing:server:attemptSale', function()
    local src = source
    local now = os.time()

    if lastSale[src] and (now - lastSale[src]) < (Config.CooldownMs / 1000) then
        TriggerClientEvent('QBCore:Notify', src, 'Attendez un peu avant de retenter une vente.', 'error')
        return
    end
    lastSale[src] = now

    local gang = exports['rp-crime-core']:GetPlayerGang(src)
    if not gang then
        TriggerClientEvent('QBCore:Notify', src, 'Vous devez appartenir à un gang pour faire ça.', 'error')
        return
    end

    if math.random(100) <= Config.SuccessChancePercent then
        local reward = math.random(Config.RewardMin, Config.RewardMax)
        exports['rp-crime-core']:AddMoney(src, reward, 'cash')
        exports['rp-gangs']:AddReputation(gang, Config.RepGain, src)
        TriggerClientEvent('QBCore:Notify', src, ('Vente réussie : +$%d'):format(reward), 'success')
    else
        TriggerClientEvent('QBCore:Notify', src, 'Le client a refusé, aucune vente.', 'error')
    end

    if math.random(100) <= Config.PoliceCallChancePercent then
        local coords = GetEntityCoords(GetPlayerPed(src))
        exports['rp-crime-core']:AlertPolice(coords, 'Deal de drogue signalé par un témoin.')
    end
end)

AddEventHandler('playerDropped', function()
    lastSale[source] = nil
end)
