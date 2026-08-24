local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('rp-casino:server:play', function(rawAmount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then
        return
    end

    local amount = math.floor(tonumber(rawAmount) or 0)
    if amount < Config.MinBet or amount > Config.MaxBet then
        TriggerClientEvent('QBCore:Notify', src,
            ('Mise invalide (entre $%d et $%d).'):format(Config.MinBet, Config.MaxBet), 'error')
        return
    end

    local dist = #(GetEntityCoords(GetPlayerPed(src)) - Config.TableLocation)
    if dist > Config.InteractDistance then
        TriggerClientEvent('QBCore:Notify', src, 'Approchez-vous de la table de jeu.', 'error')
        return
    end

    if Player.PlayerData.money.cash < amount then
        TriggerClientEvent('QBCore:Notify', src, "Vous n'avez pas assez d'argent liquide.", 'error')
        return
    end

    Player.Functions.RemoveMoney('cash', amount, 'casino-bet')

    if math.random(100) <= Config.WinChancePercent then
        local payout = math.floor(amount * Config.PayoutMultiplier)
        Player.Functions.AddMoney('cash', payout, 'casino-win')
        TriggerClientEvent('QBCore:Notify', src, ('Vous gagnez $%d !'):format(payout), 'success')
    else
        TriggerClientEvent('QBCore:Notify', src, ('Vous perdez votre mise de $%d.'):format(amount), 'error')
    end
end)

--- Vérifie que le joueur est bien près de la table et peut couvrir la mise ;
-- si oui, la retire et renvoie le Player. Sinon renvoie nil (et notifie).
local function tryPlaceBet(src, amount, minBet, maxBet, reason)
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then
        return nil
    end

    amount = math.floor(tonumber(amount) or 0)
    if amount < minBet or amount > maxBet then
        TriggerClientEvent('QBCore:Notify', src, ('Mise invalide (entre $%d et $%d).'):format(minBet, maxBet), 'error')
        return nil
    end

    if #(GetEntityCoords(GetPlayerPed(src)) - Config.TableLocation) > Config.InteractDistance then
        TriggerClientEvent('QBCore:Notify', src, 'Approchez-vous de la table de jeu.', 'error')
        return nil
    end

    if Player.PlayerData.money.cash < amount then
        TriggerClientEvent('QBCore:Notify', src, "Vous n'avez pas assez d'argent liquide.", 'error')
        return nil
    end

    Player.Functions.RemoveMoney('cash', amount, reason)
    return Player
end

-- =====================================================================
-- Machine à sous (/slots)
-- =====================================================================

RegisterNetEvent('rp-casino:server:slots', function(rawAmount)
    local src = source
    local cfg = Config.Slots
    local Player = tryPlaceBet(src, rawAmount, cfg.MinBet, cfg.MaxBet, 'casino-slots-bet')
    if not Player then
        return
    end
    local amount = math.floor(tonumber(rawAmount))

    local reels = {}
    for i = 1, 3 do
        reels[i] = cfg.Symbols[math.random(#cfg.Symbols)]
    end

    local counts = {}
    for _, symbol in ipairs(reels) do
        counts[symbol] = (counts[symbol] or 0) + 1
    end
    local best = 1
    for _, count in pairs(counts) do
        if count > best then
            best = count
        end
    end

    local reelText = table.concat(reels, ' | ')
    local payout = 0
    if best == 3 then
        payout = math.floor(amount * cfg.ThreeMatchMultiplier)
    elseif best == 2 then
        payout = math.floor(amount * cfg.TwoMatchMultiplier)
    end

    if payout > 0 then
        Player.Functions.AddMoney('cash', payout, 'casino-slots-win')
        TriggerClientEvent('QBCore:Notify', src, ('[%s] Vous gagnez $%d !'):format(reelText, payout), 'success')
    else
        TriggerClientEvent('QBCore:Notify', src, ('[%s] Perdu, mise de $%d envolée.'):format(reelText, amount), 'error')
    end
end)

-- =====================================================================
-- Blackjack simplifié (une seule main, pas de split/double)
-- =====================================================================

local blackjackHands = {} -- [src] = { bet, playerCards, dealerCards }

local function drawCard()
    local value = math.random(1, 13)
    if value > 10 then
        value = 10 -- valets/dames/rois
    elseif value == 1 then
        value = 11 -- as (compté haut par défaut, ajusté par handValue)
    end
    return value
end

local function handValue(cards)
    local total = 0
    local aces = 0
    for _, card in ipairs(cards) do
        total = total + card
        if card == 11 then
            aces = aces + 1
        end
    end
    while total > 21 and aces > 0 do
        total = total - 10
        aces = aces - 1
    end
    return total
end

local function describeHand(cards)
    return table.concat(cards, '+') .. (' = %d'):format(handValue(cards))
end

RegisterNetEvent('rp-casino:server:blackjackStart', function(rawAmount)
    local src = source
    if blackjackHands[src] then
        TriggerClientEvent('QBCore:Notify', src, 'Terminez votre main en cours (/bjhit ou /bjstand).', 'error')
        return
    end

    local cfg = Config.Blackjack
    local Player = tryPlaceBet(src, rawAmount, cfg.MinBet, cfg.MaxBet, 'casino-blackjack-bet')
    if not Player then
        return
    end

    local hand = {
        bet = math.floor(tonumber(rawAmount)),
        playerCards = { drawCard(), drawCard() },
        dealerCards = { drawCard() },
    }
    blackjackHands[src] = hand

    TriggerClientEvent('chat:addMessage', src, {
        args = { '^3[BLACKJACK]', ('Votre main : %s | Carte visible du croupier : %d'):format(
            describeHand(hand.playerCards), hand.dealerCards[1]) }
    })

    if handValue(hand.playerCards) == 21 then
        TriggerClientEvent('chat:addMessage', src, { args = { '^3[BLACKJACK]', 'Blackjack ! Faites /bjstand pour encaisser.' } })
    else
        TriggerClientEvent('chat:addMessage', src, { args = { '^3[BLACKJACK]', 'Faites /bjhit pour tirer, ou /bjstand pour rester.' } })
    end
end)

local function resolveBlackjack(src, playerBusted)
    local hand = blackjackHands[src]
    blackjackHands[src] = nil
    if not hand then
        return
    end

    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then
        return
    end

    local playerTotal = handValue(hand.playerCards)

    if playerBusted then
        TriggerClientEvent('chat:addMessage', src,
            { args = { '^3[BLACKJACK]', ('Vous dépassez 21 (%d) : mise de $%d perdue.'):format(playerTotal, hand.bet) } })
        return
    end

    -- Le croupier tire jusqu'à Config.Blackjack.DealerStandsOn.
    while handValue(hand.dealerCards) < Config.Blackjack.DealerStandsOn do
        table.insert(hand.dealerCards, drawCard())
    end
    local dealerTotal = handValue(hand.dealerCards)

    TriggerClientEvent('chat:addMessage', src, {
        args = { '^3[BLACKJACK]', ('Main du croupier : %s'):format(describeHand(hand.dealerCards)) }
    })

    if dealerTotal > 21 or playerTotal > dealerTotal then
        local payout = hand.bet * 2
        Player.Functions.AddMoney('cash', payout, 'casino-blackjack-win')
        TriggerClientEvent('QBCore:Notify', src, ('Vous gagnez $%d !'):format(payout), 'success')
    elseif playerTotal == dealerTotal then
        Player.Functions.AddMoney('cash', hand.bet, 'casino-blackjack-push')
        TriggerClientEvent('QBCore:Notify', src, 'Égalité, mise remboursée.', 'primary')
    else
        TriggerClientEvent('QBCore:Notify', src, ('Le croupier gagne : mise de $%d perdue.'):format(hand.bet), 'error')
    end
end

RegisterNetEvent('rp-casino:server:blackjackHit', function()
    local src = source
    local hand = blackjackHands[src]
    if not hand then
        TriggerClientEvent('QBCore:Notify', src, 'Aucune main en cours (/blackjack <montant>).', 'error')
        return
    end

    table.insert(hand.playerCards, drawCard())
    local total = handValue(hand.playerCards)
    TriggerClientEvent('chat:addMessage', src, { args = { '^3[BLACKJACK]', ('Votre main : %s'):format(describeHand(hand.playerCards)) } })

    if total > 21 then
        resolveBlackjack(src, true)
    elseif total == 21 then
        resolveBlackjack(src, false)
    end
end)

RegisterNetEvent('rp-casino:server:blackjackStand', function()
    resolveBlackjack(source, false)
end)

-- =====================================================================
-- Paris hippiques (/horsebet)
-- =====================================================================

local horseBets = {} -- [src] = { horseIndex, amount }

local function findHorseIndex(name)
    for i, horse in ipairs(Config.HorseRace.Horses) do
        if horse.name:lower() == name:lower() then
            return i
        end
    end
    return nil
end

RegisterNetEvent('rp-casino:server:horsebet', function(horseName, rawAmount)
    local src = source
    if horseBets[src] then
        TriggerClientEvent('QBCore:Notify', src, 'Vous avez déjà parié sur cette course.', 'error')
        return
    end

    local horseIndex = findHorseIndex(horseName)
    if not horseIndex then
        local names = {}
        for _, horse in ipairs(Config.HorseRace.Horses) do
            table.insert(names, horse.name)
        end
        TriggerClientEvent('QBCore:Notify', src, ('Chevaux : %s'):format(table.concat(names, ', ')), 'error')
        return
    end

    local cfg = Config.HorseRace
    local Player = tryPlaceBet(src, rawAmount, cfg.MinBet, cfg.MaxBet, 'casino-horsebet')
    if not Player then
        return
    end

    horseBets[src] = { horseIndex = horseIndex, amount = math.floor(tonumber(rawAmount)) }
    TriggerClientEvent('QBCore:Notify', src,
        ('Pari placé sur %s.'):format(Config.HorseRace.Horses[horseIndex].name), 'success')
end)

local function runHorseRace()
    local horses = Config.HorseRace.Horses
    local totalWeight = 0
    for _, horse in ipairs(horses) do
        totalWeight = totalWeight + horse.winChancePercent
    end

    local roll = math.random() * totalWeight
    local winnerIndex = #horses
    local cumulative = 0
    for i, horse in ipairs(horses) do
        cumulative = cumulative + horse.winChancePercent
        if roll <= cumulative then
            winnerIndex = i
            break
        end
    end

    local winner = horses[winnerIndex]
    TriggerClientEvent('chat:addMessage', -1,
        { args = { '^2[COURSE]', ('%s remporte la course !'):format(winner.name) } })

    for src, bet in pairs(horseBets) do
        if bet.horseIndex == winnerIndex then
            local payout = math.floor(bet.amount * winner.odds)
            local Player = QBCore.Functions.GetPlayer(src)
            if Player then
                Player.Functions.AddMoney('cash', payout, 'casino-horsebet-win')
            end
            TriggerClientEvent('QBCore:Notify', src, ('Votre pari sur %s rapporte $%d !'):format(winner.name, payout), 'success')
        else
            TriggerClientEvent('QBCore:Notify', src, ('%s a gagné, votre pari est perdu.'):format(winner.name), 'error')
        end
    end

    horseBets = {}
end

CreateThread(function()
    while true do
        Wait(Config.HorseRace.RaceIntervalMs)
        runHorseRace()
    end
end)

AddEventHandler('playerDropped', function()
    local src = source
    blackjackHands[src] = nil
    horseBets[src] = nil
end)
