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
        local dist = #(coords - Config.Front.coords)

        if dist < Config.InteractDistance then
            sleep = 0
            DrawMarker(2, Config.Front.coords.x, Config.Front.coords.y, Config.Front.coords.z - 0.9,
                0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 30, 30, 30, 150, false, true, 2, false, nil, nil, false)

            if dist < 3.0 then
                DrawText3D(Config.Front.coords, '~y~/launder <montant>~s~ pour blanchir de l\'argent sale')
            end
        end

        Wait(sleep)
    end
end)
