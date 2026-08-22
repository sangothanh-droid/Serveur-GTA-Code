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

RegisterNetEvent('rp-druglab:server:cook', function(labIndex)
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
    local cost = isOwner and math.floor(Config.IngredientCost * (1 - Config.OwnerDiscountPercent / 100)) or Config.IngredientCost

    if Player.PlayerData.money['cash'] < cost then
        TriggerClientEvent('QBCore:Notify', src, ('Il vous faut $%d de précurseurs chimiques.'):format(cost), 'error')
        return
    end

    Player.Functions.RemoveMoney('cash', cost)
    TriggerClientEvent('rp-druglab:client:startCook', src, Config.CookTimeMs, labIndex, isOwner)
end)

RegisterNetEvent('rp-druglab:server:finishCook', function(labIndex, isOwner, success)
    local src = source
    local lab = Config.Labs[labIndex]
    if not success or not lab then
        return
    end

    if not isOwner and math.random(100) <= Config.NonOwnerFailChancePercent then
        TriggerClientEvent('QBCore:Notify', src, "La cuisson a mal tourné, vous n'êtes pas en terrain contrôlé.", 'error')
        exports['rp-crime-core']:AlertPolice(lab.coords, 'Explosion signalée dans un laboratoire clandestin.')
        return
    end

    local yield = math.random(Config.YieldMin, Config.YieldMax)
    local reward = yield * Config.PricePerUnit
    exports['rp-crime-core']:AddMoney(src, reward, 'cash')

    local gang = exports['rp-crime-core']:GetPlayerGang(src)
    if gang then
        exports['rp-gangs']:AddReputation(gang, math.floor(yield / 5) * Config.RepGainPer5Units, src)
    end

    TriggerClientEvent('QBCore:Notify', src, ('%d unité(s) produite(s) et vendue(s) : +$%d'):format(yield, reward), 'success')

    if math.random(100) <= Config.PoliceCallChancePercent then
        exports['rp-crime-core']:AlertPolice(lab.coords, "Odeur suspecte signalée près d'un laboratoire.")
    end
end)

exports('GetLabs', function()
    return Config.Labs
end)
