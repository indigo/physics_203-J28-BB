#import "@preview/theorion:0.4.1": *
#import cosmos.rainbow: *
#show: show-theorion

#set document(
  author: ("Richard Rispoli"),
  title: [TP Final : Siege Engine (Moteur Physique Commercial)]
)

#show title: set align(right)
#show title: set block(below: 1.2em)
#show title: set text(weight: "bold", size: 1.2em, fill: rgb("#406372"))

#set page(
  paper: "us-letter",
  margin: 2cm,
  header: align(right + horizon, "Physics 203 - Rapier Integration"),
  numbering: "1/1",
)

#set text(font: "Georgia", lang: "fr", size: 11pt)
#show heading: set text(weight: "bold", size: 1.1em, fill: rgb("#005F87"))

#title()

#tip-box(title: "Contexte")[
  Ce TP se déroule sur deux séances (Session 12 et 13).
  L'objectif est d'abandonner notre moteur "maison" pour utiliser un moteur professionnel (**Rapier** avec Three.js ou **Box2D** avec Raylib).
  
  Vous allez construire un jeu de siège/destruction physique.
]

#heading(level: 1)[Partie A : Intégration & RigidBodies (Session 12)]

#definition-box(title: "Objectif de la séance")[
  Mettre en place le moteur physique et simuler une scène statique qui s'effondre.
]

#heading(level: 2)[1. Setup du Projet]
- Créer un projet vide (Vite + Three.js ou C++ Raylib).
- Installer la librairie physique (`npm install @dimforge/rapier3d-compat` ou lien Box2D).
- Initialiser le `PhysicsWorld` avec une gravité de $(0, -9.81, 0)$.

#heading(level: 2)[2. Le Sol et les Murs (Statics)]
- Créer un sol plat infini (Collider Plane).
- Ce corps doit être **STATIQUE** (Masse infinie, ne bouge pas).
- Ajouter des murs invisibles ou visibles pour délimiter la zone de jeu.

#heading(level: 2)[3. Construction du Château (Dynamics)]
- Créer une classe `Block` qui génère un Mesh (visuel) et un RigidBody (physique).
- Générer un mur de briques (ex: 10x10 caisses empilées).
- *Défi :* Ajuster la friction pour que le mur tienne debout mais s'effondre si on le pousse.

#important-box(title: "Livrable Soir 1")[
  Une scène avec un sol et un mur de briques stable. Si on fait tomber une grosse sphère dessus (depuis le code), le mur doit s'effondrer de manière réaliste.
]

#pagebreak()

#heading(level: 1)[Partie B : Joints & Destruction (Session 13)]

#definition-box(title: "Objectif de la séance")[
  Ajouter du gameplay : une arme de siège (Catapulte ou Trébuchet) et de l'interaction.
]

#heading(level: 2)[4. L'Arme de Siège (Joints)]
- Construire une catapulte composée de plusieurs pièces :
  - **Base :** Fixe au sol.
  - **Bras :** Mobile.
  - **Pivot :** Un `RevoluteJoint` (Hinge) qui relie la Base et le Bras.
- Ajouter un mécanisme de tir :
  - Soit un ressort (`SpringJoint`).
  - Soit un moteur sur le pivot (`MotorModel`).

#heading(level: 2)[5. Le Projectile]
- Le projectile doit suivre le bras de la catapulte avant d'être relâché.
- *Astuce :* Créer le projectile au moment du tir, ou le lier temporairement avec un `FixedJoint` que l'on détruit au moment du lancer.

#heading(level: 2)[6. Interaction (Raycast)]
- Ajouter un clic souris pour tirer.
- Utiliser un `Raycast` pour viser ou pour appliquer une force d'explosion là où le joueur clique.

#heading(level: 1)[Critères d'évaluation (Total /30)]

#table(
  columns: (4fr, 1fr),
  inset: 7pt,
  stroke: 0.5pt + gray,
  [*Critère*], [*Points*],
  [**Intégration Moteur :** La simulation tourne à 60fps, les objets ne passent pas à travers le sol.], [7 pts],
  [**Stacking :** Le mur de briques est stable au repos (ne tremble pas).], [7 pts],
  [**Mécanisme (Joints) :** La catapulte fonctionne physiquement (pas d'animation pré-calculée).], [7 pts],
  [**Gameplay :** On peut tirer et détruire le mur.], [9 pts],
)
