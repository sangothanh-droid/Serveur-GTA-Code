local QBCore = exports['qb-core']:GetCoreObject()
local reputations = {} -- [citizenid] = points

local function loadReputation(citizenid, cb)
    MySQL.scalar('SELECT reputation FROM street_reputation WHERE citizenid = ?', { citizenid }, function(result)
        cb(result or 0)
    end)
end

local function saveReputation(citizenid, points)
    MySQL.insert(
        'INSERT INTO street_reputation (citizenid, reputation) VALUES (?, ?) ON DUPLICATE KEY UPDATE reputation = ?',
        { citizenid, points, points }
    )
end

local function ensureLoaded(citizenid, cb)
    if reputations[citizenid] ~= nil then
        cb(reputations[citizenid])
        return
    end
    loadReputation(citizenid, function(points)
        reputations[citizenid] = points
        cb(points)
    end)
end

--- Renvoie (de façon asynchrone) la réputation de rue du joueur.
-- @param src number
-- @param cb fun(points: number)
local function GetStreetRep(src, cb)
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then
        cb(0)
        return
    end
    ensureLoaded(Player.PlayerData.citizenid, cb)
end

--- Ajoute (ou retire, si amount est négatif) de la réputation de rue.
-- @param src number
-- @param amount number
local function AddStreetRep(src, amount)
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then
        return
    end
    local citizenid = Player.PlayerData.citizenid

    ensureLoaded(citizenid, function(current)
        local updated = math.max(Config.MinReputation, current + amount)
        reputations[citizenid] = updated
        saveReputation(citizenid, updated)

        if updated >= Config.RiskReductionThreshold and current < Config.RiskReductionThreshold then
            TriggerClientEvent('QBCore:Notify', src,
                'Réputation de rue : seuil atteint, vos activités solo sont un peu moins risquées.', 'success')
        end
    end)
end

exports('GetStreetRep', GetStreetRep)
exports('AddStreetRep', AddStreetRep)

--- true si le joueur a dépassé le seuil de réduction de risque.
exports('HasRiskReduction', function(src, cb)
    GetStreetRep(src, function(points)
        cb(points >= Config.RiskReductionThreshold)
    end)
end)

RegisterNetEvent('rp-streetrep:server:checkRep', function()
    local src = source
    GetStreetRep(src, function(points)
        TriggerClientEvent('chat:addMessage', src, { args = { '^3[RÉPUTATION]', ('Réputation de rue : %d'):format(points) } })
    end)
end)
