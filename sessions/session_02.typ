#set text(font: "Georgia", lang: "fr", size: 12pt)
#set page(paper: "us-letter", margin: 3cm)
#set par(justify: true)

= Session 2 : Cinématique 2D et Mouvement de Projectile

== Résumé de la Session :

- *Introduction à la cinématique :*
  - Branche de la mécanique qui décrit le mouvement des objets sans considérer les causes du mouvement (les forces).
  - Contrairement à la dynamique, qui relie le mouvement aux forces.
  - Notre objectif dans ce bloc est de développer les outils mathématiques pour décrire précisément _comment_ les objets se déplacent.

La position, la vitesse et l'accélération sont des concepts qui permettent de décrire précisément comment un objet se comporte.

La relation entre ces concepts est la suivante :

- La position est le vecteur qui indique la localisation d'un point dans l'espace.
- La vitesse est le vecteur qui indique la vitesse du point, il est défini comme la variation (dérivée) de la position par rapport au temps.
- L'accélération est le vecteur qui indique l'accélération du point, il est défini comme la variation (dérivée) de la vitesse par rapport au temps.

Lorsque la position est constante, le point est au repos, immobile. Sa vitesse et son accélération sont nulles.

Lorsque la vitesse est constante, le point se déplace à vitesse constante en ligne droite. Son accélération est nulle.

Lorsque l'accélération est constante, la vitesse augmente constamment,
le point se déplace de plus en plus vite.

=== 1. Introduction et Rappels

- *Brève révision des vecteurs :*
  - Rappel de la définition d'un vecteur comme une quantité possédant une magnitude (longueur, norme) et une direction.
  - Représentation d'un vecteur en 2D à l'aide de ses composantes : $ arrow(v) = vec(v_x, v_y) $.
  - Opérations vectorielles de base (addition et soustraction) :
    $ arrow(a) + arrow(b) = vec(a_x + b_x, a_y + b_y) $
    $ arrow(a) - arrow(b) = vec(a_x - b_x, a_y - b_y) $
  - Multiplication d'un vecteur par un scalaire : $ k arrow(a) = vec(k a_x, k a_y) $.



=== 2. Position en 2D

- *Vecteur Position :*
  - Pour décrire la localisation d'un point (ou d'un objet considéré comme un point) dans un plan bidimensionnel, nous utilisons le *vecteur position*, noté $arrow(r)$ (ou parfois $arrow(s)$ ou $arrow(x)$).
  - Si nous définissons un système de coordonnées cartésiennes avec un axe horizontal ($x$) et un axe vertical ($y$), le vecteur position d'un point $P$ de coordonnées $(x, y)$ est donné par :
    $
    arrow(r) = vec(x, y) = x hat(i) + y hat(j)
    $
    où $hat(i) = vec(1, 0)$ est le vecteur unitaire dans la direction de l'axe $x$, et $hat(j) = vec(0, 1)$ est le vecteur unitaire dans la direction de l'axe $y$.
  - Le vecteur position pointe de l'origine du système de coordonnées vers la position de l'objet.
  - La *magnitude* du vecteur position, $|arrow(r)| = sqrt(x^2 + y^2)$, représente la distance de l'objet à l'origine.
  - La *direction* du vecteur position peut être donnée par l'angle $theta$ qu'il forme avec l'axe $x$, où $tan(theta) = y/x$.

  #figure(
    image("../images/vecteurs_03.svg", width: 80%),
    caption: [Plan 2D avec vecteurs position et vitesse],
  )

