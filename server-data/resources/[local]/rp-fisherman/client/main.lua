local QBCore = exports['qb-core']:GetCoreObject()
local isFishing = false

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

        for i, spot in ipairs(Config.FishingSpots) do
            local dist = #(coords - spot)
            if dist < Config.MarkerDistance then
                sleep = 0
                DrawMarker(2, spot.x, spot.y, spot.z - 0.9, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                    0.4, 0.4, 0.4, 30, 120, 200, 150, false, true, 2, false, nil, nil, false)

                if dist < Config.InteractDistance and not isFishing then
                    DrawText3D(spot, '[E] Pêcher')
                    if IsControlJustReleased(0, 38) then -- E
                        isFishing = true
                        QBCore.Functions.Progressbar('fishing_catch', 'Pêche en cours...', Config.FishTimeMs,
                            false, true, {
                                disableMovement = true,
                                disableCarMovement = true,
                                disableMouse = false,
                                disableCombat = true,
                            }, {}, {}, {}, function()
                                TriggerServerEvent('rp-fisherman:server:catch', i)
                                isFishing = false
                            end, function()
                                isFishing = false
                            end)
                    end
                end
            end
        end

        local mdist = #(coords - Config.Market.coords)
        if mdist < Config.MarkerDistance then
            sleep = 0
            DrawMarker(2, Config.Market.coords.x, Config.Market.coords.y, Config.Market.coords.z - 0.9,
                0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 200, 180, 30, 150, false, true, 2, false, nil, nil, false)

            if mdist < Config.InteractDistance then
                DrawText3D(Config.Market.coords, '[E] Vendre le poisson')
                if IsControlJustReleased(0, 38) then -- E
                    TriggerServerEvent('rp-fisherman:server:sell')
                end
            end
        end

        Wait(sleep)
    end
end)
