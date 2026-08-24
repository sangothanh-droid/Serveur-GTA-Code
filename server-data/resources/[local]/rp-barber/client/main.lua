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
    local hairColor = tonumber(args[1])
    local beardColor = tonumber(args[2]) or hairColor

    if not hairColor or hairColor < 0 or hairColor > Config.MaxColorIndex then
        TriggerEvent('QBCore:Notify',
            ('Utilisation : /%s <couleur 0-%d> [couleur barbe]'):format(Config.CommandName, Config.MaxColorIndex),
            'error')
        return
    end

    TriggerServerEvent('rp-barber:server:requestStyle', hairColor, beardColor)
end, false)

RegisterNetEvent('rp-barber:client:applyStyle', function(hairColor, beardColor)
    local ped = PlayerPedId()
    SetPedHairColor(ped, hairColor, hairColor)
    SetPedComponentVariation(ped, 2, 0, beardColor, 0) -- barbe (composant 2 selon le modèle)
    TriggerEvent('QBCore:Notify', 'Nouvelle coupe appliquée !', 'success')
end)

CreateThread(function()
    while true do
        local sleep = 1000
        local coords = GetEntityCoords(PlayerPedId())

        for _, shop in ipairs(Config.BarberShops) do
            local dist = #(coords - shop.coords)
            if dist < Config.MarkerDistance then
                sleep = 0
                DrawMarker(2, shop.coords.x, shop.coords.y, shop.coords.z - 0.9,
                    0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 200, 140, 200, 150, false, true, 2, false, nil, nil, false)

                if dist < Config.InteractDistance then
                    DrawText3D(shop.coords,
                        ('%s - /%s <couleur> ($%d)'):format(shop.label, Config.CommandName, Config.Price))
                end
            end
        end

        Wait(sleep)
    end
end)
