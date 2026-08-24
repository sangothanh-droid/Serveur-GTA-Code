local QBCore = exports['qb-core']:GetCoreObject()
local isRobbing = false

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

RegisterNetEvent('rp-atmrobbery:client:startProgress', function(duration)
    isRobbing = true
    QBCore.Functions.Progressbar('atm_robbery', 'Piratage du distributeur...', duration, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function()
        TriggerServerEvent('rp-atmrobbery:server:finish', true)
        isRobbing = false
    end, function()
        TriggerServerEvent('rp-atmrobbery:server:finish', false)
        isRobbing = false
    end)
end)

CreateThread(function()
    while true do
        local sleep = 1000
        local coords = GetEntityCoords(PlayerPedId())

        for i, atm in ipairs(Config.ATMs) do
            local dist = #(coords - atm)
            if dist < Config.MarkerDistance then
                sleep = 0
                DrawMarker(2, atm.x, atm.y, atm.z - 0.9, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                    0.3, 0.3, 0.3, 200, 30, 30, 120, false, true, 2, false, nil, nil, false)

                if dist < Config.InteractDistance and not isRobbing then
                    DrawText3D(atm, '[E] Braquer le distributeur')
                    if IsControlJustReleased(0, 38) then -- E
                        TriggerServerEvent('rp-atmrobbery:server:attempt', i)
                    end
                end
            end
        end

        Wait(sleep)
    end
end)
