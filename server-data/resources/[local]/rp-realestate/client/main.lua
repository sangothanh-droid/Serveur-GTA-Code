CreateThread(function()
    for _, property in ipairs(Config.Properties) do
        local blip = AddBlipForRadius(property.coords.x, property.coords.y, property.coords.z, property.radius)
        SetBlipColour(blip, 3) -- bleu : jobs légaux (voir docs/HUD-THEME.md)
        SetBlipAlpha(blip, 60)

        local marker = AddBlipForCoord(property.coords.x, property.coords.y, property.coords.z)
        SetBlipSprite(marker, 40)
        SetBlipColour(marker, 3)
        SetBlipScale(marker, 0.7)
        SetBlipAsShortRange(marker, true)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentSubstringPlayerName(property.label)
        EndTextCommandSetBlipName(marker)
    end
end)
