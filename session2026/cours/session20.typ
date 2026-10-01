#import "@preview/theorion:0.4.1": *
#import cosmos.rainbow: *
#show: show-theorion

// ===================== SESSION 20 =====================

#heading(level: 1)[Session 20 : Résumé - Quiz final]

#heading(level: 2)[Objectifs de la session]
- Réviser les concepts clés du cours.
- Faire le point sur les compétences acquises.
- Passer un quiz final pour valider les apprentissages.

#tip-box(title: "Session présentielle")[
  Révisions et Quiz (30 points).
]

#heading(level: 2)[Concepts clés à retenir]

#definition-box(title: "Fondamentaux")[
  - Les trois lois de Newton.
  - Les forces de la nature (gravity, normale, friction, drag).
  - L'intégration numérique (Euler, Verlet, RK4).
  - L'impulsion et les collisions.
]

#definition-box(title: "Détection de collision")[
  - Broad Phase (Grille, Quadtree, SAP).
  - Narrow Phase (SAT, GJK).
  - Génération de contacts et résolution.
]

#definition-box(title: "Moteurs et systèmes avancés")[
  - RigidBodies, Colliders, Joints, Moteurs.
  - Contraintes et IK (CCD, FABRIK).
  - Particules, GPU, personnages, véhicules, IA.
]

#heading(level: 2)[Quiz final]

#tip-box(title: "Format")[
  30 questions, 1 point chacune. Le quiz porte sur les sessions 1 à 18 et vérifie la compréhension des concepts du cours. Chaque question propose quatre réponses. Pour la plupart, une seule réponse est exacte ; pour certaines, il y en a plus d'une, et c'est à vous de déterminer combien. Pour obtenir le point, cochez toutes les réponses exactes et aucune autre.
]

#pagebreak()

#definition-box(title: "Q01 — Produit scalaire (séance 1)")[
  À propos du produit scalaire, quelle affirmation est exacte ?

  *A.* Il retourne un vecteur perpendiculaire aux deux opérandes, ce qui permet de calculer une normale de surface.

  *B.* Il retourne un nombre, nul lorsque les deux vecteurs sont perpendiculaires et maximal lorsqu'ils sont parallèles.

  *C.* Il retourne un nombre qui vaut toujours le produit des normes, quelle que soit l'orientation relative des deux vecteurs.

  *D.* Il retourne un vecteur dans le plan des deux opérandes, dont la norme donne l'aire du parallélogramme formé.
]

#definition-box(title: "Q02 — Projectile sans traînée (séance 2)")[
  Un projectile est lancé sans résistance de l'air. Quelle affirmation décrit correctement ses composantes de vitesse ?

  *A.* $v_x$ reste constante car aucune force horizontale n'agit ; la gravité modifie seulement $v_y$ au fil du temps.

  *B.* $v_x$ diminue régulièrement car la gravité ralentit tout le mouvement, même lorsque sa direction est verticale.

  *C.* $v_x$ et $v_y$ restent toutes deux constantes car, sans traînée, aucune force ne retire d'énergie au projectile.

  *D.* $v_y$ reste constante tandis que $v_x$ change, puisque la gravité courbe la trajectoire vers le bas.
]

#definition-box(title: "Q03 — Troisième loi — Action-Réaction (séance 3)")[
  Une balle exerce une force sur un mur fixe. Que dit la troisième loi de Newton sur la force que le mur exerce en retour ?

  *A.* Le mur ne renvoie aucune force, puisqu'il ne bouge pas et n'accélère pas sous l'impact de la balle.

  *B.* La force du mur est plus faible que celle de la balle, car un corps plus massif absorbe une partie du choc.

  *C.* La force du mur est égale et opposée à celle de la balle, quelles que soient les masses des deux corps.

  *D.* La force du mur dépend de la vitesse de la balle, mais disparaît dès que la balle cesse d'avancer.
]

#definition-box(title: "Q04 — Quantité de mouvement (séance 6)")[
  Dans un système isolé, quelle grandeur est toujours conservée lors d'une collision, qu'elle soit élastique ou non ?

  *A.* La quantité de mouvement totale, car ce qui est perdu par un corps est gagné par l'autre.

  *B.* L'énergie cinétique totale, car elle ne dépend que des masses et reste donc constante pendant le choc.

  *C.* La vitesse totale, car les vitesses individuelles s'échangent sans que leur somme ne change jamais.

  *D.* La somme des accélérations, car les forces internes s'annulent deux à deux pendant toute la collision.
]

