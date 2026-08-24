local QBCore = exports['qb-core']:GetCoreObject()

local function GetPlayerJob(src)
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then
        return nil
    end
    return Player.PlayerData.job.name, Player.PlayerData.job.onduty
end

local function AddMoney(src, amount, account)
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then
        return
    end
    Player.Functions.AddMoney(account or 'cash', amount)
end

exports('GetPlayerJob', GetPlayerJob)
exports('AddMoney', AddMoney)
