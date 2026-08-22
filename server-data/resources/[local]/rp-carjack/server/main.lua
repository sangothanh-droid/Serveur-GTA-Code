RegisterNetEvent('rp-carjack:server:sellVehicle', function(netId)
    local src = source
    local veh = NetworkGetEntityFromNetworkId(netId)
    if not DoesEntityExist(veh) then
        return
    end

    local plate = GetVehicleNumberPlateText(veh):gsub('%s+', '')

    MySQL.scalar('SELECT 1 FROM player_vehicles WHERE plate = ?', { plate }, function(owned)
        if owned then
            TriggerClientEvent('QBCore:Notify', src, 'Ce véhicule vous appartient, impossible de le revendre à la casse.', 'error')
            return
        end

        local gang = exports['rp-crime-core']:GetPlayerGang(src)
        if not gang then
            TriggerClientEvent('QBCore:Notify', src, 'Vous devez appartenir à un gang pour faire ça.', 'error')
            return
        end

        local reward = math.random(Config.MinValue, Config.MaxValue)
        exports['rp-crime-core']:AddMoney(src, reward, 'cash')
        exports['rp-gangs']:AddReputation(gang, Config.RepGain, src)
        exports['rp-crime-core']:AlertPolice(Config.ChopShop.coords, 'Activité suspecte signalée près de Cypress Flats.')

        TriggerClientEvent('rp-carjack:client:deleteVehicle', src, netId)
        TriggerClientEvent('QBCore:Notify', src, ('Véhicule revendu : +$%d'):format(reward), 'success')
    end)
end)
