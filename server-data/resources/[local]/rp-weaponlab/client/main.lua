local QBCore = exports['qb-core']:GetCoreObject()
local isCrafting = false

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

RegisterNetEvent('rp-weaponlab:client:startCraft', function(duration, labIndex, isOwner)
    isCrafting = true
    QBCore.Functions.Progressbar('weapon_craft', 'Fabrication en cours...', duration, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function()
        TriggerServerEvent('rp-weaponlab:server:finishCraft', labIndex, isOwner, true)
        isCrafting = false
    end, function()
        TriggerServerEvent('rp-weaponlab:server:finishCraft', labIndex, isOwner, false)
        isCrafting = false
    end)
end)

CreateThread(function()
    while true do
        local sleep = 1000
        local coords = GetEntityCoords(PlayerPedId())

        for i, lab in ipairs(Config.Labs) do
            local dist = #(coords - lab.coords)
            if dist < Config.MarkerDistance then
                sleep = 0
                DrawMarker(2, lab.coords.x, lab.coords.y, lab.coords.z - 0.9, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                    0.4, 0.4, 0.4, 150, 30, 30, 150, false, true, 2, false, nil, nil, false)

                if dist < Config.InteractDistance and not isCrafting then
                    DrawText3D(lab.coords, '[E] Fabriquer une arme - ' .. lab.label)
                    if IsControlJustReleased(0, 38) then -- E
                        TriggerServerEvent('rp-weaponlab:server:craft', i)
                    end
                end
            end
        end

        Wait(sleep)
    end
end)
