#import "@preview/theorion:0.4.1": *
#import cosmos.rainbow: *
#show: show-theorion

// ===================== SESSION 17 =====================

#heading(level: 1)[Session 17 : TP - Véhicules]

#heading(level: 2)[Objectifs du TP]
- Comprendre le modèle "Raycast Vehicle".
- Implémenter une suspension simple.
- Gérer la tenue de route (grip, slip angle).
- Créer un véhicule drivable avec Rapier.

#heading(level: 3)[1. Le Modèle Raycast Vehicle]

#definition-box(title: "Raycast Vehicle")[
  Pour les jeux arcade, on ne simule pas les vraies roues. On utilise un raycast depuis le châssis vers le sol pour chaque roue.
]

*Anatomie :*
- Un châssis (RigidBody dynamique).
- Des roues invisibles : raycasts vers le bas.

*Avantages :* plus stable, plus performant, pas besoin de RigidBody pour les roues.

#heading(level: 3)[2. La Suspension]

#definition-box(title: "Suspension")[
  Chaque roue simule un ressort.
  
  1. Raycast depuis la roue vers le bas.
  2. Si on touche le sol à distance $d$ :
     - Compression : $c = 1 - d / "maxSuspensionLength"$
     - Force : $F = k dot c - "damping" dot v_"suspension"$
  3. Appliquer la force au châssis.
]

#heading(level: 3)[3. La Tenue de Route]

#definition-box(title: "Grip et Slip Angle")[
  - *Force longitudinale* : accélération / freinage.
  - *Force latérale* : virage.
  - *Slip angle* : angle entre la direction du pneu et la direction réelle du mouvement.
    - Petit angle : la voiture tourne normalement.
    - Grand angle : la voiture dérape (drift).
]

#heading(level: 3)[4. Missions du TP]

1. Créer un châssis (boîte dynamique).
2. Ajouter 4 raycasts (roues).
3. Implémenter la suspension (ressort + damping).
4. Ajouter l'accélération (force longitudinale).
5. Ajouter la direction (force latérale sur les roues avant).
6. Tester sur un terrain off-road.

#definition-box(title: "Défi")[
  Trouver les bons paramètres de suspension pour que la voiture ne bascule pas dans les virages.
]
