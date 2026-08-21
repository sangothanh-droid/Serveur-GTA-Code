Config = {}

-- Paliers de réputation : plus un gang commet d'actions criminelles, plus il
-- monte de palier, avec des conséquences croissantes (police, économie).
Config.Tiers = {
    { threshold = 0,    label = 'Inconnu',       policeMultiplier = 1.0, incomeMultiplier = 1.0  },
    { threshold = 100,  label = 'Surveillé',     policeMultiplier = 1.3, incomeMultiplier = 1.1  },
    { threshold = 300,  label = 'Recherché',     policeMultiplier = 1.6, incomeMultiplier = 1.25 },
    { threshold = 600,  label = 'Dangereux',     policeMultiplier = 2.0, incomeMultiplier = 1.5  },
    { threshold = 1000, label = 'Ennemi public', policeMultiplier = 2.5, incomeMultiplier = 1.75 },
}

-- Points perdus par heure d'inactivité du gang (pour redescendre de palier).
Config.ReputationDecayPerHour = 5
Config.MinReputation = 0
