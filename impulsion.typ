#import "@preview/theorion:0.4.1": *
#import cosmos.rainbow: *
#show: show-theorion

#set document(
  author: ("Richard Rispoli"),
  title: [Démonstration : L'Impulsion de Collision]
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
    "Physics 203-j28-Collision - " + context document.author.at(0),
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

#definition-box(title: "Partie 1 : D'où vient l'Impulsion ? (Le Lien Newtonien)")[
  La relation $J = Delta p$ n'est pas une invention magique. C'est la 2ème Loi de Newton réécrite sous forme intégrale.
  
  *1. Retour à la définition de la Force*
  L'accélération $arrow(a)$ est la dérivée de la vitesse.
  $ arrow(F) = m arrow(a) = m (d arrow(v)) / (d t) $
  
  Comme la masse est constante, on peut la rentrer dans la dérivée. On reconnait alors la Quantité de Mouvement ($arrow(p) = m arrow(v)$).
  $ arrow(F) = (d (m arrow(v))) / (d t) = (d arrow(p)) / (d t) $
  
  *2. L'Intégration (Somme des forces)*
  Pour connaitre l'effet total d'un choc entre un instant $t_1$ et $t_2$, on multiplie par $d t$ et on intègre (on somme) les deux côtés de l'équation :
  
  $ integral_(t_1)^(t_2) arrow(F) d t = integral_(p_1)^(p_2) d arrow(p) $
  
  *3. Le Résultat : Le Théorème de l'Impulsion*
  - Le terme de droite devient simplement le changement de quantité de mouvement : $Delta arrow(p)$.
  - Le terme de gauche est la définition exacte de l'Impulsion $arrow(J)$.
  
  $ arrow(J) = Delta arrow(p) $
  
  *Interprétation Géométrique :*
  L'impulsion est l'*Aire sous la courbe* de la Force en fonction du temps. Peu importe que la force soit petite et longue, ou géante et courte : si l'aire est la même, le changement de vitesse est le même.
]

#definition-box(title: "Application au Moteur Physique (Temps Zéro)")[
  Dans une simulation "Narrow Phase", on considère que la collision est instantanée ($Delta t approx 0$).
  
  Si le temps est nul, pour avoir une aire non-nulle, la Force devrait être infinie. L'ordinateur ne peut pas calculer l'infini.
  
  *L'Astuce :*
  On saute l'étape de l'intégration temporelle. On utilise directement le résultat $J$.
  Cela nous permet de "téléporter" la vitesse sans passer par l'accélération.
  
  $ Delta v = J / m $
]

#definition-box(title: "Partie 2 : La Règle du Rebond (La Loi)")[
  Nous avons l'outil ($J$), mais quelle valeur doit-il avoir ?
  C'est ici qu'intervient la *Loi expérimentale*.
  
  *Loi de Restitution :*
  "La vitesse à laquelle deux objets s'éloignent après un choc est proportionnelle à la vitesse à laquelle ils se rapprochaient avant le choc."
  
  $ v_"rel" ("après") = -e dot v_"rel" ("avant") $
  
  - $v_"rel" = v_A - v_B$ (Vitesse relative le long de la normale).
  - $e$ : Coefficient de restitution (entre 0 et 1).
  - Le signe moins ($-$) indique que les objets repartent dans l'autre sens.
]

#definition-box(title: "Zoom sur la Vitesse Relative")[
  Avant de calculer, définissons les termes.
  Soient $arrow(v)_A$ et $arrow(v)_B$ les vecteurs vitesse des deux objets dans le monde.
  
  *1. Le Vecteur Vitesse Relative ($Delta arrow(v)$)*
  C'est la vitesse de A vue depuis B.
  $ arrow(v)_"diff" = arrow(v)_A - arrow(v)_B $
  
  *2. La Normale de Collision ($arrow(n)$)*
  C'est le vecteur unitaire qui relie les centres (la direction du choc).
  
  *3. La Vitesse Relative Scalaire ($v_"rel"$)*
  C'est celle qu'on utilise dans la formule de l'impulsion !
  On ne s'intéresse qu'à la vitesse *sur l'axe du choc*. On fait donc une projection (Produit Scalaire) :
  
  $ v_"rel" = (arrow(v)_A - arrow(v)_B) dot arrow(n) $
  
  *Interprétation du signe :*
  - Si $v_"rel" < 0$ : Les objets se rapprochent (Collision imminente).
  - Si $v_"rel" > 0$ : Les objets s'éloignent (Ils se sont déjà tapés ou se fuient).
  - Si $v_"rel" = 0$ : Ils glissent l'un à côté de l'autre sans s'écraser.
]

#definition-box(title: "Application de l'Impulsion")[
  Cherchons l'intensité de l'impulsion $j$ (scalaire) à appliquer le long de la normale pour satisfaire la loi du rebond.
  
  On applique $j$ sur la boule A et $-j$ sur la boule B (3ème loi de Newton).
  Les nouvelles vitesses ($v'$) sont :
  $ v'_A = v_A + j/m_A quad "et" quad v'_B = v_B - j/m_B $

En passant par les impulsions, on peut effectuer un changement de vitesse instantané, sans passer par l'accélération.

]
    *Calcul de la valeur de l'impulsion*
  
  Voici la formule de base pour calculer l'impulsion :
  $ bold(j = (-(1+e)v_"rel") / (1/m_A + 1/m_B)) $
  
  Le terme au dénominateur $(1/m_A + 1/m_B)$ est peu intuitif. Transformons-le.
  Mise au même dénominateur :
  
  $ 1/m_A + 1/m_B = m_B/(m_A m_B) + m_A/(m_A m_B) = (m_A + m_B) / (m_A m_B) $
  
  Maintenant, remplaçons cette fraction dans la formule de $j$.
  Diviser par une fraction, c'est multiplier par son inverse :
  
  $ j = -(1+e) v_"rel" dot 1 / ((m_A + m_B) / (m_A m_B)) $
  
  Ce qui nous donne la *Formule Finale* très élégante :
  

  $ bold(j = underbrace(-(1+e) v_"rel", "Vitesse à changer") dot underbrace(((m_A m_B) / (m_A + m_B)), "Masse Équivalente")) $


#tip-box(title: "Interprétation Physique")[
  Cette forme $ (m_A m_B)/(m_A + m_B) $ est appelée la *Masse Réduite* du système.
  
  Elle montre que lors d'une collision, le système se comporte comme une masse unique équivalente.
  
  - Si une masse est minuscule ($m_A << m_B$), la masse équivalente devient $approx m_A$.
    *Conclusion :* C'est le plus léger qui dicte la dynamique du rebond.
]