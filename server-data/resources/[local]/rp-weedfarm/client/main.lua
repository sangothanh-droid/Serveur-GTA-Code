local QBCore = exports['qb-core']:GetCoreObject()

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

RegisterNetEvent('rp-weedfarm:client:startProcessing', function(duration)
    QBCore.Functions.Progressbar('weed_processing', 'Conditionnement en cours...', duration, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function()
        TriggerServerEvent('rp-weedfarm:server:finishProcessing', true)
    end, function()
        TriggerServerEvent('rp-weedfarm:server:finishProcessing', false)
    end)
end)

CreateThread(function()
    while true do
        local sleep = 1000
        local coords = GetEntityCoords(PlayerPedId())

        for i, spot in ipairs(Config.PlantSpots) do
            local dist = #(coords - spot)
            if dist < Config.MarkerDistance then
                sleep = 0
                DrawMarker(2, spot.x, spot.y, spot.z - 0.9, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                    0.4, 0.4, 0.4, 30, 180, 30, 150, false, true, 2, false, nil, nil, false)

                if dist < Config.InteractDistance then
                    DrawText3D(spot, '[E] Récolter')
                    if IsControlJustReleased(0, 38) then -- E
                        TriggerServerEvent('rp-weedfarm:server:harvest', i)
                    end
                end
            end
        end

        local pdist = #(coords - Config.ProcessPoint.coords)
        if pdist < Config.MarkerDistance then
            sleep = 0
            DrawMarker(2, Config.ProcessPoint.coords.x, Config.ProcessPoint.coords.y, Config.ProcessPoint.coords.z - 0.9,
                0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 200, 180, 30, 150, false, true, 2, false, nil, nil, false)

            if pdist < Config.InteractDistance then
                DrawText3D(Config.ProcessPoint.coords, '[E] Traiter et vendre la récolte')
                if IsControlJustReleased(0, 38) then -- E
                    TriggerServerEvent('rp-weedfarm:server:startProcessing')
                end
            end
        end

        Wait(sleep)
    end
end)
