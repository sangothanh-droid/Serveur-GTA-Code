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

RegisterNetEvent('rp-carjack:client:deleteVehicle', function(netId)
    local veh = NetworkGetEntityFromNetworkId(netId)
    if DoesEntityExist(veh) then
        DeleteEntity(veh)
    end
end)

CreateThread(function()
    while true do
        local sleep = 1000
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        local dist = #(coords - Config.ChopShop.coords)

        if dist < Config.MarkerDistance then
            sleep = 0
            DrawMarker(2, Config.ChopShop.coords.x, Config.ChopShop.coords.y, Config.ChopShop.coords.z - 0.9,
                0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 200, 120, 30, 120, false, true, 2, false, nil, nil, false)

            if dist < Config.InteractDistance and IsPedInAnyVehicle(ped, false) then
                local veh = GetVehiclePedIsIn(ped, false)
                if GetPedInVehicleSeat(veh, -1) == ped then
                    DrawText3D(Config.ChopShop.coords, '[E] Revendre ce véhicule à la casse')
                    if IsControlJustReleased(0, 38) then -- E
                        local netId = NetworkGetNetworkIdFromEntity(veh)
                        TriggerServerEvent('rp-carjack:server:sellVehicle', netId)
                    end
                end
            end
        end

        Wait(sleep)
    end
end)