- *Trajectoire :*
  - Si la position d'un objet change au cours du temps, nous pouvons décrire son mouvement en spécifiant son vecteur position en fonction du temps : 
  
  $ arrow(r)(t) = vec(x(t), y(t)) $.
  - L'ensemble des points atteints par l'objet au cours de son mouvement forme sa *trajectoire*. La trajectoire est une courbe dans l'espace (ici, en 2D).
  
  - Exemples de trajectoires :
    - *Mouvement rectiligne uniforme :* 
    
    $arrow(r)(t) = vec(x_0 + v_x t, y_0 + v_y t)$, 
    
    où $x_0, y_0, v_x, v_y$ sont des constantes. La trajectoire est une ligne droite.
    - *Mouvement circulaire uniforme :* 
    $arrow(r)(t) = vec(R cos(omega t), R sin(omega t))$, où $R$ est le rayon et $omega$ la vitesse angulaire. La trajectoire est un cercle.
    - *Mouvement parabolique (projectile) :* 
    $arrow(r)(t) = vec(v_(0x) t, y_0 + v_(0y) t - 1/2 g t^2)$ (sous l'effet de la gravité). La trajectoire est une parabole.
  - Visualisation de différentes trajectoires et des vecteurs position correspondants à différents instants.

- *Démo cinématique :* Pour visualiser les concepts de cinématique, consultez la démo : #link("../scenes/session02.html")[file:../scenes/session02.html]
 
=== 3. Vitesse en 2D 

- *Vitesse Moyenne :*

  #figure(
    image("../images/vitesse_moyenne.svg", width: 80%),
    caption: [Plan 2D avec vecteurs position et vitesse],
  )

  - Considérons un objet qui se déplace de la position $arrow(r)_i$ à l'instant $t_i$ à la position $arrow(r)_f$ à l'instant $t_f$.
  - Le *déplacement* de l'objet pendant cet intervalle de temps $Delta t = t_f - t_i$ est le vecteur :
    $ Delta arrow(r) = arrow(r)_f - arrow(r)_i = vec(x_f - x_i, y_f - y_i) = vec(Delta x, Delta y) $


  - Le *vecteur vitesse moyenne* $arrow(v)_m$ est défini comme le rapport du déplacement au temps écoulé :
    $
    arrow(v)_"moy" = (Delta arrow(r)) / (Delta t) = (arrow(r)_f - arrow(r)_i) / (t_f - t_i) = vec((Delta x)/(Delta t), (Delta y)/(Delta t)) = vec(v_("moy", x), v_("moy", y))
    $
  - La vitesse moyenne est un vecteur dont la direction est la même que celle du déplacement, et dont la magnitude est le déplacement total divisé par le temps écoulé.

*Exemple :* Si une voiture se déplace de la position $arrow(r)_i = vec(0, 0)$ à la position $arrow(r)_f = vec(10, 5)$ au cours d'un intervalle de temps $Delta t = 5$ secondes, alors le déplacement de la voiture est $Delta arrow(r) = vec(10, 5)$ et la vitesse moyenne est $arrow(v)_"moy" = vec(2, 1)$ m/s.

- *Vitesse Instantanée :*
  - Pour décrire la vitesse de l'objet à un instant précis $t$, nous utilisons la notion de *vitesse instantanée*, $arrow(v)(t)$.
  - Mathématiquement, la vitesse instantanée est définie comme la limite de la vitesse moyenne lorsque l'intervalle de temps $Delta t$ tend vers zéro :
    $
    arrow(v)(t) = lim_(Delta t -> 0) (Delta arrow(r)) / (Delta t) = (d arrow(r)) / (d t)
    $
  - En termes de composantes, la vitesse instantanée est la dérivée des composantes de la position par rapport au temps :
    $
    arrow(v)(t) = vec((d x(t)) / (d t), (d y(t)) / (d t)) = vec(v_x (t), v_y (t))
    $
    où $v_x(t)$ est la composante de la vitesse selon l'axe $x$, et $v_y(t)$ est la composante de la vitesse selon l'axe $y$ à l'instant $t$.
  - La *magnitude* de la vitesse instantanée, $|arrow(v)(t)| = sqrt(v_x(t)^2 + v_y(t)^2)$, est appelée *vitesse scalaire*.
  - La *direction* de la vitesse instantanée est tangente à la trajectoire de l'objet au point considéré. Visualisation de ce concept avec des exemples de trajectoires courbes.

