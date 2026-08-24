local QBCore = exports['qb-core']:GetCoreObject()
local isPreparing = false

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
        local coords = GetEntityCoords(PlayerPedId())

        local kitchenDist = #(coords - Config.Kitchen.coords)
        if kitchenDist < Config.MarkerDistance then
            sleep = 0
            DrawMarker(2, Config.Kitchen.coords.x, Config.Kitchen.coords.y, Config.Kitchen.coords.z - 0.9,
                0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 220, 160, 40, 150, false, true, 2, false, nil, nil, false)

            if kitchenDist < Config.InteractDistance and not isPreparing then
                DrawText3D(Config.Kitchen.coords, '[E] Préparer un plat')
                if IsControlJustReleased(0, 38) then -- E
                    isPreparing = true
                    QBCore.Functions.Progressbar('restaurant_prep', 'Préparation en cours...', Config.PrepTimeMs,
                        false, true, {
                            disableMovement = true,
                            disableCarMovement = true,
                            disableMouse = false,
                            disableCombat = true,
                        }, {}, {}, {}, function()
                            TriggerServerEvent('rp-restaurant:server:prepare')
                            isPreparing = false
                        end, function()
                            isPreparing = false
                        end)
                end
            end
        end

        local counterDist = #(coords - Config.Counter.coords)
        if counterDist < Config.MarkerDistance then
            sleep = 0
            DrawMarker(2, Config.Counter.coords.x, Config.Counter.coords.y, Config.Counter.coords.z - 0.9,
                0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 40, 160, 220, 150, false, true, 2, false, nil, nil, false)

            if counterDist < Config.InteractDistance then
                DrawText3D(Config.Counter.coords, '[E] Vendre les plats')
                if IsControlJustReleased(0, 38) then -- E
                    TriggerServerEvent('rp-restaurant:server:sell')
                end
            end
        end

        Wait(sleep)
    end
end)
