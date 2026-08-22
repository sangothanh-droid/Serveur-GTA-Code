local QBCore = exports['qb-core']:GetCoreObject()
local isCollecting = false

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

        for i, bin in ipairs(Config.Bins) do
            local dist = #(coords - bin)
            if dist < Config.MarkerDistance then
                sleep = 0
                DrawMarker(2, bin.x, bin.y, bin.z - 0.9, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                    0.3, 0.3, 0.3, 30, 200, 30, 120, false, true, 2, false, nil, nil, false)

                if dist < Config.InteractDistance and not isCollecting then
                    DrawText3D(bin, '[E] Collecter la poubelle')
                    if IsControlJustReleased(0, 38) then -- E
                        isCollecting = true
                        QBCore.Functions.Progressbar('garbage_collect', 'Collecte en cours...', Config.CollectTimeMs,
                            false, true, {
                                disableMovement = true,
                                disableCarMovement = true,
                                disableMouse = false,
                                disableCombat = true,
                            }, {}, {}, {}, function()
                                TriggerServerEvent('rp-garbage:server:collect', i)
                                isCollecting = false
                            end, function()
                                isCollecting = false
                            end)
                    end
                end
            end
        end

        Wait(sleep)
    end
end)
