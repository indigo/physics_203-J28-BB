#import "@preview/theorion:0.4.1": *
#import cosmos.rainbow: *
#show: show-theorion

// ===================== SESSION 04 =====================

#heading(level: 1)[Session 4 : Les Forces de Frottement]

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

#heading(level: 2)[TP : Le Laboratoire de Chocs 1D]

#tip-box(title: "Objectifs du TP")[
  Nous allons implémenter la réponse physique d'une collision entre deux boules de masses différentes.
  
  Pour simplifier le problème et isoler les mathématiques de l'impulsion, nous travaillons dans un **"Laboratoire 1D"** :
  - Pas de gravité.
  - Mouvement uniquement sur l'axe X.
  - Pas de friction pour l'instant.
]

#definition-box(title: "1. Analyse de la Scène")[
  Le code de démarrage (`Template.js`) contient :
  - Une *Boule Rouge (A)* : Lourde ($m=5$), lancée vers la droite.
  - Une *Boule Verte (B)* : Légère ($m=1$), immobile (actuellement désactivée).
  - Une interface *GUI* : Pour modifier les masses, la vitesse et le temps en direct.
  
  *État actuel :* La boule rouge traverse le vide et rebondit bêtement sur les murs (inversion simple de vitesse).
]

#important-box(title: "2. Rappel Théorique : L'Impulsion")[
  Lors d'un choc, nous devons calculer une impulsion $j$ (scalaire) et l'appliquer aux deux objets.
  
  *Formule de l'Impulsion (avec Masse Réduite) :*
  
  $ j = -(1+e) dot v_"rel" dot ((m_A m_B) / (m_A + m_B)) $
  
  - $e$ : Coefficient de restitution (1 = Élastique, 0 = Mou).
  - $v_"rel"$ : Vitesse relative de rapprochement 
  
  $ (arrow(v)_A - arrow(v)_B) dot arrow(n) $.
  
  *Application (Action-Réaction) :*
  $ arrow(v)'_A = arrow(v)_A + (j / m_A) arrow(n) $
  $ arrow(v)'_B = arrow(v)_B - (j / m_B) arrow(n) $
]

#definition-box(title: "3. Vos Missions (Code)")[
  *Étape A : Activer la Boule B*
  Dans le fichier `init()`, décommentez les lignes créant la deuxième boule. Relancez : les boules devraient se traverser comme des fantômes.
  
  *Étape B : Implémenter le "Solver" (Fonction `resolveBallCollision`)*
  Repérez la zone `TODO ÉTUDIANT`. Vous devez traduire la physique en JavaScript (Three.js).
  
  1. Calculez la **Normale** $arrow(n)$ (Vecteur unitaire de B vers A).
  2. Calculez la **Vitesse Relative** $v_"rel"$ (Produit scalaire).
  3. *Sécurité :* Si $v_"rel" > 0$ (elles s'éloignent), on arrête (`return`).
  4. Calculez la **Masse Réduite** et l'**Impulsion** $j$.
  5. Appliquez le changement aux vitesses `velA` et `velB`.
  
  _Indice : Utilisez `addScaledVector(vector, scale)`._
]

#definition-box(title: "4. Expérimentations (Observations)")[
  Une fois votre code fonctionnel, utilisez la GUI pour tester ces scénarios physiques classiques.
  
  *Scénario 1 : Le Pendule de Newton*
  - Réglez $m_A = 5$ et $m_B = 5$ (Masses égales).
  - Restitution $e = 1$.
  - *Observation :* La boule rouge doit s'arrêter net. La verte doit partir avec toute la vitesse.
  
  *Scénario 2 : Le Mur*
  - Réglez $m_A = 1$ (Légère) et $m_B = 100$ (Très lourde).
  - *Observation :* La rouge rebondit en arrière. La verte bouge à peine.
  
  *Scénario 3 : Le Bulldozer (Effet Catapulte)*
  - Réglez $m_A = 100$ (Très lourde) et $m_B = 1$ (Légère).
  - *Observation :* La rouge continue presque sans ralentir. À quelle vitesse part la verte ? (Indice : $2 times v_A$).
  
  *Scénario 4 : La Pâte à modeler*
  - Mettez la restitution $e = 0$.
  - *Observation :* Les boules doivent se coller et avancer ensemble à une vitesse moyenne.
]

#tip-box(title: "Astuce Debug")[
  Si vos boules disparaissent ou accélèrent à l'infini :
  1. Vérifiez le signe dans l'application de l'impulsion ($-j$ pour B).
  2. Vérifiez la condition `if (vRel > 0) return;`.
  3. Utilisez le slider "Time Scale" pour mettre le temps au ralenti ($0.1$) et voir exactement ce qui se passe au moment de l'impact.
]
