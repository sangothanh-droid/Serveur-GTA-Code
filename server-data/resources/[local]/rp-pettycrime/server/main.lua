local QBCore = exports['qb-core']:GetCoreObject()

local lastPickpocket = {}     -- [src] = os.time()
local carBreakInCooldowns = {} -- [index] = os.time()
local mailboxCooldowns = {}    -- [index] = os.time()
local graffitiCooldowns = {}   -- [index] = os.time()
local pendingCarBreakIn = {}   -- [src] = index
local pendingMailbox = {}      -- [src] = index
local pendingGraffiti = {}     -- [src] = index

local function isEligible(src)
    -- Réservé aux joueurs sans gang officiel : évite de cumuler la
    -- réputation de rue ET la réputation de gang.
    return exports['rp-crime-core']:GetPlayerGang(src) == nil
end

local function reward(src, minAmount, maxAmount, repGain)
    local amount = math.random(minAmount, maxAmount)
    local Player = QBCore.Functions.GetPlayer(src)
    if Player then
        Player.Functions.AddMoney('cash', amount, 'pettycrime')
    end
    exports['rp-streetrep']:AddStreetRep(src, repGain)
    return amount
end

RegisterNetEvent('rp-pettycrime:server:pickpocket', function()
    local src = source
    if not isEligible(src) then
        TriggerClientEvent('QBCore:Notify', src, 'Réservé aux joueurs sans gang officiel.', 'error')
        return
    end

    local cfg = Config.Pickpocket
    local now = os.time()
    if lastPickpocket[src] and (now - lastPickpocket[src]) < (cfg.CooldownMs / 1000) then
        TriggerClientEvent('QBCore:Notify', src, 'Attendez un peu avant de retenter.', 'error')
        return
    end
    lastPickpocket[src] = now

    if math.random(100) <= cfg.SuccessChancePercent then
        local amount = reward(src, cfg.RewardMin, cfg.RewardMax, cfg.RepGain)
        TriggerClientEvent('QBCore:Notify', src, ('Vol à la tire réussi : +$%d'):format(amount), 'success')
    else
        TriggerClientEvent('QBCore:Notify', src, 'Le passant a remarqué votre geste, rien de volé.', 'error')
    end

    if math.random(100) <= cfg.PoliceCallChancePercent then
        exports['rp-crime-core']:AlertPolice(GetEntityCoords(GetPlayerPed(src)), 'Vol à la tire signalé par un témoin.')
    end
end)

RegisterNetEvent('rp-pettycrime:server:attemptCarBreakIn', function(index)
    local src = source
    local spot = Config.CarBreakIn.Locations[index]
    if not spot then
        return
    end
    if not isEligible(src) then
        TriggerClientEvent('QBCore:Notify', src, 'Réservé aux joueurs sans gang officiel.', 'error')
        return
    end

    local cfg = Config.CarBreakIn
    local now = os.time()
    if carBreakInCooldowns[index] and (now - carBreakInCooldowns[index]) < (cfg.CooldownMs / 1000) then
        TriggerClientEvent('QBCore:Notify', src, "Ce coin vient d'être fait, changez de quartier.", 'error')
        return
    end

    carBreakInCooldowns[index] = now
    pendingCarBreakIn[src] = index
    TriggerClientEvent('rp-pettycrime:client:startCarBreakIn', src)
end)

RegisterNetEvent('rp-pettycrime:server:finishCarBreakIn', function(success)
    local src = source
    local index = pendingCarBreakIn[src]
    pendingCarBreakIn[src] = nil
    if not index or not success then
        return
    end

    local cfg = Config.CarBreakIn
    local amount = reward(src, cfg.RewardMin, cfg.RewardMax, cfg.RepGain)
    TriggerClientEvent('QBCore:Notify', src, ('Butin récupéré : +$%d'):format(amount), 'success')

    if math.random(100) <= cfg.PoliceCallChancePercent then
        exports['rp-crime-core']:AlertPolice(Config.CarBreakIn.Locations[index], "Vol à l'arraché sur véhicule signalé.")
    end
end)

RegisterNetEvent('rp-pettycrime:server:attemptMailbox', function(index)
    local src = source
    local spot = Config.MailboxTheft.Locations[index]
    if not spot then
        return
    end
    if not isEligible(src) then
        TriggerClientEvent('QBCore:Notify', src, 'Réservé aux joueurs sans gang officiel.', 'error')
        return
    end

    local cfg = Config.MailboxTheft
    local now = os.time()
    if mailboxCooldowns[index] and (now - mailboxCooldowns[index]) < (cfg.CooldownMs / 1000) then
        TriggerClientEvent('QBCore:Notify', src, 'Cette boîte aux lettres est déjà vide.', 'error')
        return
    end

    mailboxCooldowns[index] = now
    pendingMailbox[src] = index
    TriggerClientEvent('rp-pettycrime:client:startMailbox', src)
end)

RegisterNetEvent('rp-pettycrime:server:finishMailbox', function(success)
    local src = source
    local index = pendingMailbox[src]
    pendingMailbox[src] = nil
    if not index or not success then
        return
    end

    local cfg = Config.MailboxTheft
    local amount = reward(src, cfg.RewardMin, cfg.RewardMax, cfg.RepGain)
    TriggerClientEvent('QBCore:Notify', src, ('Colis trouvé : +$%d'):format(amount), 'success')

    if math.random(100) <= cfg.PoliceCallChancePercent then
        exports['rp-crime-core']:AlertPolice(Config.MailboxTheft.Locations[index], 'Vol de courrier signalé par un voisin.')
    end
end)

RegisterNetEvent('rp-pettycrime:server:attemptGraffiti', function(index)
    local src = source
    local wall = Config.Graffiti.Walls[index]
    if not wall then
        return
    end
    if not isEligible(src) then
        TriggerClientEvent('QBCore:Notify', src, 'Réservé aux joueurs sans gang officiel.', 'error')
        return
    end

    local cfg = Config.Graffiti
    local now = os.time()
    if graffitiCooldowns[index] and (now - graffitiCooldowns[index]) < (cfg.CooldownMs / 1000) then
        TriggerClientEvent('QBCore:Notify', src, 'Ce mur a déjà été tagué récemment.', 'error')
        return
    end

    graffitiCooldowns[index] = now
    pendingGraffiti[src] = index
    TriggerClientEvent('rp-pettycrime:client:startGraffiti', src)
end)

RegisterNetEvent('rp-pettycrime:server:finishGraffiti', function(success)
    local src = source
    local index = pendingGraffiti[src]
    pendingGraffiti[src] = nil
    if not index or not success then
        return
    end

    local cfg = Config.Graffiti
    local amount = reward(src, cfg.RewardMin, cfg.RewardMax, cfg.RepGain)
    TriggerClientEvent('QBCore:Notify', src, ('Tag terminé : +$%d et réputation de rue en hausse'):format(amount), 'success')

    if math.random(100) <= cfg.PoliceCallChancePercent then
        exports['rp-crime-core']:AlertPolice(Config.Graffiti.Walls[index], 'Tag de graffiti signalé.')
    end
end)

AddEventHandler('playerDropped', function()
    local src = source
    lastPickpocket[src] = nil
    pendingCarBreakIn[src] = nil
    pendingMailbox[src] = nil
    pendingGraffiti[src] = nil
end)
