#import "@preview/theorion:0.4.1": *
#show: show-theorion

#set document(title: [Session 18 : Physique des Véhicules], author: ("Richard Rispoli"))
#set page(header: align(right)[Physics 203 - Vehicle Physics])
#show heading: set text(fill: rgb("#005F87"))

#title()

#tip-box(title: "Le modèle Arcade (Raycast Vehicle)")[
  Simuler une voiture réaliste est extrêmement difficile. Utiliser 4 cylindres physiques attachés par des joints (`HingeJoint`) provoque souvent des bugs (roues qui sautent, voiture qui vibre).
  
  L'industrie (GTA, Mario Kart, Cyberpunk) utilise une approximation robuste : le *Raycast Vehicle*.
  - La voiture est une *brique flottante*.
  - Les roues sont des *ressorts invisibles* (Raycasts).
  - On applique des forces manuelles pour simuler l'adhérence.
]

#heading(level: 1)[1. Anatomie du Véhicule]

Le véhicule est composé d'un seul *RigidBody Dynamic* (le Châssis). Les roues ne sont pas des objets physiques, ce sont des *points de simulation*.

Pour chaque roue, on définit :
- Un *point d'ancrage* (coin du châssis).
- Une *direction de suspension* (vers le bas, localement $-y$).
- Une *longueur de rayon* (longueur de la suspension + rayon de la roue).

#heading(level: 1)[2. La Suspension (Le Ressort)]

C'est la force qui maintient la voiture en l'air. Elle agit selon la Loi de Hooke, mais amortie.

#definition-box(title: "Formule de la Suspension")[
  On lance un rayon vers le bas. S'il touche le sol à une distance $d$ :
  
  1. *Compression ($x$) :* Différence entre la longueur au repos et la distance actuelle.
     $ x = "LongueurMax" - d $
  
  2. *Vitesse de Compression ($v_c$) :* À quelle vitesse la roue s'enfonce-t-elle ? On projette la vitesse du châssis sur la direction de la suspension.
  
  3. *Force Totale ($F_s$) :*
     $ F_s = underbrace(k times x, "Ressort (Spring)") - underbrace(c times v_c, "Amortisseur (Damper)") $
     
  Cette force est appliquée vers le haut au point d'ancrage de la roue.
]

#heading(level: 1)[3. L'Adhérence (Le Pneu)]

Une fois la voiture en lévitation, elle glisse comme sur de la glace. Il faut simuler le frottement du caoutchouc.
Pour chaque roue, on calcule deux vecteurs au sol : *Forward* (Avancer) et *Right* (Côté).

- *Force Longitudinale (Accélération/Frein) :* On applique une force dans la direction *Forward*.
- *Force Latérale (Grip) :* C'est la plus importante. On calcule la vitesse latérale de la roue (dérapage) et on applique une force *opposée* pour l'annuler.
  - Si Grip = 1.0 : La voiture tourne sur des rails (F1).
  - Si Grip = 0.1 : La voiture dérape (Rally/Drift).

#heading(level: 1)[4. Travail Pratique : Off-Road Challenge]

*Objectif :* Transformer un cube en véhicule tout-terrain pilotable, capable de franchir des obstacles sans se retourner.

#heading(level: 3)[Étape A : Configuration du Châssis]
1. Créer un cube (RigidBody Dynamic) de dimensions $(2, 0.5, 4)$.
2. Définir une masse réaliste (ex: 1500kg).
3. Définir 4 points d'ancrage (Vector3) aux coins du véhicule (ex: $\pm 1, -0.25, \pm 2$).

#heading(level: 3)[Étape B : Simulation de la Suspension (Boucle Physique)]
_À faire dans `fixedUpdate` ou `step`._
1. Pour chaque roue, lancer un *Raycast* vers le bas (longueur = 1.0m).
2. Si le rayon ne touche rien : ne rien faire (la roue est en l'air).
3. Si le rayon touche :
   - Calculer la compression $x$ (entre 0.0 et 1.0).
   - Calculer la force $F = (k dot x) dot arrow(n)_("up")$.
   - Appliquer cette force au point d'ancrage avec `body.addForceAtPoint(F, anchor)`.
   - *Test :* La voiture doit rebondir indéfiniment comme un trampoline.

#heading(level: 3)[Étape C : Stabilisation (Damping)]
1. Ajouter le terme d'amortissement.
2. Récupérer la vitesse du châssis au point d'ancrage : `v = body.getVelocityAtPoint(anchor)`.
3. Projeter cette vitesse sur l'axe vertical local (produit scalaire).
4. Soustraire `damping * vitesseVerticale` à la force de ressort.
5. *Test :* La voiture doit se stabiliser et arrêter de rebondir.

#heading(level: 3)[Étape D : Contrôle (Accélération)]
1. Récupérer l'input $Z/S$ (ou W/S).
2. Calculer le vecteur *Forward* de la voiture (transformé par la rotation du châssis).
3. Appliquer une force `Input * Power` au point de contact des roues motrices.

#heading(level: 3)[Étape E : Direction et Friction Latérale]
1. Pour les roues avant, faire pivoter le vecteur de calcul (Forward/Right) selon l'angle de braquage.
2. Calculer la vitesse latérale : $v_("lat") = arrow(v)_("roue") dot arrow(d)_("right")$.
3. Calculer la force de friction : $F_("lat") = -v_("lat") dot "masse" dot "coeff_adhérence"$.
4. Appliquer cette force pour empêcher le véhicule de glisser en crabe.