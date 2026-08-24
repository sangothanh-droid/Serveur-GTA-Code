local QBCore = exports['qb-core']:GetCoreObject()
local lastMeet = {} -- [src] = os.time()

RegisterNetEvent('rp-carmeet:server:start', function()
    local src = source
    local now = os.time()

    if lastMeet[src] and (now - lastMeet[src]) < (Config.CooldownMs / 1000) then
        TriggerClientEvent('QBCore:Notify', src, 'Vous devez attendre avant de relancer un rassemblement.', 'error')
        return
    end
    lastMeet[src] = now

    local coords = GetEntityCoords(GetPlayerPed(src))
    local organizerName = GetPlayerName(src)
    local label = 'Rassemblement voitures'

    local notified = 0
    for _, playerId in ipairs(QBCore.Functions.GetPlayers()) do
        local ped = GetPlayerPed(playerId)
        if ped and ped ~= 0 then
            local dist = #(GetEntityCoords(ped) - coords)
            if dist <= Config.PingRadiusMeters then
                TriggerClientEvent('rp-carmeet:client:showMeet', playerId, coords, label, organizerName, Config.MeetDurationMs)
                notified = notified + 1
            end
        end
    end

    TriggerClientEvent('QBCore:Notify', src,
        ('Rassemblement lancé : %d joueur(s) proche(s) prévenu(s).'):format(notified), 'success')
end)

AddEventHandler('playerDropped', function()
    lastMeet[source] = nil
end)
