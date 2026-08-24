local QBCore = exports['qb-core']:GetCoreObject()

local session = nil -- { phase = 'joining'|'active', participants = {[src]=true}, scores = {[src]=n}, lastTag = {[src]={[targetSrc]=os.time()}} }
local endSession -- déclaré avant utilisation (référencé dans un SetTimeout créé plus haut)

local function playersInArena()
    local result = {}
    for _, playerId in ipairs(QBCore.Functions.GetPlayers()) do
        local ped = GetPlayerPed(playerId)
        if ped and ped ~= 0 and #(GetEntityCoords(ped) - Config.Arena.coords) <= Config.Arena.radius then
            table.insert(result, playerId)
        end
    end
    return result
end

endSession = function()
    if not session then
        return
    end

    local ranking = {}
    for src, score in pairs(session.scores) do
        table.insert(ranking, { src = src, score = score })
    end
    table.sort(ranking, function(a, b) return a.score > b.score end)

    local lines = { 'Session terminée ! Classement :' }
    local topScore = ranking[1] and ranking[1].score or 0
    for i, entry in ipairs(ranking) do
        lines[#lines + 1] = ('%d. %s - %d tag(s)'):format(i, GetPlayerName(entry.src) or '?', entry.score)
    end

    if topScore > 0 then
        for _, entry in ipairs(ranking) do
            if entry.score == topScore then
                local Player = QBCore.Functions.GetPlayer(entry.src)
                if Player then
                    Player.Functions.AddMoney('cash', Config.RewardTop, 'lasergame-win')
                end
            end
        end
        lines[#lines + 1] = ('Récompense de $%d pour le(s) meilleur(s) score(s).'):format(Config.RewardTop)
    end

    for src in pairs(session.participants) do
        TriggerClientEvent('rp-lasergame:client:sessionEnded', src, lines)
    end

    session = nil
end

RegisterNetEvent('rp-lasergame:server:start', function()
    local src = source
    if session then
        TriggerClientEvent('QBCore:Notify', src, 'Une session est déjà en cours.', 'error')
        return
    end

    local dist = #(GetEntityCoords(GetPlayerPed(src)) - Config.Arena.coords)
    if dist > Config.Arena.radius then
        TriggerClientEvent('QBCore:Notify', src, "Vous devez être dans l'arène pour lancer une partie.", 'error')
        return
    end

    session = { phase = 'joining', participants = { [src] = true }, scores = { [src] = 0 }, lastTag = {} }

    local message = ('%s lance une partie de laser game ! /%s join dans les %ds.'):format(
        GetPlayerName(src), Config.CommandName, math.floor(Config.JoinWindowMs / 1000))

    for _, playerId in ipairs(playersInArena()) do
        TriggerClientEvent('rp-lasergame:client:announce', playerId, message)
    end

    SetTimeout(Config.JoinWindowMs, function()
        if not session or session.phase ~= 'joining' then
            return
        end

        local count = 0
        for _ in pairs(session.participants) do
            count = count + 1
        end

        if count < Config.MinParticipants then
            TriggerClientEvent('chat:addMessage', -1, { args = { '^5[LASERGAME]', 'Pas assez de joueurs, partie annulée.' } })
            session = nil
            return
        end

        session.phase = 'active'
        for playerId in pairs(session.participants) do
            TriggerClientEvent('rp-lasergame:client:sessionStarted', playerId)
        end

        SetTimeout(Config.SessionDurationMs, endSession)
    end)
end)

RegisterNetEvent('rp-lasergame:server:join', function()
    local src = source
    if not session or session.phase ~= 'joining' then
        TriggerClientEvent('QBCore:Notify', src, 'Aucune inscription en cours.', 'error')
        return
    end
    if session.participants[src] then
        return
    end

    local dist = #(GetEntityCoords(GetPlayerPed(src)) - Config.Arena.coords)
    if dist > Config.Arena.radius then
        TriggerClientEvent('QBCore:Notify', src, "Vous devez être dans l'arène pour rejoindre.", 'error')
        return
    end

    session.participants[src] = true
    session.scores[src] = 0
    TriggerClientEvent('QBCore:Notify', src, 'Inscription au laser game confirmée.', 'success')
end)

RegisterNetEvent('rp-lasergame:server:tag', function(targetId)
    local src = source
    if not session or session.phase ~= 'active' or not session.participants[src] or not session.participants[targetId] then
        return
    end

    session.lastTag[src] = session.lastTag[src] or {}
    local now = os.time()
    if session.lastTag[src][targetId] and (now - session.lastTag[src][targetId]) < (Config.TagCooldownMs / 1000) then
        return
    end
    session.lastTag[src][targetId] = now

    session.scores[src] = (session.scores[src] or 0) + 1
    TriggerClientEvent('QBCore:Notify', src, 'Tag !', 'success')
    TriggerClientEvent('QBCore:Notify', targetId, ('Vous avez été taggé par %s.'):format(GetPlayerName(src)), 'error')
end)

AddEventHandler('playerDropped', function()
    local src = source
    if session then
        session.participants[src] = nil
        session.scores[src] = nil
        session.lastTag[src] = nil
    end
end)
