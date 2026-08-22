local QBCore = exports['qb-core']:GetCoreObject()
local labs = {} -- [labId] = { coords = vector3, label = string, owner = gangName|nil, points = {} }

local function collectLabs()
    local all = {}

    local ok1, weaponLabs = pcall(function() return exports['rp-weaponlab']:GetLabs() end)
    if ok1 and weaponLabs then
        for _, lab in ipairs(weaponLabs) do
            table.insert(all, lab)
        end
    end

    local ok2, drugLabs = pcall(function() return exports['rp-druglab']:GetLabs() end)
    if ok2 and drugLabs then
        for _, lab in ipairs(drugLabs) do
            table.insert(all, lab)
        end
    end

    return all
end

CreateThread(function()
    Wait(2000) -- laisser rp-weaponlab/rp-druglab finir de démarrer
    for _, lab in ipairs(collectLabs()) do
        MySQL.scalar('SELECT owner_gang FROM lab_control WHERE lab_id = ?', { lab.id }, function(owner)
            MySQL.insert('INSERT IGNORE INTO lab_control (lab_id, owner_gang) VALUES (?, NULL)', { lab.id })
            labs[lab.id] = { coords = lab.coords, label = lab.label, owner = owner, points = {} }
        end)
    end
end)

local function tick()
    local players = QBCore.Functions.GetPlayers()

    for labId, lab in pairs(labs) do
        local presentGangs = {}

        for _, playerId in ipairs(players) do
            local ped = GetPlayerPed(playerId)
            if ped and ped ~= 0 then
                local dist = #(GetEntityCoords(ped) - lab.coords)
                if dist <= Config.OccupationRadius then
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

        if #contenders == 1 and contenders[1] ~= lab.owner then
            local challenger = contenders[1]
            lab.points[challenger] = (lab.points[challenger] or 0) + Config.PointsPerTick

            if lab.points[challenger] >= Config.PointsToCapture then
                local previousOwner = lab.owner
                lab.owner = challenger
                lab.points = {}

                MySQL.update('UPDATE lab_control SET owner_gang = ? WHERE lab_id = ?', { challenger, labId })

                local Gangs = exports['rp-gangs']:GetAllGangs()
                local challengerLabel = Gangs[challenger] and Gangs[challenger].label or challenger
                local previousLabel = previousOwner and (Gangs[previousOwner] and Gangs[previousOwner].label or previousOwner) or nil

                TriggerClientEvent('chat:addMessage', -1, {
                    args = { '^1[LABO]', previousLabel
                        and ('%s prend le contrôle de "%s" (anciennement %s) !'):format(challengerLabel, lab.label, previousLabel)
                        or ('%s prend le contrôle de "%s" !'):format(challengerLabel, lab.label) }
                })

                exports['rp-gangs']:AddReputation(challenger, Config.CaptureRepGain)
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

exports('GetLabOwner', function(labId)
    local lab = labs[labId]
    return lab and lab.owner
end)

exports('GetAllLabs', function()
    return labs
end)
