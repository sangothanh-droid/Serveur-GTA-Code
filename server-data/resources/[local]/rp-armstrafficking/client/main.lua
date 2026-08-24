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
        local dist = #(coords - Config.DealPoint.coords)

        if dist < Config.InteractDistance then
            sleep = 0
            DrawMarker(2, Config.DealPoint.coords.x, Config.DealPoint.coords.y, Config.DealPoint.coords.z - 0.9,
                0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 120, 90, 30, 150, false, true, 2, false, nil, nil, false)

            if dist < 3.0 then
                DrawText3D(Config.DealPoint.coords, '[E] Rencontrer le fournisseur')
                if IsControlJustReleased(0, 38) then -- E
                    TriggerServerEvent('rp-armstrafficking:server:attemptDeal')
                end
            end
        end

        Wait(sleep)
    end
end)
