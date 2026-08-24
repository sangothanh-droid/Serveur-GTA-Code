# Dossier `[addons]` — véhicules, armes et maps additionnels

Ce dossier contient des **templates vides** pour ajouter du contenu additionnel
(véhicules moddés, armes moddées, maps/intérieurs custom). Je ne peux pas
générer les fichiers binaires du jeu (`.yft`, `.ytd`, `.ymap`, `.ybn`...) —
ce sont des assets 3D créés avec des outils comme Blender+Sollumz ou
CodeWalker, ou fournis par un pack acheté/téléchargé.

## ⚠️ Sécurité : où trouver du contenu fiable

- Ne jamais installer un pack "leaké"/piraté trouvé sur un forum ou Discord
  inconnu : c'est la source n°1 de **backdoors** sur les serveurs FiveM
  (scripts Lua obfusqués qui exfiltrent votre base de données ou donnent un
  accès admin caché à l'auteur du leak).
- Privilégier des sources reconnues : packs open-source sur GitHub avec une
  licence claire, contenus achetés sur des marketplaces établies (Tebex,
  CFX Store), ou vos propres créations.
- Avant d'activer un mod téléchargé, ouvrir tous les fichiers `.lua`/`.js` en
  clair (fuir tout ce qui est fortement obfusqué/minifié sans raison) et,
  si possible, tester sur un serveur de dev séparé avant la prod.

## Structure attendue

```
[addons]/
  addon-vehicle-template/   -> un véhicule additionnel = une resource FiveM
    fxmanifest.lua
    stream/                 -> fichiers .ytd/.yft du véhicule (à fournir)
    data/vehicles.meta      -> métadonnées du véhicule (nom, catégorie...)
    data/carcols.meta       -> couleurs/livrées (optionnel)

  addon-weapon-template/    -> une arme additionnelle = une resource FiveM
    fxmanifest.lua
    stream/                 -> fichiers .ytd/.yft de l'arme (à fournir)
    data/weapons.meta       -> métadonnées de l'arme (dégâts, cadence...)

  addon-map-template/       -> une map/intérieur custom (MLO)
    fxmanifest.lua
    stream/                 -> fichiers .ymap/.ytyp/.ybn générés par
                               CodeWalker ou Sollumz (à fournir)
```

## Étapes pour ajouter un vrai contenu

1. Dupliquer le template correspondant, ex: `cp -r addon-vehicle-template addon-my-car`.
2. Déposer les fichiers binaires du pack dans `stream/` et compléter les
   fichiers `data/*.meta` fournis avec le pack (ou générés par vos soins).
3. Ajouter `ensure addon-my-car` dans `server-data/server.cfg`.
4. Pour un véhicule : l'ajouter aussi dans la config des concessionnaires
   côté QBCore (`qb-core/shared/vehicles.lua` et les shops `qb-shops` /
   `qb-vehicleshop` selon votre installation) pour qu'il soit achetable.
5. Pour une arme : référencer son nom d'arme dans `qb-core/shared/items.lua`
   et l'armurerie (`qb-shops` / `qb-weapons`) pour la rendre disponible.
6. Pour une map/MLO : ajouter l'`ipl`/interior correspondant et, si besoin,
   un script de téléportation/marqueur pour y accéder en jeu.

Les fichiers binaires ne doivent **pas** être commités dans ce repo Git tels
quels (poids, licence) : les dossiers `stream/` des templates sont ignorés
par `.gitignore` en dehors d'un `.gitkeep`. Gérez vos assets séparément
(archive privée, Git LFS, etc.) et copiez-les sur le VPS au déploiement.
