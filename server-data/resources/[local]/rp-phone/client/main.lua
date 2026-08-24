local QBCore = exports['qb-core']:GetCoreObject()
local phoneOpen = false

local function sendBankUpdate()
    local PlayerData = QBCore.Functions.GetPlayerData()
    local money = PlayerData and PlayerData.money or {}
    SendNUIMessage({
        action = 'bankUpdate',
        cash = money.cash or 0,
        bank = money.bank or 0,
    })
end

local function setPhoneOpen(open)
    phoneOpen = open
    SetNuiFocus(open, open)
    SendNUIMessage({ action = open and 'open' or 'close' })
    if open then
        sendBankUpdate()
    end
end

RegisterKeyMapping('phone', 'Ouvrir/fermer le téléphone', 'keyboard', 'F1')
RegisterCommand('phone', function()
    setPhoneOpen(not phoneOpen)
end, false)

RegisterNUICallback('close', function(_, cb)
    setPhoneOpen(false)
    cb('ok')
end)

RegisterNUICallback('sendMessage', function(data, cb)
    TriggerServerEvent('rp-phone:server:sendMessage', tonumber(data.targetId), data.text)
    cb('ok')
end)

RegisterNetEvent('rp-phone:client:receiveMessage', function(fromName, text, fromId)
    SendNUIMessage({ action = 'message', direction = 'in', name = fromName, id = fromId, text = text })
end)

RegisterNetEvent('rp-phone:client:messageSent', function(toName, text, toId)
    SendNUIMessage({ action = 'message', direction = 'out', name = toName, id = toId, text = text })
end)

RegisterNetEvent('rp-phone:client:messageFailed', function(reason)
    TriggerEvent('QBCore:Notify', reason, 'error')
end)

-- Rafraîchit le solde pendant que le téléphone reste ouvert.
CreateThread(function()
    while true do
        Wait(3000)
        if phoneOpen then
            sendBankUpdate()
        end
    end
end)
