local QBCore = exports['qb-core']:GetCoreObject()
local bankCooldowns = {}
local activeHeists = {} -- [src] = bankIndex

local function countOnlinePolice()
    local count = 0
    for _, playerId in ipairs(QBCore.Functions.GetPlayers()) do
        local Player = QBCore.Functions.GetPlayer(playerId)
        if Player and Player.PlayerData.job.name == 'police' then
            count = count + 1
        end
    end
    return count
end

RegisterNetEvent('rp-heist:server:startHack', function(bankIndex)
    local src = source
    local bank = Config.Banks[bankIndex]
    if not bank then
        return
    end

    local now = os.time()
    if bankCooldowns[bankIndex] and (now - bankCooldowns[bankIndex]) < (Config.CooldownMs / 1000) then
        TriggerClientEvent('QBCore:Notify', src, 'Cette banque est encore sous surveillance renforcée.', 'error')
        return
    end

    if countOnlinePolice() < Config.MinPoliceOnline then
        TriggerClientEvent('QBCore:Notify', src, 'Pas assez de policiers en service pour lancer ce braquage.', 'error')
        return
    end

    local gang = exports['rp-crime-core']:GetPlayerGang(src)
    if not gang then
        TriggerClientEvent('QBCore:Notify', src, 'Vous devez appartenir à un gang pour faire ça.', 'error')
        return
    end

    bankCooldowns[bankIndex] = now
    activeHeists[src] = bankIndex

    exports['rp-crime-core']:AlertPolice(bank.coords, ('Alarme déclenchée : %s'):format(bank.label))
    TriggerClientEvent('rp-heist:client:startHack', src, Config.HackTimeMs)
end)

RegisterNetEvent('rp-heist:server:hackDone', function(success)
    local src = source
    local bankIndex = activeHeists[src]
    if not bankIndex or not success then
        activeHeists[src] = nil
        return
    end

    local bank = Config.Banks[bankIndex]
    exports['rp-crime-core']:AlertPolice(bank.coords, ('Effraction en cours : %s'):format(bank.label))
    TriggerClientEvent('rp-heist:client:startDrill', src, Config.DrillTimeMs)
end)

RegisterNetEvent('rp-heist:server:drillDone', function(success)
    local src = source
    local bankIndex = activeHeists[src]
    activeHeists[src] = nil
    if not bankIndex or not success then
        return
    end

    local reward = math.random(Config.RewardMin, Config.RewardMax)
    exports['rp-crime-core']:AddMoney(src, reward, 'cash')

    local gang = exports['rp-crime-core']:GetPlayerGang(src)
    if gang then
        exports['rp-gangs']:AddReputation(gang, Config.RepGain, src)
    end

    TriggerClientEvent('QBCore:Notify', src, ('Braquage réussi : +$%d'):format(reward), 'success')
end)

AddEventHandler('playerDropped', function()
    activeHeists[source] = nil
end)
