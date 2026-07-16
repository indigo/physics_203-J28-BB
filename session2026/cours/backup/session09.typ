#import "@preview/theorion:0.4.1": *
#import cosmos.rainbow: *
#show: show-theorion

// ===================== SESSION 09 =====================

#heading(level: 1)[Session 9 : L'Intégration de Verlet]

#definition-box(title: "Qu'est-ce que l'Intégration de Verlet ?")[
  Contrairement à l'intégration d'Euler, l'algorithme de **Verlet** ne stocke pas explicitement la vitesse d'un objet. 
  
  La vitesse est déduite de la différence entre la position actuelle et la position à l'instant précédent. C'est un schéma d'intégration **symplectique**, ce qui signifie qu'il conserve l'énergie de manière bien plus stable qu'Euler.
]

#tip-box(title: "Le Concept de Base")[
  Imaginez que vous savez où vous êtes ($P_n$) et où vous étiez il y a un instant ($P_{n-1}$). La direction et la distance entre ces deux points représentent votre **élan** (inertie).
]

#important-box(title: "La Formule Mathématique")[
  La position future ($x_{n+1}$) est calculée à partir de la position actuelle ($x_n$) et de la précédente ($x_{n-1}$) :
  
  $ x_{n+1} = x_n + (x_n - x_{n-1}) + a dot d t^2 $
  
  Où :
  - $(x_n - x_{n-1})$ représente la vitesse (pseudo-vitesse).
  - $a dot d t^2$ représente l'accélération (comme la gravité).
]

#definition-box(title: "L'Algorithme en 3 Étapes")[
  Pour chaque objet dans la simulation, on suit cet ordre strict :

  1. **Calcul de la Vitesse :** `vitesse = pos - old_pos`
  2. **Mise à jour :**
     - On sauve la position actuelle : `temp = pos`
     - On calcule la nouvelle : `pos = pos + vitesse + (accel * dt * dt)`
     - On met à jour l'ancienne : `old_pos = temp`
  3. **Contraintes :** On ajuste `pos` directement (murs, collisions).
]

#example(title: "Comparaison : Euler vs Verlet")[
  *Euler Explicite :*
  - Avantage : Très simple.
  - Inconvénient : "Explose" vite. Si on modifie la position d'un objet sans changer sa vitesse, le moteur devient incohérent.
  
  *Verlet :*
  - Avantage : *Inconditionnellement stable*. Si on déplace un objet manuellement (contrainte), sa vitesse s'ajuste d'elle-même à la frame suivante.
  - Idéal pour : Les tas de billes, les cordes, les tissus et les chevelures.
]

#definition-box(title: "Gestion des Collisions", [
  En Verlet, on ne calcule pas de forces de réaction complexes. On utilise la **Relaxation de Contrainte**.
  
  Si une bille pénètre dans un mur :
  - On la téléporte à la surface du mur (`pos.y = sol`).
  - À la prochaine frame, le calcul `pos - old_pos` donnera une vitesse nulle ou réduite.
  - Le système s'auto-équilibre.
  
  $ v_"new" = ("pos"_"corrigée" - "old"_"pos") / "dt" $
])

#heading(level: 2)[Annexe : La Méthode Runge-Kutta (RK4)]

#tip-box(title: "Le \"Couteau Suisse\" de la simulation physique")[
  Dans les sessions précédentes, nous avons utilisé la méthode d'Euler. Elle est simple, mais elle "dérape" vite car elle suppose que la vitesse est constante durant tout le pas de temps.
  
  La méthode de **Runge-Kutta d'ordre 4 (RK4)** corrige ce problème en étant beaucoup plus astucieuse : au lieu de regarder la pente (dérivée) uniquement au début, elle "sonde" le terrain à 4 endroits différents pour trouver une trajectoire moyenne quasi-parfaite.
]

#heading(level: 3)[1. Le Concept : 4 sondes valent mieux qu'une]

Imaginez que vous êtes aveugle et que vous devez traverser une vallée vallonnée en un pas de temps $Delta t$.

- *Euler (k1)* : Vous tendez le pied, sentez la pente actuelle, et faites un grand saut dans cette direction. $->$ _Risqué._
- *RK4* : Vous envoyez des éclaireurs virtuels avant de bouger.

