// --- Début de la section Math 101 ---

= Annexe Mathématique : Dérivée et Intégration 101

Pour faire de la physique, nous avons besoin de deux outils mathématiques fondamentaux qui fonctionnent comme des opérations inverses l'une de l'autre, un peu comme l'addition et la soustraction.

#box(fill: luma(245), inset: 1em, radius: 5pt, width: 100%)[
  == 1. La Dérivée (La Pente)
  _Le microscope du changement_

  La dérivée mesure comment une valeur change *à un instant précis*. Géométriquement, c'est la *pente* de la courbe.

  - *Notation :* Si on a une fonction $f(t)$, sa dérivée s'écrit $f'(t)$ ou $(d f)/(d t)$.
  - *Intuition :*
    - Si $x(t)$ est la position, sa pente nous dit à quelle vitesse on avance. Une pente raide = grande vitesse. Une pente nulle (plat) = à l'arrêt.
    - $v(t) = (d x(t)) / (d t)$

  // ILLUSTRATION 1 :
  // Un graphique montrant une courbe arbitraire (ex: f(t) = t^2).
  // Dessiner une ligne tangente à un point t précis.
  // Annoter cette ligne comme "Pente = Dérivée = Vitesse instantanée".
  // Montrer que si la courbe monte, la dérivée est positive.

  *Règle de puissance (La plus utile !) :*
  Pour dériver $t^n$, on descend l'exposant devant et on réduit l'exposant de 1.
  $
    f(t) = t^n arrow.long f'(t) = n t^(n-1)
  $
  *Exemple :* Si $x(t) = 5t^3$, alors $v(t) = 15t^2$.
]

#v(1em)

#box(fill: luma(245), inset: 1em, radius: 5pt, width: 100%)[
  == 2. L'Intégrale (L'Aire)
  _L'accumulateur_

  L'intégration est l'opération inverse de la dérivée. Elle permet de retrouver la fonction originale à partir de son taux de changement. Géométriquement, c'est l'*aire sous la courbe*.

  - *Notation :* $integral f(t) d t$.
  - *Intuition :*
    - Si on connaît la vitesse à chaque instant, l'intégrale additionne toutes ces petites distances parcourues pour nous donner la position totale.
    - $x(t) = integral v(t) d t$

  // ILLUSTRATION 2 :
  // Un graphique montrant une courbe de vitesse (ex: une ligne droite v(t) = at).
  // Colorier l'aire sous la courbe entre t=0 et t=now.
  // Annoter cette surface coloriée comme "Aire = Intégrale = Distance parcourue".

  *Règle de puissance inversée :*
  On augmente l'exposant de 1 et on divise par le nouveau nombre.
  $
    f(t) = t^n arrow.long F(t) = (t^(n+1)) / (n+1) + C
  $
  *Attention à la Constante ($C$) !*
  Quand on intègre, on perd l'information du point de départ. La constante $C$ représente les conditions initiales (Position initiale $x_0$ ou Vitesse initiale $v_0$).
]

#v(1em)

== 3. Le cycle de la Cinématique

En physique, on passe constamment de l'un à l'autre selon ce que l'on cherche :

#align(center)[
  #table(
    columns: 3,
    align: center + horizon,
    stroke: none,
    [*Position* \ $x(t)$], [$arrow(d/(d t))$ \ Dérivation \ (Pente)], [*Vitesse* \ $v(t)$],
    [], [], [], // Espace vide
    [*Vitesse* \ $v(t)$], [$arrow(d/(d t))$ \ Dérivation \ (Pente)], [*Accélération* \ $a(t)$]
  )
]

#align(center)[
  _Et dans l'autre sens..._
]

#align(center)[
  #table(
    columns: 3,
    align: center + horizon,
    stroke: none,
    [*Accélération* \ $a(t)$], [$arrow(integral_(t_0)^t d t)$ \ Intégration \ (Aire + $v_0$)], [*Vitesse* \ $v(t)$],
    [], [], [], // Espace vide
    [*Vitesse* \ $v(t)$], [$arrow(integral_(t_0)^t d t)$ \ Intégration \ (Aire + $x_0$)], [*Position* \ $x(t)$]
  )
]

// ILLUSTRATION 3 (Optionnelle mais recommandée) :
// Un diagramme vertical en trois étages.
// Haut : Graphique Position (Parabole). Flèche vers le bas marquée "Dérivée".
// Milieu : Graphique Vitesse (Ligne oblique). Flèche vers le bas marquée "Dérivée".
// Bas : Graphique Accélération (Ligne horizontale constante).
// Sur le côté, des flèches remontent marquées "Intégrale".

== Aide-mémoire des fonctions usuelles

Voici les transformations que nous utiliserons le plus souvent dans ce cours :

#figure(
  table(
    columns: (1fr, 1fr, 1fr),
    inset: 10pt,
    align: center,
    stroke: 0.5pt + gray,
    table.header(
      [*Fonction* $f(t)$],
      [*Dérivée* $f'(t)$],
      [*Intégrale* $integral f(t) d t$]
    ),
    [Constante $k$ \ (ex: 5)],
    [$0$],
    [$k t + C$],

    [Linéaire $t$],
    [$1$],
    [$1/2 t^2 + C$],

    [Quadratique $t^2$],
    [$2t$],
    [$1/3 t^3 + C$],

    [Sinus $sin(omega t)$],
    [$omega cos(omega t)$],
    [$-1/omega cos(omega t) + C$],

    [Cosinus $cos(omega t)$],
    [$-omega sin(omega t)$],
    [$1/omega sin(omega t) + C$],
  ),
  caption: [Tableau des dérivées et primitives usuelles]
)