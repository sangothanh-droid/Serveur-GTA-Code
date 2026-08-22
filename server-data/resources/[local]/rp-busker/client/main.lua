RegisterCommand(Config.CommandName, function()
    TriggerServerEvent('rp-busker:server:perform')
end, false)

RegisterNetEvent('rp-busker:client:playAnim', function(duration)
    local ped = PlayerPedId()
    TaskStartScenarioInPlace(ped, 'WORLD_HUMAN_MUSICIAN', 0, true)

    CreateThread(function()
        Wait(duration)
        ClearPedTasks(ped)
    end)
end)