#definition-box(title: "Q05 — Broad Phase (séance 7)")[
  Quel est le rôle principal de la *Broad Phase* dans un moteur de collision ?

  *A.* Écarter rapidement la plupart des paires impossibles, puis transmettre les paires candidates aux tests géométriques plus précis.

  *B.* Calculer la pénétration exacte de chaque paire et déterminer les points de contact à transmettre au solveur.

  *C.* Résoudre les collisions en appliquant les impulsions, puis transmettre les vitesses corrigées à la simulation.

  *D.* Tester toutes les paires avec des maillages détaillés, afin d'éviter les approximations des boîtes englobantes.
]

#pagebreak()

#definition-box(title: "Q06 — Le tunneling (séance 13)")[
  Un objet rapide traverse un mur mince entre deux frames. Quel mécanisme du moteur physique peut prévenir ce *tunneling* ?

  *A.* Le *CCD* teste la trajectoire entre les positions discrètes et détecte un impact même si l'objet ne se trouve pas dans le mur à une frame.

  *B.* Le *sleeping* suspend les objets rapides jusqu'à ce qu'ils se trouvent entièrement de l'autre côté de l'obstacle.

  *C.* La *Broad Phase* remplace le trajet par une boîte plus précise, puis calcule seule le point exact de contact.

  *D.* Le *raycast* modifie la vitesse de l'objet en continu et le maintient automatiquement à l'extérieur du mur.
]

#definition-box(title: "Q07 — Mouvement circulaire uniforme (séance 2)")[
  Un objet tourne sur un cercle à vitesse scalaire constante. Que peut-on dire de son accélération ?

  *A.* Elle est nulle, car la vitesse scalaire ne varie pas et aucune force n'agit donc sur l'objet en mouvement.

  *B.* Elle pointe vers le centre du cercle, car la direction de la vitesse change à chaque instant.

  *C.* Elle pointe vers l'extérieur du cercle, car l'objet tend à s'éloigner du centre sous l'effet de son inertie.

  *D.* Elle est tangente au cercle, car elle ne peut modifier que la vitesse scalaire de l'objet en mouvement.
]

#definition-box(title: "Q08 — Structures de partitionnement (séance 7)")[
  Quelles affirmations sur les structures de partitionnement spatial sont exactes ?

  *A.* Une grille uniforme range les objets dans des cases de taille fixe et ne teste que les cases voisines.

  *B.* Un quadtree subdivise récursivement les zones denses, ce qui lui permet de s'adapter à la distribution des objets.

  *C.* Le Sweep and Prune trie les intervalles projetés et exploite la cohérence temporelle entre deux frames.

  *D.* Ces structures remplacent la Narrow Phase, car elles calculent seules les points de contact exacts.
]

#definition-box(title: "Q09 — Frottement statique et cinétique (séance 4)")[
  Pourquoi est-il plus difficile de mettre un objet en mouvement que de le maintenir en mouvement ?

  *A.* La masse de l'objet augmente au moment du démarrage, ce qui rend le mouvement plus difficile à initier.

  *B.* Le frottement cinétique est toujours supérieur au frottement statique, car le mouvement ajoute des forces de contact.

  *C.* La force normale diminue dès que l'objet glisse, ce qui augmente le frottement et freine le mouvement.

  *D.* Le frottement statique peut atteindre une valeur plus élevée que le frottement cinétique, qui reste ensuite à peu près constant.
]

#definition-box(title: "Q10 — SAT et collision (séance 11)")[
  Pour deux polygones convexes, que permet de conclure le *Separating Axis Theorem* (SAT) ?

  *A.* Si les projections se chevauchent sur un axe, la collision est certaine et ses contacts sont déjà entièrement déterminés.

  *B.* Si l'on trouve un axe où les projections sont disjointes, les formes ne se chevauchent pas ; cet axe sépare les deux formes.

  *C.* Si les centres des deux formes sont distincts, le test prouve qu'elles se touchent sur une face commune.

  *D.* Si les projections se chevauchent sur tous les axes testés, les objets sont nécessairement sphériques et imbriqués.
]

