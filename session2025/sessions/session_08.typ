#import "@preview/theorion:0.4.1": *
#import cosmos.rainbow: *
#show: show-theorion

#set document(
  author: ("Richard Rispoli"),
  title: [Session 8 : Physique de la Rotation]
)

#show title: set align(right)
#show title: set block(below: 1.2em)
#show title: set text(weight: "bold", size: 1em, fill: rgb("#406372"))

#set page(
  paper: "us-letter",
  margin: 2cm,
  header: align(right + horizon, "Physics 203 - Mécanique du Solide"),
)

#set text(font: "Georgia", lang: "fr", size: 11pt)

#show heading: set text(weight: "bold", size: 1.1em, fill: rgb("#005F87"))

#title()

#tip-box(title: "L'objectif du jour")[
  Passer de la particule (un point) au **corps rigide** (une forme). 
  Un corps rigide ne fait pas que se déplacer, il *pivote* autour de son centre de masse.
]

#definition-box(title: "1. Le Dictionnaire de Traduction")[
  #table(
    columns: (1fr, 1fr, 1fr),
    inset: 8pt,
    align: center + horizon,
    stroke: 0.5pt + gray,
    table.header([*Concept*], [*Translation (Linéaire)*], [*Rotation (Angulaire)*]),
    [Position], [$arrow(r)$ (m)], [Angle $theta$ (rad)],
    [Vitesse], [$arrow(v)$ (m/s)], [Vitesse Angulaire $omega$ (rad/s)],
    [Résistance], [Masse $m$ (kg)], [**Moment d'Inertie $I$** (kg·m²)],
    [Cause], [Force $arrow(F)$ (N)], [**Couple / Torque $tau$** (N·m)],
    [*Loi de Newton*], [$arrow(F) = m arrow(a)$], [$tau = I alpha$]
  )
]

#important-box(title: "2. Le Couple (Torque) : Faire tourner")[
  Le couple $tau$ dépend de **où** on pousse. 
      #figure(
image("../images/Moment.svg", width: 50%),
  caption: [
    Plus on tire loin du centre, plus l'effet de rotation est fort.
  ],
)


  *En 3D (Vectoriel) :*

  La formule générale utlise un produit vectoriel.
  $ bold(arrow(tau) = arrow(r) times arrow(F) ) $

$tau$ est donc un vecteur perpendiculaire au plan de rotation.

  *En 2D (Scalaire) :*

  En 2D, la formule se simplifie.
  $ tau = r_x F_y - r_y F_x $ 
  _(Où $arrow(r)$ est le vecteur allant du centre de masse au point d'impact)_


]

#definition-box(title: "3. Le Moment d'Inertie (I ou J)")[
Le moment d'inertie représente la résistance d'un objet à la rotation.
  
Il dépend de la répartition de la masse, et de la forme de l'objet. 

Toujours par rapport a l'axe de rotation bien entendu.

La formule générale est :

 $ bold(I = sum_i  m_i.r_i^2) $

 ou $r_i$ est la distance au centre de rotation de la masse $m_i$.

Pour un anneau mince de masse $m$ et de rayon $R$, on a :

$ I = m R^2 $, en effet, toute la masse de l'anneau est à la distance fixe $R$ du centre de rotation.

#definition-box(title: "Exercice A : Calcul du moment d’inertie d’un anneau")[
  Retrouver $I = m R^2$ pour un anneau mince de masse $m$ et de rayon $R$.
  
  *1. Paramètres :*
  - Densité linéaire : $lambda = m / L = m / (2 pi R)$ (où $L$ est la circonférence).
  - Masse infinitésimale d'un petit segment : $d m = lambda R d theta$.
  - Distance à l'axe pour tout point : $r = R$.

  *2. Calcul par intégration :*
  Le moment d'inertie total est la somme (intégrale) des moments infinitésimaux $d I = r^2 d m$.

  $ I = integral d I = integral_0^(2 pi) R^2 dot (lambda R d theta) $

  Sortons les constantes de l'intégrale :
  $ I = lambda R^3 integral_0^(2 pi) d theta $

  Résolution de l'intégrale :
  $ I = lambda R^3 [theta]_0^(2 pi) $
  $ I = lambda R^3 (2 pi - 0) = 2 pi lambda R^3 $

  *3. Substitution et simplification :*
  Remplaçons $lambda$ par sa définition ($m / (2 pi R)$) :
  
  $ I = (m / (cancel(2 pi R))) dot cancel(2 pi) R^(cancel(3) 2) $

  #align(center)[
    #rect(stroke: 2pt + rgb("#005F87"), inset: 10pt)[
      $ bold(I = m R^2) $
    ]
  ]
  
  *Conclusion :* Pour un anneau, toute la masse est à la distance maximale $R$. C'est l'objet qui offre la plus grande résistance à la rotation pour une masse donnée.
]

  - **Rectangle (Largeur $w$, Hauteur $h$) :** 
    $ I = 1/12 m (w^2 + h^2) $
  
  *Pourquoi $1/12$ ?* C'est le résultat mathématique de l'intégration de la masse sur toute la surface du rectangle.
]

#definition-box(title: "4. Vitesse d'un point sur le corps")[
  C'est l'équation la plus importante pour la détection de collision future.
  Si un corps se déplace à $arrow(v)_G$ et tourne à $omega$, la vitesse d'un point $P$ situé à la distance $arrow(r)$ du centre est :
  
  $ arrow(v)_P = arrow(v)_G + (omega times arrow(r)) $
  
  *En 2D, cela devient :*
  $ v_(P.x) = v_(G.x) - omega dot r_y $
  $ v_(P.y) = v_(G.y) + omega dot r_x $
]

#pagebreak()

#definition-box(title: "Travaux Pratiques : Le 'Spinning Box'")[]

#definition-box(title: "Objectif")[
  Implémenter un rectangle qui tourne lorsqu'on clique dessus avec la souris (application d'une force à un point précis).
]

=== Étape 1 : Mise à jour de la classe `RigidBody`
Ajoutez les propriétés suivantes à vos objets :
- `angle` (float)
- `angularVelocity` (float)
- `torque` (float)
- `Inertia` (float) : Calculez-le une seule fois au début via la formule du rectangle.

=== Étape 2 : La méthode `ApplyForce(force, worldPoint)`
Cette méthode remplace l'ancien ajout direct à l'accélération :
1. Calculer le bras de levier : $arrow(r) = "worldPoint" - "positionCentre"$.
2. Ajouter à la force linéaire : $arrow(F)_"total" += arrow("force")$.
3. Ajouter au torque : $tau += (r_x F_y - r_y F_x)$.

=== Étape 3 : L'intégrateur (Euler Semi-Implicite)
Dans votre boucle `update(dt)` :
1. $a = F / m$
2. $alpha = tau / I$
3. $v += a dot d"t"$
4. $omega += alpha dot d"t"$
5. $p += v dot d"t"$
6. $theta += omega dot d"t"$
7. **Important :** Remettre `F` et `tau` à zéro pour la frame suivante.

#definition-box(title: "Test de compréhension")[
  "A) L'objet tourne plus vite si je clique au centre.",
  "B) L'objet tourne plus vite si je clique sur un coin.",
  "C) L'endroit du clic n'a pas d'importance."
]
"Pensez au bras de levier r."