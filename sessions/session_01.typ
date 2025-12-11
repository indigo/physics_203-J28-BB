#import "@preview/theorion:0.4.1": *
//#import cosmos.fancy: *
#import cosmos.rainbow: *
// #import cosmos.clouds: *
#show: show-theorion

#set document(
  author: ("Richard Rispoli"),
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
    // Retrieve the document
    // element's title property.
    "Physics 203-j28-BB - " + context document.author.at(0),
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
// Style des boîtes
#let section-box(title, body) = {
  rect(
    width: 100%,
    radius: 4pt,
    stroke: 1pt + luma(65.27%),
    inset: 10pt,
    fill: luma(98.6%)
  )[
    #heading()[#title]
    #v(1.5em)
    #body
  ]
}



#set document(title: [Géométrie et Calcul Vectoriel])

#title()


#definition-box(title: "Définitions", outlined: false)[

    
    Un vecteur est une grandeur ayant une direction et une magnitude.
    
    On dit qu'il est de dimension $n$ si il a $n$ composantes. 
    
    Dans le plan, $n = 2$, donc un vecteur a 2 composantes, 2 dimensions.
]
#tip-box(title: "Représentation")[
    Un vecteur est représenté par une flèche. Il peut être placé n'importe où dans le plan. On le place habituellement par rapport au contexte de ce qu'il représente.

    #figure(
image("../images/un_vecteur.svg", width: 20%),
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
image("../images/vecteur_exemple.svg", width: 20%),
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
    // Parenthèses ajoutées pour assurer la fraction verticale
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
      image("../images/vecteurs_01.svg", width: 70%),
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
image("../images/vecteurs_02.svg", width: 70%),
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

  
  
  
//]