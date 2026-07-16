#import "@preview/theorion:0.4.1": *
#import cosmos.rainbow: *
#show: show-theorion

// ===================== SESSION 18 =====================

#heading(level: 1)[Session 18 : Physique des Véhicules]

#definition-box(title: "1. Le Modèle 'Raycast Vehicle'")[
  Pour les jeux arcade, on ne simule pas les vraies roues (trop complexe). On utilise le modèle "Raycast Vehicle".
  
  *Anatomie :*
  - Un *châssis* (RigidBody dynamique).
  - Des *roues invisibles* : Chaque roue est un raycast vers le bas depuis le châssis.
  
  *Pourquoi des raycasts ?*
  - Pas besoin de simuler des RigidBodies pour les roues.
  - Le raycast détecte le sol, et on applique les forces manuellement.
  - Beaucoup plus stable et performant que des vraies roues.
]

#definition-box(title: "2. La Suspension")[
  Chaque roue simule un ressort (suspension).
  
  *Calcul :*
  1. Lancer un raycast depuis la roue vers le bas.
  2. Si on touche le sol à la distance $d$ :
     - Compression : $c = 1 - d / "maxSuspensionLength"$
     - Force : $F = k dot c - d dot "damping" dot v_"suspension"$
  3. Appliquer la force au châssis au point de contact.
  
  *Résultat :* La voiture "flotte" au-dessus du sol, maintenue par 4 ressorts invisibles.
]

#definition-box(title: "3. La Tenue de Route (Tire Grip)")[
  Le pneu exerce des forces dans deux directions :
  
  *Force Longitudinale (Accélération/Freinage) :*
  - On applique un couple moteur à la roue.
  - Le pneu "pousse" le sol vers l'arrière, la voiture avance.
  
  *Force Latérale (Virage) :*
  - Quand on tourne le volant, les roues avant changent de direction.
  - Le pneu exerce une force latérale qui fait tourner la voiture.
  - *Grip :* Si le grip est faible, la voiture dérape (drift).
  
  *Le Slip Angle :*
  C'est l'angle entre la direction du pneu et la direction réelle du mouvement.
  - Petit angle : La voiture tourne normalement.
  - Grand angle : La voiture dérape (drift).
]

#definition-box(title: "TP : Transformer un Cube en Véhicule")[
  *Objectif :* Créer un véhicule drivable avec Rapier.
  1. Créer un châssis (boîte dynamique).
  2. Ajouter 4 raycasts (roues).
  3. Implémenter la suspension (ressort $+$ damping).
  4. Ajouter l'accélération (force longitudinale).
  5. Ajouter la direction (force latérale sur les roues avant).
  6. Tester sur un terrain off-road (pentes, bosses).
  
  *Défi :* Trouver les bons paramètres de suspension pour que la voiture ne bascule pas dans les virages.
]
