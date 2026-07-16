#import "@preview/theorion:0.4.1": *
#import cosmos.rainbow: *
#show: show-theorion

// ===================== SESSION 12 =====================

#heading(level: 1)[Session 12 : TP - Les planètes - Runge-Kutta]

#heading(level: 2)[Objectifs du TP]
- Simuler un système solaire avec la gravité universelle.
- Comprendre pourquoi Euler "dérape" sur les orbites.
- Implémenter Runge-Kutta 4 pour une intégration plus stable.
- Trouver la bonne vitesse initiale pour une orbite circulaire.

#heading(level: 3)[1. La Gravité Universelle]

#definition-box(title: "Loi de gravitation universelle")[
  Newton a découvert que tous les objets s'attirent mutuellement.
  $ arrow(F) = G dot (m_1 m_2) / r^2 dot hat(u) $
  
  - $G$ : constante gravitationnelle ($6.674 times 10^-11$).
  - $r$ : distance entre les centres.
  - $hat(u)$ : direction de l'attraction.
]

*Pourquoi on ne ressent pas l'attraction entre deux personnes ?* Parce que $G$ est minuscule. Il faut une masse planétaire.

#heading(level: 3)[2. Le Système Solaire]

#definition-box(title: "Objectif du TP")[
  1. Créer un soleil massif au centre.
  2. Ajouter des planètes avec des vitesses initiales perpendiculaires au soleil.
  3. Appliquer la gravité universelle entre chaque paire.
  4. Observer les orbites.
]

*Défi :* trouver la vitesse initiale pour une orbite circulaire parfaite.
$ v = sqrt(G M / r) $

#heading(level: 3)[3. Pourquoi Euler ne suffit pas]

Euler suppose que la vitesse est constante sur tout le pas de temps. Sur une orbite, la force change constamment, donc Euler accumule de l'erreur et les planètes "dérapent" ou s'échappent.

#heading(level: 3)[4. Runge-Kutta 4 (RK4)]

#definition-box(title: "Algorithme RK4")[
  RK4 "sonde" le terrain à 4 endroits du pas de temps pour obtenir une pente moyenne.
  
  1. $k_1$ = `eval(état)`
  2. $k_2$ = `eval(état + k_1 * h/2)`
  3. $k_3$ = `eval(état + k_2 * h/2)`
  4. $k_4$ = `eval(état + k_3 * h)`
  
  Nouvel état = état + $(k_1 + 2k_2 + 2k_3 + k_4) / 6 * h$
]

#definition-box(title: "Structure d'État")[
  On regroupe position et vitesse dans un vecteur d'état $Y$.
  $ Y = vec(x, v) $
  $ dot(Y) = vec(v, a) $
]

#heading(level: 3)[5. Missions]

- Implémenter la gravité universelle entre N objets.
- Comparer Euler vs RK4 sur une orbite simple.
- Observer la stabilité des orbites sur plusieurs révolutions.
- Ajouter plusieurs planètes et voir leurs interactions.
