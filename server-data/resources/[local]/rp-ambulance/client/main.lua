local isDowned = false

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

CreateThread(function()
    exports.spawnmanager:setAutoSpawn(false)
end)

-- Détecte la "mort" du joueur et la remplace par un état "à terre" au sol
-- plutôt qu'un respawn immédiat.
CreateThread(function()
    while true do
        Wait(500)
        local ped = PlayerPedId()
        if not isDowned and IsPedDeadOrDying(ped, true) then
            isDowned = true
            TriggerServerEvent('rp-ambulance:server:playerDowned')
            ClearPedTasksImmediately(ped)
            SetEntityHealth(ped, 110)
            SetPedToRagdoll(ped, 15000, 15000, 0, false, false, false)
            TriggerEvent('QBCore:Notify', 'Vous êtes à terre. Attendez les secours (/revive).', 'error')
        end
    end
end)

CreateThread(function()
    while true do
        local sleep = 500
        if isDowned then
            sleep = 0
            local ped = PlayerPedId()
            DisableControlAction(0, 24, true)
            DisableControlAction(0, 25, true)
            DisableControlAction(0, 47, true)
            DisableControlAction(0, 58, true)
            DisableControlAction(0, 21, true)
            DisableControlAction(0, 22, true)
            DisableControlAction(0, 23, true)
            DisableControlAction(0, 75, true)
            DisableControlAction(0, 30, true)
            DisableControlAction(0, 31, true)
            if GetEntityHealth(ped) > 110 then
                SetEntityHealth(ped, 110)
            end
        end
        Wait(sleep)
    end
end)

RegisterNetEvent('rp-ambulance:client:revive', function()
    isDowned = false
    local ped = PlayerPedId()
    ClearPedTasksImmediately(ped)
    SetEntityHealth(ped, Config.ReviveHealth)
    TriggerEvent('QBCore:Notify', 'Vous avez été relevé par les secours !', 'success')
end)

RegisterNetEvent('rp-ambulance:client:healed', function(amount)
    SetEntityHealth(PlayerPedId(), amount)
    TriggerEvent('QBCore:Notify', 'Vous avez été soigné.', 'success')
end)

RegisterCommand('revive', function()
    local target = GetClosestPlayer(Config.ReviveDistance)
    if not target then
        TriggerEvent('QBCore:Notify', 'Aucun joueur à proximité.', 'error')
        return
    end
    TriggerServerEvent('rp-ambulance:server:revive', target)
end, false)

RegisterCommand('heal', function()
    local target = GetClosestPlayer(Config.HealDistance)
    if not target then
        TriggerEvent('QBCore:Notify', 'Aucun joueur à proximité.', 'error')
        return
    end
    TriggerServerEvent('rp-ambulance:server:heal', target)
end, false)

RegisterNetEvent('rp-ambulance:client:spawnVehicle', function(model, coords, heading)
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

CreateThread(function()
    while true do
        local sleep = 1000
        local coords = GetEntityCoords(PlayerPedId())
        local dist = #(coords - Config.Hospital.coords)

        if dist < 20.0 then
            sleep = 0
            DrawMarker(2, Config.Hospital.coords.x, Config.Hospital.coords.y, Config.Hospital.coords.z - 0.9,
                0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 220, 40, 40, 150, false, true, 2, false, nil, nil, false)

            if dist < Config.SpawnDistance then
                DrawText3D(Config.Hospital.coords, '[E] Prendre un véhicule de service')
                if IsControlJustReleased(0, 38) then -- E
                    TriggerServerEvent('rp-ambulance:server:requestVehicleSpawn')
                end
            end
        end

        Wait(sleep)
    end
end)

-- Voir docs/HUD-THEME.md : blanc (0) réservé à l'ambulance (le sprite
-- "Hospital" est déjà une croix rouge sur fond blanc).
CreateThread(function()
    local blip = AddBlipForCoord(Config.Hospital.coords.x, Config.Hospital.coords.y, Config.Hospital.coords.z)
    SetBlipSprite(blip, 61)
    SetBlipColour(blip, 0)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName(Config.Hospital.label)
    EndTextCommandSetBlipName(blip)
end)
