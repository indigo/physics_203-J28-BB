#import "@preview/theorion:0.4.1": *
#import cosmos.rainbow: *
#show: show-theorion

// ===================== SESSION 11 =====================

#heading(level: 1)[Session 11 : Broad et Narrow phases – Part 2]

#heading(level: 2)[Objectifs de la session]
- Comprendre le rôle de la Narrow Phase.
- Apprendre SAT et GJK pour la détection précise de collision.
- Voir comment générer un contact et résoudre la collision.

#tip-box(title: "Rappel")[
  La Broad Phase a filtré les paires candidates. La Narrow Phase répond à la question : *"Ces deux objets se touchent-ils vraiment ?"*
]

#heading(level: 3)[1. La Narrow Phase : Méthodes de Résolution]

#definition-box(title: "Objectif")[
  On a maintenant des paires proches. Il faut déterminer si elles se touchent vraiment, puis générer un contact (point, normale, profondeur).
]

#heading(level: 3)[2. SAT (Separating Axis Theorem)]

#definition-box(title: "Principe de SAT")[
  Si on peut trouver un axe sur lequel les projections de deux objets ne se chevauchent pas, alors ils ne se touchent pas.
  
  On teste les axes normaux des faces et les produits vectoriels des arêtes. Si un seul axe sépare les objets, il n'y a pas collision.
]

*Utilisation :* Boîtes vs boîtes, polyèdres convexes simples.

#heading(level: 3)[3. GJK (Gilbert-Johnson-Keerthi)]

#definition-box(title: "Principe de GJK")[
  On travaille dans l'espace de Minkowski ($A - B$). On cherche si l'origine $(0,0,0)$ est contenue dans cette forme en construisant un simplex (tétraèdre en 3D).
]

#definition-box(title: "Fonction de Support")[
  GJK pose la question : *"Quel est ton point le plus extrême dans la direction $arrow(d)$ ?"*
  
  $ S_(A-B)(arrow(d)) = S_A(arrow(d)) - S_B(-arrow(d)) $
  
  - Sphère : $"Centre" + "Rayon" dot arrow(d)$
  - Cube : coin correspondant au signe de $arrow(d)$
]

*Utilisation :* Formes convexes quelconques (capsules, cônes, meshes convexes).

#heading(level: 3)[4. Génération du Contact et Résolution]

#definition-box(title: "Contact")[
  Une fois la collision détectée, on a besoin de :
  - Point de contact.
  - Normale de collision.
  - Profondeur de pénétration.
]

#definition-box(title: "Résumé du Pipeline")[
  1. *Update Position* : $P = P + V dot d t$
  2. *Broad Phase* : voisinage -> paires candidates.
  3. *Narrow Phase* : AABB, SAT/GJK -> collision OUI/NON.
  4. *Contact Generation* : point, normale, profondeur.
  5. *Resolution* : impulsions pour séparer les objets.
]
