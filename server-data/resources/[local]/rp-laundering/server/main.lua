local QBCore = exports['qb-core']:GetCoreObject()

RegisterCommand('launder', function(source, args)
    local src = source
    local amount = tonumber(args[1])

    if not amount or amount < Config.MinAmount or amount > Config.MaxAmount then
        TriggerClientEvent('QBCore:Notify', src,
            ('Montant invalide (entre %d et %d).'):format(Config.MinAmount, Config.MaxAmount), 'error')
        return
    end

    local ped = GetPlayerPed(src)
    local dist = #(GetEntityCoords(ped) - Config.Front.coords)
    if dist > Config.InteractDistance then
        TriggerClientEvent('QBCore:Notify', src, ('Vous devez être à : %s.'):format(Config.Front.label), 'error')
        return
    end

    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then
        return
    end

    local item = Player.Functions.GetItemByName(Config.ItemName)
    if not item or item.amount < amount then
        TriggerClientEvent('QBCore:Notify', src, "Vous n'avez pas assez d'argent sale.", 'error')
        return
    end

    Player.Functions.RemoveItem(Config.ItemName, amount)
    local clean = math.floor(amount * (1 - Config.CutPercent / 100))
    Player.Functions.AddMoney('bank', clean)

    local gang = exports['rp-crime-core']:GetPlayerGang(src)
    if gang then
        exports['rp-gangs']:AddReputation(gang, math.floor(amount / 1000) * Config.RepGainPer1000, src)
    end

    TriggerClientEvent('QBCore:Notify', src,
        ('Blanchi : $%d sale -> $%d propre (commission %d%%)'):format(amount, clean, Config.CutPercent), 'success')

    if math.random(100) <= Config.AuditChancePercent then
        exports['rp-crime-core']:AlertPolice(Config.Front.coords, 'Activité financière suspecte signalée.')
    end
end, false)
