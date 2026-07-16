#import "@preview/theorion:0.4.1": *
#import cosmos.rainbow: *
#show: show-theorion

#set document(
  author: ("Richard Rispoli"),
  title: [Les Forces de Frottement]
)

#show title: set align(right)
#show title: set block(below: 1.2em)
#show title: set text(
  weight: "bold", 
  size: 1em, 
  fill: rgb("#406372")
)

#set page(
  paper: "us-letter",
  margin: 2cm,
  header: align(
    right + horizon,
    "Physics 203-j28-Friction - " + context document.author.at(0),
  ),
)

#set text(
  font: "Georgia",
  lang: "fr",
  size: 12pt
)

#show heading: set text(
  weight: "bold", 
  size: 1em, 
  fill: rgb("#005F87")
)

// --- DÉBUT DU DOCUMENT ---

#title()

#tip-box(title: "Introduction")[
  Dans le vide spatial (et dans un moteur physique naïf), un objet lancé garde sa vitesse pour l'éternité (1ère loi de Newton).
  
  Sur Terre, tout finit par s'arrêter. Pourquoi ? À cause des interactions avec l'environnement.
  Ces interactions sont modélisées par des **Forces de Frottement**.
  
  Il existe deux grandes familles à maîtriser pour le jeu vidéo :
  1. Le Frottement Sec (Solide contre Solide).
  2. Le Frottement Visqueux (Solide dans un Fluide).
]

#definition-box(title: "1. Le Frottement Sec (Modèle de Coulomb)")[
  C'est le frottement de contact : un pneu sur la route, une caisse sur le sol, ou une boule de billard qui glisse. Tous les frottements qui "accrochent".
  
  Il ne dépend **pas** de la vitesse (tant que ça bouge), ni de la surface (l'aire) de contact (contrairement à l'intuition).
  
  Il dépend de deux choses :
  1. *La rugosité des matériaux* (Coefficient $mu$).
  2. *Le poids apparent* (Force Normale $N$).
  
  $ ||arrow(f)|| = mu dot ||arrow(N)|| $
  
  *Direction :* Toujours opposée à la vitesse (ou à la force qui tente de bouger l'objet). Il compense la force qui tente de bouger l'objet, et le garde immobile. Il va s'adapter exactement pour annuler votre poussée, jusqu'à un seuil critique.
]

#definition-box(title: "La Force Normale (N)")[
  C'est la force avec laquelle les deux surfaces sont pressées l'une contre l'autre.
  
  - Sur un sol plat horizontal : $N = m g$ (Le Poids).
  - Sur une pente : $N = m g cos(theta)$ (La composante perpendiculaire au sol).
  - Dans un virage relevé (F1) : $N$ augmente à cause de la force centrifuge.
  -Bien assis sur son siège : $N = m g cos(alpha)$ (la composante perpendiculaire au sol).
]

#important-box(title: "Distinction : Statique vs Cinétique")[
  Avez-vous remarqué qu'il est plus dur de *commencer* à pousser une armoire lourde que de la *maintenir* en mouvement ? On pousse de plus en plus fort et tout d'un coup on passe le seuil critique, et l'armoire commence à bouger beaucoup plus facilement.
  
  *A. Frottement Statique ($mu_s$)*
  - L'objet est immobile ($v=0$).
  - La force est "intelligente" : elle s'adapte exactement pour annuler votre poussée, jusqu'à un seuil critique.
  - *Seuil de rupture :* $F_"max" = mu_s N$.
  
  *B. Frottement Cinétique ($mu_k$)*
  - L'objet glisse ($v > 0$).
  - La force est *constante*, peu importe la vitesse.
  - $F_k = mu_k N$.
  
  *En général :* $mu_s > mu_k$. (C'est pour ça que l'armoire "décolle" d'un coup).
]

#definition-box(title: "2. Le Frottement Visqueux (Fluide)")[
  C'est la résistance de l'air (Drag) ou de l'eau.
  Contrairement au frottement sec, celui-ci dépend énormément de la vitesse, ainsi que la forme de l'objet.
  
  *Cas 1 : Vitesse faible (Loi de Stokes)*
  Pour les particules dans le miel ou la poussière.
  $ arrow(f) = -k dot arrow(v) $
  (Proportionnel à la vitesse).
  
  *Cas 2 : Vitesse élevée (Loi quadratique)*
  Pour les voitures, les avions, les balles.
  $ arrow(f) = -C dot ||v||^2 dot hat(v) $
  (Proportionnel au *carré* de la vitesse).
  
  *Conséquence : La Vitesse Terminale*
  Si un objet tombe, la gravité ($m g$) est constante, mais le frottement fluide augmente. À un moment, les deux s'annulent : l'objet ne peut plus accélérer.
]

#example[
  *Comparaison pour le Gameplay :*
  
  - *Frottement Sec (Billard, Glisse)* : L'objet ralentit linéairement ($v$ diminue de manière constante). Il s'arrête net.
    
  - *Frottement Fluide (Amortissement)* : L'objet ralentit de moins en moins vite. Il ne s'arrête théoriquement jamais complètement (approche asymptotique de 0).
]
