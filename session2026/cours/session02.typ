#import "@preview/theorion:0.4.1": *
#import cosmos.rainbow: *
#show: show-theorion

// ===================== SESSION 02 =====================

#heading(level: 1)[Session 2 : Cinématique 2D et Mouvement de Projectile]

#tip-box(title: "Introduction à la cinématique")[
  La cinématique est la branche de la mécanique qui décrit le mouvement des objets sans considérer les causes du mouvement (les forces). Contrairement à la dynamique, qui relie le mouvement aux forces.

  Notre objectif dans ce bloc est de développer les outils mathématiques pour décrire précisément _comment_ les objets se déplacent.
]

#definition-box(title: "Position, Vitesse et Accélération", outlined: false)[
  La position, la vitesse et l'accélération sont des concepts qui permettent de décrire précisément comment un objet se comporte.

  - La *position* est le vecteur qui indique la localisation d'un point dans l'espace.
  - La *vitesse* est le vecteur qui indique la vitesse du point, définie comme la variation (dérivée) de la position par rapport au temps.
  - L'*accélération* est le vecteur qui indique l'accélération du point, définie comme la variation (dérivée) de la vitesse par rapport au temps.
]

#tip-box(title: "Cas particuliers")[
  - Lorsque la position est constante, le point est au repos, immobile. Sa vitesse et son accélération sont nulles.
  - Lorsque la vitesse est constante, le point se déplace à vitesse constante en ligne droite. Son accélération est nulle.
  - Lorsque l'accélération est constante, la vitesse augmente constamment, le point se déplace de plus en plus vite.
]

#heading(level: 3)[1. Introduction et Rappels]

#definition-box(title: "Rappels sur les vecteurs", outlined: false)[
  Rappel de la définition d'un vecteur comme une quantité possédant une magnitude (longueur, norme) et une direction.

  Représentation d'un vecteur en 2D à l'aide de ses composantes : $ arrow(v) = vec(v_x, v_y) $.

  *Opérations vectorielles de base :*
  $ arrow(a) + arrow(b) = vec(a_x + b_x, a_y + b_y) $
  $ arrow(a) - arrow(b) = vec(a_x - b_x, a_y - b_y) $

  *Multiplication par un scalaire :*
  $ k arrow(a) = vec(k a_x, k a_y) $
]

#heading(level: 2)[Position en 2D]

#definition-box(title: "Vecteur Position")[
  Pour décrire la localisation d'un point dans un plan bidimensionnel, nous utilisons le *vecteur position*, noté $arrow(r)$ (ou parfois $arrow(s)$ ou $arrow(x)$).

  Avec un système de coordonnées cartésiennes ($x$, $y$), le vecteur position d'un point $P$ de coordonnées $(x, y)$ est :
  $
  arrow(r) = vec(x, y) = x hat(i) + y hat(j)
  $
  où $hat(i) = vec(1, 0)$ et $hat(j) = vec(0, 1)$ sont les vecteurs unitaires.

  - Le vecteur position pointe de l'origine vers la position de l'objet.
  - La *magnitude* $|arrow(r)| = sqrt(x^2 + y^2)$ représente la distance à l'origine.
  - La *direction* est donnée par l'angle $theta$ avec $tan(theta) = y/x$.

  #figure(
    image("images/vecteurs_03.svg", width: 80%),
    caption: [Plan 2D avec vecteurs position et vitesse],
  )
]

#tip-box(title: "Trajectoire")[
  Si la position d'un objet change au cours du temps, on décrit son mouvement par :
  $ arrow(r)(t) = vec(x(t), y(t)) $

  L'ensemble des points atteints forme la *trajectoire* — une courbe dans l'espace. $x(t)$ et $y(t)$ sont des fonctions du temps.

  *Exemples de trajectoires :*
  - *Mouvement rectiligne uniforme :* 
  
  $ arrow(r)(t) = vec(x_0 + v_(0x) t, y_0 + v_(0y) t) $ 
  
  - *Mouvement circulaire uniforme :* 

  $ arrow(r)(t) = vec(R cos(omega t), R sin(omega t)) $ 
  
  - *Mouvement parabolique (projectile) :* 

  $ arrow(r)(t) = vec(x_0 + v_(0x) t, y_0 + v_(0y) t - 1/2 g t^2) $ 
]

#heading(level: 2)[Vitesse en 2D]

#definition-box(title: "Vitesse Moyenne")[
  Le *déplacement* d'un objet pendant un intervalle $Delta t = t_f - t_i$ est :
  $ Delta arrow(r) = arrow(r)_f - arrow(r)_i = vec(Delta x, Delta y) $

  Le *vecteur vitesse moyenne* $arrow(v)_"moy"$ est le rapport du déplacement au temps écoulé :
  $
  arrow(v)_"moy" = (Delta arrow(r)) / (Delta t) = vec((Delta x)/(Delta t), (Delta y)/(Delta t)) = vec(v_("moy", x), v_("moy", y))
  $

  La vitesse moyenne a la même direction que le déplacement, et sa magnitude est le déplacement total divisé par le temps écoulé.

  #figure(
    image("images/vitesse_moyenne.svg", width: 80%),
    caption: [Plan 2D avec vecteurs position et vitesse],
  )
]

