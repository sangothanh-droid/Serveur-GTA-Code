local QBCore = exports['qb-core']:GetCoreObject()
local isChopping = false

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

        for i, tree in ipairs(Config.Trees) do
            local dist = #(coords - tree)
            if dist < Config.MarkerDistance then
                sleep = 0
                DrawMarker(2, tree.x, tree.y, tree.z - 0.9, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                    0.4, 0.4, 0.4, 90, 60, 20, 150, false, true, 2, false, nil, nil, false)

                if dist < Config.InteractDistance and not isChopping then
                    DrawText3D(tree, "[E] Couper l'arbre")
                    if IsControlJustReleased(0, 38) then -- E
                        isChopping = true
                        QBCore.Functions.Progressbar('lumberjack_chop', 'Coupe en cours...', Config.ChopTimeMs,
                            false, true, {
                                disableMovement = true,
                                disableCarMovement = true,
                                disableMouse = false,
                                disableCombat = true,
                            }, {}, {}, {}, function()
                                TriggerServerEvent('rp-lumberjack:server:chop', i)
                                isChopping = false
                            end, function()
                                isChopping = false
                            end)
                    end
                end
            end
        end

        local sdist = #(coords - Config.Sawmill.coords)
        if sdist < Config.MarkerDistance then
            sleep = 0
            DrawMarker(2, Config.Sawmill.coords.x, Config.Sawmill.coords.y, Config.Sawmill.coords.z - 0.9,
                0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 150, 100, 40, 150, false, true, 2, false, nil, nil, false)

            if sdist < Config.InteractDistance then
                DrawText3D(Config.Sawmill.coords, '[E] Vendre le bois')
                if IsControlJustReleased(0, 38) then -- E
                    TriggerServerEvent('rp-lumberjack:server:sell')
                end
            end
        end

        Wait(sleep)
    end
end)
