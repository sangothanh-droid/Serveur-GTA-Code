local activeFare = nil
local activeFareBlip = nil

RegisterCommand('taxi', function()
    TriggerServerEvent('rp-taxi:server:requestFare')
end, false)

RegisterNetEvent('rp-taxi:client:startFare', function(destination, label)
    activeFare = destination

    activeFareBlip = AddBlipForCoord(destination.x, destination.y, destination.z)
    SetBlipSprite(activeFareBlip, 1)
    SetBlipColour(activeFareBlip, 3) -- bleu : jobs légaux (voir docs/HUD-THEME.md)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName('Client : ' .. label)
    EndTextCommandSetBlipName(activeFareBlip)

    TriggerEvent('QBCore:Notify', 'Direction : ' .. label, 'primary')
end)

CreateThread(function()
    while true do
        local sleep = 1000

        if activeFare then
            sleep = 0
            local dist = #(GetEntityCoords(PlayerPedId()) - activeFare)
            if dist < Config.ArrivalDistance then
                TriggerServerEvent('rp-taxi:server:completeFare')
                if activeFareBlip then
                    RemoveBlip(activeFareBlip)
                    activeFareBlip = nil
                end
                activeFare = nil
            end
        end

        Wait(sleep)
    end
end)
