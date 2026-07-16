#import "@preview/theorion:0.4.1": *
#import cosmos.rainbow: *
#show: show-theorion

// ===================== SESSION 13 =====================

#heading(level: 1)[Session 13 : Joints, Moteurs & Raycasts]

#definition-box(title: "1. Les Joints (Articulations)")[
  Les joints relient deux RigidBodies entre eux, limitant leur mouvement relatif.
  
  *Types de Joints :*
  - *Fixed Joint :* Les deux corps sont rigidement liés (comme un soudage).
  - *Revolute Joint :* Rotation autour d'un axe (comme une charnière de porte).
  - *Prismatic Joint :* Translation le long d'un axe (comme un tiroir).
  - *Spherical Joint :* Rotation libre dans toutes les directions (comme une épaule).
  
  *Configuration :*
  Chaque joint nécessite des *ancres* (anchors) : la position du joint sur chaque corps, dans les coordonnées locales de chaque corps.
]

#example(title: "Créer une charnière (Revolute Joint)")[
  ```javascript
  const jointDesc = RAPIER.JointData.revolute(
    { x: 0, y: 1, z: 0 },  // Anchor on body A (local)
    { x: 0, y: -1, z: 0 }, // Anchor on body B (local)
    { x: 0, y: 1, z: 0 }   // Axis of rotation (world)
  );
  const joint = world.createJoint(jointDesc, bodyA, bodyB);
  ```
]

#definition-box(title: "2. Les Moteurs et Limites")[
  On peut ajouter des *moteurs* aux joints pour les faire tourner activement.
  
  ```javascript
  // Configurer un moteur sur un revolute joint
  joint.configureMotorVelocity(targetVelocity, stiffness, damping);
  ```
  
  On peut aussi ajouter des *limites* (min/max angle) pour empêcher une rotation excessive (comme un coude qui ne peut pas tourner à 360°).
]

#definition-box(title: "3. Les Raycasts")[
  Un raycast projette un rayon invisible dans la scène et retourne le premier objet touché.
  
  *Utilisations :*
  - Détection du sol (Character Controller).
  - Visée (FPS).
  - Interaction (cliquer sur un objet).
  - Capteurs de voiture (autonomous driving).
]

#example(title: "Raycast dans Rapier")[
  ```javascript
  const ray = new RAPIER.Ray(
    { x: 0, y: 10, z: 0 },  // Origin
    { x: 0, y: -1, z: 0 }   // Direction
  );
  const hit = world.castRay(ray, 20.0, true);
  
  if (hit) {
    console.log("Touché à la distance:", hit.timeOfImpact);
    console.log("Collider touché:", hit.collider);
  }
  ```
]

#definition-box(title: "TP : La Machine de Siège")[
  *Objectif :* Construire une catapulte fonctionnelle.
  1. Créer une base fixe.
  2. Créer un bras avec un revolute joint.
  3. Ajouter un moteur au joint.
  4. Lancer un projectile.
]
