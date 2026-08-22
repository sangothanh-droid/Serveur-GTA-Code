local bins = {}
for i = 1, #Config.Bins do
    bins[i] = { ready = true }
end

RegisterNetEvent('rp-garbage:server:collect', function(binIndex)
    local src = source
    local bin = bins[binIndex]
    if not bin or not bin.ready then
        TriggerClientEvent('QBCore:Notify', src, 'Cette poubelle est déjà vide.', 'error')
        return
    end

    bin.ready = false
    SetTimeout(Config.RegrowTimeMs, function()
        bin.ready = true
    end)

    exports['rp-job-core']:AddMoney(src, Config.PayPerBin, 'cash')
    TriggerClientEvent('QBCore:Notify', src, ('+$%d'):format(Config.PayPerBin), 'success')
end)
