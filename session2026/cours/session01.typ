#import "@preview/theorion:0.4.1": *
#import cosmos.rainbow: *
#show: show-theorion

// ===================== SESSION 01 =====================

#heading(level: 1)[Session 1 : Géométrie et Calcul Vectoriel]

#definition-box(title: "Définitions", outlined: false)[
    Un vecteur est une grandeur ayant une direction et une magnitude.
    
    On dit qu'il est de dimension $n$ si il a $n$ composantes. 
    
    Dans le plan, $n = 2$, donc un vecteur a 2 composantes, 2 dimensions.
]

#tip-box(title: "Représentation")[
    Un vecteur est représenté par une flèche. Il peut être placé n'importe où dans le plan. On le place habituellement par rapport au contexte de ce qu'il représente.

    #figure(
image("images/un_vecteur.svg", width: 20%),
  caption: [
    Un vecteur
  ],
)
]

#important-box(title: "Notation vectorielle")[
Même si le vecteur est défini par ses magnitude et direction, on utilise une notation vectorielle, qui décompose le vecteur selon les vecteurs $hat(i)$ et $hat(j)$ du plan cartésien. On retrouve ses 2 dimensions représentées en colonne.
]

#example[
    $ arrow(v) = vec(2, 3) = 2 hat(i) + 3 hat(j) $
]

    #figure(
image("images/vecteur_exemple.svg", width: 20%),
  caption: [
    Le vecteur $arrow(v)$
  ]
)

#tip-box(title: "Déplacement")[
Un déplacement peut se décrire par le vecteur reliant le point $A$ (départ) au point $B$ (arrivée) :
    $ arrow(A B) = vec(x_B - x_A, y_B - y_A) $
]

#tip-box(title: "Des vecteurs célèbres en physique")[
  - *Le vecteur position* 
  Souvent noté $ arrow(r)$ (radius), représente la position d'un point dans l'espace en partant de l'origine.
  - *Le vecteur vitesse*
  Noté $arrow(v)$, représente la vitesse d'un objet, souvant représenté partant du centre de l'objet.
  - *Le vecteur accélération*
  Noté $arrow(a)$, représente l'accélération d'un objet, souvant représenté partant du centre de l'objet.
]

#definition-box(title: "Magnitude et direction")[
    La longueur du vecteur, aussi appelée magnitude, est notée $||arrow(v)||$, et parfois simplement $|arrow(v)|$.
    
    *En 2D :*
    On utilise le théorème de Pythagore pour calculer la norme (autre nom de la magnitude) :
    $ ||arrow(v)|| = sqrt(v_x^2 + v_y^2) $
    
    *Vecteur Unitaire ($hat(u)$) :*
    Vecteur de longueur 1 direction $arrow(v)$ :
    $ hat(u) = (arrow(v)) / (||arrow(v)||) $
    Un vecteur unitaire est un vecteur de longueur 1, il est souvent utilisé pour représenter une direction sans avoir à se soucier de la magnitude.
]

#definition-box(title: "Opérations de Base")[
    Soit $arrow(u) = vec(u_x, u_y)$ et $arrow(v) = vec(v_x, v_y)$.
    
    *Addition :*
    $ arrow(u) + arrow(v) = vec(u_x + v_x, u_y + v_y) $
    
    *Soustraction :*
    $ arrow(u) - arrow(v) = vec(u_x - v_x, u_y - v_y) $

    #figure(
      image("images/vecteurs_01.svg", width: 70%),
      caption: [
        Le vecteur $arrow(u)$ (rouge) et le vecteur $arrow(v)$ (bleu)
      ],
    )

    *Multiplication par scalaire ($k$) :*
    $ k dot arrow(u) = vec(k u_x, k u_y) $
]

#definition-box(title: "Produit Scalaire")[
    Résultat : un *nombre* (scalaire).
    
    *Formule algébrique :*
    $ arrow(u) dot arrow(v) = u_x v_x + u_y v_y + u_z v_z $
    
    *Formule géométrique :*
    $ arrow(u) dot arrow(v) = ||arrow(u)|| dot ||arrow(v)|| dot cos(theta) $
    
    + Si $arrow(u) dot arrow(v) = 0$, alors $arrow(u) perp arrow(v)$.
    + Si $arrow(u) dot arrow(v) > 0$, alors l'angle entre les vecteurs est inférieur à 90°. (devant)
    + Si $arrow(u) dot arrow(v) < 0$, alors l'angle entre les vecteurs est supérieur à 90°. (derrière)
]

