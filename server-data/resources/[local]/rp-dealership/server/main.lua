local QBCore = exports['qb-core']:GetCoreObject()

local function findDealership(dealershipId)
    for _, dealership in ipairs(Config.Dealerships) do
        if dealership.id == dealershipId then
            return dealership
        end
    end
    return nil
end

local function findCatalogEntry(model, vehicleType)
    for _, entry in ipairs(Config.Catalog) do
        if entry.model == model and entry.type == vehicleType then
            return entry
        end
    end
    return nil
end

local function generatePlateCandidate()
    local plate = Config.PlatePrefix
    for _ = 1, 8 - #Config.PlatePrefix do
        local idx = math.random(#Config.PlateChars)
        plate = plate .. Config.PlateChars:sub(idx, idx)
    end
    return plate
end

--- Génère une plaque unique (même table/colonne que rp-carjack et
-- rp-lonewolfcarjack : SELECT 1 FROM player_vehicles WHERE plate = ?).
local function generateUniquePlate(cb)
    local plate = generatePlateCandidate()
    MySQL.scalar('SELECT 1 FROM player_vehicles WHERE plate = ?', { plate }, function(exists)
        if exists then
            generateUniquePlate(cb)
        else
            cb(plate)
        end
    end)
end

RegisterNetEvent('rp-dealership:server:buyVehicle', function(dealershipId, model)
    local src = source
    local dealership = findDealership(dealershipId)
    if not dealership then
        return
    end

    local entry = findCatalogEntry(model, dealership.vehicleType)
    if not entry then
        return
    end

    local dist = #(GetEntityCoords(GetPlayerPed(src)) - dealership.coords)
    if dist > Config.MarkerDistance then
        TriggerClientEvent('QBCore:Notify', src, 'Approchez-vous de la concession.', 'error')
        return
    end

    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then
        return
    end

    if Player.PlayerData.money.bank < entry.price then
        TriggerClientEvent('QBCore:Notify', src, 'Solde bancaire insuffisant.', 'error')
        return
    end

    generateUniquePlate(function(plate)
        Player.Functions.RemoveMoney('bank', entry.price, 'dealership-purchase')

        MySQL.insert(
            'INSERT INTO player_vehicles (citizenid, vehicle, hash, plate, garage, state) VALUES (?, ?, ?, ?, ?, ?)',
            {
                Player.PlayerData.citizenid,
                entry.model,
                GetHashKey(entry.model),
                plate,
                dealership.deliveryGarage,
                1, -- garé dès l'achat, à récupérer au garage (voir rp-garage)
            }
        )

        TriggerClientEvent('QBCore:Notify', src,
            ('Achat confirmé : %s (%s). Récupérez-le au garage.'):format(entry.label, plate), 'success')
    end)
end)
