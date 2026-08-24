local QBCore = exports['qb-core']:GetCoreObject()

local activeHouses = {}  -- [poolIndex] = coords
local houseCooldowns = {} -- [poolIndex] = os.time()
local pending = {}        -- [src] = poolIndex

local function rotateHouses()
    local indices = {}
    for i = 1, #Config.HousePool do
        indices[i] = i
    end
    -- Mélange simple (Fisher-Yates) puis on garde les N premiers.
    for i = #indices, 2, -1 do
        local j = math.random(i)
        indices[i], indices[j] = indices[j], indices[i]
    end

    activeHouses = {}
    for i = 1, math.min(Config.ActiveCount, #indices) do
        local poolIndex = indices[i]
        activeHouses[poolIndex] = Config.HousePool[poolIndex]
    end

    TriggerClientEvent('rp-soloburglary:client:setActiveHouses', -1, activeHouses)
end

CreateThread(function()
    rotateHouses()
    while true do
        Wait(Config.RotationIntervalMs)
        rotateHouses()
    end
end)

RegisterNetEvent('rp-soloburglary:server:requestSync', function()
    TriggerClientEvent('rp-soloburglary:client:setActiveHouses', source, activeHouses)
end)

RegisterNetEvent('rp-soloburglary:server:attempt', function(poolIndex)
    local src = source
    local coords = activeHouses[poolIndex]
    if not coords then
        TriggerClientEvent('QBCore:Notify', src, "Cette maison n'est plus disponible.", 'error')
        return
    end

    if exports['rp-crime-core']:GetPlayerGang(src) ~= nil then
        TriggerClientEvent('QBCore:Notify', src, 'Réservé aux joueurs sans gang officiel.', 'error')
        return
    end

    local now = os.time()
    if houseCooldowns[poolIndex] and (now - houseCooldowns[poolIndex]) < (Config.CooldownMs / 1000) then
        TriggerClientEvent('QBCore:Notify', src, 'Cette maison vient déjà d\'être visitée.', 'error')
        return
    end

    local dist = #(GetEntityCoords(GetPlayerPed(src)) - coords)
    if dist > Config.InteractDistance then
        return
    end

    houseCooldowns[poolIndex] = now
    pending[src] = poolIndex
    TriggerClientEvent('rp-soloburglary:client:startSearch', src)
end)

RegisterNetEvent('rp-soloburglary:server:finish', function(success)
    local src = source
    local poolIndex = pending[src]
    pending[src] = nil
    if not poolIndex or not success then
        return
    end

    local coords = Config.HousePool[poolIndex]
    local loot = math.random(Config.LootMin, Config.LootMax)
    local Player = QBCore.Functions.GetPlayer(src)
    if Player then
        Player.Functions.AddMoney('cash', loot, 'soloburglary')
    end
    exports['rp-streetrep']:AddStreetRep(src, Config.RepGain)

    TriggerClientEvent('QBCore:Notify', src, ('Cambriolage réussi : +$%d'):format(loot), 'success')

    if math.random(100) <= Config.PoliceCallChancePercent then
        exports['rp-crime-core']:AlertPolice(coords, 'Cambriolage signalé par un voisin.')
    end
end)

AddEventHandler('playerDropped', function()
    pending[source] = nil
end)
