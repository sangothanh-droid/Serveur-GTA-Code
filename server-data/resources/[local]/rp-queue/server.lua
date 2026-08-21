-- File d'attente FIFO avec priorité pour un serveur en accès libre.
-- Aucune whitelist : tout le monde peut rejoindre la file, seul l'ordre change.

local Config = {
    -- Identifiants (ex: 'license:xxxxxxxx') passant devant la file, ex. staff/VIP.
    PriorityIdentifiers = {
        -- 'license:REPLACE_WITH_ADMIN_LICENSE',
    },
    CheckIntervalMs = 1500,
}

local queue = {}
local nextQueueId = 0

local function getFreeSlots()
    local max = GetConvarInt('sv_maxclients', 48)
    return max - GetNumPlayerIndices()
end

local function isPriority(identifiers)
    for _, ident in ipairs(identifiers) do
        for _, priorityIdent in ipairs(Config.PriorityIdentifiers) do
            if ident == priorityIdent then
                return true
            end
        end
    end
    return false
end

local function queuePosition(id)
    for i, entry in ipairs(queue) do
        if entry.id == id then
            return i
        end
    end
    return nil
end

local function removeFromQueue(id)
    for i, entry in ipairs(queue) do
        if entry.id == id then
            table.remove(queue, i)
            return
        end
    end
end

AddEventHandler('playerConnecting', function(name, _setKickReason, deferrals)
    local src = source
    deferrals.defer()
    Citizen.Wait(0)

    local identifiers = GetPlayerIdentifiers(src)
    nextQueueId = nextQueueId + 1
    local myId = nextQueueId

    table.insert(queue, { id = myId, priority = isPriority(identifiers) })
    table.sort(queue, function(a, b)
        if a.priority ~= b.priority then
            return a.priority
        end
        return a.id < b.id
    end)

    deferrals.update(('Connexion en cours, %s...'):format(name))

    while true do
        local pos = queuePosition(myId)
        if not pos then
            deferrals.done("Erreur pendant la mise en file d'attente, reconnectez-vous.")
            return
        end

        if pos <= 1 and getFreeSlots() > 0 then
            break
        end

        deferrals.update(('File d\'attente : position %d/%d.'):format(pos, #queue))
        Citizen.Wait(Config.CheckIntervalMs)
    end

    removeFromQueue(myId)
    deferrals.done()
end)