#definition-box(title: "Q11 — Véhicule à roues raycastées (séance 17)")[
  Dans un *raycast vehicle*, à quoi sert principalement le rayon lancé depuis chaque roue ?

  *A.* À détecter le sol et estimer la compression de la suspension, afin de calculer la force de soutien de cette roue.

  *B.* À remplacer le châssis par quatre corps rigides indépendants, qui transmettent ensuite leur poids au véhicule.

  *C.* À calculer directement la couleur et la rotation du pneu visible, sans intervenir dans le modèle physique.

  *D.* À empêcher toute perte d'adhérence, car le rayon fournit une force latérale suffisante dans tous les virages.
]

#pagebreak()

#definition-box(title: "Q12 — Rotation (séance 10)")[
  Quelles affirmations sur la rotation d'un corps rigide sont exactes ?

  *A.* Le moment d'inertie dépend de la répartition de la masse par rapport à l'axe ; une masse éloignée de l'axe augmente généralement $I$.

  *B.* Le couple dépend uniquement de l'intensité de la force, jamais de son point d'application ni de sa direction.

  *C.* Le couple s'écrit $arrow(tau) = arrow(r) times arrow(F)$ ; seule la composante perpendiculaire du bras et de la force contribue.

  *D.* Les angles d'Euler évitent le *gimbal lock* lors des rotations successives, tandis que les quaternions ne peuvent pas s'interpoler entre deux orientations.
]

#definition-box(title: "Q13 — Dynamic, fixed et kinematic (séance 14)")[
  Quelles affirmations distinguent correctement ces types de corps ?

  *A.* Un corps *dynamic* subit les forces et les collisions ; le moteur met à jour son mouvement pendant la simulation.

  *B.* Un corps *fixed* tombe sous l'effet de la gravité, mais reste immobile lorsqu'il entre en contact avec un autre corps.

  *C.* Un corps *kinematic* est contrôlé par le code et ignore les forces ; il peut néanmoins pousser des corps *dynamic*.

  *D.* Un corps *kinematic* est toujours ignoré par les tests de collision, puisqu'il ne réagit pas aux forces appliquées.
]

#definition-box(title: "Q14 — Inverse kinematics (séance 16)")[
  Quelle distinction entre *CCD* et *FABRIK* est correcte ?

  *A.* CCD déplace les articulations en ligne droite sans les tourner, alors que FABRIK applique uniquement des couples physiques.

  *B.* CCD calcule une animation enregistrée à l'avance ; FABRIK détermine la trajectoire du personnage dans le monde.

  *C.* CCD ajuste successivement les articulations vers la cible ; FABRIK alterne des passes avant et arrière en maintenant les longueurs des segments.

  *D.* CCD et FABRIK modifient la masse des os jusqu'à ce que l'effecteur atteigne la cible souhaitée.
]

#definition-box(title: "Q15 — Gravitation universelle (séance 12)")[
  En orbite autour d'un astre, de quoi dépend l'accélération subie par un satellite ?

  *A.* De la masse du satellite et de sa vitesse, car un corps plus lourd subit une attraction plus forte de l'astre.

  *B.* De la masse de l'astre attracteur et de la distance qui les sépare, mais pas de la masse du satellite.

  *C.* Uniquement de la vitesse du satellite, car une orbite circulaire impose une accélération centripète constante.

  *D.* De la masse du satellite uniquement, car l'astre attracteur reste fixe dans son propre référentiel.
]

#definition-box(title: "Q16 — Joints et moteurs (séance 15)")[
  Quel est le rôle d'un moteur associé à un joint dans un moteur physique ?

  *A.* Il téléporte l'articulation à son angle cible et neutralise les contacts avec les autres corps.

  *B.* Il remplace le joint par une liaison fixe, puis supprime les degrés de liberté restants.

  *C.* Il modifie directement la masse des corps reliés afin que leur vitesse angulaire devienne constante.

  *D.* Il applique un effort pour rapprocher le mouvement du joint d'une vitesse ou d'une position cible, sous les limites du système.
]

#pagebreak()

