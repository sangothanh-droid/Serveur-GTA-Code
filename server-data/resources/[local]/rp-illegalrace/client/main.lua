local checkpoints = {}
local currentIndex = 1
local racing = false

RegisterNetEvent('rp-illegalrace:client:startRace', function(routeCheckpoints)
    checkpoints = routeCheckpoints
    currentIndex = 1
    racing = true
    TriggerEvent('QBCore:Notify', 'La course commence !', 'success')
end)

RegisterNetEvent('rp-illegalrace:client:endRace', function()
    racing = false
    checkpoints = {}
end)

CreateThread(function()
    while true do
        local sleep = 500

        if racing and checkpoints[currentIndex] then
            sleep = 0
            local cp = checkpoints[currentIndex]
            DrawMarker(1, cp.x, cp.y, cp.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                Config.CheckpointRadius, Config.CheckpointRadius, 2.0, 255, 165, 0, 120, false, true, 2, false, nil, nil, false)

            local dist = #(GetEntityCoords(PlayerPedId()) - cp)
            if dist < Config.CheckpointRadius then
                currentIndex = currentIndex + 1
                TriggerServerEvent('rp-illegalrace:server:checkpoint', currentIndex)
            end
        end

        Wait(sleep)
    end
end)
