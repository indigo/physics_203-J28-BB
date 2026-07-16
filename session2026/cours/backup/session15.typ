#import "@preview/theorion:0.4.1": *
#import cosmos.rainbow: *
#show: show-theorion

// ===================== SESSION 15 =====================

#heading(level: 1)[Session 15 : Cinématique Inverse (IK)]

#definition-box(title: "1. Forward Kinematics vs Inverse Kinematics")[
  *Forward Kinematics (FK)*
  - On donne les angles des articulations, et on calcule la position de la main.
  - $arrow(p) = f(theta_1, theta_2, theta_3, ...)$
  - C'est ce qu'on fait depuis le début : on donne une rotation, le moteur calcule la position.
  
  *Inverse Kinematics (IK)*
  - On donne la position désirée de la main, et on calcule les angles des articulations.
  - $theta_1, theta_2, theta_3, ... = f^-1(arrow(p))$
  - C'est ce qu'on veut faire : "Je veux que ma main touche cette pomme, calcule comment plier mon bras."
  
  *Pourquoi c'est difficile ?*
  - Il y a souvent *plusieurs solutions* (le bras peut se plier de plusieurs façons).
  - Parfois il n'y a *aucune solution* (la cible est trop loin).
  - L'équation $f^-1$ n'a pas de solution analytique simple.
]

#definition-box(title: "2. Algorithme 1 : CCD (Cyclic Coordinate Descent)")[
  C'est l'algorithme le plus simple à comprendre et à coder.
  
  *Principe :*
  On ajuste les articulations une par une, en partant de l'extrémité (la main) vers la base (l'épaule).
  
  *Boucle :*
  1. Prendre la dernière articulation (le poignet).
  2. Calculer l'angle entre (articulation $->$ cible) et (articulation $->$ main).
  3. Tourner l'articulation de cet angle.
  4. Passer à l'articulation précédente (le coude).
  5. Répéter jusqu'à la base.
  6. Recommencer la boucle entière plusieurs fois (itérations).
  
  *Avantage :* Très simple, converge rapidement.
  *Inconvénient :* Les mouvements ne sont pas naturels (les articulations proches de la base bougent trop).
]

#definition-box(title: "3. Algorithme 2 : FABRIK (Forward And Backward Reaching Inverse Kinematics)")[
  C'est l'algorithme le plus populaire pour l'animation en temps réel.
  
  *Principe :*
  Au lieu de calculer des angles, on manipule directement les positions des articulations.
  
  *Boucle :*
  1. *Forward :* Partir de la main et remonter vers l'épaule. Chaque articulation est déplacée pour être à la bonne distance de la suivante.
  2. *Backward :* Partir de l'épaule et redescendre vers la main. Chaque articulation est repositionnée pour respecter les longueurs des segments.
  3. Répéter jusqu'à convergence.
  
  *Avantage :* Mouvements naturels, très rapide, facile à implémenter.
  *Inconvénient :* Ne gère pas les limites d'angles directement (il faut post-traiter).
]

#definition-box(title: "4. IK et Physique : L'Animation Procédurale")[
  L'IK devient magique quand on la combine avec la physique.
  
  *Exemples :*
  - *Foot Placement :* Les pieds du personnage s'adaptent au terrain irrégulier. On lance un raycast vers le sol, et l'IK place le pied exactement sur la surface.
  - *Active Ragdoll :* Un personnage ragdoll (corps mou) qui essaie de maintenir une pose via IK. C'est ce qui donne des morts réalistes dans les jeux modernes.
  - *Hand Grab :* La main du personnage attrape un objet précis dans le monde.
]
