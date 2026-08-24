local hotzoneBlip = nil

RegisterNetEvent('rp-gangwar-events:client:setHotzone', function(coords, label)
    if hotzoneBlip then
        RemoveBlip(hotzoneBlip)
    end
    hotzoneBlip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(hotzoneBlip, 436)
    SetBlipColour(hotzoneBlip, 1)
    SetBlipScale(hotzoneBlip, 1.2)
    SetBlipFlashes(hotzoneBlip, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName('Point chaud - ' .. label)
    EndTextCommandSetBlipName(hotzoneBlip)
end)

RegisterNetEvent('rp-gangwar-events:client:clearHotzone', function()
    if hotzoneBlip then
        RemoveBlip(hotzoneBlip)
        hotzoneBlip = nil
    end
end)
