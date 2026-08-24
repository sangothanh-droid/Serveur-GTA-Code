local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('rp-casino:server:play', function(rawAmount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then
        return
    end

    local amount = math.floor(tonumber(rawAmount) or 0)
    if amount < Config.MinBet or amount > Config.MaxBet then
        TriggerClientEvent('QBCore:Notify', src,
            ('Mise invalide (entre $%d et $%d).'):format(Config.MinBet, Config.MaxBet), 'error')
        return
    end

    local dist = #(GetEntityCoords(GetPlayerPed(src)) - Config.TableLocation)
    if dist > Config.InteractDistance then
        TriggerClientEvent('QBCore:Notify', src, 'Approchez-vous de la table de jeu.', 'error')
        return
    end

    if Player.PlayerData.money.cash < amount then
        TriggerClientEvent('QBCore:Notify', src, "Vous n'avez pas assez d'argent liquide.", 'error')
        return
    end

    Player.Functions.RemoveMoney('cash', amount, 'casino-bet')

    if math.random(100) <= Config.WinChancePercent then
        local payout = math.floor(amount * Config.PayoutMultiplier)
        Player.Functions.AddMoney('cash', payout, 'casino-win')
        TriggerClientEvent('QBCore:Notify', src, ('Vous gagnez $%d !'):format(payout), 'success')
    else
        TriggerClientEvent('QBCore:Notify', src, ('Vous perdez votre mise de $%d.'):format(amount), 'error')
    end
end)
