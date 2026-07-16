#import "@preview/theorion:0.4.1": *
#import cosmos.rainbow: *
#show: show-theorion

// ===================== SESSION 11 =====================

#heading(level: 1)[Session 11 : Moteurs Physiques & Middleware]

#definition-box(title: "1. Pourquoi utiliser un moteur physique ?")[
  Jusqu'à présent, nous avons codé notre propre moteur. C'est excellent pour apprendre, mais en production, on utilise des moteurs existants.
  
  *Pourquoi ?*
  - *Complexité :* Gestion des contacts multiples, stabilité, optimisation.
  - *Temps :* Un moteur professionnel représente des décennies de R&D.
  - *Performance :* Optimisé pour des milliers d'objets.
]

#definition-box(title: "2. Concepts Avancés des Moteurs Modernes")[
  *A. Rigid Body vs. Soft Body*
  - *Rigid Body :* Objet indéformable (boîte, sphère). C'est ce qu'on a codé.
  - *Soft Body :* Objet déformable (tissu, gelée). Beaucoup plus complexe.
  
  *B. Continuous Collision Detection (CCD)*
  - *Problème :* Si un objet va très vite, il peut "traverser" un mur entre deux frames (Tunneling).
  - *Solution :* Au lieu de checker la position à $t$ et $t+Delta t$, on calcule la trajectoire complète (raycast entre les deux positions).
  
  #figure(
    image("images/CCD.svg", width: 80%),
    caption: [Continuous Collision Detection : Éviter le Tunneling],
  )
  
  *C. Sleeping*
  - *Concept :* Si un objet est immobile depuis plusieurs frames, on arrête de le simuler. Il "dort".
  - *Réveil :* Si un autre objet le touche, il se réveille.
  - *Bénéfice :* Économie CPU massive pour les scènes statiques.
]

#definition-box(title: "3. Comparatif des Moteurs Physiques")[
  #table(
    columns: (1fr, 1fr, 1fr),
    inset: 8pt,
    stroke: 0.5pt + gray,
    table.header([*Moteur*], [*Langage*], [*Usage*]),
    [PhysX], [C++], [AAA Games (Unity, Unreal default)],
    [Havok], [C++], [AAA Games (Half-Life 2, Zelda TotK)],
    [Jolt Physics], [C++], [Modern, open-source, Horizon Forbidden West],
    [Box2D], [C++], [2D Games (Angry Birds, Terraria)],
    [Cannon.js], [JavaScript], [Three.js (simple, legacy)],
    [Ammo.js], [JavaScript (WASM)], [Three.js (Bullet port)],
    [Rapier], [Rust/WASM], [Modern, fast, Three.js recommended],
  )
  
  #figure(
    image("images/Moteur.svg", width: 90%),
    caption: [Architecture d'un moteur physique moderne],
  )
]

#definition-box(title: "4. Le Déterminisme")[
  Un moteur physique est *déterministe* si, pour les mêmes inputs, il produit exactement les mêmes outputs.
  
  *Pourquoi c'est important ?*
  - *Multijoueur :* Si tous les clients simulent la même scène, ils doivent voir la même chose.
  - *Replay :* Pour rejouer une action, il suffit de stocker les inputs, pas toutes les positions.
  
  *Pièges :*
  - L'ordre des opérations peut varier.
  - Les calculs flottants peuvent différer selon le CPU.
  - Rapier est déterministe par design.
]

#definition-box(title: "5. L'Architecture ECS (Entity-Component-System)")[
  C'est le pattern moderne pour organiser un jeu vidéo.
  
  - *Entity :* Un simple ID (ex: `entity_42`).
  - *Component :* Données pures (ex: `Position`, `RigidBody`, `Mesh`).
  - *System :* Logique qui opère sur les composants (ex: `PhysicsSystem`, `RenderSystem`).
  
  *Avantage :* Extrêmement flexible. On peut ajouter/enlever des composants à la volée sans changer le code des systèmes.
]
