#import "@preview/theorion:0.4.1": *
#import cosmos.rainbow: *
#show: show-theorion

// ===================== SESSION 14 =====================

#heading(level: 1)[Session 14 : Les Solveurs de Contraintes]

#definition-box(title: "1. PBD vs Impulse Based")[
  Il existe deux grandes approches pour résoudre les contraintes et collisions :
  
  *A. Position Based Dynamics (PBD)*
  - *Philosophie :* Corriger directement les positions.
  - *Méthode :* Si deux objets se chevauchent, on les sépare manuellement.
  - *Avantage :* Simple, stable visuellement.
  - *Inconvénient :* La physique n'est pas "vraie" (les vitesses ne sont pas correctes).
  - *Utilisé par :* Verlet, PhysX (Soft Body), BeamNG.
  
  *B. Impulse Based*
  - *Philosophie :* Calculer les impulsions nécessaires pour respecter les contraintes.
  - *Méthode :* On calcule $j$ (comme dans le TP collision) pour chaque contact.
  - *Avantage :* Physiquement correct, conserve la quantité de mouvement.
  - *Inconvénient :* Plus complexe, peut nécessiter plusieurs itérations.
  - *Utilisé par :* Box2D, Rapier, Havok, PhysX (Rigid Body).
]

#definition-box(title: "2. Le Concept de Contrainte")[
  Une contrainte est une équation qui doit être satisfaite à chaque frame.
  
  *Exemple : Contrainte de distance*
  Deux particules A et B doivent rester à une distance $L$.
  $ C = ||arrow(A B)| - L| = 0 $
  
  Si $C != 0$, il faut appliquer une correction.
]

#definition-box(title: "3. L'Algorithme PGS (Projected Gauss-Seidel)")[
  C'est l'algorithme utilisé par les moteurs modernes pour résoudre les impulsions.
  
  *Principe :*
  1. Pour chaque contact, calculer l'impulsion nécessaire.
  2. L'appliquer.
  3. Mais cette application a modifié les vitesses des autres contacts !
  4. Donc on recommence (itération).
  5. Après N itérations, le système converge vers une solution stable.
  
  *Le nombre d'itérations est un paramètre clé :*
  - Trop peu : Les objets s'enfoncent (soft).
  - Trop : Le CPU surchauffe.
  - Typique : 4 à 8 itérations.
]

#definition-box(title: "4. Techniques Avancées de Stabilité")[
  *A. Warm Starting*
  - *Idée :* Au lieu de repartir de zéro à chaque frame, on réutilise les impulsions de la frame précédente.
  - *Bénéfice :* Convergence beaucoup plus rapide (1-2 itérations suffisent).
  - *C'est comme "préchauffer" le solveur.*
  
  *B. Sleeping*
  - Déjà vu : les objets immobiles ne sont plus simulés.
  
  *C. Position Correction (Baumgarte)*
  - Même avec les impulsions, les objets peuvent légèrement s'enfoncer.
  - On ajoute une petite correction de position pour les séparer.
  - $ "correction" = "penetration" times "BaumgarteFactor" times arrow(n) $
  - Le facteur est généralement 0.2 (20% de correction par frame).
]

#definition-box(title: "5. Paramétrer un Solveur")[
  Les moteurs physiques exposent plusieurs paramètres :
  
  - *Velocity Threshold :* En dessous de cette vitesse, l'objet est considéré comme immobile.
  - *Restitution Threshold :* En dessous de cette vitesse de collision, pas de rebond.
  - *Max Penetration :* Distance maximale d'enfoncement autorisée.
  - *Solver Iterations :* Nombre d'itérations du PGS.
  
  *Le jeu du développeur :* Trouver le bon équilibre entre précision et performance.
]
