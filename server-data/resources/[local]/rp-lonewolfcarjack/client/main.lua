local QBCore = exports['qb-core']:GetCoreObject()
local isStealing = false

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

RegisterNetEvent('rp-lonewolfcarjack:client:deleteVehicle', function(netId)
    local veh = NetworkGetEntityFromNetworkId(netId)
    if DoesEntityExist(veh) then
        DeleteEntity(veh)
    end
end)

RegisterNetEvent('rp-lonewolfcarjack:client:startSteal', function(netId, duration)
    isStealing = true
    QBCore.Functions.Progressbar('lonewolfcarjack_steal', 'Vol du véhicule...', duration, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function()
        TriggerServerEvent('rp-lonewolfcarjack:server:finish', netId, true)
        isStealing = false
    end, function()
        TriggerServerEvent('rp-lonewolfcarjack:server:finish', netId, false)
        isStealing = false
    end)
end)

CreateThread(function()
    while true do
        local sleep = 1000
        local ped = PlayerPedId()

        if not isStealing and IsPedInAnyVehicle(ped, false) then
            local veh = GetVehiclePedIsIn(ped, false)
            if GetPedInVehicleSeat(veh, -1) == ped then
                sleep = 0
                DrawText3D(GetEntityCoords(ped), '[E] Voler ce véhicule (revente rapide, risqué)')
                if IsControlJustReleased(0, 38) then -- E
                    local netId = NetworkGetNetworkIdFromEntity(veh)
                    TriggerServerEvent('rp-lonewolfcarjack:server:attempt', netId)
                end
            end
        end

        Wait(sleep)
    end
end)