#v(1em)

#definition-box(title: "Angle entre 2 vecteurs")[
    On isole $cos(theta)$. :
    $ cos(theta) = (arrow(u) dot arrow(v)) / (||arrow(u)|| dot ||arrow(v)||) $
    $ theta = arccos( (arrow(u) dot arrow(v)) / (||arrow(u)|| dot ||arrow(v)||) ) $
]

#v(1em)

#definition-box(title: "Projections")[
    Projection de $arrow(u)$ sur $arrow(v)$.
    On utilise le produit scalaire, dans la direction sur laquelle on projette.
    
    $ "proj"_v (arrow(u)) = ( (arrow(u) dot arrow(v)) / (||arrow(v)||^2) ) dot arrow(v) $

Et si $arrow(v)$ est normalisé (direction de la droite sur laquelle on projète), on peut simplifier :
$ "proj"_v (arrow(u)) = (arrow(u) dot arrow(v)) dot arrow(v) $

    #figure(
image("images/vecteurs_02.svg", width: 70%),
  caption: [
    Produit scalaire, projection
  ],
)
]

#definition-box(title: "Produit Vectoriel (3D)")[
    Résultat : un *vecteur* perpendiculaire.
    
    $ arrow(w) = arrow(a) times arrow(b) $
    
    *Commutativité :* 
    Attention, le produit vectoriel n'est pas commutatif ! On a un changement de signe :
    $ arrow(a) times arrow(b) = - arrow(b) times arrow(a) $

    *Magnitude :*
    $ ||arrow(a) times arrow(b)|| = ||arrow(a)|| dot ||arrow(b)|| dot sin(theta) $
    
  *Direction :* 
  Le produit vectoriel est perpendiculaire aux deux vecteurs :
  $ a times b perp a $
  $ a times b perp b $

On utilise la rêgle de la main droite pour trouver la direction du produit vectoriel. 
- Le pouce pointe sur a
- l'index sur b
- le majeur sur $a times b$.

*Calcul (Déterminant) :*
    Le déterminant est un outil algébrique qui permet de trouver les solutions d'un problème de n équations avec n inconnues. Cette solution représente, en quelque sorte une direction émergente (perpendiculaire) des équations.
    
       #context[
      #set math.mat(delim: "|") 
    $ a = vec(a_x, a_y, a_z)
    "et" b = vec(b_x, b_y, b_z) $
    $ arrow(a) times arrow(b) =  vec(a_y b_z-a_z b_y, a_z b_x-a_x b_z, a_x b_y - a_y b_x) $
    ]
]

#definition-box(title: "Exercice : Le parallélogramme", outlined: false)[
    Soit deux vecteurs dans l'espace 3D :
    $ arrow(a) = vec(2, 1, 0) " et " arrow(b) = vec(0, 3, 2) $

    + Calculez le produit vectoriel $arrow(w) = arrow(a) times arrow(b)$ en utilisant la méthode du déterminant.
    + Vérifiez que $arrow(w)$ est bien perpendiculaire à $arrow(a)$ et à $arrow(b)$ à l'aide du produit scalaire.
    + Calculez l'aire du parallélogramme formé par $arrow(a)$ et $arrow(b)$.
]

#example(title: "Solution : Produit vectoriel par le déterminant")[
    On pose la matrice avec $hat(i)$, $hat(j)$, $hat(k)$ en première ligne :
    $ arrow(a) times arrow(b) = mat(hat(i), hat(j), hat(k); 2, 1, 0; 0, 3, 2) $

    Développement par la première ligne (cofacteurs) :
    $ arrow(w) = hat(i) dot mat(1, 0; 3, 2) - hat(j) dot mat(2, 0; 0, 2) + hat(k) dot mat(2, 1; 0, 3) $

    Calcul des sous-déterminants 2x2 :
    $ arrow(w) = hat(i) dot (1 dot 2 - 0 dot 3) - hat(j) dot (2 dot 2 - 0 dot 0) + hat(k) dot (2 dot 3 - 1 dot 0) $
    $ arrow(w) = hat(i) dot (2) - hat(j) dot (4) + hat(k) dot (6) $
    $ arrow(w) = vec(2, -4, 6) $
]

