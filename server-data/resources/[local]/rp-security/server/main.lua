local QBCore = exports['qb-core']:GetCoreObject()

local function isOnPatrolSite(coords)
    for _, site in ipairs(Config.PatrolSites) do
        if #(coords - site.coords) <= site.radius then
            return site
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
                    local site = isOnPatrolSite(GetEntityCoords(ped))
                    if site then
                        Player.Functions.AddMoney('cash', Config.PayPerTick)
                        TriggerClientEvent('QBCore:Notify', playerId, ('Prime de patrouille (%s) : +$%d'):format(site.label, Config.PayPerTick), 'success')
                    end
                end
            end
        end
    end
end)
