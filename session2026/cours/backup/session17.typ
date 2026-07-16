#import "@preview/theorion:0.4.1": *
#import cosmos.rainbow: *
#show: show-theorion

// ===================== SESSION 17 =====================

#heading(level: 1)[Session 17 : Character Controllers]

#definition-box(title: "1. Le Choix Fondamental : DCC vs KCC")[
  *Dynamic Character Controller (DCC)*
  - Le personnage est un RigidBody standard.
  - Il subit les forces, les collisions, la gravité.
  - *Avantage :* Interagit naturellement avec le monde (se fait pousser, tombe, etc.).
  - *Inconvénient :* Difficile à contrôler précisément. Le personnage peut glisser, tomber, être poussé par d'autres objets. Pas de "game feel".
  
  *Kinematic Character Controller (KCC)*
  - Le personnage est un RigidBody kinematic.
  - On contrôle manuellement sa position. La physique ne le pousse pas.
  - *Avantage :* Contrôle total. Le personnage fait exactement ce qu'on veut.
  - *Inconvénient :* Il faut coder manuellement les collisions, la gravité, les pentes.
  
  *La norme dans l'industrie :* KCC. Les jeux AAA utilisent presque toujours un KCC pour le joueur.
]

#definition-box(title: "2. L'Algorithme 'Move and Slide'")[
  C'est l'algorithme standard pour un KCC.
  
  *Principe :*
  1. On calcule le mouvement souhaité (input $+$ gravité $+$ vélocité).
  2. On tente de déplacer le personnage de ce vecteur.
  3. Si on touche un mur, on *glisse* le long du mur au lieu de s'arrêter.
  
  *Mathématique : Projection et Rejection*
  - Soit $arrow(v)$ la vélocité et $arrow(n)$ la normale du mur.
  - *Projection :* La composante dans le mur (à annuler).
    $ arrow(v)_"proj" = (arrow(v) dot arrow(n)) arrow(n) $
  - *Rejection :* La composante le long du mur (à conserver).
    $ arrow(v)_"rej" = arrow(v) - arrow(v)_"proj" $
  - Nouvelle vélocité : $arrow(v)' = arrow(v)_"rej"$
  
  C'est pour ça qu'on "glisse" le long des murs dans les jeux !
]

#definition-box(title: "3. Le Problème du 'Corner Trap'")[
  Quand on glisse le long de deux murs en même temps (un coin), le personnage peut se bloquer.
  
  *Solution :* On ne traite qu'une collision à la fois. On trie les collisions par profondeur, on résout la plus profonde, puis on re-tente le mouvement.
]

#definition-box(title: "4. Détection du Sol")[
  Pour savoir si le personnage est au sol, on lance un raycast vers le bas.
  
  *Méthodes :*
  - *Raycast simple :* Un rayon depuis le centre vers le bas. Simple mais peut rater les bords.
  - *Shapecast :* On projette la forme entière (capsule) vers le bas. Plus précis.
  - *Multi-raycast :* Plusieurs rayons répartis sous les pieds.
  
  *Critère :* Si la distance au sol est inférieure à un seuil (ex: 0.1m), le personnage est "au sol" et peut sauter.
]

#definition-box(title: "5. Game Feel : Coyote Time et Jump Buffering")[
  Ces deux techniques transforment un saut "technique" en un saut "fun".
  
  *Coyote Time :*
  - Après avoir quitté une plateforme, le joueur peut encore sauter pendant ~0.1s.
  - *Pourquoi ?* Parce que le cerveau humain a du mal à accepter qu'on ne puisse pas sauter quand on vient de marcher au bord.
  
  *Jump Buffering :*
  - Si le joueur appuie sur "saut" juste *avant* d'atterrir, le saut s'enregistre et s'exécute dès qu'on touche le sol.
  - *Pourquoi ?* Parce que appuyer trop tôt ne devrait pas être puni.
  
  Ces deux techniques sont la différence entre un jeu "rigide" et un jeu "fun".
]

#definition-box(title: "TP : FPS Controller avec Rapier")[
  *Objectif :* Implémenter un contrôleur FPS en mode kinematic avec Rapier.
  1. Créer un RigidBody kinematic (capsule).
  2. Lire les inputs (WASD $+$ souris).
  3. Calculer la vélocité souhaitée.
  4. Utiliser `world.castRay` pour détecter le sol.
  5. Implémenter le Move and Slide.
  6. Ajouter le Coyote Time et le Jump Buffering.
]
