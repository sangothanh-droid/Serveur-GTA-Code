local QBCore = exports['qb-core']:GetCoreObject()
local isHeisting = false

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

RegisterNetEvent('rp-heist:client:startHack', function(duration)
    isHeisting = true
    QBCore.Functions.Progressbar('heist_hack', "Piratage de l'alarme...", duration, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function()
        TriggerServerEvent('rp-heist:server:hackDone', true)
    end, function()
        TriggerServerEvent('rp-heist:server:hackDone', false)
        isHeisting = false
    end)
end)

RegisterNetEvent('rp-heist:client:startDrill', function(duration)
    QBCore.Functions.Progressbar('heist_drill', 'Perçage du coffre...', duration, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function()
        TriggerServerEvent('rp-heist:server:drillDone', true)
        isHeisting = false
    end, function()
        TriggerServerEvent('rp-heist:server:drillDone', false)
        isHeisting = false
    end)
end)

CreateThread(function()
    while true do
        local sleep = 1000
        local coords = GetEntityCoords(PlayerPedId())

        for i, bank in ipairs(Config.Banks) do
            local dist = #(coords - bank.coords)
            if dist < Config.MarkerDistance then
                sleep = 0
                DrawMarker(2, bank.coords.x, bank.coords.y, bank.coords.z - 0.9, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                    0.4, 0.4, 0.4, 30, 100, 220, 150, false, true, 2, false, nil, nil, false)

                if dist < Config.InteractDistance and not isHeisting then
                    DrawText3D(bank.coords, '[E] Braquer ' .. bank.label)
                    if IsControlJustReleased(0, 38) then -- E
                        TriggerServerEvent('rp-heist:server:startHack', i)
                    end
                end
            end
        end

        Wait(sleep)
    end
end)
