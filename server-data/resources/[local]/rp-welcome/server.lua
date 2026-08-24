local Config = {
    -- Webhook Discord pour les logs de connexion (laisser vide pour désactiver).
    DiscordWebhook = GetConvar('rp_welcome_discord_webhook', ''),
    RulesText = table.concat({
        "1. Respect entre joueurs : pas d'insultes ni de discrimination.",
        "2. Roleplay réaliste obligatoire (RDM/VDM interdits).",
        "3. Pas de méta-gaming ni de power-gaming.",
        "4. Aucune triche, exploit ou script tiers.",
        "5. Le staff a le dernier mot en cas de litige.",
    }, '\n'),
}

local function sendDiscordLog(message)
    if Config.DiscordWebhook == '' then
        return
    end
    PerformHttpRequest(Config.DiscordWebhook, function() end, 'POST',
        json.encode({ content = message }),
        { ['Content-Type'] = 'application/json' })
end

RegisterNetEvent('rp-welcome:server:requestRules', function()
    local src = source
    TriggerClientEvent('rp-welcome:client:showRules', src, Config.RulesText)
end)

RegisterNetEvent('rp-welcome:server:rulesAccepted', function()
    local src = source
    sendDiscordLog(('✅ **%s** a accepté le règlement et rejoint le serveur.'):format(GetPlayerName(src)))
end)

AddEventHandler('playerDropped', function(reason)
    local name = GetPlayerName(source)
    if name then
        sendDiscordLog(('🔴 **%s** a quitté le serveur (%s).'):format(name, reason))
    end
end)
