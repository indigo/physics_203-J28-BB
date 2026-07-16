#import "@preview/theorion:0.4.1": *
#import cosmos.rainbow: *
#show: show-theorion

#set document(
  author: ("Richard Rispoli"),
  title: [Exercice : Frottement sur Plan Incliné]
)

#show title: set align(right)
#show title: set block(below: 1.2em)
#show title: set text(
  weight: "bold", 
  size: 1em, 
  fill: rgb("#406372")
)

#set page(
  paper: "us-letter",
  margin: 2cm,
  header: align(
    right + horizon,
    "Physics 203 - Exercice Rapide",
  ),
)

#set text(
  font: "Georgia",
  lang: "fr",
  size: 11pt
)

#show heading: set text(
  weight: "bold", 
  size: 1em, 
  fill: rgb("#005F87")
)

#title()

// --- ÉNONCÉ ---

#example(title: "Énoncé du problème")[
  Un cube de masse $m = 1 "kg"$ est posé sur un plan incliné.
  
  On augmente progressivement l'inclinaison du plan.
  Lorsque l'angle atteint $theta = 30 degree$, le cube commence tout juste à glisser.
  
  *Question :*
  Quelle est la valeur limite de la force de frottement statique ($f_(s,max)$) à cet instant précis ?
  
  _(On prendra $g = 9.81 "m/s"^2$)_
]

#v(2em)

// --- SOLUTION ---

    #figure(
      image("../images/Ex_fro_sol.svg", width: 70%),
    )
  

#definition-box(title: "Solution Détaillée")[
  
  *1. Bilan des Forces*
  Le cube est soumis à 3 forces :
  - Le Poids ($arrow(P)$) : Vertical, vers le bas.
  - La Normale ($arrow(N)$) : Perpendiculaire au plan.
  - Le Frottement Statique ($arrow(f)_s$) : Parallèle au plan, vers le haut (il retient le cube).

  *2. Décomposition du Poids*
  Pour simplifier le calcul, on place notre repère aligné avec le plan incliné.

    #figure(
      image("../images/Ex_fro_proj.svg", width: 20%),
    )
  

  Il faut décomposer le vecteur Poids en deux composantes :
  
  - $P_y = m g cos(theta)$ (Composante qui plaque le cube contre le sol).
  - $P_x = m g sin(theta)$ (Composante qui tire le cube vers le bas de la pente).

  *3. Condition d'équilibre limite*
  Juste avant que le cube ne bouge, les forces s'annulent parfaitement.
  Sur l'axe X (le long de la pente), la force qui tire vers le bas ($P_x$) est exactement compensée par la force de frottement maximale ($f_(s,max)$).
  
  $ sum F_x = 0 "implique" P_x - f_(s,max) = 0 $
  
  Donc :
  $ f_(s,max) = P_x = m g sin(theta) $

  *4. Application Numérique*
  $ m = 1 "kg" $
  $ g = 9.81 "m/s"^2 $
  $ theta = 30 degree $
  
  $ f_(s,max) = 1 dot 9.81 dot sin(30 degree) $
  $ f_(s,max) = 9.81 dot 0.5 $
  
  #align(center)[
    #rect(stroke: 2pt + rgb("#005F87"), inset: 10pt, radius: 5pt)[
      *Réponse :* $ f_(s,max) approx 4.905 "Newtons" $
    ]
  ]
]

#definition-box(title: "Pour aller plus loin : Le Coefficient de Frottement")[
  On sait que la friction statique maximale dépend de la force Normale :
  $ f_(s,max) = mu_s dot N $
  
  Or, la Normale compense la composante du poids perpendiculaire ($P_y$) :
  $ N = m g cos(theta) $
  
  En combinant les deux équations :
  $ m g sin(theta) = mu_s dot (m g cos(theta)) $
  
  Les masses s'annulent ! On isole $mu_s$ :
  $ mu_s = sin(theta) / cos(theta) = tan(theta) $
  
  *Résultat magique :* Le coefficient de frottement est simplement la tangente de l'angle limite.
  $ mu_s = tan(30 degree) approx 0.577 $
]