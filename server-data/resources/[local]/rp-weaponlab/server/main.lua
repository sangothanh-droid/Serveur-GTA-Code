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

local function pickLoot()
    local totalWeight = 0
    for _, entry in ipairs(Config.LootTable) do
        totalWeight = totalWeight + entry.weight
    end

    local roll = math.random(totalWeight)
    local cumulative = 0
    for _, entry in ipairs(Config.LootTable) do
        cumulative = cumulative + entry.weight
        if roll <= cumulative then
            return entry
        end
    end
    return Config.LootTable[1]
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
    local cost = isOwner and math.floor(Config.MaterialCost * (1 - Config.OwnerDiscountPercent / 100)) or Config.MaterialCost

    if Player.PlayerData.money['cash'] < cost then
        TriggerClientEvent('QBCore:Notify', src, ('Il vous faut $%d de matériaux.'):format(cost), 'error')
        return
    end

    Player.Functions.RemoveMoney('cash', cost)
    TriggerClientEvent('rp-weaponlab:client:startCraft', src, Config.CraftTimeMs, labIndex, isOwner)
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

    local loot = pickLoot()
    Player.Functions.AddItem(loot.item, 1)
    Player.Functions.AddItem(loot.ammo, loot.ammoAmount)

    local gang = exports['rp-crime-core']:GetPlayerGang(src)
    if gang then
        exports['rp-gangs']:AddReputation(gang, Config.RepGain, src)
    end

    TriggerClientEvent('QBCore:Notify', src, ('Fabrication réussie : %s obtenue.'):format(loot.item), 'success')

    if math.random(100) <= Config.PoliceCallChancePercent then
        exports['rp-crime-core']:AlertPolice(lab.coords, "Détonations suspectes signalées près d'un atelier.")
    end
end)

exports('GetLabs', function()
    return Config.Labs
end)