#definition-box(title: "Q17 — Kinematic Character Controller (séance 18)")[
  Quel énoncé décrit le mieux un *Kinematic Character Controller* (KCC) ?

  *A.* Il s'agit d'un corps *dynamic* libre, qui subit les forces et offre toujours un contrôle plus précis qu'un contrôleur kinematic.

  *B.* Il donne un contrôle direct et précis du personnage ; le programme doit toutefois gérer les collisions, la gravité et les pentes.

  *C.* Il s'agit d'un corps *fixed* qui ne bouge jamais, mais dont le moteur recalcule automatiquement le mouvement souhaité.

  *D.* Il désactive les collisions pour garantir la précision, puis utilise le *Move and Slide* uniquement pour l'animation visuelle.
]

#definition-box(title: "Q18 — Corps mous et PBD (séance 18)")[
  Pourquoi un tissu simulé avec PBD demande-t-il plusieurs itérations de ses contraintes par frame ?

  *A.* Chaque itération augmente la masse des particules, ce qui compense progressivement l'étirement provoqué par la gravité.

  *B.* Une passe calcule les forces exactes du tissu ; les passes suivantes servent uniquement à réduire le bruit de rendu.

  *C.* Corriger une contrainte déplace des particules partagées avec d'autres contraintes ; les itérations propagent les corrections et améliorent la convergence.

  *D.* Les itérations remplacent le pas de temps et garantissent une solution exacte, même avec des contraintes incohérentes.
]

#definition-box(title: "Q19 — Sleeping (séance 13)")[
  À quoi sert le *sleeping* dans un moteur physique ?

  *A.* À cesser de simuler les objets immobiles pour économiser du CPU, jusqu'à ce qu'ils soient réveillés par un contact ou une force.

  *B.* À ralentir la simulation lorsque le framerate est trop élevé, afin de stabiliser les contacts entre les objets.

  *C.* À figer définitivement les objets qui ont été touchés, pour qu'ils ne participent plus jamais à la simulation.

  *D.* À désactiver les colliders des objets lents, afin d'éviter les tests de collision devenus inutiles.
]

#definition-box(title: "Q20 — Déterminisme (séance 14)")[
  Dans une simulation, que signifie le *déterminisme* ?

  *A.* Les corps finissent toujours au même endroit, même si les commandes, l'ordre de calcul et l'état initial sont différents.

  *B.* Des mêmes entrées produisent exactement les mêmes sorties ; l'ordre des opérations et les flottants peuvent compliquer cette garantie.

  *C.* Un pas de temps fixe garantit à lui seul des résultats identiques sur toutes les machines et tous les processeurs.

  *D.* Le moteur désactive les collisions aléatoires et supprime ainsi tout besoin de vérifier les résultats d'une simulation.
]

#pagebreak()

#definition-box(title: "Q21 — Vecteur unitaire (séance 1)")[
  Que signifie normaliser un vecteur ?

  *A.* Le rendre perpendiculaire à un autre vecteur, afin de construire un repère orthogonal dans l'espace.

  *B.* Le ramener à une longueur de 1 en conservant sa direction, ce qui donne une direction pure sans magnitude.

  *C.* Le rendre parallèle à l'axe principal du repère, afin de simplifier les calculs de projection.

  *D.* Rendre toutes ses composantes positives, afin d'obtenir un vecteur toujours dirigé vers l'avant.
]

#definition-box(title: "Q22 — Première loi — Inertie (séance 3)")[
  Que dit la première loi de Newton sur un objet déjà en mouvement ?

  *A.* Il continue en ligne droite à vitesse constante tant qu'aucune force extérieure n'agit sur lui.

  *B.* Il s'arrête de lui-même après un certain temps, car le mouvement se dissipe naturellement dans le milieu.

  *C.* Il ralentit dès que la force qui l'a mis en mouvement cesse d'être appliquée par sa source.

  *D.* Il suit toujours une trajectoire circulaire, car tout mouvement tend à se refermer sur lui-même.
]

#definition-box(title: "Q23 — Force normale (séance 4)")[
  Que peut-on dire de la force normale exercée par une surface sur un objet posé dessus ?

  *A.* Elle est toujours égale au poids de l'objet, quelle que soit l'inclinaison de la surface qui le soutient.

  *B.* Elle est toujours dirigée vers le haut, car une surface ne peut exercer qu'une poussée verticale.

  *C.* Elle est perpendiculaire à la surface et s'ajuste pour empêcher l'objet de la traverser.

  *D.* Elle dépend du coefficient de frottement, car c'est la friction qui crée la poussée de la surface.
]

