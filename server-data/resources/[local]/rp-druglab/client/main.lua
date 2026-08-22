local QBCore = exports['qb-core']:GetCoreObject()
local isCooking = false

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

RegisterNetEvent('rp-druglab:client:startCook', function(duration, labIndex, isOwner)
    isCooking = true
    QBCore.Functions.Progressbar('drug_cook', 'Cuisson en cours...', duration, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function()
        TriggerServerEvent('rp-druglab:server:finishCook', labIndex, isOwner, true)
        isCooking = false
    end, function()
        TriggerServerEvent('rp-druglab:server:finishCook', labIndex, isOwner, false)
        isCooking = false
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
                    0.4, 0.4, 0.4, 30, 180, 60, 150, false, true, 2, false, nil, nil, false)

                if dist < Config.InteractDistance and not isCooking then
                    DrawText3D(lab.coords, '[E] Cuisiner - ' .. lab.label)
                    if IsControlJustReleased(0, 38) then -- E
                        TriggerServerEvent('rp-druglab:server:cook', i)
                    end
                end
            end
        end

        Wait(sleep)
    end
end)
