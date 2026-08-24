local trees = {}
for i = 1, #Config.Trees do
    trees[i] = { ready = true }
end

local rawWood = {} -- [src] = quantité de bois en attente de vente

RegisterNetEvent('rp-lumberjack:server:chop', function(treeIndex)
    local src = source
    local tree = trees[treeIndex]
    if not tree or not tree.ready then
        TriggerClientEvent('QBCore:Notify', src, "Cet arbre n'a pas repoussé.", 'error')
        return
    end

    tree.ready = false
    SetTimeout(Config.RegrowTimeMs, function()
        tree.ready = true
    end)

    rawWood[src] = (rawWood[src] or 0) + Config.YieldPerChop
    TriggerClientEvent('QBCore:Notify', src, 'Bois coupé.', 'success')
end)

RegisterNetEvent('rp-lumberjack:server:sell', function()
    local src = source
    local wood = rawWood[src] or 0
    if wood <= 0 then
        TriggerClientEvent('QBCore:Notify', src, 'Vous n\'avez pas de bois à vendre.', 'error')
        return
    end

    rawWood[src] = 0
    local reward = wood * Config.PricePerUnit
    exports['rp-job-core']:AddMoney(src, reward, 'cash')
    TriggerClientEvent('QBCore:Notify', src, ('%d unité(s) de bois vendue(s) : +$%d'):format(wood, reward), 'success')
end)

AddEventHandler('playerDropped', function()
    rawWood[source] = nil
end)
