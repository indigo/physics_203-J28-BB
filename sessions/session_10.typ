#import "@preview/theorion:0.4.1": *
#import cosmos.rainbow: *
#show: show-theorion

#set document(
  author: ("Richard Rispoli"),
  title: [Session 10 : Élasticié et Systèmes de Contraintes]
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
  Aujourd'hui, nous allons les **lier** entre elles. Il existe deux manières de voir un lien :
  1. Comme une **Force** qui tire (Loi de Hooke).
  2. Comme une **Règle** géométrique à respecter (Contrainte de Verlet).
]

#heading(level: 1)[1. La Loi de Hooke (L'approche par Force)]

#definition-box(title: "Définition")[
  La loi de Hooke modélise la force exercée par un ressort. La force est proportionnelle à l'étirement (ou la compression) du ressort.
  
  $ arrow(F)_s = -k dot (|L - L_0|) dot hat(u) $
  
  - $k$ : Constante de raideur (stiffness). Plus $k$ est grand, plus le ressort est dur.
  - $L$ : Distance actuelle entre les deux points.
  - $L_0$ : Longueur au repos (rest length).
  - $hat(u)$ : Vecteur unitaire de la direction du ressort.
]

#important-box(title: "Le problème de la stabilité")[
  En utilisant Euler avec la loi de Hooke, si $k$ est trop élevé ou si le $d t$ est trop grand, le système accumule de l'énergie et **explose**. Pour stabiliser un ressort, il faut ajouter une **Force d'Amortissement** (Damping) :
  
  $ arrow(F)_d = -c dot v_{r e l} $
]

#heading(level: 1)[2. Contraintes de Distance (L'approche Verlet)]

#definition-box(title: "La méthode géométrique")[
  Avec l'intégration de Verlet, au lieu de calculer une force, on déplace directement les points pour satisfaire la longueur souhaitée. C'est exactement ce que vous avez fait pour séparer deux billes en collision !
  
  *Algorithme pour une contrainte entre A et B :*
  1. Calculer la distance actuelle $d$.
  2. Calculer l'erreur : $e = (d - L_0) / d$.
  3. Déplacer A et B de la moitié de l'erreur :
     $ P_"A" = P_"A" - 0.5 dot "erreur" dot arrow(A B) $
     $ P_"B" = P_"B" + 0.5 dot "erreur" dot arrow(A B) $
]

#pagebreak()

#definition-box(title: "Travaux Pratiques : La Corde de Verlet")[]

Objectif:
  Créer une corde composée de $N$ particules liées par des contraintes de distance.


=== Étape 1 : Structure de la Contrainte
Créez une structure `Constraint` qui lie deux indices de particules :
```c
typedef struct {
    int ballA;
    int ballB;
    float restLength;
} Constraint;
```