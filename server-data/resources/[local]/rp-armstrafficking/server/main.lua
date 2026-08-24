local lastDeal = {}

RegisterNetEvent('rp-armstrafficking:server:attemptDeal', function()
    local src = source
    local ped = GetPlayerPed(src)
    local dist = #(GetEntityCoords(ped) - Config.DealPoint.coords)
    if dist > Config.InteractDistance then
        TriggerClientEvent('QBCore:Notify', src, 'Vous devez être au point de rendez-vous.', 'error')
        return
    end

    local now = os.time()
    if lastDeal[src] and (now - lastDeal[src]) < (Config.DealIntervalMs / 1000) then
        TriggerClientEvent('QBCore:Notify', src, 'Le fournisseur ne veut pas vous revoir tout de suite.', 'error')
        return
    end
    lastDeal[src] = now

    local gang = exports['rp-crime-core']:GetPlayerGang(src)
    if not gang then
        TriggerClientEvent('QBCore:Notify', src, 'Vous devez appartenir à un gang pour faire ça.', 'error')
        return
    end

    exports['rp-gangs']:GetGangMultiplier(gang, function(_, policeMultiplier)
        local ambushChance = Config.AmbushBaseChancePercent * policeMultiplier

        if math.random(100) <= ambushChance then
            TriggerClientEvent('QBCore:Notify', src, 'Embuscade ! Le fournisseur était surveillé.', 'error')
            exports['rp-crime-core']:AlertPolice(Config.DealPoint.coords, "Coups de feu signalés lors d'un deal d'armes.")
            return
        end

        local reward = math.random(Config.RewardMin, Config.RewardMax)
        exports['rp-crime-core']:AddMoney(src, reward, 'cash')
        exports['rp-gangs']:AddReputation(gang, Config.RepGain, src)
        TriggerClientEvent('QBCore:Notify', src, ('Deal conclu : +$%d'):format(reward), 'success')
    end)
end)

AddEventHandler('playerDropped', function()
    lastDeal[source] = nil
end)
