# Loisirs et casino

Contenus purement récréatifs, ouverts à tous, sans lien avec les gangs, les
jobs ou la réputation de rue. Aucun ne casse l'économie : chaque jeu d'argent
garde un avantage "maison" et une limite de mise.

## Casino (`rp-casino`)

`rp-casino` (déjà existant) est étendu avec 3 jeux supplémentaires, tous
accessibles près de la même table de jeu (Diamond Casino & Resort).

| Jeu | Commande | Mise | Avantage maison |
|---|---|---|---|
| Mise simple (existant) | `/casino <montant>` | $50–2000 | 45% de gain, paiement x1.8 |
| Machine à sous | `/slots <montant>` | $20–500 | ~4% de triple, ~48% de double, ~48% de rien (espérance ≈ 78% de la mise) |
| Blackjack simplifié | `/blackjack <montant>`, puis `/bjhit` ou `/bjstand` | $50–1000 | Règles standards (croupier tire jusqu'à 17), une seule main, pas de split/double |
| Paris hippiques | `/horsebet <cheval> <montant>` | $20–500 | 4 chevaux à cotes différentes, tirage toutes les 5 min, espérance < 1 sur chaque cheval |

Les chevaux disponibles (`Config.HorseRace.Horses`) : **Tornado**, **Lucky
Star**, **Midnight**, **Comet** — cote et chance de victoire différentes par
cheval (voir `rp-casino/shared/config.lua`). Un seul pari actif par joueur
et par course ; les paris sont réglés automatiquement au tirage puis remis
à zéro.

Le blackjack garde une main active par joueur en mémoire serveur : `/bjhit`
tire une carte, `/bjstand` fait jouer le croupier et compare les mains. Pas
de split ni de double pour rester simple, comme demandé.

## Laser game (`rp-lasergame`)

Arène désignée (Elysian Island par défaut, `Config.Arena`) — aucune arme
réelle, juste de la proximité :

1. `/lasergame start` (dans l'arène) ouvre une fenêtre d'inscription de 30s,
   annoncée aux joueurs présents dans l'arène.
2. `/lasergame join` (dans l'arène, pendant la fenêtre) inscrit le joueur.
   Il faut au moins `Config.MinParticipants` (2) inscrits, sinon la partie
   est annulée.
3. Pendant `Config.SessionDurationMs` (3 min), chaque `[E]` sur un autre
   participant à moins de `Config.TagRange` (3m) marque un point
   (cooldown de 2s par cible pour éviter le spam).
4. À la fin, le classement est affiché dans le chat à tous les
   participants, et le(s) meilleur(s) score(s) reçoivent
   `Config.RewardTop` ($200 par défaut).

## Bornes d'arcade (`rp-arcade`)

Deux bornes (`Config.Machines`) proposent un mini-jeu de réflexe, gratuit à
tenter :

1. `[E]` sur la borne lance une tentative.
2. Après un délai aléatoire (`Config.MinDelayMs`–`Config.MaxDelayMs`), le
   jeu affiche "MAINTENANT ! [E]".
3. Il faut appuyer sur `[E]` en moins de `Config.MaxReactionMs` (400ms) pour
   gagner `Config.Reward` ($40) ; trop lent (ou pas de réaction du tout dans
   `Config.ReactionTimeoutMs`) : rien.

Le chronométrage est fait **côté serveur** (`GetGameTimer()` au moment du
signal et de la réaction) pour éviter qu'un client triche sur son propre
temps de réaction. Cooldown de `Config.CooldownMs` (15s) par joueur entre
deux tentatives.

## Installation

1. Aucun schéma SQL à importer pour ce fichier : tout l'état
   (mains de blackjack, paris hippiques, sessions de laser game,
   tentatives d'arcade) est en mémoire serveur, remis à zéro au
   redémarrage.
2. Aucun de ces contenus ne dépend de `rp-gangs`, `rp-crime-core`,
   `rp-job-core` ou `rp-streetrep` — ils fonctionnent sur n'importe quel
   serveur QBCore, gangs ou non.
3. `rp-casino` (étendu) reste une seule resource : `ensure rp-casino` suffit
   pour les 4 jeux, rien à ajouter dans `server.cfg`.

## Personnalisation

Chaque resource a son `shared/config.lua` : emplacements, mises,
probabilités, délais. Les emplacements par défaut (table de jeu, arène
laser game, bornes d'arcade) sont des coordonnées de départ à ajuster selon
votre carte.

## Idées pour aller plus loin (non implémentées)

- Persister les gains/pertes du casino (historique) pour un futur système
  de VIP ou de limites journalières.
- `rp-lasergame` : équipes au lieu de chacun pour soi, ou une arme factice
  (`weapon_stungun` désactivée en dégâts) au lieu du tag par proximité.
- `rp-arcade` : ajouter un vrai leaderboard des meilleurs temps de réaction
  par borne.
