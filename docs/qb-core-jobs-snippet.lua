-- À ajouter dans server-data/resources/[qb]/qb-core/shared/jobs.lua
-- (dans la table QBShared.Jobs), pour rp-mechanic, rp-security et
-- rp-realestate qui nécessitent un métier assigné (/job pour un admin, ou
-- qb-multicharacter à la création du personnage selon votre configuration).
--
-- rp-taxi, rp-delivery, rp-garbage, rp-lumberjack, rp-fisherman, rp-postal
-- et rp-busker sont volontairement ouverts à tous les joueurs (pas de job
-- requis), voir docs/CRIME-JOBS.md et docs/LEGAL-JOBS.md.

QBShared.Jobs['mechanic'] = {
    label = 'Mécanicien',
    defaultDuty = true,
    offDutyPay = false,
    grades = {
        ['0'] = { name = 'Apprenti', payment = 50 },
        ['1'] = { name = 'Mécanicien', payment = 75 },
        ['2'] = { name = "Chef d'atelier", payment = 100, isboss = true },
    },
}

QBShared.Jobs['security'] = {
    label = 'Agent de sécurité',
    defaultDuty = true,
    offDutyPay = false,
    grades = {
        ['0'] = { name = 'Agent', payment = 60 },
        ['1'] = { name = 'Superviseur', payment = 90, isboss = true },
    },
}

QBShared.Jobs['realestate'] = {
    label = 'Agent immobilier',
    defaultDuty = true,
    offDutyPay = false,
    grades = {
        ['0'] = { name = 'Agent', payment = 70 },
        ['1'] = { name = 'Agent senior', payment = 110, isboss = true },
    },
}
