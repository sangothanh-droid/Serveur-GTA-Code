local QBCore = exports['qb-core']:GetCoreObject()
local lastAttempt = {} -- [src] = os.time()
local pending = {}     -- [src] = { startTime, resolved }

RegisterNetEvent('rp-arcade:server:attempt', function()
    local src = source
    local now = os.time()
    if lastAttempt[src] and (now - lastAttempt[src]) < (Config.CooldownMs / 1000) then
        TriggerClientEvent('QBCore:Notify', src, 'Attendez un peu avant de rejouer.', 'error')
        TriggerClientEvent('rp-arcade:client:result', src, false, 0)
        return
    end

    local coords = GetEntityCoords(GetPlayerPed(src))
    local nearMachine = false
    for _, machine in ipairs(Config.Machines) do
        if #(coords - machine.coords) <= Config.InteractDistance then
            nearMachine = true
            break
        end
    end
    if not nearMachine then
        TriggerClientEvent('rp-arcade:client:result', src, false, 0)
        return
    end

    lastAttempt[src] = now

    local delay = math.random(Config.MinDelayMs, Config.MaxDelayMs)
    SetTimeout(delay, function()
        if not GetPlayerName(src) then
            return -- le joueur s'est déconnecté pendant le délai
        end

        pending[src] = { startTime = GetGameTimer(), resolved = false }
        TriggerClientEvent('rp-arcade:client:go', src)

        SetTimeout(Config.ReactionTimeoutMs, function()
            local p = pending[src]
            if p and not p.resolved then
                p.resolved = true
                TriggerClientEvent('rp-arcade:client:result', src, false, 0)
            end
        end)
    end)
end)

RegisterNetEvent('rp-arcade:server:react', function()
    local src = source
    local p = pending[src]
    if not p or p.resolved then
        return
    end
    p.resolved = true

    local elapsed = GetGameTimer() - p.startTime
    if elapsed <= Config.MaxReactionMs then
        local Player = QBCore.Functions.GetPlayer(src)
        if Player then
            Player.Functions.AddMoney('cash', Config.Reward, 'arcade-win')
        end
        TriggerClientEvent('rp-arcade:client:result', src, true, Config.Reward)
    else
        TriggerClientEvent('rp-arcade:client:result', src, false, 0)
    end
end)

AddEventHandler('playerDropped', function()
    local src = source
    lastAttempt[src] = nil
    pending[src] = nil
end)
