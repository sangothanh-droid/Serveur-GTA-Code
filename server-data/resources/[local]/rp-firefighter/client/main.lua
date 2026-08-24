local QBCore = exports['qb-core']:GetCoreObject()

local activeFire = nil -- { coords, label }
local fireProp = nil
local isExtinguishing = false

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

RegisterNetEvent('rp-firefighter:client:setFire', function(coords, label)
    activeFire = { coords = coords, label = label }

    local hash = GetHashKey('prop_beach_fire01x')
    RequestModel(hash)
    while not HasModelLoaded(hash) do
        Wait(10)
    end
    fireProp = CreateObject(hash, coords.x, coords.y, coords.z - 1.0, false, false, false)
    SetModelAsNoLongerNeeded(hash)

    TriggerEvent('chat:addMessage', { args = { '^1[INCENDIE]', ('Un incendie s\'est déclaré : %s'):format(label) } })
end)

RegisterNetEvent('rp-firefighter:client:clearFire', function()
    activeFire = nil
    if fireProp and DoesEntityExist(fireProp) then
        DeleteEntity(fireProp)
    end
    fireProp = nil
end)

RegisterNetEvent('rp-firefighter:client:startExtinguish', function(duration)
    isExtinguishing = true
    QBCore.Functions.Progressbar('firefighter_extinguish', "Extinction de l'incendie...", duration, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function()
        TriggerServerEvent('rp-firefighter:server:finish', true)
        isExtinguishing = false
    end, function()
        TriggerServerEvent('rp-firefighter:server:finish', false)
        isExtinguishing = false
    end)
end)

CreateThread(function()
    while true do
        local sleep = 1000

        if activeFire then
            local coords = GetEntityCoords(PlayerPedId())
            local dist = #(coords - activeFire.coords)

            if dist < Config.MarkerDistance then
                sleep = 0
                DrawMarker(1, activeFire.coords.x, activeFire.coords.y, activeFire.coords.z, 0.0, 0.0, 0.0,
                    0.0, 0.0, 0.0, 2.5, 2.5, 2.0, 255, 100, 0, 140, false, true, 2, false, nil, nil, false)

                if dist < Config.InteractDistance and not isExtinguishing then
                    DrawText3D(activeFire.coords, "[E] Éteindre l'incendie")
                    if IsControlJustReleased(0, 38) then -- E
                        TriggerServerEvent('rp-firefighter:server:attempt')
                    end
                end
            end
        end

        Wait(sleep)
    end
end)