*Application aux différents types de trajectoire :*

*1. Mouvement rectiligne uniforme :*
  - Pour $arrow(r)(t) = vec(x_0 + v_x t, y_0 + v_y t)$, la vitesse instantanée est :
    $
    arrow(v)(t) = vec(v_x, v_y)
    $
  - Le vecteur vitesse est *constant* : direction, magnitude et composantes ne changent pas au cours du temps. Par exemple, un objet avec $arrow(r)(0) = vec(1, 2)$ et $arrow(v) = vec(3, 0)$ se déplace horizontalement à 3 m/s.

*2. Mouvement circulaire uniforme :*
  - Pour $arrow(r)(t) = vec(R cos(omega t), R sin(omega t))$, la vitesse instantanée est :
    $
    arrow(v)(t) = vec(-R omega sin(omega t), R omega cos(omega t)) = vec(-omega y(t), omega x(t))
    $
  - La magnitude est constante : $|arrow(v)| = R omega$. À l'instant $t = pi/(2 omega)$ (quand l'objet est en haut du cercle), $arrow(r) = vec(0, R)$ et $arrow(v) = vec(-R omega, 0)$ : la vitesse est purement horizontale et tangente au cercle.

*3. Mouvement parabolique (projectile) :*
  - Pour $arrow(r)(t) = vec(v_(0x) t, y_0 + v_(0y) t - 1/2 g t^2)$, la vitesse instantanée est :
    $
    arrow(v)(t) = vec(v_(0x), v_(0y) - g t)
    $
  - La composante horizontale $v_x$ reste constante, tandis que la composante verticale $v_y$ diminue linéairement. Par exemple, avec $v_(0x) = 10$ m/s, $v_(0y) = 20$ m/s et $g = 9.81$ m/s², à $t = 2$ s : $arrow(v) = vec(10, 20 - 9.81*2) = vec(10, 0.38)$ m/s. Le projectile est quasiment à son apogée.

=== 4. Accélération en 2D

- *Accélération Moyenne :*
  - Si la vitesse d'un objet change au cours du temps, l'objet est en train d'accélérer.
  - Le *vecteur accélération moyenne* $arrow(a)_"moy"$ pendant un intervalle de temps $Delta t = t_f - t_i$ est défini comme le rapport du changement de vitesse au temps écoulé :
    $
    arrow(a)_"moy" = (Delta arrow(v)) / (Delta t) = (arrow(v)_f - arrow(v)_i) / (t_f - t_i) = vec((Delta v_x) / (Delta t), (Delta v_y) / (Delta t)) = vec(a_("moy", x), a_("moy", y))
    $
  - L'accélération moyenne est un vecteur dont la direction est celle du changement de vitesse.

