local fire = nil -- { coords, label, hasNpc, claimed }

local function isOnDutyFirefighter(src)
    local jobName, onDuty = exports['rp-job-core']:GetPlayerJob(src)
    return jobName == Config.JobName and onDuty
end

local function spawnFire()
    local location = Config.FireLocations[math.random(#Config.FireLocations)]
    fire = {
        coords = location.coords,
        label = location.label,
        hasNpc = math.random(100) <= Config.NpcRescueChancePercent,
        claimed = false,
    }
    TriggerClientEvent('rp-firefighter:client:setFire', -1, fire.coords, fire.label)
end

CreateThread(function()
    Wait(Config.InitialDelayMs)
    if not fire then
        spawnFire()
    end
end)

CreateThread(function()
    while true do
        Wait(Config.SpawnIntervalMs)
        if not fire then
            spawnFire()
        end
    end
end)

RegisterNetEvent('rp-firefighter:server:attempt', function()
    local src = source
    if not fire or fire.claimed then
        TriggerClientEvent('QBCore:Notify', src, 'Aucun incendie actif.', 'error')
        return
    end
    if not isOnDutyFirefighter(src) then
        TriggerClientEvent('QBCore:Notify', src, 'Vous devez être pompier en service pour ça.', 'error')
        return
    end

    local dist = #(GetEntityCoords(GetPlayerPed(src)) - fire.coords)
    if dist > Config.InteractDistance then
        TriggerClientEvent('QBCore:Notify', src, "Rapprochez-vous de l'incendie.", 'error')
        return
    end

    fire.claimed = true
    TriggerClientEvent('rp-firefighter:client:startExtinguish', src, Config.ExtinguishTimeMs)
end)

RegisterNetEvent('rp-firefighter:server:finish', function(success)
    local src = source
    if not fire then
        return
    end

    if not success then
        fire.claimed = false
        return
    end

    local reward = math.random(Config.RewardMin, Config.RewardMax)
    local rescued = fire.hasNpc
    if rescued then
        reward = reward + Config.RescueBonus
    end

    exports['rp-job-core']:AddMoney(src, reward, 'cash')
    TriggerClientEvent('QBCore:Notify', src,
        rescued and ('Incendie éteint, victime secourue : +$%d'):format(reward)
                 or ('Incendie éteint : +$%d'):format(reward),
        'success')
    TriggerClientEvent('chat:addMessage', -1,
        { args = { '^1[INCENDIE]', ('%s a maîtrisé l\'incendie de "%s".'):format(GetPlayerName(src), fire.label) } })

    TriggerClientEvent('rp-firefighter:client:clearFire', -1)
    fire = nil
end)
