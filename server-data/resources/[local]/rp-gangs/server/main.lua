local reputations = {}   -- [gangName] = points
local lastActivity = {}  -- [gangName] = os.time()

local function getTierIndex(points)
    local tierIndex = 1
    for i, tier in ipairs(Config.Tiers) do
        if points >= tier.threshold then
            tierIndex = i
        end
    end
    return tierIndex
end

local function loadReputation(gangName, cb)
    MySQL.scalar('SELECT reputation FROM gang_reputation WHERE gang_name = ?', { gangName }, function(result)
        cb(result or 0)
    end)
end

local function saveReputation(gangName, points)
    MySQL.insert(
        'INSERT INTO gang_reputation (gang_name, reputation) VALUES (?, ?) ON DUPLICATE KEY UPDATE reputation = ?',
        { gangName, points, points }
    )
end

local function ensureLoaded(gangName, cb)
    if reputations[gangName] ~= nil then
        cb(reputations[gangName])
        return
    end
    loadReputation(gangName, function(points)
        reputations[gangName] = points
        cb(points)
    end)
end

-- Conséquence concrète et immédiate : quand le gang passe un palier, le
-- joueur à l'origine de l'action voit son niveau recherché augmenter, et un
-- message d'alerte est diffusé (ex: à écouter côté qb-policejob pour du
-- dispatch renforcé).
local function applyConsequences(gangName, oldTierIndex, newTierIndex, src)
    if newTierIndex <= oldTierIndex then
        return
    end

    local tier = Config.Tiers[newTierIndex]
    TriggerClientEvent('chat:addMessage', -1, {
        args = { '^1[GANGS]', ('Le gang %s est maintenant classé "%s" (surveillance policière renforcée).'):format(gangName, tier.label) }
    })

    TriggerEvent('rp-gangs:server:tierChanged', gangName, newTierIndex, tier)

    if src then
        local stars = math.min(5, newTierIndex)
        TriggerClientEvent('rp-gangs:client:setWanted', src, stars)
    end
end

--- Ajoute (ou retire, si amount est négatif) de la réputation à un gang.
-- @param gangName string
-- @param amount number
-- @param src number|nil source du joueur à l'origine de l'action (pour les conséquences directes)
function AddReputation(gangName, amount, src)
    ensureLoaded(gangName, function(current)
        local oldTierIndex = getTierIndex(current)
        local updated = math.max(Config.MinReputation, current + amount)
        reputations[gangName] = updated
        lastActivity[gangName] = os.time()
        saveReputation(gangName, updated)

        local newTierIndex = getTierIndex(updated)
        applyConsequences(gangName, oldTierIndex, newTierIndex, src)
    end)
end

RegisterNetEvent('rp-gangs:server:addReputation', function(gangName, amount)
    local src = source
    AddReputation(gangName, amount, src)
end)

exports('AddReputation', AddReputation)

exports('GetGangReputation', function(gangName, cb)
    ensureLoaded(gangName, cb)
end)

exports('GetGangMultiplier', function(gangName, cb)
    ensureLoaded(gangName, function(points)
        local tier = Config.Tiers[getTierIndex(points)]
        cb(tier.incomeMultiplier, tier.policeMultiplier, tier.label)
    end)
end)

-- Décroissance horaire de la réputation des gangs inactifs.
CreateThread(function()
    while true do
        Wait(60 * 60 * 1000)
        local now = os.time()
        for gangName, points in pairs(reputations) do
            local last = lastActivity[gangName] or 0
            if now - last >= 3600 and points > Config.MinReputation then
                local updated = math.max(Config.MinReputation, points - Config.ReputationDecayPerHour)
                reputations[gangName] = updated
                saveReputation(gangName, updated)
            end
        end
    end
end)
