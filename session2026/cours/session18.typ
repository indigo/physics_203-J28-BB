#import "@preview/theorion:0.4.1": *
#import cosmos.rainbow: *
#show: show-theorion

// ===================== SESSION 18 =====================

#heading(level: 1)[Session 18 : Personnages]

#heading(level: 2)[Objectifs de la session]
- Comparer Dynamic Character Controller (DCC) et Kinematic Character Controller (KCC).
- Implémenter Move and Slide.
- Gérer la détection du sol, le Coyote Time et le Jump Buffering.
- Créer un contrôleur FPS avec Rapier.

#heading(level: 3)[1. DCC vs KCC]

#definition-box(title: "Dynamic Character Controller (DCC)")[
  Le personnage est un RigidBody standard.
  - *Avantages :* interagit naturellement avec le monde (poussé, tombe, etc.).
  - *Inconvénients :* difficile à contrôler, peut glisser, être poussé.
]

#definition-box(title: "Kinematic Character Controller (KCC)")[
  Le personnage est un RigidBody kinematic. On contrôle sa position manuellement.
  - *Avantages :* contrôle total, game feel précis.
  - *Inconvénients :* il faut coder les collisions, la gravité, les pentes.
]

*La norme dans l'industrie :* KCC pour les jeux AAA.

#heading(level: 3)[2. Move and Slide]

#definition-box(title: "Algorithme")[
  1. Calculer le mouvement souhaité (input + gravité + vélocité).
  2. Tenter de déplacer le personnage.
  3. Si on touche un mur, glisser le long du mur.
]

#definition-box(title: "Projection et Rejection")[
  Soit $arrow(v)$ la vélocité et $arrow(n)$ la normale du mur.
  - Projection (à annuler) : $arrow(v)_"proj" = (arrow(v) dot arrow(n)) arrow(n)$
  - Rejection (à conserver) : $arrow(v)_"rej" = arrow(v) - arrow(v)_"proj"$
  - Nouvelle vélocité : $arrow(v)' = arrow(v)_"rej"$
]

#heading(level: 3)[3. Corner Trap]

Quand on glisse le long de deux murs (un coin), le personnage peut se bloquer. Solution : traiter une collision à la fois, trier par profondeur, résoudre la plus profonde, puis re-tenter le mouvement.

#heading(level: 3)[4. Détection du Sol]

#definition-box(title: "Méthodes")[
  - *Raycast simple :* un rayon depuis le centre. Simple mais peut rater les bords.
  - *Shapecast :* on projette la capsule entière. Plus précis.
  - *Multi-raycast :* plusieurs rayons sous les pieds.
]

#definition-box(title: "Coyote Time et Jump Buffering")[
  *Coyote Time :* après avoir quitté une plateforme, le joueur peut encore sauter pendant ~0.1s.
  
  *Jump Buffering :* si le joueur appuie sur saut juste avant d'atterrir, le saut s'exécute dès l'atterrissage.
]

#heading(level: 3)[5. TP : FPS Controller avec Rapier]

1. Créer un RigidBody kinematic (capsule).
2. Lire les inputs (WASD + souris).
3. Calculer la vélocité souhaitée.
4. Utiliser `world.castRay` pour détecter le sol.
5. Implémenter le Move and Slide.
6. Ajouter le Coyote Time et le Jump Buffering.
