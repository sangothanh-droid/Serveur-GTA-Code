-- À fusionner dans server-data/resources/[qb]/qb-core/shared/gangs.lua
-- (une fois ./setup.sh exécuté) pour que les grades internes des gangs
-- soient reconnus par QBCore (permissions, qb-multicharacter, etc.).
--
-- Ce fichier doit rester synchronisé avec
-- server-data/resources/[local]/rp-gangs/shared/gangs.lua (source de
-- vérité pour la réputation/territoires/véhicules/tenues).

QBShared.Gangs['eastside_locos'] = {
    label = 'East Side Locos',
    grades = {
        ['0'] = 'Recrue',
        ['1'] = 'Soldat',
        ['2'] = 'Lieutenant',
        ['3'] = 'Boss',
    },
}

QBShared.Gangs['reapers_18th'] = {
    label = '18th Street Reapers',
    grades = {
        ['0'] = 'Recrue',
        ['1'] = 'Soldat',
        ['2'] = 'Lieutenant',
        ['3'] = 'Boss',
    },
}

QBShared.Gangs['antonelli_family'] = {
    label = 'Antonelli Family',
    grades = {
        ['0'] = 'Associé',
        ['1'] = 'Soldat',
        ['2'] = 'Capo',
        ['3'] = 'Consigliere',
        ['4'] = 'Don',
    },
}

QBShared.Gangs['culebra_cartel'] = {
    label = 'Culebra Cartel',
    grades = {
        ['0'] = 'Mule',
        ['1'] = 'Sicario',
        ['2'] = 'Lieutenant',
        ['3'] = 'Jefe',
    },
}

QBShared.Gangs['iron_vultures_mc'] = {
    label = 'Iron Vultures MC',
    grades = {
        ['0'] = 'Prospect',
        ['1'] = 'Membre',
        ['2'] = "Sergent d'armes",
        ['3'] = 'Président',
    },
}
