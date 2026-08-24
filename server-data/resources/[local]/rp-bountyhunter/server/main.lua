local target = nil -- { coords, label, claimed }

local function announceTarget()
    local zone = Config.CombatZones[math.random(#Config.CombatZones)]
    target = { coords = zone.coords, label = zone.label, claimed = false }

    TriggerClientEvent('chat:addMessage', -1, {
        args = { '^1[PRIME]', ('Une cible a été repérée près de "%s". Premier arrivé, premier servi.'):format(zone.label) }
    })
    TriggerClientEvent('rp-bountyhunter:client:setTarget', -1, target.coords, target.label)
end

-- Première cible après un court délai au démarrage du serveur, puis
-- réapparition périodique tant qu'aucune cible n'est active.
CreateThread(function()
    Wait(Config.InitialDelayMs)
    if not target then
        announceTarget()
    end
end)

CreateThread(function()
    while true do
        Wait(Config.SpawnIntervalMs)
        if not target then
            announceTarget()
        end
    end
end)

RegisterNetEvent('rp-bountyhunter:server:attemptClaim', function()
    local src = source
    if not target or target.claimed then
        TriggerClientEvent('QBCore:Notify', src, 'Aucune cible active.', 'error')
        return
    end

    local gang = exports['rp-crime-core']:GetPlayerGang(src)
    if not gang then
        TriggerClientEvent('QBCore:Notify', src, 'Vous devez appartenir à un gang pour faire ça.', 'error')
        return
    end

    local dist = #(GetEntityCoords(GetPlayerPed(src)) - target.coords)
    if dist > Config.InteractDistance then
        TriggerClientEvent('QBCore:Notify', src, 'Rapprochez-vous de la cible.', 'error')
        return
    end

    target.claimed = true
    TriggerClientEvent('rp-bountyhunter:client:startHunt', src, Config.HuntTimeMs)
end)

RegisterNetEvent('rp-bountyhunter:server:finishHunt', function(success)
    local src = source
    if not target then
        return
    end

    if not success then
        target.claimed = false
        return
    end

    local gang = exports['rp-crime-core']:GetPlayerGang(src)
    local reward = math.random(Config.RewardMin, Config.RewardMax)
    exports['rp-crime-core']:AddMoney(src, reward, 'cash')
    if gang then
        exports['rp-gangs']:AddReputation(gang, Config.RepGain, src)
    end

    TriggerClientEvent('QBCore:Notify', src, ('Cible éliminée : +$%d'):format(reward), 'success')
    TriggerClientEvent('chat:addMessage', -1, {
        args = { '^1[PRIME]', ('%s a éliminé la cible près de "%s" !'):format(GetPlayerName(src), target.label) }
    })

    target = nil
    TriggerClientEvent('rp-bountyhunter:client:clearTarget', -1)
end)
