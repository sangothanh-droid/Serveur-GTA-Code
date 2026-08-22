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

RegisterNetEvent('rp-shoprobbery:client:startProgress', function(duration)
    isRobbing = true
    QBCore.Functions.Progressbar('shop_robbery', 'Braquage en cours...', duration, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function()
        TriggerServerEvent('rp-shoprobbery:server:finish', true)
        isRobbing = false
    end, function()
        TriggerServerEvent('rp-shoprobbery:server:finish', false)
        isRobbing = false
    end)
end)

CreateThread(function()
    while true do
        local sleep = 1000
        local coords = GetEntityCoords(PlayerPedId())

        for i, shop in ipairs(Config.Shops) do
            local dist = #(coords - shop.coords)
            if dist < Config.MarkerDistance then
                sleep = 0
                DrawMarker(2, shop.coords.x, shop.coords.y, shop.coords.z - 0.9, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                    0.3, 0.3, 0.3, 200, 30, 30, 120, false, true, 2, false, nil, nil, false)

                if dist < Config.InteractDistance and not isRobbing then
                    DrawText3D(shop.coords, '[E] Braquer ' .. shop.label)
                    if IsControlJustReleased(0, 38) then -- E
                        TriggerServerEvent('rp-shoprobbery:server:attempt', i)
                    end
                end
            end
        end

        Wait(sleep)
    end
end)
