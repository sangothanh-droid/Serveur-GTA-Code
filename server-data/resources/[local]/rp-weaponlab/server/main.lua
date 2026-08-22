local QBCore = exports['qb-core']:GetCoreObject()

local function getLabOwner(labId)
    local ok, owner = pcall(function()
        return exports['rp-labwars']:GetLabOwner(labId)
    end)
    if ok then
        return owner
    end
    return nil
end

RegisterNetEvent('rp-weaponlab:server:craft', function(labIndex)
    local src = source
    local lab = Config.Labs[labIndex]
    if not lab then
        return
    end

    local gang = exports['rp-crime-core']:GetPlayerGang(src)
    if not gang then
        TriggerClientEvent('QBCore:Notify', src, 'Vous devez appartenir à un gang pour faire ça.', 'error')
        return
    end

    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then
        return
    end

    local isOwner = getLabOwner(lab.id) == gang
    local cost = isOwner and math.floor(lab.cost * (1 - Config.OwnerDiscountPercent / 100)) or lab.cost

    if Player.PlayerData.money['cash'] < cost then
        TriggerClientEvent('QBCore:Notify', src, ('Il vous faut $%d de matériaux.'):format(cost), 'error')
        return
    end

    Player.Functions.RemoveMoney('cash', cost)
    TriggerClientEvent('rp-weaponlab:client:startCraft', src, lab.craftTimeMs, labIndex, isOwner)
end)

RegisterNetEvent('rp-weaponlab:server:finishCraft', function(labIndex, isOwner, success)
    local src = source
    local lab = Config.Labs[labIndex]
    if not success or not lab then
        return
    end

    if not isOwner and math.random(100) <= Config.NonOwnerFailChancePercent then
        TriggerClientEvent('QBCore:Notify', src, "Fabrication ratée : vous n'êtes pas en terrain contrôlé.", 'error')
        return
    end

    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then
        return
    end

    Player.Functions.AddItem(lab.item, 1)
    Player.Functions.AddItem(lab.ammo, lab.ammoAmount)

    local gang = exports['rp-crime-core']:GetPlayerGang(src)
    if gang then
        exports['rp-gangs']:AddReputation(gang, lab.repGain, src)
    end

    TriggerClientEvent('QBCore:Notify', src, ('Fabrication réussie : %s obtenue.'):format(lab.item), 'success')

    if math.random(100) <= Config.PoliceCallChancePercent then
        exports['rp-crime-core']:AlertPolice(lab.coords, "Détonations suspectes signalées près d'un atelier.")
    end
end)

exports('GetLabs', function()
    return Config.Labs
end)
