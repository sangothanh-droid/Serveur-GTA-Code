RegisterNetEvent('rp-scoreboard:server:requestPlayers', function()
    local src = source
    local players = {}

    for _, playerId in ipairs(GetPlayers()) do
        local pid = tonumber(playerId)
        table.insert(players, {
            id = pid,
            name = GetPlayerName(pid) or ('Joueur %d'):format(pid),
            ping = GetPlayerPing(pid) or 0,
        })
    end

    table.sort(players, function(a, b) return a.id < b.id end)

    TriggerClientEvent('rp-scoreboard:client:updatePlayers', src, players, GetConvarInt('sv_maxclients', 48))
end)
