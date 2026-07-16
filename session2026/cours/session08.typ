#import "@preview/theorion:0.4.1": *
#import cosmos.rainbow: *
#show: show-theorion

// ===================== SESSION 08 =====================

#heading(level: 1)[Session 8 : Les ressorts - Méthode de Verlet]

#heading(level: 2)[Objectifs de la session]
- Comprendre la loi de Hooke et les forces de rappel.
- Stabiliser les ressorts avec le damping.
- Découvrir l'intégration de Verlet pour les systèmes de particules.
- Apprendre à résoudre les contraintes de distance (PBD).

#heading(level: 3)[1. Les Ressorts : La Loi de Hooke]

#definition-box(title: "La Loi de Hooke")[
  Un ressort est une force qui ramène un objet à sa position d'équilibre.
  $ arrow(F) = -k dot (L - L_0) dot hat(u) $
  
  - $k$ : raideur du ressort.
  - $L$ : longueur actuelle.
  - $L_0$ : longueur au repos.
  - $hat(u)$ : direction unitaire.
]

*Problème de stabilité :* Avec Euler et un $k$ élevé, le système "explose" et accumule de l'énergie.

#heading(level: 3)[2. Le Damping (Amortissement)]

#definition-box(title: "Force d'amortissement")[
  On ajoute une force opposée à la vitesse pour dissiper l'énergie.
  $ arrow(F)_"damping" = -b dot arrow(v) $
]

*Résultat :* Le ressort finit par se stabiliser au lieu d'osciller indéfiniment.

#heading(level: 3)[3. L'Intégration de Verlet]

#definition-box(title: "Verlet")[
  Contrairement à Euler, Verlet ne stocke pas explicitement la vitesse. Elle est déduite de la différence entre la position actuelle et la position précédente.
  $ x_(n+1) = x_n + (x_n - x_(n-1)) + a dot d t^2 $
]

*Avantages :*
- Stable pour les ressorts et les oscillations.
- Si on déplace une particule manuellement (contrainte), sa vitesse s'ajuste automatiquement.

*Utilisations typiques :* cordes, tissus, chevelures, tas de billes.

#heading(level: 3)[4. Contraintes de Verlet (PBD)]

#definition-box(title: "Position Based Dynamics")[
  Au lieu de calculer des forces complexes, on corrige directement les positions des particules pour respecter des contraintes (distance, angle, etc.).
]

*Algorithme :*
1. Mettre à jour toutes les particules avec Verlet (gravité, etc.).
2. Pour chaque contrainte de distance, calculer l'écart entre la distance actuelle et la distance souhaitée.
3. Déplacer les deux particules pour corriger la moitié de l'écart chacune.
4. Répéter plusieurs fois (itérations) pour converger.

*Avantage :* pas de calcul de forces, manipulation directe des positions. C'est la base des moteurs PBD.
