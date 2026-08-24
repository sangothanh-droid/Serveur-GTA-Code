local activeMeet = nil
local activeBlip = nil

RegisterCommand(Config.CommandName, function()
    TriggerServerEvent('rp-carmeet:server:start')
end, false)

RegisterNetEvent('rp-carmeet:client:showMeet', function(coords, label, organizerName, durationMs)
    activeMeet = coords

    if activeBlip then
        RemoveBlip(activeBlip)
    end
    activeBlip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(activeBlip, 225)
    SetBlipColour(activeBlip, 5)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName(label)
    EndTextCommandSetBlipName(activeBlip)

    TriggerEvent('QBCore:Notify', ('%s organise un rassemblement de voitures : %s'):format(organizerName, label), 'primary')

    SetTimeout(durationMs, function()
        if activeBlip then
            RemoveBlip(activeBlip)
            activeBlip = nil
        end
        activeMeet = nil
    end)
end)

CreateThread(function()
    while true do
        local sleep = 1000

        if activeMeet then
            local dist = #(GetEntityCoords(PlayerPedId()) - activeMeet)
            if dist < Config.MarkerRenderDistance then
                sleep = 0
                DrawMarker(1, activeMeet.x, activeMeet.y, activeMeet.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                    8.0, 8.0, 2.0, 80, 180, 255, 100, false, true, 2, false, nil, nil, false)
            end
        end

        Wait(sleep)
    end
end)