#definition-box(title: "Q24 — Coefficient de restitution (séance 6)")[
  Que décrivent les valeurs extrêmes du coefficient de restitution ?

  *A.* Il vaut 0 pour un rebond parfaitement élastique, car aucune énergie n'est alors transmise à la surface.

  *B.* Il vaut 1 pour un choc totalement inélastique, où les deux corps restent collés après l'impact.

  *C.* Il décrit la masse perdue lors du choc et vaut 1 lorsque les deux corps ont la même masse.

  *D.* Il vaut 1 pour un rebond parfaitement élastique, sans perte d'énergie cinétique, et 0 pour un choc mou.
]

#definition-box(title: "Q25 — Narrow Phase (séance 7)")[
  Quel est le rôle de la Narrow Phase dans le pipeline de collision ?

  *A.* Éliminer rapidement la majorité des paires à l'aide de boîtes englobantes, avant les tests plus coûteux.

  *B.* Tester chaque paire candidate pour confirmer la collision et calculer le point de contact, la normale et la profondeur.

  *C.* Appliquer les impulsions de collision et corriger les positions des corps qui se chevauchent.

  *D.* Trier les objets par distance à la caméra, afin de ne traiter que ceux qui sont visibles à l'écran.
]

#pagebreak()

#definition-box(title: "Q26 — GJK (séance 11)")[
  Sur quel principe repose l'algorithme GJK ?

  *A.* Il découpe les formes en une grille régulière et compare les cases occupées par chacune d'elles.

  *B.* Il projette les formes sur des axes et cherche un axe où leurs projections ne se chevauchent pas.

  *C.* Il construit un simplex dans la différence de Minkowski et teste si l'origine se trouve à l'intérieur.

  *D.* Il subdivise récursivement la boîte englobante jusqu'à isoler le point de contact le plus profond.
]

#definition-box(title: "Q27 — Quaternions et gimbal lock (séance 10)")[
  Pourquoi préfère-t-on les quaternions aux angles d'Euler pour orienter un objet en 3D ?

  *A.* Ils sont plus intuitifs à lire pour un artiste, car leurs quatre composantes correspondent à des angles.

  *B.* Ils évitent le gimbal lock et s'interpolent naturellement entre deux orientations.

  *C.* Ils occupent moins de mémoire, car ils stockent l'orientation sur un seul nombre.

  *D.* Ils représentent toutes les rotations, ce que les angles d'Euler ne peuvent pas faire.
]

#definition-box(title: "Q28 — Types de joints (séance 15)")[
  Quelles associations entre un joint et le mouvement qu'il autorise sont exactes ?

  *A.* Le joint *revolute* se comporte comme une charnière : rotation autour d'un seul axe.

  *B.* Le joint *prismatic* se comporte comme un tiroir : glissement le long d'un axe.

  *C.* Le joint *spherical* se comporte comme une rotule : rotations libres dans les trois axes.

  *D.* Le joint *fixed* autorise une translation libre le long de l'axe principal des deux corps.
]

#definition-box(title: "Q29 — Grip et slip angle (séance 17)")[
  Que décrit le *slip angle* d'un pneu ?

  *A.* La distance parcourue par la roue pendant une frame, mesurée au point de contact avec le sol.

  *B.* La force maximale que le pneu peut transmettre avant de se détruire sous la charge.

  *C.* L'écart entre la direction visée par la roue et la direction réelle de son déplacement.

  *D.* L'angle entre l'axe de rotation de la roue et la verticale du véhicule en mouvement.
]

#definition-box(title: "Q30 — N-body (séance 12)")[
  Qu'est-ce qui distingue un système *N-body* d'un système à deux corps ?

  *A.* Les corps cessent de s'attirer, car la gravité devient négligeable dès qu'il y a plus de deux objets.

  *B.* Une seule masse domine le système, ce qui simplifie le calcul et rend les orbites parfaitement stables.

  *C.* Les interactions sont limitées aux paires voisines, ce qui rend le système beaucoup plus rapide à simuler.

  *D.* Chaque corps attire tous les autres, ce qui rend les orbites imparfaites et sujettes à des perturbations.
]
