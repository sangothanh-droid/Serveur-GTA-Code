-- Affiche les zones de patrouille (visibles pour tout le monde, simple repère RP).
CreateThread(function()
    for _, site in ipairs(Config.PatrolSites) do
        local blip = AddBlipForRadius(site.coords.x, site.coords.y, site.coords.z, site.radius)
        SetBlipColour(blip, 3)
        SetBlipAlpha(blip, 60)

        local marker = AddBlipForCoord(site.coords.x, site.coords.y, site.coords.z)
        SetBlipSprite(marker, 60)
        SetBlipColour(marker, 3)
        SetBlipScale(marker, 0.7)
        SetBlipAsShortRange(marker, true)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentSubstringPlayerName(site.label)
        EndTextCommandSetBlipName(marker)
    end
end)
