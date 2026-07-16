#import "@preview/theorion:0.4.1": *
#import cosmos.rainbow: *
#show: show-theorion

#set document(
  author: ("Richard Rispoli"),
  title: [Session 13 : Joints, Moteurs & Raycasts]
)

#show title: set align(right)
#show title: set block(below: 1.2em)
#show title: set text(weight: "bold", size: 1.2em, fill: rgb("#406372"))

#set page(
  paper: "us-letter",
  margin: 2cm,
  header: align(right + horizon, "Physics 203 - Commercial Engines II"),
)

#set text(font: "Georgia", lang: "fr", size: 11pt)
#show heading: set text(weight: "bold", size: 1.1em, fill: rgb("#005F87"))

#title()

#tip-box(title: "Introduction")[
  Pour le moment, nous avons des briques qui tombent. C'est amusant, mais pour faire un vrai jeu (ou une machine complexe), nous devons relier les objets entre eux.
  
  C'est le rôle des *Joints* (Articulations) et des *Constraints*.
]

#heading(level: 1)[1. Les Joints (Articulations)]

Un Joint relie deux RigidBodies ($A$ et $B$) et limite leurs mouvements relatifs.

#definition-box(title: "Les Types Principaux")[
  - *Fixed Joint :* Colle deux objets ensemble (ex: souder deux pièces).
  - *Revolute Joint (Hinge) :* Une charnière. Rotation libre autour d'un axe (ex: Roue de voiture, Porte, Genou).
  - *Prismatic Joint (Slider) :* Glissière. Translation libre sur un axe (ex: Ascenseur, Piston).
  - *Spherical Joint (Ball & Socket) :* Rotation libre sur tous les axes (ex: Épaule, Attelage de remorque).
]

#important-box(title: "Ancres (Anchors)")[
  Pour définir un joint, il faut préciser *où* il s'accroche sur chaque objet.
  - $"Anchor"_A$ : Point d'attache dans le repère local de A.
  - $"Anchor"_B$ : Point d'attache dans le repère local de B.
]

#example(title: "Créer une Charnière (Rapier)")[
  ```javascript
  // On veut attacher une roue (bodyB) à une voiture (bodyA)
  // L'axe de rotation est l'axe X (1, 0, 0)
  
  let jointDesc = RAPIER.JointData.revolute(
      { x: 0.0, y: -0.5, z: 0.0 }, // Anchor A (sous la voiture)
      { x: 0.0, y: 0.0, z: 0.0 },  // Anchor B (centre de la roue)
      { x: 1.0, y: 0.0, z: 0.0 }   // Axe de rotation
  );
  
  world.createImpulseJoint(jointDesc, bodyA, bodyB);
  ```
]

#heading(level: 1)[2. Moteurs & Limites]

Les joints ne sont pas forcément passifs. On peut les motoriser ou restreindre leur mouvement.

#definition-box(title: "Contrôle actif")[
  - *Limits :* Empêcher une porte de s'ouvrir à plus de 90 degrés.
    `joint.setLimits(-PI/2, PI/2)`
  - *Motor (Velocity) :* Faire tourner une roue à vitesse constante.
    `joint.configureMotorVelocity(10.0, 50.0)` (Vitesse cible, Force max)
  - *Motor (Position) :* Servo-moteur qui cherche à atteindre un angle précis.
    `joint.configureMotorPosition(targetAngle, stiffness, damping)`
]

#heading(level: 1)[3. Raycasting (Interaction)]

Comment cliquer sur un objet 3D ? Comment savoir si mon personnage voit l'ennemi ?
On lance un rayon invisible (*Ray*) et on demande au moteur physique ce qu'il touche.

#figure(
  // image("raycast.png"), // Placeholder
  "../images/raycast.png",
  caption: [Le Raycast part de la caméra et traverse le monde]
)

#example(title: "Tirer un rayon")[
  ```javascript
  let ray = new RAPIER.Ray(origin, direction);
  let maxToi = 100.0; // Distance max
  let solid = true;   // Considérer les objets pleins comme obstacles
  
  let hit = world.castRay(ray, maxToi, solid);
  
  if (hit != null) {
      // On a touché quelque chose !
      let collider = hit.collider;
      let point = ray.pointAt(hit.timeOfImpact); // Position précise
      
      console.log("Touché : ", collider.handle);
  }
  ```
]

#heading(level: 1)[4. Travaux Pratiques]

Voir le sujet "Siege Engine - Partie B".
Vous allez construire une catapulte fonctionnelle avec des joints et interagir avec la souris.