#example[
  Si une voiture se déplace de $arrow(r)_i = vec(0, 0)$ à $arrow(r)_f = vec(10, 5)$ en $Delta t = 5$ secondes, alors le déplacement est $Delta arrow(r) = vec(10, 5)$ et la vitesse moyenne est $arrow(v)_"moy" = vec(2, 1)$ m/s.
]

#definition-box(title: "Vitesse Instantanée")[
  La *vitesse instantanée* $arrow(v)(t)$ est la limite de la vitesse moyenne lorsque $Delta t -> 0$ :
  $
  arrow(v)(t) = lim_(Delta t -> 0) (Delta arrow(r)) / (Delta t) = (d arrow(r)) / (d t)
  $

  En composantes :
  $
  arrow(v)(t) = vec((d x(t)) / (d t), (d y(t)) / (d t)) = vec(v_x (t), v_y (t))
  $

  - La *magnitude* $|arrow(v)(t)| = sqrt(v_x(t)^2 + v_y(t)^2)$ est la *vitesse scalaire*.
  - La *direction* est tangente à la trajectoire au point considéré.
]

#tip-box(title: "Application aux types de trajectoire")[
  *1. Mouvement rectiligne uniforme :*
  $ arrow(v)(t) = vec(v_x, v_y) $ — Le vecteur vitesse est *constant*.

  *2. Mouvement circulaire uniforme :*
  $ arrow(v)(t) = vec(-R omega sin(omega t), R omega cos(omega t)) $
  Magnitude constante : $|arrow(v)| = R omega$. La vitesse est tangente au cercle.

  *3. Mouvement parabolique (projectile) :*
  $ arrow(v)(t) = vec(v_(0x), v_(0y) - g t) $
  La composante horizontale $v_x$ reste constante, la verticale $v_y$ diminue linéairement.
]

#heading(level: 2)[Accélération en 2D]

#definition-box(title: "Accélération Moyenne")[
  Le *vecteur accélération moyenne* $arrow(a)_"moy"$ pendant un intervalle $Delta t = t_f - t_i$ est le rapport du changement de vitesse au temps écoulé :
  $
  arrow(a)_"moy" = (Delta arrow(v)) / (Delta t) = vec((Delta v_x) / (Delta t), (Delta v_y) / (Delta t)) = vec(a_("moy", x), a_("moy", y))
  $

  L'accélération moyenne a la direction du changement de vitesse.
]

#definition-box(title: "Accélération Instantanée")[
  L'*accélération instantanée* $arrow(a)(t)$ est la dérivée de la vitesse par rapport au temps :
  $
  arrow(a)(t) = (d arrow(v)) / (d t) = vec((d v_x (t)) / (d t), (d v_y (t)) / (d t)) = vec((d^2 x(t)) / (d t^2), (d^2 y(t)) / (d t^2))
  $

  L'accélération peut changer la magnitude de la vitesse (accélérer/décélérer), sa direction, ou les deux.
]

#important-box(title: "Cas particulier : Accélération constante")[
  Si l'accélération $arrow(a)$ est constante, on peut *intégrer* pour obtenir la vitesse et la position :
  $
  arrow(v)(t) = arrow(v)_0 + arrow(a) t = vec(v_(0x) + a_x t, v_(0y) + a_y t)
  $
  $
  arrow(r)(t) = arrow(r)_0 + arrow(v)_0 t + 1/2 arrow(a) t^2 = vec(x_0 + v_(0x) t + 1/2 a_x t^2, y_0 + v_(0y) t + 1/2 a_y t^2)
  $
  où $arrow(v)_0 = vec(v_(0x), v_(0y))$ est la vitesse initiale et $arrow(r)_0 = vec(x_0, y_0)$ est la position initiale.

  C'est ce cas particulier qui est crucial pour l'étude du mouvement de projectile sous l'effet de la gravité.
]

#tip-box(title: "Exemples par type de trajectoire")[
  *1. Mouvement rectiligne uniforme :*
  - Position : $arrow(r)(t) = vec(x_0 + v_x t, y_0 + v_y t)$
  - Vitesse : $arrow(v)(t) = vec(v_x, v_y)$
  - Accélération : $arrow(a)(t) = vec(0, 0)$

  La dérivée d'un vecteur constant est nulle. Aucune accélération n'est nécessaire pour maintenir le mouvement rectiligne uniforme.

  *2. Mouvement circulaire uniforme :*
  - Position : $arrow(r)(t) = vec(R cos(omega t), R sin(omega t))$
  - Vitesse : $arrow(v)(t) = vec(-R omega sin(omega t), R omega cos(omega t))$
  - Accélération : $arrow(a)(t) = vec(-R omega^2 cos(omega t), -R omega^2 sin(omega t))$

  On observe que $arrow(a)(t) = -omega^2 arrow(r)(t)$ : l'accélération est dirigée vers le centre du cercle.

  #figure(
    image("images/circulaire 1.svg", width: 80%),
    caption: [Le mouvement circulaire uniforme],
  )

  *3. Mouvement parabolique (projectile) :*
  - Position : $arrow(r)(t) = vec(v_(0x) t, y_0 + v_(0y) t - 1/2 g t^2)$
  - Vitesse : $arrow(v)(t) = vec(v_(0x), v_(0y) - g t)$
  - Accélération : $arrow(a)(t) = vec(0, -g)$

  L'accélération est *constante* et dirigée vers le bas. Avec $g = 9.81$ m/s², $arrow(a) = vec(0, -9.81)$ m/s². Seule la composante verticale de la vitesse change.
]
