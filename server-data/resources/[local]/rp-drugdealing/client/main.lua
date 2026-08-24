local function GetClosestPed()
    local ped = PlayerPedId()
    local pedCoords = GetEntityCoords(ped)
    local closestPed, closestDist = nil, Config.NpcSearchRadius

    for _, otherPed in ipairs(GetGamePool('CPed')) do
        if otherPed ~= ped and not IsPedAPlayer(otherPed) and IsEntityAPed(otherPed) then
            local dist = #(pedCoords - GetEntityCoords(otherPed))
            if dist < closestDist then
                closestDist = dist
                closestPed = otherPed
            end
        end
    end

    return closestPed
end

RegisterCommand(Config.CommandName, function()
    local target = GetClosestPed()
    if not target then
        TriggerEvent('QBCore:Notify', 'Aucun client à proximité.', 'error')
        return
    end
    TriggerServerEvent('rp-drugdealing:server:attemptSale')
end, false)
