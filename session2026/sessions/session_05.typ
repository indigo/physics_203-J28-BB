#import "@preview/theorion:0.4.1": *
#import cosmos.rainbow: *
#show: show-theorion

#set document(
  author: ("Richard Rispoli"),
  title: [Cahier d'Exercices : Vecteurs & Physique]
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
    "Physics 203 - TP Session 5",
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

#definition-box(title: "Thème 1 : Vecteurs et Produits Scalaires")[
  Ces exercices visent à maîtriser les outils mathématiques de base pour la détection et l'IA.
]

#example(title: "Exercice 1 : Le Garde et le Voleur")[

  *Contexte :* Dans un jeu d'infiltration, un garde regarde dans une direction donnée par le vecteur directeur $arrow(D)$. Un voleur se trouve à une position $P$ dans la pièce. Le garde se trouve à la position $G$.

  On considère que le garde a un champ de vision de 180° (il voit tout ce qui est devant lui).

  *Données :*
  - Position du Garde : $G(10, 10)$
  - Direction du regard : $arrow(D) = vec(1, 0)$ (Regarde vers l'Est)
  - Position du Voleur : $P(5, 12)$

  *Question :*
  En utilisant le **produit scalaire**, déterminer si le voleur est "Devant" ou "Derrière" le garde.
]

#example(title: "Exercice 2 : La Racing Line (Projections)")[

  *Contexte :* Pour aider une IA à conduire, on définit la trajectoire idéale comme une ligne droite entre deux points $A$ et $B$. La voiture se trouve actuellement au point $V$.
  
  On souhaite connaitre la distance latérale entre la voiture et cette trajectoire idéale (l'écart de conduite).

  *Données :*
  - Départ de la ligne : $A(0, 0)$
  - Fin de la ligne : $B(100, 0)$
  - Position Voiture : $V(50, 5)$

  *Question :*
  1. Calculer le vecteur $arrow(A V)$.
  2. Projeter ce vecteur sur la direction de la piste $arrow(A B)$.
  3. En déduire la distance de la voiture à la ligne.
]

#example(title: "Exercice 3 : Le Radar de Vitesse (Vitesse Relative)")[

  *Contexte :* Un radar mesure la vitesse de rapprochement sur sa ligne de visée. Pour savoir ce que le radar affiche, il faut projeter les vitesses des véhicules sur l'axe qui les relie.

  *Données (Positions et Vitesses) :*
  - Police (A) :
    - Position : $P_A = vec(0, 0)$
    - Vitesse : $arrow(v)_A = vec(0, 100)$ (Roule vers le Nord à 100 km/h)
  
  - Cible (B) :
    - Position : $P_B = vec(0, 500)$ (Est située 500m au Nord de la police)
    - Vitesse : $arrow(v)_B = vec(85, 85)$ (Roule vers le Nord-Est à $approx 120$ km/h)

  *Questions :*
  1. Calculer le vecteur direction de visée $arrow(D) = P_B - P_A$.
  2. En déduire la normale de visée $arrow(n)$ (le vecteur unitaire).
  3. Projeter les vitesses $arrow(v)_A$ et $arrow(v)_B$ sur $arrow(n)$ (Produit Scalaire).
  4. La police est-elle en train de rattraper la cible ? (Est-ce que $v_A$ projeté $> v_B$ projeté ?)
]

#definition-box(title: "Thème 2 : Forces, Gravité et Frottements")[
  Application des lois de Newton pour simuler des mouvements réalistes.
]

#example(title: "Exercice 4 : Le Drag Race (Code)")[
  
  *Contexte :* Une voiture accélère en ligne droite.
  
  - Force Moteur : $F_"moteur" = 5000 "N"$ (Constante).
  - Friction de l'air : $F_"air" = -k dot v^2$ (Opposée au mouvement).
  - Masse : $m = 1000 "kg"$, Coefficient $k = 0.8$.

  *Objectif Code :*
  Implémenter ce système dans Three.js. Afficher la vitesse en temps réel.
  Observer la "Vitesse Terminale" : le moment où la voiture n'accélère plus car la friction compense exactement le moteur.
]

#example(title: "Exercice 5 : Le Sniper (Balistique)")[
  *Contexte :* On tire un projectile soumis uniquement à la gravité $arrow(g) = vec(0, -9.81)$.
  
  *Données :*
  - Vitesse initiale : $v_0 = 50 "m/s"$.
  - Angle de tir : $theta = 45 degree$.
  - Hauteur initiale : $y_0 = 0$.

  *Objectif Code :*
  Trouver ce résultat dans une simulation avec la méthode d'Euler.
]

#example(title: "Exercice 6 : Le Cube sur la Pente (Code)")[
  *Contexte :* Reprise de l'exercice théorique sur le plan incliné.
  
  *Mise en place :*
  Créer un plan (sol) dans Three.js dont on peut modifier l'inclinaison (rotation X) via une interface (GUI).
  Poser un cube dessus.
  
  *Logique à coder :*
  - Calculer la force de gravité parallèle à la pente : $P_x = m g sin(theta)$.
  - Calculer la friction statique max : $f_(s,max) = mu_s m g cos(theta)$.
  - *Condition :* Tant que $P_x < f_(s,max)$, la vitesse reste à 0. Sinon, le cube accélère.
  
  *Test :* Vérifier si le cube se met à glisser exactement à l'angle prévu (ex: 30° pour $mu_s = 0.57$).
]

#example(title: "Exercice 7 : L'Ascenseur Spatial (Ressorts)")[
  *Contexte :* Une boule est suspendue dans le vide, attachée à un point fixe par un ressort invisible.
  
  *Loi de Hooke :* $arrow(F) = -k dot (L - L_0) dot arrow(n)$
  (Où $L$ est la longueur actuelle et $L_0$ la longueur au repos).
  
  *Objectif Code :*
  Simuler ce ressort. Ajouter une force d'amortissement (Damping) $F = -b dot v$ pour que la boule finisse par se stabiliser et ne rebondisse pas à l'infini.
]

#pagebreak()

#definition(title: "Thème 3 : Collisions et Impulsions")[
  Gestion des chocs et conservation de la quantité de mouvement.
]

#example(title: "Exercice 8 : Le Bumper Car (Code)")[
  *Contexte :* Arène fermée avec 5 boules de masses identiques.
  
  *Objectif Code :*
  Mettre en place la boucle de détection "Narrow Phase" : vérifier chaque paire de boules $(i, j)$.
  Si `distance < radius * 2`, résoudre la collision élastique ($e=1$).
  
  Observer le chaos et vérifier que les boules ne "fusionnent" pas (stabilité).
]

#example(title: "Exercice 9 : Le Matériau Mystère")[
  *Contexte :* On lâche 3 boules de la même hauteur $H = 10m$. Elles tombent sur le sol (masse infinie).
  
  - Boule A : Remonte à 10m.
  - Boule B : Remonte à 5m.
  - Boule C : Reste collée au sol.
  
  *Question :*
  Déterminer le coefficient de restitution $e$ pour chaque boule.
  Rappel : $v_"après" = -e dot v_"avant"$.
]

#example(title: "Exercice 10 : Le Rocket Jump")[
  *Contexte :* Une explosion se produit à la position $E(0, 0, 0)$.
  Un joueur se trouve à la position $P(2, 0, 0)$.
  
  On veut propulser le joueur avec une impulsion radiale.
  
  *Règle :*
  - Direction : Du centre de l'explosion vers le joueur.
  - Intensité : $J = 100 / "distance"^2$.
  
  *Question :*
  Calculer le vecteur Impulsion $arrow(J)$ à appliquer au joueur.
]