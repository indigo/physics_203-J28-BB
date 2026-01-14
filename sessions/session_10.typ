#import "@preview/theorion:0.4.1": *
#import cosmos.rainbow: *
#show: show-theorion

#set document(
  author: ("Richard Rispoli"),
  title: [Session 10 : Encore plus de forces]
)

#show title: set align(right)
#show title: set block(below: 1.2em)
#show title: set text(weight: "bold", size: 1.2em, fill: rgb("#406372"))

#set page(
  paper: "us-letter",
  margin: 2cm,
  header: align(right + horizon, "Physics 203 - Springs & Constraints"),
)

#set text(font: "Georgia", lang: "fr", size: 11pt)
#show heading: set text(weight: "bold", size: 1.1em, fill: rgb("#005F87"))

#title()

#tip-box(title: "Introduction")[
  Jusqu'à présent, nos particules étaient soit libres, soit en collision. 
  Aujourd'hui, nous allons voir d'autres types de forces.
  Dans un premier temps, nous allons voir comment *lier* des particules ensemble.
  Cela va nous permettre de créer des objets plus complexes, comme des chaînes, des tissus, ou des structures, et d'avoir des comportements plus intéressants.
  Dans un deuxième temps, nous allons mettre en pratique les forces gravitationnelles pour un TP épique.

  Il existe deux manières de voir un lien :
  1. Comme une *Force* qui tire (Loi de Hooke).
  2. Comme une *Règle* géométrique à respecter (Contrainte de Verlet).
]

#heading(level: 1)[1. La Loi de Hooke (L'approche par Force)]
    #figure(
    image("../images/HOOK.svg", width: 80%),
    caption: [loi de Hook],
  )
#definition-box(title: "Définition")[
  La loi de Hooke modélise la *force exercée par un ressort*. La force est proportionnelle à l'étirement (ou la compression) du ressort.

  $ arrow(F)_s = -k dot (|L - L_0|) dot hat(u) $
  
  - $k$ : Constante de raideur (stiffness). Plus $k$ est grand, plus le ressort est dur.
  - $L$ : Distance actuelle entre les deux points.
  - $L_0$ : Longueur au repos (rest length).
  - $hat(u)$ : Vecteur unitaire de la direction du ressort.

C'est une loi linéaire (qui est proportionnelle à la distance) qui décrit le comportement d'un ressort idéal.

]
#definition-box()[
  On peut noter que:
  - lorsque $L = L_0$, la force est nulle.
  - lorsque $L > L_0$, la force est négative (le ressort est étiré).
  - lorsque $L < L_0$, la force est positive (le ressort est comprimé).

  Cela signifie que la force est toujours dirigée vers la position d'équilibre.

]

#important-box(title: "Le problème de la stabilité")[
  En utilisant Euler avec la loi de Hooke, si $k$ est trop élevé ou si le $d t$ est trop grand, le système accumule de l'énergie et **explose**. Pour stabiliser un ressort, il faut ajouter une **Force d'Amortissement** (Damping) pour dissiper l'énergie parasite :
  
  $ arrow(F)_d = -c dot (arrow(v)_"A" - arrow(v)_"B") $
]

#heading(level: 1)[2. Contraintes de Distance (L'approche Verlet)]

#definition-box(title: "La méthode géométrique")[
  Avec l'intégration de Verlet, au lieu de calculer une force, on déplace directement les points pour satisfaire la longueur souhaitée. C'est un système de **relaxation**.
  
  *Algorithme pour une contrainte entre A et B :*
  1. Calculer la distance actuelle $d = ||P_"A" - P_"B"||$.
  2. Calculer l'erreur relative : $e = (d - L_0) / d$.
  3. Déplacer A et B de la moitié de l'erreur :
     $ P_"A" = P_"A" - 0.5 dot e dot (P_"A" - P_"B") $
     $ P_"B" = P_"B" + 0.5 dot e dot (P_"A" - P_"B") $
]

#tip-box(title: "La Rigidité par l'itération")[
  Si vous n'appliquez cette correction qu'une seule fois par frame, la corde semblera élastique. Pour obtenir un câble rigide, il faut répéter cette opération plusieurs fois par frame ($5$ à $15$ itérations). C'est ce qu'on appelle la **Relaxation de Gauss-Seidel**.
]

#pagebreak()

#heading(level: 1)[3. Travaux Pratiques : Le système solaire]

#definition-box(title: "Objectif")[
  Créer une simulation du système solaire.
]

#definition-box(title: "La force gravitationnelle")[
  La force gravitationnelle est une force d'attraction universelle qui s'exerce entre tous les corps possédant une masse, s'attirant mutuellement sans se toucher. Son intensité dépend directement des masses des objets et diminue avec le carré de la distance qui les sépare (selon la célèbre loi de la gravitation universelle de Newton). 
  
  C'est cette force qui maintient la Lune en orbite autour de la Terre et qui donne leur poids aux objets sur Terre

Elle est définie par la loi de la gravitation *universelle* de Newton :
$ bold( F = G dot (m_1 m_2 ) / r^2 ) $

où
F représente la force d'attraction entre les corps (Newton)

G représente la constante de la gravitation universelle ($6.67 × 10^"-11" N⋅m^2/"kg"^2$)

$m_1$ représente la masse du premier objet (kg)

$m_2$ représente la masse du deuxième objet (kg)

$r$ représente la distance séparant les deux objets (m)
]
#important-box(title: "Le défi du TP : L'orbite stable")[
  Pour qu'une planète orbite autour d'une étoile sans s'écraser ni s'enfuir, elle doit posséder une *vitesse tangentielle* initiale précise.
  
  $ v_"orbitale" = sqrt((G dot M_"étoile") / r) $
]

#definition-box(title: "Données astronomiques")[
Nous utiliserons des valeurs relatives. 

Le **Soleil** sera placé au centre avec une masse de **333 000** (unités terrestres).
]

#table(
  columns: (1fr, 1.2fr, 1.2fr, 1.5fr),
  inset: 7pt,
  align: center + horizon,
  stroke: 0.5pt + gray,
  table.header([*Astre*], [*Masse relative* \ (Terre = 1)], [*Distance* \ (UA)], [*Vitesse Orbitale* \ (Relative)]),
  [Mercure], [0.055], [0.39], [1.60],
  [Vénus], [0.815], [0.72], [1.17],
  [**Terre**], [**1.000**], [**1.00**], [**1.00**],
  [Mars], [0.107], [1.52], [0.80],
  [Jupiter], [317.8], [5.20], [0.43],
  [Saturne], [95.2], [9.54], [0.32],
  [Uranus], [14.5], [19.20], [0.22],
  [Neptune], [17.1], [30.10], [0.18],
)

#tip-box(title: "Conseils pour l'échelle du TP")[
  - **Unités :** Si vous prenez 1 UA = 100 pixels, Neptune sera trop loin (3000 px). Essayez plutôt **1 UA = 20 pixels** ou utilisez un zoom caméra.
  - **Vitesse initiale :** Pour que la Terre reste en orbite circulaire, sa vitesse de départ doit être perpendiculaire au rayon Soleil-Terre. 
  - **G :** Réglez votre constante $G$ de sorte que la Terre mette environ 10 secondes à faire un tour complet.
]

#tip-box(title: "Vitesse d'orbite")[
Pour qu'une planète reste en orbite circulaire, sa vitesse initiale doit être perpendiculaire au rayon Soleil-Terre.

Sa vitesse est donc de $ v = sqrt((G dot M_"soleil") / r) $.

]