1.  *k1 (Le Départ)* : Pente au début (comme Euler).
2.  *k2 (Le Milieu A)* : On utilise la pente $k 1$ pour avancer jusqu'à la moitié du pas ($Delta t / 2$) et on regarde la pente là-bas.
3.  *k3 (Le Milieu B)* : On se méfie de $k 2$. On repart du début, mais cette fois on utilise la pente $k 2$ pour aller au milieu. On regarde la nouvelle pente.
4.  *k4 (L'Arrivée)* : On utilise la pente $k 3$ pour aller jusqu'à la fin du pas ($Delta t$) et on regarde la pente finale.

*Le Grand Final :* On fait une **moyenne pondérée** de ces 4 pentes. On donne plus de poids aux pentes du milieu ($k 2$ et $k 3$).

$
"Pente Finale" = (k_1 + 2k_2 + 2k_3 + k_4) / 6
$

    #figure(
      image("images/Runge-Kutta_slopes.svg", width: 50%),
      caption: [
        Runge Kutta : 4 pentes pour une meilleure trajectoire
      ],
    )

#heading(level: 3)[2. Les Mathématiques (L'État du Système)]

Pour implémenter RK4 proprement, nous devons regrouper nos variables (Position et Vitesse) dans un seul vecteur que nous appellerons l'**État** ($Y$).

Si on a un système physique simple :
$
Y = vec(x, v) \
dot(Y) = f(t, Y) = vec(v, a)
$
La dérivée de l'état (le changement), c'est la vitesse et l'accélération.

Voici l'algorithme complet pour un pas de temps $h$ (ou $Delta t$) :

#definition-box(title: "Algorithme RK4 pour un pas $h$")[
  Soit la fonction `eval(état)` qui retourne la dérivée `[vitesse, accélération]`.
  1.  *$k_1$ (Début)* = `eval(état_actuel)`
  2.  *$k_2$ (Milieu)* = `eval(état_actuel +` $k_1 times h/2$`)`
  3.  *$k_3$ (Milieu)* = `eval(état_actuel +` $k_2 times h/2$`)`
  4.  *$k_4$ (Fin)* = `eval(état_actuel +` $k_3 times h$`)`
  *Nouvel État* = `état_actuel` + $(k_1 + 2k_2 + 2k_3 + k_4) / 6 times h$
]

#heading(level: 3)[3. Implémentation (Pseudo-Code / JavaScript)]

Contrairement à Euler où l'on écrit `pos += vel * dt` directement, RK4 nécessite une structure plus organisée.
```javascript
// Définition d'un État
struct State {
    Vector3 position;
    Vector3 velocity;
};

// La dérivée de l'état, c'est ce qui change
struct Derivative {
    Vector3 d_position; // C'est la vitesse
    Vector3 d_velocity; // C'est l'accélération (Forces / Masse)
};

// Fonction qui calcule les forces et retourne la dérivée
function evaluate(initialState, t, dt, derivative) {
    // 1. Estimer l'état futur basé sur la dérivée précédente
    State state = initialState;
    state.position += derivative.d_position * dt;
    state.velocity += derivative.d_velocity * dt;

    // 2. Calculer les forces à cet endroit/vitesse là
    // (Exemple: Gravité + Vent + Ressort)
    Vector3 forces = calculateForces(state.position, state.velocity);
    Vector3 acceleration = forces / mass;

    // 3. Retourner la nouvelle dérivée
    return new Derivative(state.velocity, acceleration);
}

// BOUCLE PRINCIPALE (INTÉGRATEUR)
function integrateRK4(state, t, dt) {
    // a. Préparer les 4 échantillons
    Derivative a = evaluate(state, t, 0.0, new Derivative()); // k1
    Derivative b = evaluate(state, t, dt*0.5, a);             // k2
    Derivative c = evaluate(state, t, dt*0.5, b);             // k3
    Derivative d = evaluate(state, t, dt, c);                 // k4

    // b. Moyenne pondérée pour la position (dxdt)
    Vector3 dxdt = (a.d_pos + 2*(b.d_pos + c.d_pos) + d.d_pos) * 1/6;
    
    // c. Moyenne pondérée pour la vitesse (dvdt)
    Vector3 dvdt = (a.d_vel + 2*(b.d_vel + c.d_vel) + d.d_vel) * 1/6;

    // d. Mise à jour finale
    state.position += dxdt * dt;
    state.velocity += dvdt * dt;
}```
