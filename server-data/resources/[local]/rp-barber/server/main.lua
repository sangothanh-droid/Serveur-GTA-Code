local QBCore = exports['qb-core']:GetCoreObject()

local function isNearBarberShop(coords)
    for _, shop in ipairs(Config.BarberShops) do
        if #(coords - shop.coords) <= Config.InteractDistance then
            return true
        end
    end
    return false
end

RegisterNetEvent('rp-barber:server:requestStyle', function(hairColor, beardColor)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then
        return
    end

    if not isNearBarberShop(GetEntityCoords(GetPlayerPed(src))) then
        TriggerClientEvent('QBCore:Notify', src, "Approchez-vous d'un coiffeur.", 'error')
        return
    end

    if Player.PlayerData.money.cash < Config.Price then
        TriggerClientEvent('QBCore:Notify', src, "Vous n'avez pas assez d'argent liquide.", 'error')
        return
    end

    Player.Functions.RemoveMoney('cash', Config.Price, 'barber')
    TriggerClientEvent('rp-barber:client:applyStyle', src, hairColor, beardColor)
end)