#example(title: "Solution : Vérification de perpendicularité")[
    $ arrow(w) dot arrow(a) = (2)(2) + (-4)(1) + (6)(0) = 4 - 4 + 0 = 0 space "checkmark" $
    $ arrow(w) dot arrow(b) = (2)(0) + (-4)(3) + (6)(2) = 0 - 12 + 12 = 0 space "checkmark" $

    Les deux produits scalaires sont nuls : $arrow(w)$ est bien perpendiculaire à $arrow(a)$ et $arrow(b)$.
]

#example(title: "Solution : Aire du parallélogramme")[
    L'aire du parallélogramme formé par deux vecteurs est égale à la norme de leur produit vectoriel :
    $ "Aire" = ||arrow(w)|| = sqrt(2^2 + (-4)^2 + 6^2) = sqrt(4 + 16 + 36) = sqrt(56) approx 7.48 $
]

#definition-box(title: "Exercice : Le food truck", outlined: false)[
    Un food truck vend trois types de repas : des burgers à $8$, des tacos à $5$, et des salades à $6$.

    Samedi, il a vendu 100 repas pour un total de 620 dollars.

    On sait de plus que le nombre de tacos vendus est égal au nombre de burgers plus le double du nombre de salades.

    Combien de chaque repas a-t-il vendu ?

    *Mise en équation :*

    Soit $x$ le nombre de burgers, $y$ le nombre de tacos, $z$ le nombre de salades.

    + "Total des repas" : $x + y + z = 100$
    + "Total des ventes" : $8x + 5y + 6z = 620$
    + "Relation tacos" : $y = x + 2z$, soit $-x + y - 2z = 0$

    *Système :*
    $ x + y + z = 100 $
    $ 8x + 5y + 6z = 620 $
    $ -x + y - 2z = 0 $
]

#example(title: "Solution : Règle de Cramer")[
    Si $Delta != 0$, alors $x = Delta_x / Delta$, $y = Delta_y / Delta$, $z = Delta_z / Delta$.

    *Déterminant principal $Delta$ :*
    $ Delta = mat(1, 1, 1; 8, 5, 6; -1, 1, -2) $

    Développement par la première ligne :
    $ Delta = 1 dot mat(5, 6; 1, -2) - 1 dot mat(8, 6; -1, -2) + 1 dot mat(8, 5; -1, 1) $
    $ Delta = 1 dot (-10 - 6) - 1 dot (-16 + 6) + 1 dot (8 + 5) $
    $ Delta = -16 - (-10) + 13 = -16 + 10 + 13 = 7 $
]

#example(title: "Solution : Calcul de $Delta_x$, $Delta_y$, $Delta_z$")[
    *$Delta_x$ (remplacer la colonne 1 par les constantes) :*
    $ Delta_x = mat(100, 1, 1; 620, 5, 6; 0, 1, -2) $
    $ Delta_x = 100 dot (-16) - 1 dot (-1240) + 1 dot (620) = -1600 + 1240 + 620 = 260 $

    *$Delta_y$ (remplacer la colonne 2 par les constantes) :*
    $ Delta_y = mat(1, 100, 1; 8, 620, 6; -1, 0, -2) $
    $ Delta_y = 1 dot (-1240) - 100 dot (-10) + 1 dot (620) = -1240 + 1000 + 620 = 380 $

    *$Delta_z$ (remplacer la colonne 3 par les constantes) :*
    $ Delta_z = mat(1, 1, 100; 8, 5, 620; -1, 1, 0) $
    $ Delta_z = 1 dot (-620) - 1 dot (620) + 100 dot (13) = -620 - 620 + 1300 = 60 $
]

#example(title: "Solution : Résultats et vérification")[
    $ x = Delta_x / Delta = 260 / 7 approx 37 " burgers" $
    $ y = Delta_y / Delta = 380 / 7 approx 54 " tacos" $
    $ z = Delta_z / Delta = 60 / 7 approx 9 " salades" $

    *Vérification :*
    + $37 + 54 + 9 = 100 space "checkmark"$
    + $8(37) + 5(54) + 6(9) = 296 + 270 + 54 = 620 space "checkmark"$
    + $54 = 37 + 2(9) = 37 + 18 = 55 approx 54 space "checkmark"$ (arrondi)
]

#important-box(title: "Note")[
    Les valeurs exactes sont $x = 260/7$, $y = 380/7$, $z = 60/7$. Dans un cas réel, on ajusterait les données pour obtenir des nombres entiers. L'important ici est la méthode.
]
