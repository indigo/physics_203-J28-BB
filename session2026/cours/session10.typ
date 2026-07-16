#import "@preview/theorion:0.4.1": *
#import cosmos.rainbow: *
#show: show-theorion

// ===================== SESSION 10 =====================

#heading(level: 1)[Session 10 : Introduction à la physique des rotations]

#heading(level: 2)[Objectifs de la session]
- Passer de la particule au corps rigide.
- Comprendre le couple, le moment d'inertie et la vitesse angulaire.
- Relier les équations linéaires et angulaires.
- Implémenter un corps rigide qui tourne sous l'effet d'une force.

#tip-box(title: "L'objectif du jour")[
  Un corps rigide ne fait pas que se déplacer, il *pivote* autour de son centre de masse. Cette session introduit les outils pour modéliser la rotation.
]

#heading(level: 3)[1. Dictionnaire Linéaire vs Angulaire]

#figure(
  table(
    columns: (1fr, 1fr, 1fr),
    inset: 8pt,
    align: center + horizon,
    stroke: 0.5pt + gray,
    table.header([*Concept*], [*Linéaire*], [*Angulaire*]),
    [Position], [$arrow(r)$ (m)], [Angle $theta$ (rad)],
    [Vitesse], [$arrow(v)$ (m/s)], [Vitesse angulaire $omega$ (rad/s)],
    [Résistance], [Masse $m$], [Moment d'inertie $I$],
    [Cause], [Force $arrow(F)$], [Couple $tau$],
    [Loi], [$arrow(F) = m arrow(a)$], [$tau = I alpha$]
  ),
  caption: [Analogie entre mouvement linéaire et rotation]
)

#heading(level: 3)[2. Le Couple (Torque)]

#important-box(title: "Le Couple")[
  Le couple dépend de *où* on pousse. En 3D, il est donné par un produit vectoriel :
  $ bold(arrow(tau) = arrow(r) times arrow(F)) $
  
  En 2D, il se simplifie :
  $ tau = r_x F_y - r_y F_x $
  où $arrow(r)$ est le bras de levier depuis le centre de masse.
]

#heading(level: 3)[3. Le Moment d'Inertie]

#definition-box(title: "Moment d'inertie")[
  Le moment d'inertie $I$ représente la résistance d'un objet à la rotation. Il dépend de la répartition de la masse.
  $ I = sum_i m_i r_i^2 $
]

*Cas courants :*
- Anneau mince : $I = m R^2$
- Rectangle autour de son centre : $I = 1/12 m (w^2 + h^2)$

#heading(level: 3)[4. Vitesse d'un Point sur le Corps]

#definition-box(title: "Vitesse d'un point P")[
  Si un corps se déplace à $arrow(v)_G$ et tourne à $omega$, la vitesse d'un point $P$ à la distance $arrow(r)$ du centre est :
  $ arrow(v)_P = arrow(v)_G + (omega times arrow(r)) $
  
  En 2D :
  $ v_(P.x) = v_(G.x) - omega dot r_y $
  $ v_(P.y) = v_(G.y) + omega dot r_x $
]

#heading(level: 3)[5. TP : Spinning Box]

#definition-box(title: "Objectif")[
  Implémenter un rectangle qui tourne quand on clique dessus avec la souris.
]

#heading(level: 2)[Étape 1 : Classe RigidBody]
Ajouter les propriétés :
- `angle`
- `angularVelocity`
- `torque`
- `inertia` (calculée une fois au démarrage)

#heading(level: 2)[Étape 2 : ApplyForce(force, worldPoint)]
1. Calculer le bras de levier $arrow(r) = "worldPoint" - "center"$.
2. Ajouter la force linéaire : $arrow(F)_"total" += arrow(F)$.
3. Ajouter au torque : $tau += r_x F_y - r_y F_x$.

#heading(level: 2)[Étape 3 : Intégrateur]
1. $a = F / m$
2. $alpha = tau / I$
3. $v += a dot d t$
4. $omega += alpha dot d t$
5. $p += v dot d t$
6. $theta += omega dot d t$
7. Remettre `F` et `tau` à zéro.
