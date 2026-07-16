#import "@preview/theorion:0.4.1": *
#import cosmos.rainbow: *
#show: show-theorion

// ===================== SESSION 10 =====================

#heading(level: 1)[Session 10 : Encore plus de forces]

#definition-box(title: "1. Les Ressorts : La Loi de Hooke")[
  Un ressort est une force qui essaie toujours de ramener un objet à une position d'équilibre.
  
  *La Formule :*
  $ arrow(F) = -k dot (L - L_0) dot hat(u) $
  
  - $k$ : Raideur du ressort (Stiffness).
  - $L$ : Longueur actuelle.
  - $L_0$ : Longueur au repos.
  - $hat(u)$ : Direction (unitaire).
  
  *Le problème de la stabilité :*
  Si on utilise la méthode d'Euler avec un $k$ élevé, le système "explose". C'est l'équation d'un oscillateur harmonique qui accumule de l'énergie à chaque pas de temps.
  
  *Solution 1 : Le Damping (Amortissement)*
  On ajoute une force qui s'oppose à la vitesse pour dissiper l'énergie :
  $ arrow(F)_"damping" = -b dot arrow(v) $
  
  *Solution 2 : Verlet*
  L'intégration de Verlet est naturellement plus stable pour les systèmes de ressorts.
  
  #figure(
    image("images/HOOK.svg", width: 80%),
    caption: [La Loi de Hooke : Force de rappel proportionnelle à l'étirement],
  )
]

#definition-box(title: "2. Les Contraintes de Verlet (Linking Particles)")[
  Au lieu de simuler des ressorts complexes, on peut utiliser l'intégration de Verlet pour créer des "bâtons" rigides entre des particules.
  
  *Principe :*
  1. On met à jour toutes les particules avec Verlet (gravité, etc.).
  2. Pour chaque contrainte (bâton), on calcule l'écart entre la distance actuelle et la distance souhaitée.
  3. On déplace les deux particules pour corriger la moitié de l'écart chacune.
  4. On répète l'opération plusieurs fois (itérations) pour converger.
  
  *Avantage :* Pas besoin de calculer des forces. On manipule directement les positions. C'est la base des moteurs PBD (Position Based Dynamics).
]

#definition-box(title: "3. La Gravité Universelle")[
  Newton a découvert que *tous* les objets s'attirent mutuellement.
  
  $ arrow(F) = G dot (m_1 m_2) / r^2 dot hat(u) $
  
  - $G$ : Constante gravitationnelle ($6.674 times 10^-11 "N" dot "m"^2/"kg"^2$).
  - $r$ : Distance entre les centres.
  - $hat(u)$ : Direction de l'attraction.
  
  *Pourquoi on ne ressent pas l'attraction entre deux personnes ?*
  Parce que $G$ est minuscule. Il faut une masse planétaire pour que la force soit perceptible.
  
  *Dans un jeu vidéo :*
  On simule un système solaire en appliquant cette force entre chaque paire d'objets.
]

#definition-box(title: "TP : Le Système Solaire")[
  *Objectif :*
  1. Créer un soleil massif au centre.
  2. Ajouter plusieurs planètes avec des vitesses initiales perpendiculaires au soleil.
  3. Appliquer la gravité universelle entre chaque paire.
  4. Observer les orbites.
  
  *Défi :* Trouver la bonne vitesse initiale pour qu'une planète orbite en cercle parfait.
  $ v = sqrt(G M / r) $
]
