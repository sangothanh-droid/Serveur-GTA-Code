local QBCore = exports['qb-core']:GetCoreObject()

local activeTarget = nil
local targetBlip = nil
local hunting = false

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

RegisterNetEvent('rp-bountyhunter:client:setTarget', function(coords, label)
    activeTarget = coords

    if targetBlip then
        RemoveBlip(targetBlip)
    end
    targetBlip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(targetBlip, 93)
    SetBlipColour(targetBlip, 1)
    SetBlipFlashes(targetBlip, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName('Cible - ' .. label)
    EndTextCommandSetBlipName(targetBlip)
end)

RegisterNetEvent('rp-bountyhunter:client:clearTarget', function()
    activeTarget = nil
    if targetBlip then
        RemoveBlip(targetBlip)
        targetBlip = nil
    end
end)

RegisterNetEvent('rp-bountyhunter:client:startHunt', function(duration)
    hunting = true
    QBCore.Functions.Progressbar('bountyhunter_hunt', 'Traque de la cible...', duration, false, true, {
        disableMovement = false,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = false,
    }, {}, {}, {}, function()
        TriggerServerEvent('rp-bountyhunter:server:finishHunt', true)
        hunting = false
    end, function()
        TriggerServerEvent('rp-bountyhunter:server:finishHunt', false)
        hunting = false
    end)
end)

CreateThread(function()
    while true do
        local sleep = 1000

        if activeTarget and not hunting then
            local dist = #(GetEntityCoords(PlayerPedId()) - activeTarget)
            if dist < Config.BlipRenderDistance then
                sleep = 0
                DrawMarker(1, activeTarget.x, activeTarget.y, activeTarget.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                    3.0, 3.0, 2.0, 200, 30, 30, 120, false, true, 2, false, nil, nil, false)

                if dist < Config.InteractDistance then
                    DrawText3D(activeTarget, '[E] Affronter la cible')
                    if IsControlJustReleased(0, 38) then -- E
                        TriggerServerEvent('rp-bountyhunter:server:attemptClaim')
                    end
                end
            end
        end

        Wait(sleep)
    end
end)
