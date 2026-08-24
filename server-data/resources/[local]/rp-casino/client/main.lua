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

RegisterCommand(Config.CommandName, function(_, args)
    local amount = tonumber(args[1])
    if not amount then
        TriggerEvent('QBCore:Notify', ('Utilisation : /%s <montant>'):format(Config.CommandName), 'error')
        return
    end
    TriggerServerEvent('rp-casino:server:play', amount)
end, false)

RegisterCommand(Config.Slots.CommandName, function(_, args)
    local amount = tonumber(args[1])
    if not amount then
        TriggerEvent('QBCore:Notify', ('Utilisation : /%s <montant>'):format(Config.Slots.CommandName), 'error')
        return
    end
    TriggerServerEvent('rp-casino:server:slots', amount)
end, false)

RegisterCommand(Config.Blackjack.CommandName, function(_, args)
    local amount = tonumber(args[1])
    if not amount then
        TriggerEvent('QBCore:Notify', ('Utilisation : /%s <montant>'):format(Config.Blackjack.CommandName), 'error')
        return
    end
    TriggerServerEvent('rp-casino:server:blackjackStart', amount)
end, false)

RegisterCommand(Config.Blackjack.HitCommandName, function()
    TriggerServerEvent('rp-casino:server:blackjackHit')
end, false)

RegisterCommand(Config.Blackjack.StandCommandName, function()
    TriggerServerEvent('rp-casino:server:blackjackStand')
end, false)

RegisterCommand(Config.HorseRace.CommandName, function(_, args)
    local horseName = args[1]
    local amount = tonumber(args[2])
    if not horseName or not amount then
        TriggerEvent('QBCore:Notify',
            ('Utilisation : /%s <cheval> <montant>'):format(Config.HorseRace.CommandName), 'error')
        return
    end
    TriggerServerEvent('rp-casino:server:horsebet', horseName, amount)
end, false)

CreateThread(function()
    while true do
        local sleep = 1000
        local coords = GetEntityCoords(PlayerPedId())
        local dist = #(coords - Config.TableLocation)

        if dist < Config.MarkerDistance then
            sleep = 0
            DrawMarker(2, Config.TableLocation.x, Config.TableLocation.y, Config.TableLocation.z - 0.9,
                0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 220, 180, 40, 150, false, true, 2, false, nil, nil, false)

            if dist < Config.InteractDistance then
                DrawText3D(Config.TableLocation, ('Table de jeu - /%s, /%s, /%s ou /%s <montant>'):format(
                    Config.CommandName, Config.Slots.CommandName, Config.Blackjack.CommandName, Config.HorseRace.CommandName))
            end
        end

        Wait(sleep)
    end
end)
