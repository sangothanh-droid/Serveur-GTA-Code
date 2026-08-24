local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('rp-phone:server:sendMessage', function(targetId, text)
    local src = source
    text = tostring(text or ''):sub(1, 200)

    if not targetId or text == '' then
        return
    end

    if targetId == src then
        TriggerClientEvent('rp-phone:client:messageFailed', src, 'Vous ne pouvez pas vous envoyer un message.')
        return
    end

    local TargetPlayer = QBCore.Functions.GetPlayer(targetId)
    if not TargetPlayer then
        TriggerClientEvent('rp-phone:client:messageFailed', src, "Cet ID de joueur n'est pas connecté.")
        return
    end

    local senderName = GetPlayerName(src)
    TriggerClientEvent('rp-phone:client:receiveMessage', targetId, senderName, text, src)
    TriggerClientEvent('rp-phone:client:messageSent', src, GetPlayerName(targetId), text, targetId)
end)
