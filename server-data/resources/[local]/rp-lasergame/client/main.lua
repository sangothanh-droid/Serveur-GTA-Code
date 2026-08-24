local inSession = false

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

local function GetClosestPlayer(maxDistance)
    local myPed = PlayerPedId()
    local myCoords = GetEntityCoords(myPed)
    local closestId, closestDist = nil, maxDistance

    for _, playerId in ipairs(GetActivePlayers()) do
        local ped = GetPlayerPed(playerId)
        if ped ~= myPed then
            local dist = #(myCoords - GetEntityCoords(ped))
            if dist < closestDist then
                closestDist = dist
                closestId = GetPlayerServerId(playerId)
            end
        end
    end

    return closestId
end

RegisterCommand(Config.CommandName, function(_, args)
    local sub = args[1]
    if sub == 'start' then
        TriggerServerEvent('rp-lasergame:server:start')
    elseif sub == 'join' then
        TriggerServerEvent('rp-lasergame:server:join')
    else
        TriggerEvent('QBCore:Notify', ('Utilisation : /%s start | /%s join'):format(Config.CommandName, Config.CommandName), 'error')
    end
end, false)

RegisterNetEvent('rp-lasergame:client:announce', function(message)
    TriggerEvent('chat:addMessage', { args = { '^5[LASERGAME]', message } })
end)

RegisterNetEvent('rp-lasergame:client:sessionStarted', function()
    inSession = true
    TriggerEvent('QBCore:Notify', 'La session commence : taguez les autres joueurs !', 'primary')
end)

RegisterNetEvent('rp-lasergame:client:sessionEnded', function(resultLines)
    inSession = false
    for _, line in ipairs(resultLines) do
        TriggerEvent('chat:addMessage', { args = { '^5[LASERGAME]', line } })
    end
end)

CreateThread(function()
    local blip = AddBlipForRadius(Config.Arena.coords.x, Config.Arena.coords.y, Config.Arena.coords.z, Config.Arena.radius)
    SetBlipColour(blip, 46) -- or : loisirs (voir docs/HUD-THEME.md)
    SetBlipAlpha(blip, 60)

    local marker = AddBlipForCoord(Config.Arena.coords.x, Config.Arena.coords.y, Config.Arena.coords.z)
    SetBlipSprite(marker, 314)
    SetBlipColour(marker, 46)
    SetBlipAsShortRange(marker, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName(Config.Arena.label)
    EndTextCommandSetBlipName(marker)
end)

CreateThread(function()
    while true do
        local sleep = 1000

        if inSession then
            local target = GetClosestPlayer(Config.TagRange)
            if target then
                sleep = 0
                DrawText3D(GetEntityCoords(PlayerPedId()), '[E] Tag')
                if IsControlJustReleased(0, 38) then -- E
                    TriggerServerEvent('rp-lasergame:server:tag', target)
                end
            end
        end

        Wait(sleep)
    end
end)
