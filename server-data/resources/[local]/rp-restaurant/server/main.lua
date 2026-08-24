local preparedDishes = {} -- [src] = quantité

local function isOnDutyCook(src)
    local jobName, onDuty = exports['rp-job-core']:GetPlayerJob(src)
    return jobName == Config.JobName and onDuty
end

RegisterNetEvent('rp-restaurant:server:prepare', function()
    local src = source
    if not isOnDutyCook(src) then
        TriggerClientEvent('QBCore:Notify', src, "Vous devez être employé Burgershot en service pour ça.", 'error')
        return
    end

    preparedDishes[src] = (preparedDishes[src] or 0) + 1
    TriggerClientEvent('QBCore:Notify', src, 'Plat préparé.', 'success')
end)

RegisterNetEvent('rp-restaurant:server:sell', function()
    local src = source
    if not isOnDutyCook(src) then
        TriggerClientEvent('QBCore:Notify', src, "Vous devez être employé Burgershot en service pour ça.", 'error')
        return
    end

    local dishes = preparedDishes[src] or 0
    if dishes <= 0 then
        TriggerClientEvent('QBCore:Notify', src, 'Aucun plat prêt à vendre.', 'error')
        return
    end

    preparedDishes[src] = 0
    local reward = dishes * Config.PricePerDish
    exports['rp-job-core']:AddMoney(src, reward, 'cash')
    TriggerClientEvent('QBCore:Notify', src, ('%d plat(s) vendu(s) : +$%d'):format(dishes, reward), 'success')
end)

AddEventHandler('playerDropped', function()
    preparedDishes[source] = nil
end)
