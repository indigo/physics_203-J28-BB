#import "@preview/theorion:0.4.1": *
#import cosmos.rainbow: *
#show: show-theorion

// ===================== SESSION 04 =====================

#heading(level: 1)[Session 4 : Les forces de la nature]

#heading(level: 2)[Objectifs de la session]
- Identifier les forces de la nature agissant sur un objet dans un jeu.
- Comprendre le poids, la normale, le frottement sec et le frottement visqueux.
- Savoir quand et comment modéliser chaque force pour un gameplay réaliste.

#tip-box(title: "Introduction")[
  Dans le vide spatial, un objet lancé garde sa vitesse pour l'éternité (1ère loi de Newton). Sur Terre, tout finit par s'arrêter. Pourquoi ? À cause des interactions avec l'environnement, modélisées par les *forces de la nature*.
]

#heading(level: 3)[1. La Gravité et le Poids]

#definition-box(title: "La Gravité")[
  La force d'attraction gravitationnelle attire les objets vers le centre de la Terre. Son accélération est notée $arrow(g)$.
  $ arrow(P) = m dot arrow(g) $
]

*Application en jeu :* La gravité est une force constante appliquée chaque frame à tous les objets dynamiques.

#heading(level: 3)[2. La Force Normale]

#definition-box(title: "La Force Normale (N)")[
  C'est la force avec laquelle une surface repousse un objet qui appuie contre elle. Elle est perpendiculaire à la surface.
  
  - Sur un sol plat horizontal : $N = m g$.
  - Sur une pente : $N = m g cos(theta)$.
]

*Application en jeu :* La normale détermine si un objet est au sol et calcule la friction.

#heading(level: 3)[3. Le Frottement Sec (Modèle de Coulomb)]

#definition-box(title: "Frottement Sec")[
  Frottement de contact entre deux solides. Il dépend du coefficient de friction $mu$ et de la normale $N$.
  $ ||arrow(f)|| = mu dot ||arrow(N)|| $
]

#important-box(title: "Statique vs Cinétique")[
  - *Frottement statique ($mu_s$)* : l'objet est immobile. La force s'adapte jusqu'à un seuil critique $F_max = mu_s N$.
  - *Frottement cinétique ($mu_k$)* : l'objet glisse. La force est constante $F_k = mu_k N$.
  - En général : $mu_s > mu_k$.
]

#heading(level: 3)[4. Le Frottement Visqueux (Fluide)]

#definition-box(title: "Frottement Visqueux")[
  Résistance de l'air ou de l'eau. Il dépend de la vitesse et de la forme de l'objet.
  
  - Vitesse faible : $arrow(f) = -k dot arrow(v)$.
  - Vitesse élevée : $arrow(f) = -C dot ||v||^2 dot hat(v)$.
]

*Conséquence :* la vitesse terminale. Quand la gravité et le drag s'annulent, l'objet ne peut plus accélérer.

#example[
  *Comparaison pour le Gameplay :*
  - *Frottement sec* : l'objet ralentit linéairement et s'arrête net.
  - *Frottement fluide* : l'objet ralentit de moins en moins vite, approche asymptotique de 0.
]
