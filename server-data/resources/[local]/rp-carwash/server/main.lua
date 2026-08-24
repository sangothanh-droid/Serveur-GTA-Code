local lastWash = {} -- [plate] = os.time()

RegisterNetEvent('rp-carwash:server:finish', function(netId)
    local src = source
    local veh = NetworkGetEntityFromNetworkId(netId)
    if not DoesEntityExist(veh) then
        return
    end

    local plate = GetVehicleNumberPlateText(veh):gsub('%s+', '')
    local now = os.time()
    if lastWash[plate] and (now - lastWash[plate]) < (Config.CooldownMs / 1000) then
        TriggerClientEvent('QBCore:Notify', src, "Ce véhicule vient d'être lavé récemment.", 'error')
        return
    end
    lastWash[plate] = now

    local reward = math.random(Config.RewardMin, Config.RewardMax)
    exports['rp-job-core']:AddMoney(src, reward, 'cash')
    TriggerClientEvent('QBCore:Notify', src, ('Véhicule lavé : +$%d'):format(reward), 'success')
end)
