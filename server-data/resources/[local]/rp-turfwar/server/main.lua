local QBCore = exports['qb-core']:GetCoreObject()
local territories = {} -- [gangId] = { owner = gangName, points = { [challengerGang] = points } }

local function loadTerritories()
    local Gangs = exports['rp-gangs']:GetAllGangs()
    for gangId in pairs(Gangs) do
        MySQL.scalar('SELECT owner_gang FROM gang_territories WHERE territory_id = ?', { gangId }, function(owner)
            territories[gangId] = { owner = owner or gangId, points = {} }
            if not owner then
                MySQL.insert('INSERT INTO gang_territories (territory_id, owner_gang) VALUES (?, ?)', { gangId, gangId })
            end
        end)
    end
end

CreateThread(function()
    Wait(2000) -- laisser rp-gangs finir de démarrer
    loadTerritories()
end)

local function tick()
    local Gangs = exports['rp-gangs']:GetAllGangs()
    local players = QBCore.Functions.GetPlayers()

    for gangId, gang in pairs(Gangs) do
        local territory = territories[gangId]
        if territory then
            local presentGangs = {}

            for _, playerId in ipairs(players) do
                local ped = GetPlayerPed(playerId)
                if ped and ped ~= 0 then
                    local dist = #(GetEntityCoords(ped) - gang.territory.coords)
                    if dist <= gang.territory.radius then
                        local playerGang = exports['rp-crime-core']:GetPlayerGang(playerId)
                        if playerGang then
                            presentGangs[playerGang] = true
                        end
                    end
                end
            end

            local contenders = {}
            for gName in pairs(presentGangs) do
                table.insert(contenders, gName)
            end

            if #contenders == 1 and contenders[1] ~= territory.owner then
                local challenger = contenders[1]
                territory.points[challenger] = (territory.points[challenger] or 0) + Config.PointsPerTick

                if territory.points[challenger] >= Config.PointsToCapture then
                    local previousOwner = territory.owner
                    territory.owner = challenger
                    territory.points = {}

                    MySQL.update('UPDATE gang_territories SET owner_gang = ? WHERE territory_id = ?', { challenger, gangId })

                    TriggerClientEvent('chat:addMessage', -1, {
                        args = { '^1[TERRITOIRE]', ('%s a pris le contrôle de "%s" (anciennement %s) !'):format(
                            Gangs[challenger] and Gangs[challenger].label or challenger,
                            gang.territory.label,
                            Gangs[previousOwner] and Gangs[previousOwner].label or previousOwner) }
                    })

                    exports['rp-gangs']:AddReputation(challenger, Config.CaptureRepGain)
                end
            end
        end
    end
end

CreateThread(function()
    while true do
        Wait(Config.TickMs)
        tick()
    end
end)

exports('GetTerritoryOwner', function(territoryId)
    local territory = territories[territoryId]
    return territory and territory.owner
end)

exports('GetAllTerritories', function()
    return territories
end)
