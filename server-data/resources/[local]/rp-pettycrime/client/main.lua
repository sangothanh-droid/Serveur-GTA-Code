local QBCore = exports['qb-core']:GetCoreObject()
local isBusy = false

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

local function GetClosestPed()
    local ped = PlayerPedId()
    local pedCoords = GetEntityCoords(ped)
    local closestPed, closestDist = nil, Config.Pickpocket.NpcSearchRadius

    for _, otherPed in ipairs(GetGamePool('CPed')) do
        if otherPed ~= ped and not IsPedAPlayer(otherPed) and IsEntityAPed(otherPed) then
            local dist = #(pedCoords - GetEntityCoords(otherPed))
            if dist < closestDist then
                closestDist = dist
                closestPed = otherPed
            end
        end
    end

    return closestPed
end

-- Vol à la tire : interaction rapide sur le PNJ le plus proche.
RegisterCommand(Config.Pickpocket.CommandName, function()
    if not GetClosestPed() then
        TriggerEvent('QBCore:Notify', 'Aucun passant à proximité.', 'error')
        return
    end
    TriggerServerEvent('rp-pettycrime:server:pickpocket')
end, false)

local function runTimedAction(eventName, label, duration)
    isBusy = true
    QBCore.Functions.Progressbar('pettycrime_' .. eventName, label, duration, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function()
        TriggerServerEvent('rp-pettycrime:server:finish' .. eventName, true)
        isBusy = false
    end, function()
        TriggerServerEvent('rp-pettycrime:server:finish' .. eventName, false)
        isBusy = false
    end)
end

CreateThread(function()
    while true do
        local sleep = 1000
        local coords = GetEntityCoords(PlayerPedId())

        for i, spot in ipairs(Config.CarBreakIn.Locations) do
            local dist = #(coords - spot)
            if dist < Config.CarBreakIn.MarkerDistance then
                sleep = 0
                DrawMarker(2, spot.x, spot.y, spot.z - 0.9, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                    0.3, 0.3, 0.3, 200, 120, 30, 120, false, true, 2, false, nil, nil, false)

                if dist < Config.CarBreakIn.InteractDistance and not isBusy then
                    DrawText3D(spot, '[E] Fracturer un véhicule garé')
                    if IsControlJustReleased(0, 38) then -- E
                        TriggerServerEvent('rp-pettycrime:server:attemptCarBreakIn', i)
                    end
                end
            end
        end

        for i, spot in ipairs(Config.MailboxTheft.Locations) do
            local dist = #(coords - spot)
            if dist < Config.MailboxTheft.MarkerDistance then
                sleep = 0
                DrawMarker(2, spot.x, spot.y, spot.z - 0.9, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                    0.25, 0.25, 0.25, 40, 150, 220, 120, false, true, 2, false, nil, nil, false)

                if dist < Config.MailboxTheft.InteractDistance and not isBusy then
                    DrawText3D(spot, '[E] Fouiller la boîte aux lettres')
                    if IsControlJustReleased(0, 38) then -- E
                        TriggerServerEvent('rp-pettycrime:server:attemptMailbox', i)
                    end
                end
            end
        end

        for i, wall in ipairs(Config.Graffiti.Walls) do
            local dist = #(coords - wall)
            if dist < Config.Graffiti.MarkerDistance then
                sleep = 0
                DrawMarker(2, wall.x, wall.y, wall.z - 0.9, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                    0.3, 0.3, 0.3, 180, 40, 200, 120, false, true, 2, false, nil, nil, false)

                if dist < Config.Graffiti.InteractDistance and not isBusy then
                    DrawText3D(wall, '[E] Taguer le mur')
                    if IsControlJustReleased(0, 38) then -- E
                        TriggerServerEvent('rp-pettycrime:server:attemptGraffiti', i)
                    end
                end
            end
        end

        Wait(sleep)
    end
end)

RegisterNetEvent('rp-pettycrime:client:startCarBreakIn', function()
    runTimedAction('CarBreakIn', 'Fracture du véhicule...', Config.CarBreakIn.BreakInTimeMs)
end)

RegisterNetEvent('rp-pettycrime:client:startMailbox', function()
    runTimedAction('Mailbox', 'Fouille de la boîte aux lettres...', Config.MailboxTheft.SearchTimeMs)
end)

RegisterNetEvent('rp-pettycrime:client:startGraffiti', function()
    runTimedAction('Graffiti', 'Tag en cours...', Config.Graffiti.TagTimeMs)
end)
