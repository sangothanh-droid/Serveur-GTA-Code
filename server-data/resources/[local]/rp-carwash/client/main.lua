local QBCore = exports['qb-core']:GetCoreObject()
local isWashing = false

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

CreateThread(function()
    while true do
        local sleep = 1000
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)

        for _, station in ipairs(Config.CarWashes) do
            local dist = #(coords - station.coords)
            if dist < Config.MarkerDistance then
                sleep = 0
                DrawMarker(2, station.coords.x, station.coords.y, station.coords.z - 0.9,
                    0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 40, 150, 220, 120, false, true, 2, false, nil, nil, false)

                if dist < Config.InteractDistance and not isWashing and IsPedInAnyVehicle(ped, false) then
                    local veh = GetVehiclePedIsIn(ped, false)
                    if GetPedInVehicleSeat(veh, -1) == ped then
                        local dirt = GetVehicleDirtLevel(veh)
                        if dirt >= Config.MinDirtLevel then
                            DrawText3D(station.coords, '[E] Laver le véhicule')
                            if IsControlJustReleased(0, 38) then -- E
                                isWashing = true
                                local netId = NetworkGetNetworkIdFromEntity(veh)
                                QBCore.Functions.Progressbar('carwash_wash', 'Lavage en cours...', Config.WashTimeMs,
                                    false, true, {
                                        disableMovement = true,
                                        disableCarMovement = true,
                                        disableMouse = false,
                                        disableCombat = true,
                                    }, {}, {}, {}, function()
                                        SetVehicleDirtLevel(veh, 0.0)
                                        TriggerServerEvent('rp-carwash:server:finish', netId)
                                        isWashing = false
                                    end, function()
                                        isWashing = false
                                    end)
                            end
                        else
                            DrawText3D(station.coords, 'Ce véhicule est déjà propre.')
                        end
                    end
                end
            end
        end

        Wait(sleep)
    end
end)
