local atmCooldowns = {}
local pendingRobberies = {}

RegisterNetEvent('rp-atmrobbery:server:attempt', function(atmIndex)
    local src = source
    local atm = Config.ATMs[atmIndex]
    if not atm then
        return
    end

    local now = os.time()
    if atmCooldowns[atmIndex] and (now - atmCooldowns[atmIndex]) < (Config.CooldownMs / 1000) then
        TriggerClientEvent('QBCore:Notify', src, "Ce distributeur vient d'être vidé.", 'error')
        return
    end

    local gang = exports['rp-crime-core']:GetPlayerGang(src)
    if not gang then
        TriggerClientEvent('QBCore:Notify', src, 'Vous devez appartenir à un gang pour faire ça.', 'error')
        return
    end

    atmCooldowns[atmIndex] = now
    pendingRobberies[src] = atmIndex

    -- Contrairement aux autres braquages, l'alerte est immédiate et
    -- systématique (pas de chance de discrétion) : c'est le compromis du
    -- gain rapide.
    exports['rp-crime-core']:AlertPolice(atm, 'Braquage de distributeur automatique en cours.')
    TriggerClientEvent('rp-atmrobbery:client:startProgress', src, Config.RobTimeMs)
end)

RegisterNetEvent('rp-atmrobbery:server:finish', function(success)
    local src = source
    local atmIndex = pendingRobberies[src]
    pendingRobberies[src] = nil
    if not atmIndex or not success then
        return
    end

    local reward = math.random(Config.RewardMin, Config.RewardMax)
    exports['rp-crime-core']:AddMoney(src, reward, 'cash')

    local gang = exports['rp-crime-core']:GetPlayerGang(src)
    if gang then
        exports['rp-gangs']:AddReputation(gang, Config.RepGain, src)
    end

    TriggerClientEvent('QBCore:Notify', src, ('Distributeur vidé : +$%d'):format(reward), 'success')
end)

AddEventHandler('playerDropped', function()
    pendingRobberies[source] = nil
end)
