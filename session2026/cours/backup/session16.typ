#import "@preview/theorion:0.4.1": *
#import cosmos.rainbow: *
#show: show-theorion

// ===================== SESSION 16 =====================

#heading(level: 1)[Session 16 : Les Systèmes de Particules et le GPU]

#definition-box(title: "1. Architecture d'un Système de Particules")[
  Un système de particules simule un grand nombre de petits objets (pluie, feu, fumée, étincelles).
  
  *Structure d'une particule :*
  - Position, Vitesse, Accélération
  - Durée de vie (lifetime)
  - Couleur, Taille
  - Masse (optionnel)
  
  *L'Émetteur (Emitter) :*
  - Génère de nouvelles particules à un certain taux (ex: 1000/s).
  - Définit les paramètres initiaux (position, vitesse, direction).
  - Peut avoir différentes formes (point, cercle, sphère, cone).
  
  *Le Pool (Object Pooling) :*
  - On ne crée/détruit pas de particules à chaque frame (trop lent).
  - On pré-alloue un tableau fixe de particules.
  - Quand une particule "meurt", on la recycle.
]

#definition-box(title: "2. Le Cycle de Vie d'une Particule")[
  1. *Birth :* L'émetteur crée la particule avec des paramètres initiaux.
  2. *Update :* Chaque frame, on applique les forces (gravité, drag), on met à jour la position.
  3. *Render :* On dessine la particule (souvent un billboard, un quad qui fait face à la caméra).
  4. *Death :* Quand `lifetime <= 0`, la particule est désactivée et recyclée.
]

#definition-box(title: "3. Interactions Physiques")[
  *Gravité :* $arrow(a) = arrow(g)$ (constant).
  *Drag :* $arrow(F) = -k dot arrow(v)$ (ralentit les particules).
  *Collisions simplifiées :* On ne fait pas de vraies collisions (trop cher pour 10000 particules). On utilise des plans ou des champs de force.
  
  *Exemple : Rebond sur le sol*
  ```javascript
  if (particle.position.y < 0) {
    particle.position.y = 0;
    particle.velocity.y *= -restitution; // 0.5 = rebond mou
  }
  ```
]

#definition-box(title: "4. Optimisation : Le GPU et les Compute Shaders")[
  Pour simuler des centaines de milliers de particules, le CPU ne suffit plus. On déplace le calcul sur le GPU.
  
  *Pourquoi le GPU est-il parfait pour ça ?*
  - Les particules sont *indépendantes* (pas de collisions entre elles).
  - Le GPU excelle dans le traitement parallèle (des milliers de cœurs).
  - Les données restent sur le GPU (pas de transfert CPU $<->$ GPU).
  
  *Compute Shader :*
  - Un programme qui s'exécute sur le GPU mais qui n'est pas un shader de rendu.
  - On stocke les particules dans un SSBO (Shader Storage Buffer Object).
  - Le compute shader lit et modifie les positions/vitesses directement dans le buffer.
  
  #figure(
    image("images/GPU_particles.svg", width: 90%),
    caption: [Architecture GPU : Compute Shader pour particules],
  )
  
  *Pipeline :*
  1. CPU envoie les paramètres (gravité, émission) au GPU.
  2. Compute Shader met à jour les particules (position, vitesse, lifetime).
  3. Vertex Shader génère les billboards.
  4. Fragment Shader dessine les particules.
  
  *Résultat :* 1 000 000 de particules à 60 FPS sur un GPU moderne.
]
