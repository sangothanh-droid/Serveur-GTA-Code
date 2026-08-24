local raceState = { active = false, started = false, participants = {}, route = nil }

local function resetRace()
    raceState = { active = false, started = false, participants = {}, route = nil }
end

local function startRace()
    if not raceState.active or #raceState.participants == 0 then
        resetRace()
        return
    end

    raceState.started = true
    for _, src in ipairs(raceState.participants) do
        TriggerClientEvent('rp-illegalrace:client:startRace', src, raceState.route.checkpoints)
    end
end

RegisterCommand('race', function(source, args)
    local src = source
    local action = args[1]

    if action == 'start' then
        if raceState.active then
            TriggerClientEvent('QBCore:Notify', src, 'Une course est déjà en cours ou en préparation.', 'error')
            return
        end

        local route = Config.Routes[tonumber(args[2]) or 1]
        if not route then
            TriggerClientEvent('QBCore:Notify', src, 'Circuit inconnu.', 'error')
            return
        end

        raceState = { active = true, started = false, participants = { src }, route = route }
        TriggerClientEvent('chat:addMessage', -1, {
            args = { '^3[COURSE]', ('%s a lancé une course sur "%s" ! Tapez /race join pour participer (%ds).'):format(
                GetPlayerName(src), route.label, Config.JoinWindowSeconds) }
        })

        SetTimeout(Config.JoinWindowSeconds * 1000, startRace)

    elseif action == 'join' then
        if not raceState.active or raceState.started then
            TriggerClientEvent('QBCore:Notify', src, 'Aucune course ouverte pour le moment.', 'error')
            return
        end

        for _, p in ipairs(raceState.participants) do
            if p == src then
                return
            end
        end

        table.insert(raceState.participants, src)
        TriggerClientEvent('QBCore:Notify', src, 'Vous avez rejoint la course !', 'success')
    end
end, false)

RegisterNetEvent('rp-illegalrace:server:checkpoint', function(nextIndex)
    local src = source
    if not raceState.active or not raceState.started then
        return
    end

    if nextIndex > #raceState.route.checkpoints then
        local reward = math.random(Config.RewardMin, Config.RewardMax)
        exports['rp-crime-core']:AddMoney(src, reward, 'cash')

        local gang = exports['rp-crime-core']:GetPlayerGang(src)
        if gang then
            exports['rp-gangs']:AddReputation(gang, Config.RepGain, src)
        end

        TriggerClientEvent('QBCore:Notify', src, ('Vous remportez la course : +$%d'):format(reward), 'success')
        TriggerClientEvent('chat:addMessage', -1, {
            args = { '^3[COURSE]', ('%s remporte la course ! (+$%d)'):format(GetPlayerName(src), reward) }
        })

        for _, p in ipairs(raceState.participants) do
            TriggerClientEvent('rp-illegalrace:client:endRace', p)
        end
        resetRace()
    end
end)

AddEventHandler('playerDropped', function()
    local src = source
    for i, p in ipairs(raceState.participants) do
        if p == src then
            table.remove(raceState.participants, i)
            break
        end
    end
end)
