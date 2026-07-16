#import "@preview/theorion:0.4.1": *
#import cosmos.rainbow: *
#show: show-theorion

// ===================== SESSION 15 =====================

#heading(level: 1)[Session 15 : Joints, Moteurs]

#heading(level: 2)[Objectifs de la session]
- Comprendre les types de joints et leurs cas d'usage.
- Savoir configurer des moteurs et des limites sur les joints.
- Découvrir les raycasts comme outil de requête dans le moteur physique.

#heading(level: 3)[1. Les Joints]

#definition-box(title: "Joints (Articulations)")[
  Les joints relient deux RigidBodies, limitant leur mouvement relatif.
]

*Types :*
- *Fixed Joint* : les deux corps sont rigidement liés (soudure).
- *Revolute Joint* : rotation autour d'un axe (charnière).
- *Prismatic Joint* : translation le long d'un axe (tiroir).
- *Spherical Joint* : rotation libre (épaule, rotule).

*Configuration :* chaque joint nécessite des *ancres* (anchors) locales sur chaque corps.

#example(title: "Créer une charnière dans Rapier")[
  ```javascript
  const jointDesc = RAPIER.JointData.revolute(
    { x: 0, y: 1, z: 0 },  // ancre sur A
    { x: 0, y: -1, z: 0 }, // ancre sur B
    { x: 0, y: 1, z: 0 }   // axe de rotation
  );
  const joint = world.createJoint(jointDesc, bodyA, bodyB);
  ```
]

#heading(level: 3)[2. Les Moteurs et Limites]

#definition-box(title: "Moteurs")[
  On peut ajouter des moteurs aux joints pour les faire bouger activement.
  ```javascript
  joint.configureMotorVelocity(targetVelocity, stiffness, damping);
  ```
]

#definition-box(title: "Limites")[
  On ajoute des limites (min/max angle) pour empêcher une rotation excessive.
]

#heading(level: 3)[3. Les Raycasts]

#definition-box(title: "Raycast")[
  Un raycast projette un rayon invisible et retourne le premier objet touché.
]

*Utilisations :* détection du sol, visée FPS, interaction, capteurs de véhicule.

#example(title: "Raycast dans Rapier")[
  ```javascript
  const ray = new RAPIER.Ray(
    { x: 0, y: 10, z: 0 },
    { x: 0, y: -1, z: 0 }
  );
  const hit = world.castRay(ray, 20.0, true);
  if (hit) {
    console.log("Distance:", hit.timeOfImpact);
  }
  ```
]

#heading(level: 3)[4. TP : Machine de Siège]

#definition-box(title: "Objectif")[
  Construire une catapulte fonctionnelle :
  1. Créer une base fixe.
  2. Créer un bras avec un revolute joint.
  3. Ajouter un moteur au joint.
  4. Lancer un projectile.
]
