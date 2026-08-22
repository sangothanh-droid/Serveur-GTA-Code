RegisterNetEvent('rp-gangs:client:setWanted', function(stars)
    local player = PlayerId()
    SetPlayerWantedLevel(player, stars, false)
    SetPlayerWantedLevelNow(player, false)
end)

-- Affiche le territoire de chaque gang sur la carte (zone + marqueur nommé).
CreateThread(function()
    for _, gang in pairs(Gangs) do
        local coords = gang.territory.coords

        local zoneBlip = AddBlipForRadius(coords.x, coords.y, coords.z, gang.territory.radius)
        SetBlipColour(zoneBlip, gang.blipColor)
        SetBlipAlpha(zoneBlip, 90)

        local nameBlip = AddBlipForCoord(coords.x, coords.y, coords.z)
        SetBlipSprite(nameBlip, 84)
        SetBlipColour(nameBlip, gang.blipColor)
        SetBlipScale(nameBlip, 0.8)
        SetBlipAsShortRange(nameBlip, true)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentSubstringPlayerName(('%s (%s)'):format(gang.label, gang.territory.label))
        EndTextCommandSetBlipName(nameBlip)
    end
end)
