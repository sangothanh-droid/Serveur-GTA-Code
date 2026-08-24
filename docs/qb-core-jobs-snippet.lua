-- À ajouter dans server-data/resources/[qb]/qb-core/shared/jobs.lua
-- (dans la table QBCore.Shared.Jobs), pour rp-mechanic, rp-security,
-- rp-realestate, rp-firefighter, rp-restaurant et rp-nightclub qui
-- nécessitent un métier assigné (/job pour un admin, ou qb-multicharacter
-- à la création du personnage selon votre configuration).
--
-- rp-police et rp-ambulance utilisent les jobs 'police' et 'ambulance'
-- DÉJÀ définis par défaut dans qb-core/shared/jobs.lua : rien à ajouter
-- pour eux.
--
-- rp-taxi, rp-delivery, rp-garbage, rp-lumberjack, rp-fisherman, rp-postal,
-- rp-busker, rp-carwash et rp-barber sont volontairement ouverts à tous les
-- joueurs (pas de job requis), voir docs/CRIME-JOBS.md et docs/LEGAL-JOBS.md.
--
-- NOTE : ce fichier utilise QBCore.Shared.Jobs (et non QBShared.Jobs, qui
-- n'existe pas dans ce fork de qb-core) pour correspondre exactement à la
-- syntaxe attendue par qb-core/shared/jobs.lua.

QBCore.Shared.Jobs['mechanic'] = {
    label = 'Mécanicien',
    defaultDuty = true,
    offDutyPay = false,
    grades = {
        ['0'] = { name = 'Apprenti', payment = 50 },
        ['1'] = { name = 'Mécanicien', payment = 75 },
        ['2'] = { name = "Chef d'atelier", payment = 100, isboss = true },
    },
}

QBCore.Shared.Jobs['security'] = {
    label = 'Agent de sécurité',
    defaultDuty = true,
    offDutyPay = false,
    grades = {
        ['0'] = { name = 'Agent', payment = 60 },
        ['1'] = { name = 'Superviseur', payment = 90, isboss = true },
    },
}

QBCore.Shared.Jobs['realestate'] = {
    label = 'Agent immobilier',
    defaultDuty = true,
    offDutyPay = false,
    grades = {
        ['0'] = { name = 'Agent', payment = 70 },
        ['1'] = { name = 'Agent senior', payment = 110, isboss = true },
    },
}

QBCore.Shared.Jobs['fire'] = {
    label = 'Pompier',
    defaultDuty = true,
    offDutyPay = false,
    grades = {
        ['0'] = { name = 'Pompier', payment = 60 },
        ['1'] = { name = 'Pompier senior', payment = 90, isboss = true },
    },
}

QBCore.Shared.Jobs['burgershot'] = {
    label = 'Burgershot',
    defaultDuty = true,
    offDutyPay = false,
    grades = {
        ['0'] = { name = 'Employé', payment = 45 },
        ['1'] = { name = 'Manager', payment = 70, isboss = true },
    },
}

QBCore.Shared.Jobs['dj'] = {
    label = 'DJ',
    defaultDuty = true,
    offDutyPay = false,
    grades = {
        ['0'] = { name = 'DJ résident', payment = 80, isboss = true },
    },
}
