#import "@preview/theorion:0.4.1": *
#import cosmos.rainbow: *
#show: show-theorion

#set document(
  author: ("Richard Rispoli"),
  title: [Corrigé : Vecteurs & Physique]
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
    "Physics 203 - Solutions Session 5",
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
  Solutions détaillées.
]

#definition-box(title: "Solution 1 : Le Garde et le Voleur")[
    #figure(
      image("../images/exo1.svg", width: 50%),
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
      image("../images/exo2.svg", width: 70%),
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
      image("../images/vitesse_limite.png", width: 100%),
    )
  *Physique :*
  La "Vitesse Terminale" est atteinte quand l'accélération est nulle, donc quand les forces s'annulent.
  
  $ sum F = 0 "implique" F_"moteur" + F_"air" = 0 $
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