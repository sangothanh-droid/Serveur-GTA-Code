local QBCore = exports['qb-core']:GetCoreObject()
local activeHouses = {} -- [poolIndex] = coords
local isSearching = false

local function DrawText3D(coords, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry('STRING')
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(coords.x, coords.y, coords.z, 0)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()
end

RegisterNetEvent('rp-soloburglary:client:setActiveHouses', function(houses)
    activeHouses = houses
end)

AddEventHandler('onClientResourceStart', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        TriggerServerEvent('rp-soloburglary:server:requestSync')
    end
end)

RegisterNetEvent('rp-soloburglary:client:startSearch', function()
    isSearching = true
    QBCore.Functions.Progressbar('soloburglary_search', 'Fouille de la maison...', Config.SearchTimeMs, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function()
        TriggerServerEvent('rp-soloburglary:server:finish', true)
        isSearching = false
    end, function()
        TriggerServerEvent('rp-soloburglary:server:finish', false)
        isSearching = false
    end)
end)

CreateThread(function()
    while true do
        local sleep = 1000
        local coords = GetEntityCoords(PlayerPedId())

        for poolIndex, houseCoords in pairs(activeHouses) do
            local dist = #(coords - houseCoords)
            if dist < Config.MarkerDistance then
                sleep = 0
                DrawMarker(2, houseCoords.x, houseCoords.y, houseCoords.z - 0.9, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                    0.4, 0.4, 0.4, 40, 200, 90, 130, false, true, 2, false, nil, nil, false)

                if dist < Config.InteractDistance and not isSearching then
                    DrawText3D(houseCoords, '[E] Entrer et fouiller')
                    if IsControlJustReleased(0, 38) then -- E
                        TriggerServerEvent('rp-soloburglary:server:attempt', poolIndex)
                    end
                end
            end
        end

        Wait(sleep)
    end
end)
