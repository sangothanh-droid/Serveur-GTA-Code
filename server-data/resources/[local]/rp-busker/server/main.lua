local lastPerform = {}

RegisterNetEvent('rp-busker:server:perform', function()
    local src = source
    local now = os.time()

    if lastPerform[src] and (now - lastPerform[src]) < (Config.CooldownMs / 1000) then
        TriggerClientEvent('QBCore:Notify', src, 'Attendez un peu avant de rejouer.', 'error')
        return
    end
    lastPerform[src] = now

    TriggerClientEvent('rp-busker:client:playAnim', src, Config.PerformDurationMs)

    SetTimeout(Config.PerformDurationMs, function()
        local tip = math.random(Config.TipMin, Config.TipMax)
        if math.random(100) <= Config.GenerousTipChancePercent then
            tip = tip * 2
            TriggerClientEvent('QBCore:Notify', src, 'Un passant généreux double votre pourboire !', 'primary')
        end

        exports['rp-job-core']:AddMoney(src, tip, 'cash')
        TriggerClientEvent('QBCore:Notify', src, ('Pourboires récoltés : +$%d'):format(tip), 'success')
    end)
end)
