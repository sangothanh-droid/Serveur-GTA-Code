local isBusy = false
local awaitingReaction = false

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

RegisterNetEvent('rp-arcade:client:go', function()
    awaitingReaction = true
    TriggerEvent('QBCore:Notify', 'MAINTENANT ! Appuyez sur [E] !', 'primary')
end)

RegisterNetEvent('rp-arcade:client:result', function(success, reward)
    isBusy = false
    awaitingReaction = false
    if success then
        TriggerEvent('QBCore:Notify', ('Réflexes au top : +$%d'):format(reward), 'success')
    else
        TriggerEvent('QBCore:Notify', 'Trop lent, raté !', 'error')
    end
end)

CreateThread(function()
    while true do
        local sleep = 1000
        local coords = GetEntityCoords(PlayerPedId())

        for _, machine in ipairs(Config.Machines) do
            local dist = #(coords - machine.coords)
            if dist < Config.MarkerDistance then
                sleep = 0
                DrawMarker(2, machine.coords.x, machine.coords.y, machine.coords.z - 0.9,
                    0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.4, 0.4, 0.4, 40, 220, 220, 150, false, true, 2, false, nil, nil, false)

                if dist < Config.InteractDistance then
                    if not isBusy then
                        DrawText3D(machine.coords, ('[E] Jouer - %s'):format(machine.label))
                        if IsControlJustReleased(0, 38) then -- E
                            isBusy = true
                            TriggerServerEvent('rp-arcade:server:attempt')
                        end
                    elseif awaitingReaction then
                        DrawText3D(machine.coords, 'MAINTENANT ! [E]')
                    else
                        DrawText3D(machine.coords, 'Préparez-vous...')
                    end
                end
            end
        end

        if awaitingReaction and IsControlJustReleased(0, 38) then -- E
            TriggerServerEvent('rp-arcade:server:react')
        end

        Wait(sleep)
    end
end)
