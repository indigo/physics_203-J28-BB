#import "@preview/theorion:0.4.1": *
#import cosmos.rainbow: *
#show: show-theorion

// ===================== SESSION 07 =====================

#heading(level: 1)[Session 7 : Broad et Narrow phases – Part 1]

#heading(level: 2)[Objectifs de la session]
- Comprendre le budget temps d'une frame (16 ms).
- Exploquer pourquoi la détection naïve de collision est en $O(N^2)$.
- Présenter la Broad Phase et ses structures de partitionnement.
- Comparer Grille Uniforme, Quadtree/Octree et Sweep-and-Prune.

#heading(level: 3)[1. Le Contexte : Le Budget Temps (16 ms)]

#definition-box(title: "Le budget temps d'une frame")[
  À 60 FPS, on dispose de *16.6 millisecondes* pour tout calculer :
  - Rendu : ~8 ms
  - IA / Gameplay : ~4 ms
  - Audio / Réseau : ~2 ms
  - *Physique : ~2 ms*
  
  Si la détection de collision prend 10 ms, le jeu saccade. L'optimisation est vitale.
]

#heading(level: 3)[2. Le Problème : La Malédiction $O(N^2)$]

#definition-box(title: "Détection naïve")[
  Avec $N$ objets, chaque objet teste tous les autres. Le nombre de paires est :
  $ C approx (N(N-1)) / 2 approx O(N^2) $
]

- 10 objets $->$ 45 tests
- 1 000 objets $->$ 499 500 tests
- 10 000 objets $->$ 50 000 000 tests

*Solution :* réduire le nombre de paires avant les tests coûteux. C'est le rôle de la *Broad Phase*.

#heading(level: 3)[3. La Broad Phase : Structures de Partitionnement]

#definition-box(title: "Principe")[
  On entoure chaque objet complexe par une AABB (Axis Aligned Bounding Box). La Broad Phase répond vite à la question : *"Qui sont mes voisins ?"*
]

*A. Grille Uniforme (Spatial Hashing)*
- On découpe le monde en cases de taille fixe.
- On ne teste un objet que contre ceux dans la même case ou les cases adjacentes.
- *Avantage :* accès $O(1)$, rapide, facile à coder.
- *Inconvénient :* mauvais si le monde est infini ou si les tailles varient beaucoup.

*B. Arbres Spatiaux (Quadtree / Octree)*
- Découpage récursif. Si une case contient trop d'objets, on la coupe en 4 (2D) ou 8 (3D).
- *Avantage :* s'adapte à la densité.
- *Inconvénient :* coûteux à mettre à jour si les objets bougent beaucoup.

*C. Sweep and Prune (SAP)*
- On projette les débuts/fins des AABB sur les axes X, Y, Z et on trie les listes.
- Si les intervalles sur X ne se chevauchent pas, inutile de tester Y et Z.
- Exploite la *cohérence temporelle* : la liste reste presque triée d'une frame à l'autre.
