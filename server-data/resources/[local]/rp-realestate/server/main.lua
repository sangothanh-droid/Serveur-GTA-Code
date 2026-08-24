local QBCore = exports['qb-core']:GetCoreObject()

local function isOnProperty(coords)
    for _, property in ipairs(Config.Properties) do
        if #(coords - property.coords) <= property.radius then
            return property
        end
    end
    return nil
end

CreateThread(function()
    while true do
        Wait(Config.TickMs)

        for _, playerId in ipairs(QBCore.Functions.GetPlayers()) do
            local Player = QBCore.Functions.GetPlayer(playerId)
            if Player and Player.PlayerData.job.name == Config.JobName and Player.PlayerData.job.onduty then
                local ped = GetPlayerPed(playerId)
                if ped and ped ~= 0 then
                    local property = isOnProperty(GetEntityCoords(ped))
                    if property then
                        Player.Functions.AddMoney('cash', Config.PayPerTick)
                        TriggerClientEvent('QBCore:Notify', playerId, ('Commission de visite (%s) : +$%d'):format(property.label, Config.PayPerTick), 'success')
                    end
                end
            end
        end
    end
end)