- *Accélération Instantanée :*
  - L'*accélération instantanée* $arrow(a)(t)$ décrit la manière dont la vitesse d'un objet change à un instant précis $t$. Elle est définie comme la dérivée de la vitesse par rapport au temps :
    $
    arrow(a)(t) = lim_(Delta t -> 0) (Delta arrow(v)) / (Delta t) = (d arrow(v)) / (d t)
    $
  - En termes de composantes, l'accélération instantanée est la dérivée des composantes de la vitesse par rapport au temps, ou la deuxième dérivée des composantes de la position par rapport au temps :
    $
    arrow(a)(t) = vec(a_x (t), a_y (t))  = vec((d v_x (t)) / (d t), (d v_y (t)) / (d t)) = vec((d^2 x(t)) / (d t^2), (d^2 y(t)) / (d t^2))
    $
  - L'accélération peut changer la magnitude de la vitesse (l'objet accélère ou décélère), sa direction, ou les deux en même temps.

  *Cas particulier : Accélération constante.* Si l'accélération $arrow(a)$ est constante, alors $arrow(a)(t) = arrow(a) = vec(a_x, a_y)$, où $a_x$ et $a_y$ sont des constantes. Dans ce cas, nous pouvons *intégrer* les équations de l'accélération pour obtenir la vitesse et la position en fonction du temps :

    $
    arrow(v)(t) = arrow(v)_0 + arrow(a) t = vec(v_(0x) + a_x t, v_(0y) + a_y t)
    $
    $
    arrow(r)(t) = integral_(t_0)^t arrow(v)(t) d t = arrow(r)_0 + arrow(v)_0 t + 1/2 arrow(a) t^2 = vec(x_0 + v_(0x) t + 1/2 a_x t^2, y_0 + v_(0y) t + 1/2 a_y t^2)
    $
    où $arrow(v)_0 = vec(v_(0x), v_(0y))$ est la vitesse initiale
    et $arrow(r)_0 = vec(x_0, y_0)$ est la position initiale.

    C'est ce cas particulier qui sera crucial pour l'étude du mouvement de projectile sous l'effet de la gravité.

*Exemples complet par type de trajectoire :*

Nous pouvons maintenant reprendre nos 3 exemples et finaliser notre étude de leurs mouvements.

*1. Mouvement rectiligne uniforme:*

  *Position :*
$ arrow(r)(t) = vec(x_0 + v_x t, y_0 + v_y t) $
    où $x_0$ et $y_0$ sont les positions initiales, et $v_x$ et $v_y$ sont les vitesses initiales.

  *Vitesse (dérivée de la position) :*
$ arrow(v)(t) = vec(v_x, v_y) $
  
    *Accélération (dérivée de la vitesse) :*
  $ arrow(a)(t) = vec(0, 0) $
  
  La dérivée d'un vecteur constant est nulle. Aucune accélération n'est nécessaire pour maintenir le mouvement rectiligne uniforme.



== *2. Mouvement circulaire uniforme :*

  *Position :*
  


  - À l'instant $t$, le vecteur position est :
  $
    arrow(r)(t) = vec(R cos(omega t), R sin(omega t))
  $


  *Vitesse (dérivée de la position) :*
  - Dérivons chaque composante par rapport au temps :
  $
    arrow(v)(t) = vec(d(R cos(omega t))/(d t), d(R sin(omega t))/(d t)) = vec(-R omega sin(omega t), R omega cos(omega t))
  $


  *Accélération (dérivée de la vitesse) :*
  - Dérivons à nouveau chaque composante :
  $
    arrow(a)(t) = vec(-d(R omega sin(omega t))/(d t), d(R omega cos(omega t))/(d t)) = vec(-R omega^2 cos(omega t), -R omega^2 sin(omega t))
  $


  *Relation avec la position :*
  - On observe que :
  $
  arrow(a)(t) = -omega^2 vec(R cos(omega t), R sin(omega t)) = -omega^2 arrow(r)(t)
  $
L'accélération est constante et bien dirigée vers le centre du cercle.
  #figure(
    image("../images/circulaire 1.svg", width: 80%),
    caption: [Le mouvement circulaire uniforme],
  )
*3. Mouvement parabolique (projectile) :*
- L'équation de la trajectoire est :
  $
  arrow(r)(t) = vec(v_(0x) t, y_0 + v_(0y) t - 1/2 g t^2)
  $  
  - Pour $arrow(v)(t) = vec(v_(0x), v_(0y) - g t)$, l'accélération instantanée est :
  $
  arrow(a)(t) = vec(0, -g)
  $
  - L'accélération est *constante* et dirigée verticalement vers le bas. 
  Avec $g = 9.81$ m/s², quel que soit l'instant $t$, $arrow(a) = vec(0, -9.81)$ m/s². Cette accélération change uniquement la composante verticale de la vitesse. La composante horizontale reste inchangée.