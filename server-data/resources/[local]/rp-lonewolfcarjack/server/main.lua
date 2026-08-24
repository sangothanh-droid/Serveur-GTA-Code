local QBCore = exports['qb-core']:GetCoreObject()
local pendingSteals = {} -- [src] = netId

RegisterNetEvent('rp-lonewolfcarjack:server:attempt', function(netId)
    local src = source
    if exports['rp-crime-core']:GetPlayerGang(src) ~= nil then
        TriggerClientEvent('QBCore:Notify', src, 'Réservé aux joueurs sans gang officiel.', 'error')
        return
    end

    local veh = NetworkGetEntityFromNetworkId(netId)
    if not DoesEntityExist(veh) then
        return
    end

    local plate = GetVehicleNumberPlateText(veh):gsub('%s+', '')

    MySQL.scalar('SELECT 1 FROM player_vehicles WHERE plate = ?', { plate }, function(owned)
        if owned then
            TriggerClientEvent('QBCore:Notify', src, "Ce véhicule appartient à quelqu'un, trop risqué.", 'error')
            return
        end

        -- Alerte immédiate dès le début du vol : contrairement à rp-carjack
        -- (alerte seulement à la revente, sur un site fixe), ici la police
        -- est prévenue tout de suite, là où le vol a lieu.
        exports['rp-crime-core']:AlertPolice(GetEntityCoords(veh), 'Vol de véhicule en cours, suspect isolé.')

        pendingSteals[src] = netId
        TriggerClientEvent('rp-lonewolfcarjack:client:startSteal', src, netId, Config.StealTimeMs)
    end)
end)

RegisterNetEvent('rp-lonewolfcarjack:server:finish', function(netId, success)
    local src = source
    pendingSteals[src] = nil
    if not success then
        return
    end

    local reward = math.random(Config.RewardMin, Config.RewardMax)
    local Player = QBCore.Functions.GetPlayer(src)
    if Player then
        Player.Functions.AddMoney('cash', reward, 'lonewolfcarjack')
    end
    exports['rp-streetrep']:AddStreetRep(src, Config.RepGain)

    TriggerClientEvent('rp-lonewolfcarjack:client:deleteVehicle', src, netId)
    TriggerClientEvent('QBCore:Notify', src, ('Véhicule revendu en vitesse : +$%d'):format(reward), 'success')
end)

AddEventHandler('playerDropped', function()
    pendingSteals[source] = nil
end)
