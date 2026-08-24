local visible = false

local function setVisible(show)
    if show == visible then
        return
    end
    visible = show
    SendNUIMessage({ action = show and 'show' or 'hide' })
    if show then
        TriggerServerEvent('rp-scoreboard:server:requestPlayers')
    end
end

RegisterNetEvent('rp-scoreboard:client:updatePlayers', function(players, maxSlots)
    SendNUIMessage({ action = 'update', players = players, maxSlots = maxSlots })
end)

-- Contrôle 37 (INPUT_SELECT_WEAPON) est lié à TAB par défaut : maintenir
-- pour afficher, relâcher pour masquer (comme le scoreboard multijoueur
-- natif de GTA V).
CreateThread(function()
    while true do
        Wait(0)
        setVisible(IsControlPressed(0, 37))
    end
end)

-- Rafraîchit les pings pendant que le scoreboard reste affiché.
CreateThread(function()
    while true do
        Wait(2000)
        if visible then
            TriggerServerEvent('rp-scoreboard:server:requestPlayers')
        end
    end
end)
