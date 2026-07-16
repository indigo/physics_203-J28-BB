#import "@preview/theorion:0.4.1": *
#import cosmos.rainbow: *
#show: show-theorion

// ===================== SESSION 12 =====================

#heading(level: 1)[Session 12 : RigidBodies & Colliders]

#tip-box(title: "Introduction")[
  Maintenant que nous comprenons les concepts, nous allons utiliser un vrai moteur physique : **Rapier.js**.
  
  Rapier est un moteur 3D écrit en Rust, compilé en WebAssembly, et utilisable en JavaScript. C'est le moteur recommandé pour Three.js.
]

#definition-box(title: "1. Les RigidBodies")[
  Un `RigidBody` dans Rapier est l'objet principal. Il a :
  - Une position (translation + rotation).
  - Une vélocité (linéaire et angulaire).
  - Une masse.
  - Un type : `Dynamic`, `Fixed`, `Kinematic`.
  
  *Types de RigidBodies :*
  - *Dynamic :* Réagit aux forces et collisions (comme nos boules).
  - *Fixed :* Immobile. Les autres objets rebondissent contre lui (comme nos murs).
  - *Kinematic :* Contrôlé manuellement par le code. Ignore les forces mais pousse les Dynamic.
]

#example(title: "Créer un RigidBody dans Rapier")[
  ```javascript
  import RAPIER from '@dimforge/rapier3d';
  
  // 1. Créer le monde physique
  const world = new RAPIER.World({ x: 0, y: -9.81, z: 0 });
  
  // 2. Créer un RigidBody dynamique
  const rigidBodyDesc = RAPIER.RigidBodyDesc.dynamic()
    .setTranslation(0, 5, 0);
  const rigidBody = world.createRigidBody(rigidBodyDesc);
  
  // 3. Créer un Collider et l'attacher
  const colliderDesc = RAPIER.ColliderDesc.ball(1.0);
  const collider = world.createCollider(colliderDesc, rigidBody);
  ```
]

#definition-box(title: "2. Les Colliders")[
  Le `Collider` définit la *forme* de l'objet pour la détection de collision. Un RigidBody peut avoir plusieurs Colliders.
  
  *Formes disponibles :*
  - `ball(radius)` : Sphère.
  - `cuboid(hx, hy, hz)` : Boîte (half-extents).
  - `capsule(halfHeight, radius)` : Capsule.
  - `cylinder(halfHeight, radius)` : Cylindre.
  - `convexHull(points)` : Forme convexe personnalisée.
  - `trimesh(vertices, indices)` : Mesh quelconque (statique uniquement).
]

#example(title: "La Boucle de Simulation")[
  ```javascript
  function animate() {
    requestAnimationFrame(animate);
    
    // Stepping the world
    world.step();
    
    // Sync Three.js meshes with Rapier bodies
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
