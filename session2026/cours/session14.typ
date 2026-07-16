#import "@preview/theorion:0.4.1": *
#import cosmos.rainbow: *
#show: show-theorion

// ===================== SESSION 14 =====================

#heading(level: 1)[Session 14 : Corps rigides – Boite de collision]

#heading(level: 2)[Objectifs de la session]
- Utiliser un moteur physique (Rapier.js) pour créer des corps rigides.
- Comprendre les types de RigidBody.
- Découvrir les Colliders et leurs formes.
- Synchroniser le moteur physique avec Three.js.

#tip-box(title: "Introduction")[
  Maintenant que nous comprenons les concepts, nous allons utiliser un vrai moteur : *Rapier.js*. C'est un moteur 3D écrit en Rust, compilé en WebAssembly, et recommandé pour Three.js.
]

#heading(level: 3)[1. Les RigidBodies]

#definition-box(title: "RigidBody")[
  Un `RigidBody` dans Rapier est l'objet principal. Il a :
  - position, rotation, vitesse linéaire et angulaire.
  - masse.
  - un type : `Dynamic`, `Fixed`, `Kinematic`.
]

*Types :*
- *Dynamic :* réagit aux forces et collisions.
- *Fixed :* immobile, les autres rebondissent contre.
- *Kinematic :* contrôlé par le code, pousse les Dynamic.

#example(title: "Créer un RigidBody dans Rapier")[
  ```javascript
  import RAPIER from '@dimforge/rapier3d';

  const world = new RAPIER.World({ x: 0, y: -9.81, z: 0 });

  const rigidBodyDesc = RAPIER.RigidBodyDesc.dynamic()
    .setTranslation(0, 5, 0);
  const rigidBody = world.createRigidBody(rigidBodyDesc);

  const colliderDesc = RAPIER.ColliderDesc.ball(1.0);
  const collider = world.createCollider(colliderDesc, rigidBody);
  ```
]

#heading(level: 3)[2. Les Colliders]

#definition-box(title: "Collider")[
  Le `Collider` définit la forme de l'objet pour la détection. Un RigidBody peut avoir plusieurs Colliders.
]

*Formes disponibles :*
- `ball(radius)` : sphère.
- `cuboid(hx, hy, hz)` : boîte.
- `capsule(halfHeight, radius)` : capsule.
- `cylinder(halfHeight, radius)` : cylindre.
- `convexHull(points)` : forme convexe personnalisée.
- `trimesh(vertices, indices)` : mesh quelconque (statique).

#heading(level: 3)[3. Boucle de simulation]

#example(title: "Synchronisation Three.js")[
  ```javascript
  function animate() {
    requestAnimationFrame(animate);

    world.step();

    for (const { mesh, rigidBody } of objects) {
      const position = rigidBody.translation();
      const rotation = rigidBody.rotation();
      mesh.position.set(position.x, position.y, position.z);
      mesh.quaternion.set(rotation.x, rotation.y, rotation.z, rotation.w);
    }

    renderer.render(scene, camera);
  }
  ```
]
