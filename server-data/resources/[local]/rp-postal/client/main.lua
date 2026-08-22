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

local route = nil
local currentStop = 1

RegisterNetEvent('rp-postal:client:startRound', function(routeStops)
    route = routeStops
    currentStop = 1
    TriggerEvent('QBCore:Notify', 'Tournée chargée, direction le premier arrêt.', 'primary')
end)

CreateThread(function()
    while true do
        local sleep = 1000
        local coords = GetEntityCoords(PlayerPedId())

        if not route then
            local dist = #(coords - Config.PostOffice.coords)
            if dist < Config.MarkerDistance then
                sleep = 0
                DrawMarker(2, Config.PostOffice.coords.x, Config.PostOffice.coords.y, Config.PostOffice.coords.z - 0.9,
                    0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 30, 120, 220, 150, false, true, 2, false, nil, nil, false)

                if dist < Config.InteractDistance then
                    DrawText3D(Config.PostOffice.coords, '[E] Charger la tournée du jour')
                    if IsControlJustReleased(0, 38) then -- E
                        TriggerServerEvent('rp-postal:server:startRound')
                    end
                end
            end
        else
            sleep = 0
            local stop = route[currentStop]
            if stop then
                DrawMarker(1, stop.x, stop.y, stop.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                    1.0, 1.0, 1.0, 255, 165, 0, 150, false, true, 2, false, nil, nil, false)

                local dist = #(coords - stop)
                if dist < Config.ArrivalDistance then
                    currentStop = currentStop + 1
                    if currentStop > #route then
                        TriggerServerEvent('rp-postal:server:completeRound')
                        route = nil
                        currentStop = 1
                    else
                        TriggerEvent('QBCore:Notify', ('Arrêt %d/%d'):format(currentStop, #route), 'primary')
                    end
                end
            end
        end

        Wait(sleep)
    end
end)
