#import "@preview/theorion:0.4.1": *
#import cosmos.rainbow: *
#show: show-theorion

// ===================== SESSION 09 =====================

#heading(level: 1)[Session 9 : TP - Particules]

#heading(level: 2)[Objectifs du TP]
- Implémenter un système de particules simple.
- Utiliser Verlet ou Euler pour mettre à jour les particules.
- Créer des contraintes de distance pour former des structures (tissu, corde).
- Observer les cycles de vie naissance / update / mort.

#tip-box(title: "Contexte")[
  Un système de particules simule un grand nombre de petits objets : pluie, feu, fumée, étincelles. C'est le moment d'appliquer concrètement l'intégration vue précédemment.
]

#heading(level: 3)[1. Structure d'une Particule]

#definition-box(title: "Propriétés d'une particule")[
  - Position, vitesse, accélération
  - Durée de vie (lifetime)
  - Couleur, taille
  - Masse (optionnelle)
]

#heading(level: 3)[2. L'Émetteur]

#definition-box(title: "Emitter")[
  - Génère des particules à un taux donné (ex: 1000/s).
  - Définit position, direction, vitesse initiale.
  - Peut être un point, un cercle, une sphère ou un cône.
]

#heading(level: 3)[3. Le Cycle de Vie]

#definition-box(title: "Cycle de vie")[
  1. *Naissance* : création avec paramètres initiaux.
  2. *Update* : application des forces (gravité, drag), mise à jour de la position.
  3. *Rendu* : dessin sous forme de billboard (quad face caméra).
  4. *Mort* : désactivation et recyclage quand `lifetime <= 0`.
]

#heading(level: 3)[4. Interactions Physiques]

- *Gravité* : $arrow(a) = arrow(g)$.
- *Drag* : $arrow(F) = -k dot arrow(v)$.
- *Collisions simplifiées* : rebond sur un plan, par exemple.

```javascript
if (particle.position.y < 0) {
    particle.position.y = 0;
    particle.velocity.y *= -restitution; // rebond mou
}
```

#heading(level: 3)[5. Contraintes et Structures]

#tip-box(title: "Objectif avancé")[
  Relier des particules par des contraintes de distance pour créer un tissu ou une corde. Utiliser Verlet pour la stabilité et résoudre les contraintes en plusieurs itérations.
]

#heading(level: 3)[6. Défis]

- Créer un émetteur de pluie.
- Créer un feu de camp avec des particules qui montent et s'estompent.
- Créer un drapeau (tissu) avec des contraintes de distance.
