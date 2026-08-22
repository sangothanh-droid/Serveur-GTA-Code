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

local activeDrop = nil
local activeDropBlip = nil

RegisterNetEvent('rp-delivery:client:startDelivery', function(destination, label)
    activeDrop = destination

    activeDropBlip = AddBlipForCoord(destination.x, destination.y, destination.z)
    SetBlipSprite(activeDropBlip, 1)
    SetBlipColour(activeDropBlip, 5)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName('Livraison : ' .. label)
    EndTextCommandSetBlipName(activeDropBlip)

    TriggerEvent('QBCore:Notify', 'Cargaison chargée, direction : ' .. label, 'primary')
end)

CreateThread(function()
    while true do
        local sleep = 1000
        local coords = GetEntityCoords(PlayerPedId())

        if not activeDrop then
            local dist = #(coords - Config.Warehouse.coords)
            if dist < Config.MarkerDistance then
                sleep = 0
                DrawMarker(2, Config.Warehouse.coords.x, Config.Warehouse.coords.y, Config.Warehouse.coords.z - 0.9,
                    0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 30, 120, 220, 150, false, true, 2, false, nil, nil, false)

                if dist < Config.InteractDistance then
                    DrawText3D(Config.Warehouse.coords, '[E] Charger une cargaison')
                    if IsControlJustReleased(0, 38) then -- E
                        TriggerServerEvent('rp-delivery:server:load')
                    end
                end
            end
        else
            sleep = 0
            local dist = #(coords - activeDrop)
            if dist < Config.ArrivalDistance then
                TriggerServerEvent('rp-delivery:server:complete')
                if activeDropBlip then
                    RemoveBlip(activeDropBlip)
                    activeDropBlip = nil
                end
                activeDrop = nil
            end
        end

        Wait(sleep)
    end
end)
