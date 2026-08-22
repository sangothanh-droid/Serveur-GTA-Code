local QBCore = exports['qb-core']:GetCoreObject()
local isRepairing = false

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

local function FindNearestVehicle(coords, radius)
    local closest, closestDist = 0, radius
    for _, veh in ipairs(GetGamePool('CVehicle')) do
        local dist = #(coords - GetEntityCoords(veh))
        if dist < closestDist then
            closestDist = dist
            closest = veh
        end
    end
    return closest
end

RegisterNetEvent('rp-mechanic:client:startRepair', function(netId, duration)
    isRepairing = true
    QBCore.Functions.Progressbar('vehicle_repair', 'Réparation en cours...', duration, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function()
        TriggerServerEvent('rp-mechanic:server:finishRepair', netId, true)
        isRepairing = false
    end, function()
        TriggerServerEvent('rp-mechanic:server:finishRepair', netId, false)
        isRepairing = false
    end)
end)

RegisterNetEvent('rp-mechanic:client:applyRepair', function(netId)
    local veh = NetworkGetEntityFromNetworkId(netId)
    if DoesEntityExist(veh) then
        SetVehicleFixed(veh)
        SetVehicleDeformationFixed(veh)
        SetVehicleEngineHealth(veh, 1000.0)
        SetVehicleBodyHealth(veh, 1000.0)
    end
end)

CreateThread(function()
    while true do
        local sleep = 1000
        local coords = GetEntityCoords(PlayerPedId())
        local dist = #(coords - Config.Garage.coords)

        if dist < Config.MarkerDistance then
            sleep = 0
            DrawMarker(2, Config.Garage.coords.x, Config.Garage.coords.y, Config.Garage.coords.z - 0.9,
                0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 30, 120, 220, 150, false, true, 2, false, nil, nil, false)

            if dist < Config.InteractDistance and not isRepairing then
                local veh = FindNearestVehicle(coords, Config.VehicleSearchRadius)
                if veh ~= 0 then
                    DrawText3D(coords, '[E] Réparer ce véhicule')
                    if IsControlJustReleased(0, 38) then -- E
                        local netId = NetworkGetNetworkIdFromEntity(veh)
                        TriggerServerEvent('rp-mechanic:server:repair', netId)
                    end
                end
            end
        end

        Wait(sleep)
    end
end)
