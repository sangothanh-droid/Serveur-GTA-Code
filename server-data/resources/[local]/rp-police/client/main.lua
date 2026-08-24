local isCuffed = false

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

--- Renvoie le joueur (server id) le plus proche dans un rayon donné, ou nil.
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

--- Renvoie le netId du véhicule le plus proche dans un rayon donné, ou nil.
local function GetClosestVehicleNetId(maxDistance)
    local coords = GetEntityCoords(PlayerPedId())
    local closestVeh, closestDist = nil, maxDistance

    for _, veh in ipairs(GetGamePool('CVehicle')) do
        local dist = #(coords - GetEntityCoords(veh))
        if dist < closestDist then
            closestDist = dist
            closestVeh = veh
        end
    end

    return closestVeh and NetworkGetNetworkIdFromEntity(closestVeh) or nil
end

RegisterCommand('cuff', function()
    local target = GetClosestPlayer(Config.CuffDistance)
    if not target then
        TriggerEvent('QBCore:Notify', 'Aucun joueur à proximité.', 'error')
        return
    end
    TriggerServerEvent('rp-police:server:cuff', target, true)
end, false)

RegisterCommand('uncuff', function()
    local target = GetClosestPlayer(Config.CuffDistance)
    if not target then
        TriggerEvent('QBCore:Notify', 'Aucun joueur à proximité.', 'error')
        return
    end
    TriggerServerEvent('rp-police:server:cuff', target, false)
end, false)

RegisterCommand('search', function()
    local target = GetClosestPlayer(Config.SearchDistance)
    if not target then
        TriggerEvent('QBCore:Notify', 'Aucun joueur à proximité.', 'error')
        return
    end
    TriggerServerEvent('rp-police:server:search', target)
end, false)

RegisterCommand('ticket', function(_, args)
    local amount = tonumber(args[1])
    local reason = table.concat(args, ' ', 2)
    if not amount or reason == '' then
        TriggerEvent('QBCore:Notify', 'Utilisation : /ticket <montant> <raison>', 'error')
        return
    end
    local target = GetClosestPlayer(Config.TicketDistance)
    if not target then
        TriggerEvent('QBCore:Notify', 'Aucun joueur à proximité.', 'error')
        return
    end
    TriggerServerEvent('rp-police:server:ticket', target, amount, reason)
end, false)

RegisterCommand('impound', function()
    local netId = GetClosestVehicleNetId(Config.ImpoundDistance)
    if not netId then
        TriggerEvent('QBCore:Notify', 'Aucun véhicule à proximité.', 'error')
        return
    end
    TriggerServerEvent('rp-police:server:impound', netId)
end, false)

RegisterNetEvent('rp-police:client:setCuffed', function(state)
    isCuffed = state
    local ped = PlayerPedId()

    if state then
        RequestAnimDict('mp_arresting')
        while not HasAnimDictLoaded('mp_arresting') do
            Wait(10)
        end
        TaskPlayAnim(ped, 'mp_arresting', 'idle', 8.0, -8.0, -1, 49, 0, false, false, false)
        TriggerEvent('QBCore:Notify', 'Vous êtes menotté.', 'error')
    else
        ClearPedTasks(ped)
        TriggerEvent('QBCore:Notify', 'Vous êtes libéré.', 'success')
    end
end)

CreateThread(function()
    while true do
        local sleep = 500
        if isCuffed then
            sleep = 0
            DisableControlAction(0, 24, true)  -- attaque
            DisableControlAction(0, 25, true)  -- viser
            DisableControlAction(0, 47, true)  -- arme
            DisableControlAction(0, 58, true)  -- arme
            DisableControlAction(0, 263, true) -- corps à corps
            DisableControlAction(0, 264, true)
            DisableControlAction(0, 257, true)
            DisableControlAction(0, 140, true)
            DisableControlAction(0, 141, true)
            DisableControlAction(0, 142, true)
            DisableControlAction(0, 143, true)
            DisableControlAction(0, 75, true)  -- sortir du véhicule
            DisableControlAction(0, 21, true)  -- sprint
            DisableControlAction(0, 22, true)  -- sauter
            DisableControlAction(0, 23, true)  -- entrer véhicule
        end
        Wait(sleep)
    end
end)

CreateThread(function()
    while true do
        local sleep = 1000
        local coords = GetEntityCoords(PlayerPedId())
        local dist = #(coords - Config.Station.coords)

        if dist < 20.0 then
            sleep = 0
            DrawMarker(2, Config.Station.coords.x, Config.Station.coords.y, Config.Station.coords.z - 0.9,
                0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 40, 80, 220, 150, false, true, 2, false, nil, nil, false)

            if dist < Config.SpawnDistance then
                DrawText3D(Config.Station.coords, '[E] Prendre un véhicule de service')
                if IsControlJustReleased(0, 38) then -- E
                    TriggerServerEvent('rp-police:server:requestVehicleSpawn')
                end
            end
        end

        Wait(sleep)
    end
end)

RegisterNetEvent('rp-police:client:deleteVehicle', function(netId)
    local veh = NetworkGetEntityFromNetworkId(netId)
    if DoesEntityExist(veh) then
        DeleteEntity(veh)
    end
end)

RegisterNetEvent('rp-police:client:spawnVehicle', function(model, coords, heading)
    local hash = GetHashKey(model)
    RequestModel(hash)
    while not HasModelLoaded(hash) do
        Wait(10)
    end

    local veh = CreateVehicle(hash, coords.x, coords.y, coords.z, heading, true, false)
    SetVehicleOnGroundProperly(veh)
    SetPedIntoVehicle(PlayerPedId(), veh, -1)
    SetModelAsNoLongerNeeded(hash)
end)

-- Voir docs/HUD-THEME.md : bleu foncé (29) réservé à la police.
CreateThread(function()
    local blip = AddBlipForCoord(Config.Station.coords.x, Config.Station.coords.y, Config.Station.coords.z)
    SetBlipSprite(blip, 60)
    SetBlipColour(blip, 29)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName(Config.Station.label)
    EndTextCommandSetBlipName(blip)
end)
