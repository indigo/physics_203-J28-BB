#import "@preview/theorion:0.4.1": *
#import cosmos.rainbow: *
#show: show-theorion

// ===================== SESSION 05 =====================

#heading(level: 1)[Session 5 : Cahier d'Exercices - Vecteurs & Physique]

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

#pagebreak()

#heading(level: 2)[Corrigé : Vecteurs & Physique]

#definition-box(title: "Thème 1 : Vecteurs et Produits Scalaires")[
  Solutions détaillées.
]

#definition-box(title: "Solution 1 : Le Garde et le Voleur")[
    #figure(
      image("images/exo1.svg", width: 50%),
    )
  
  1. *Calcul du vecteur Garde $->$ Voleur ($arrow(V)$)* :
     $ arrow(V) = P - G = vec(5 - 10, 12 - 10) = vec(-5, 2) $

  2. *Produit Scalaire (Test de vision)* :
     On projette la position du voleur sur la direction du regard.
     $ "Dot" = arrow(V) dot arrow(D) = (-5 times 1) + (2 times 0) = -5 $

  3. *Conclusion* :
     Le résultat est **négatif** ($-5 < 0$).
     L'angle entre le regard et le voleur est donc supérieur à 90°.
     
     *Réponse :* Le voleur est **Derrière** le garde.
]

#definition-box(title: "Solution 2 : La Racing Line")[
    #figure(
      image("images/exo2.svg", width: 70%),
    )
  1. *Vecteur Voiture ($arrow(A V)$)* :
     $ arrow(A V) = V - A = vec(50, 5) $
  
  2. *Direction de la piste ($arrow(u)$)* :
     Le vecteur $arrow(A B) = vec(100, 0)$.
     Son vecteur unitaire (normalisé) est $arrow(u) = vec(1, 0)$.
     
  3. *Projection (Distance parcourue sur la piste)* :
     $ "Proj" = arrow(A V) dot arrow(u) = (50 times 1) + (5 times 0) = 50 $
     Le point projeté sur la ligne est donc $H(50, 0)$.
     
  4. *Distance latérale (Écart)* :
     C'est la distance entre $V(50, 5)$ et $H(50, 0)$.
     
     *Réponse :* La voiture est à **5 mètres** de la ligne idéale.
]

#definition-box(title: "Solution 3 : Le Radar (Vitesse Relative)")[
  1. *Vecteur de visée $arrow(D)$* :
     $ arrow(D) = P_B - P_A = vec(0, 500) - vec(0, 0) = vec(0, 500) $

  2. *Normale de visée $arrow(n)$* :
     On normalise $arrow(D)$. Comme il est purement vertical :
     $ arrow(n) = vec(0, 1) $

  3. *Projections des vitesses (Produit Scalaire)* :
     - Police : $v_A_"proj" = vec(0, 100) dot vec(0, 1) = 100 "km/h"$
     - Cible : $v_B_"proj" = vec(85, 85) dot vec(0, 1) = 85 "km/h"$

  4. *Conclusion* :
     La police fonce vers le Nord à 100. La cible s'éloigne vers le Nord à 85 seulement (le reste de sa vitesse part vers l'Est).
     $ v_A_"proj" > v_B_"proj" $
     *Réponse :* Oui, la police **rattrape** la cible (à une vitesse relative de 15 km/h). Mais attention, cela n'est vrai qu'au moment du scan. Comme la voiture de la cible se déplace vers l'est, le vecteur de visée change constamment.
]

#pagebreak()

#definition-box(title: "Thème 2 : Forces, Gravité et Frottements")[
  Solutions et Logique Code.
]

#definition-box(title: "Solution 4 : Le Drag Race")[
      #figure(
      image("images/vitesse_limite.png", width: 100%),
    )
  *Physique :*
  La "Vitesse Terminale" est atteinte quand l'accélération est nulle, donc quand les forces s'annulent.
  
  $ sum F = 0 "implies" F_"moteur" + F_"air" = 0 $
  $ 5000 - k v^2 = 0 $
  $ k v^2 = 5000 $
  
  *Calcul :*
  $ v = sqrt(5000 / 0.8) = sqrt(6250) approx 79.05 "m/s" $
  
  Soit environ **284 km/h**.
]

#definition-box(title: "Solution 5 : Le Sniper")[
  *1. Décomposition de la vitesse initiale ($t=0$)* \
  Avec $v_0 = 50$ m/s et $theta = 45 degree$ :
  $ v_{0x} = v_0 cos(theta) = 50 times 0.707 approx 35.35 "m/s" $
  $ v_{0y} = v_0 sin(theta) = 50 times 0.707 approx 35.35 "m/s" $

  *2. Équations de position (au temps $t$)* \
  On néglige les frottements. L'accélération ne joue que sur la hauteur ($y$) :
  - Horizontal : $x(t) = v_{0x} times t$
  - Vertical : $y(t) = v_{0y} times t - 1/2 g t^2$

  *3. Calcul du temps de vol ($t_{"vol"}$)* \
  Le projectile touche le sol quand $y(t) = 0$ (pour $t > 0$) :
  $ 35.35 t - 0.5 times 9.81 times t^2 = 0 $
  $ t times (35.35 - 4.905 t) = 0 $
  $ t_{"vol"} = 35.35 / 4.905 approx 7.207 "secondes" $

  *4. Calcul de la portée ($R$)* \
  C'est la distance parcourue horizontalement pendant le temps de vol :
  $ R = x(t_{"vol"}) = 35.35 "m/s" times 7.207 "s" approx 254.8 "mètres" $

  *Note Code :* Si votre simulation (Euler) donne une valeur éloignée (ex: 260m), c'est que votre pas de temps $Delta t$ est trop grand pour capter précisément l'instant $t_{"vol"}$.
]

#definition-box(title: "Solution 6 : Le Cube (Logique Code)")[
  *Algorithme à implémenter dans `updatePhysics` :*
  
  ```javascript
  // 1. Calcul des forces
  const Px = mass * g * Math.sin(angle); // Force qui tire vers le bas
  const Py = mass * g * Math.cos(angle); // Force qui plaque au sol
  
  const frictionMax = mu * Py; // Résistance max du sol
  
  // 2. Décision (Seuil)
  if (Px > frictionMax) {
      // Glissement : La force nette est la différence
      const netForce = Px - (mu_cinetique * Py);
      acceleration = netForce / mass;
  } else {
      // Statique : Pas de mouvement
      acceleration = 0;
      velocity = 0;
  }
  ```
]
