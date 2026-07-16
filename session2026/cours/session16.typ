#import "@preview/theorion:0.4.1": *
#import cosmos.rainbow: *
#show: show-theorion

// ===================== SESSION 16 =====================

#heading(level: 1)[Session 16 : Les contraintes – et l’IK]

#heading(level: 2)[Objectifs de la session]
- Comparer PBD et Impulse Based pour résoudre les contraintes.
- Comprendre l'algorithme PGS et les techniques de stabilité.
- Passer de la cinématique directe (FK) à l'inverse (IK).
- Découvrir CCD, FABRIK et leurs applications.

#heading(level: 3)[1. PBD vs Impulse Based]

#definition-box(title: "Deux approches pour résoudre les contraintes")[
  *A. Position Based Dynamics (PBD)*
  - Corrige directement les positions.
  - Avantage : simple, stable visuellement.
  - Inconvénient : la physique n'est pas "vraie" (vitesses incorrectes).
  - Utilisé par : Verlet, PhysX (Soft Body), BeamNG.

  *B. Impulse Based*
  - Calcule les impulsions nécessaires pour respecter les contraintes.
  - Avantage : physiquement correct, conserve la quantité de mouvement.
  - Inconvénient : plus complexe, nécessite plusieurs itérations.
  - Utilisé par : Box2D, Rapier, Havok, PhysX (Rigid Body).
]

#heading(level: 3)[2. Le Concept de Contrainte]

#definition-box(title: "Contrainte")[
  Une contrainte est une équation qui doit être satisfaite à chaque frame.
  
  *Exemple :* distance $L$ entre deux particules A et B.
  $ C = ||arrow(A B)| - L| = 0 $
  
  Si $C != 0$, on applique une correction.
]

#heading(level: 3)[3. Algorithme PGS (Projected Gauss-Seidel)]

#definition-box(title: "PGS")[
  Principe :
  1. Pour chaque contact, calculer l'impulsion nécessaire.
  2. L'appliquer.
  3. Les vitesses ont changé, donc on recommence (itération).
  4. Après N itérations, le système converge.
  
  Typique : 4 à 8 itérations.
]

#heading(level: 3)[4. Techniques de Stabilité]

#definition-box(title: "Stabilité")[
  *Warm Starting* : réutiliser les impulsions de la frame précédente pour converger plus vite.
  
  *Sleeping* : les objets immobiles ne sont pas simulés.
  
  *Position Correction (Baumgarte)* : corriger légèrement la position pour réduire la pénétration.
  $ "correction" = "penetration" dot "facteur" dot arrow(n) $
]

#heading(level: 3)[5. Forward vs Inverse Kinematics]

#definition-box(title: "FK vs IK")[
  *Forward Kinematics (FK)* : on donne les angles et on calcule la position de la main.
  $ arrow(p) = f(theta_1, theta_2, ...) $
  
  *Inverse Kinematics (IK)* : on donne la position de la main et on calcule les angles.
  $ theta_1, theta_2, ... = f^-1(arrow(p)) $
  
  *Difficultés :* plusieurs solutions possibles, parfois aucune solution, pas de solution analytique simple.
]

#heading(level: 3)[6. CCD (Cyclic Coordinate Descent)]

#definition-box(title: "CCD")[
  On ajuste les articulations une par une, de l'extrémité vers la base.
  
  1. Prendre la dernière articulation.
  2. Calculer l'angle entre (articulation -> cible) et (articulation -> main).
  3. Tourner l'articulation.
  4. Passer à l'articulation précédente.
  5. Répéter.
]

*Avantage :* simple, converge vite.
*Inconvénient :* mouvements peu naturels.

#heading(level: 3)[7. FABRIK]

#definition-box(title: "FABRIK")[
  On manipule directement les positions des articulations.
  
  1. *Forward* : de la main vers l'épaule, en respectant les distances.
  2. *Backward* : de l'épaule vers la main, en respectant les distances.
  3. Répéter jusqu'à convergence.
]

*Avantage :* mouvements naturels, rapide.
*Inconvénient :* ne gère pas les limites d'angles directement.

#heading(level: 3)[8. Applications de l'IK]

- *Foot placement* : adapter les pieds au terrain.
- *Active ragdoll* : maintenir une pose via IK.
- *Hand grab* : attraper un objet précis.
