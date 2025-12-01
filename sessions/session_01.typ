#set page(
  paper: "us-letter",
  margin: (x: 1.5cm, y: 1.5cm),
)
#set text(
  font: "Linux Libertine",
  lang: "fr",
  size: 14pt
)

// Style des boîtes
#let section-box(title, body) = {
  rect(
    width: 100%,
    radius: 4pt,
    stroke: 1pt + luma(150),
    inset: 10pt,
    fill: luma(250)
  )[
    #text(weight: "bold", size: 1.1em, fill: rgb("#005F87"))[#title]
    #v(0.5em)
    #body
  ]
}


#align(center)[
  #text(size: 24pt, weight: "bold")[Vecteurs 101] \
  #text(size: 14pt, style: "italic")[Géométrie et Calcul Vectoriel]
  #v(1em)
]

//#columns(2, gutter: 1em)[

#section-box("Définitions et Notation")[
    *Définition :*
    
    Un vecteur est une grandeur ayant une direction et une magnitude.
    
    Un vecteur est un objet de l'espace.
    On dit qu'il est de dimension $n$ si il a $n$ composantes. 
    
    Dans le plan, $n = 2$.

    *Notation vectorielle :*
    $ arrow(v) = vec(v_x, v_y) = v_x arrow(i) + v_y arrow(j) $

    *Example :*
    $ arrow(A B) = vec(6, -3) = 6 arrow(i) - 3 arrow(j) $

    *Déplacement :*
    Vecteur reliant le point $A$ au point $B$ :
    $ arrow(A B) = vec(x_B - x_A, y_B - y_A) $
  ]


  #v(1em)

  #section-box("Norme (Grandeur)")[
    La longueur du vecteur, notée $||arrow(v)||$.
    
    *En 2D :*
    $ ||arrow(v)|| = sqrt(v_x^2 + v_y^2) $
    
    *Vecteur Unitaire ($hat(u)$) :*
    Vecteur de longueur 1 direction $arrow(v)$ :
    // Parenthèses ajoutées pour assurer la fraction verticale
    $ hat(u) = (arrow(v)) / (||arrow(v)||) $
  ]

  #v(1em)

  #section-box("Opérations de Base")[
    Soit $arrow(u) = vec(u_x, u_y)$ et $arrow(v) = vec(v_x, v_y)$.
    
    *Addition :*
    $ arrow(u) + arrow(v) = vec(u_x + v_x, u_y + v_y) $
    
    *Soustraction :*
    $ arrow(u) - arrow(v) = vec(u_x - v_x, u_y - v_y) $

#figure(
image("../images/vecteurs_01.svg", width: 80%),
  caption: [
    Le vecteur $arrow(u)$ (rouge) et le vecteur $arrow(v)$ (bleu)
  ],
)
  

    *Multiplication par scalaire ($k$) :*
    $ k dot arrow(u) = vec(k u_x, k u_y) $
  ]

  #colbreak()

  #section-box("Produit Scalaire")[
    Résultat : un *nombre* (scalaire).
    
    *Formule algébrique :*
    $ arrow(u) dot arrow(v) = u_x v_x + u_y v_y + u_z v_z $
    
    *Formule géométrique :*
    $ arrow(u) dot arrow(v) = ||arrow(u)|| dot ||arrow(v)|| dot cos(theta) $
    
    Si $arrow(u) dot arrow(v) = 0$, alors $arrow(u) perp arrow(v)$.
  ]

  #v(1em)

  #section-box("Angle entre 2 vecteurs")[
    On isole $cos(theta)$. 
    Les parenthèses assurent que la fraction reste bien empilée :
    
    $ cos(theta) = (arrow(u) dot arrow(v)) / (||arrow(u)|| dot ||arrow(v)||) $
    
    $ theta = arccos( (arrow(u) dot arrow(v)) / (||arrow(u)|| dot ||arrow(v)||) ) $
  ]

  #v(1em)

  #section-box("Produit Vectoriel (3D)")[
    Résultat : un *vecteur* perpendiculaire.
    
    $ arrow(w) = arrow(u) times arrow(v) $
    
    *Magnitude :*
    $ ||arrow(u) times arrow(v)|| = ||arrow(u)|| dot ||arrow(v)|| dot sin(theta) $
    
    *Calcul (Déterminant) :*
    Notez les flèches sur $i, j, k$ :
    
    $ arrow(u) times arrow(v) = det(mat(arrow(i), arrow(j), arrow(k); u_x, u_y, u_z; v_x, v_y, v_z)) $
  ]

  #v(1em)
  
  #section-box("Projections")[
    Projection de $arrow(u)$ sur $arrow(v)$.
    
    
    $ "proj"_v (arrow(u)) = ( (arrow(u) dot arrow(v)) / (||arrow(v)||^2) ) dot arrow(v) $
  ]

#figure(
image("../images/vecteurs_02.svg", width: 80%),
  caption: [
    Produit scalaire, projection
  ],
)
  
  
//]