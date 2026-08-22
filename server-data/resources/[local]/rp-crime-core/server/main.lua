local QBCore = exports['qb-core']:GetCoreObject()

--- Retourne le nom du gang du joueur, ou nil s'il n'en a pas.
local function GetPlayerGang(src)
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then
        return nil
    end
    local gang = Player.PlayerData.gang
    if not gang or gang.name == 'none' then
        return nil
    end
    return gang.name
end

local function AddMoney(src, amount, account)
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then
        return
    end
    Player.Functions.AddMoney(account or 'cash', amount)
end

--- Diffuse une alerte aux joueurs ayant le job "police" (compatible qb-policejob).
local function AlertPolice(coords, message)
    local players = QBCore.Functions.GetPlayers()
    for _, playerId in ipairs(players) do
        local Player = QBCore.Functions.GetPlayer(playerId)
        if Player and Player.PlayerData.job.name == 'police' then
            TriggerClientEvent('rp-crime-core:client:policeAlert', playerId, coords, message)
        end
    end
end

exports('GetPlayerGang', GetPlayerGang)
exports('AddMoney', AddMoney)
exports('AlertPolice', AlertPolice)
