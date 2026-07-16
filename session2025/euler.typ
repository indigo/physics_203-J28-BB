#set text(font: "Linux Libertine", lang: "fr", size: 12pt)
#set page(paper: "a4", margin: 2.5cm)
#set par(justify: true)

= Annexe : Intégration Numérique & Série de Taylor
_Comment l'ordinateur prédit le futur_

Dans nos simulations (Three.js), le temps n'est pas continu. L'ordinateur calcule le monde image par image (environ 60 fois par seconde). Nous devons donc transformer les équations physiques continues (dérivées) en instructions discrètes (additions).

== 1. La Méthode d'Euler
La méthode d'Euler est l'approche la plus intuitive : elle suppose que la vitesse est constante entre deux images.

#box(fill: luma(245), inset: 1em, radius: 5pt, width: 100%)[
  *L'Algorithme (La boucle de jeu)*

  Pour chaque pas de temps $Delta t$ (ex: 0.016s) :

  1.  *Calculer l'accélération* (Forces / Masse) :
      $ arrow(a)_n = arrow(F) / m $
  2.  *Mettre à jour la vitesse* (Vitesse actuelle + Changement) :
      $ arrow(v)_(n+1) = arrow(v)_n + arrow(a)_n dot Delta t $
  3.  *Mettre à jour la position* (Position actuelle + Déplacement) :
      $ arrow(r)_(n+1) = arrow(r)_n + arrow(v)_n dot Delta t $
]

// SCHÉMA SUGGÉRÉ :
// Un graphique Position (y) vs Temps (x).
// Une courbe réelle courbe.
// Une série de segments de droite (la méthode d'Euler) qui partent de la courbe mais s'en éloignent légèrement à chaque pas, en suivant la tangente du point précédent.
// Annoter "Erreur" entre la fin du segment et la vraie courbe.

== 2. D'où ça vient ? (La Dérivée Discrète)

Mathématiquement, la vitesse est la dérivée de la position. Si on enlève la limite $lim_(Delta t -> 0)$, on obtient une approximation :

$
arrow(v)(t) = (d arrow(r)) / (d t) approx (arrow(r)(t + Delta t) - arrow(r)(t)) / (Delta t)
$

En isolant le terme futur $arrow(r)(t + Delta t)$, on retombe sur la formule d'Euler :

$
underbrace(arrow(r)(t + Delta t), "Futur") approx underbrace(arrow(r)(t), "Présent") + underbrace(arrow(v)(t) dot Delta t, "Pas")
$

== 3. La Série de Taylor (Le Moteur Mathématique)

La méthode d'Euler n'est en fait que la "pointe de l'iceberg" d'un concept plus puissant : la *Série de Taylor*.
Elle stipule que n'importe quelle fonction (trajectoire) peut être reconstruite en additionnant ses dérivées successives.

*L'intuition du conducteur aveugle :*
Si vous fermez les yeux au volant, comment deviner où vous serez dans 1 seconde ($Delta t$) ?

- *Ordre 0 (Position)* : "Je ne bouge pas." $-> arrow(r)(t)$
- *Ordre 1 (Vitesse)* : "J'avance tout droit." $-> arrow(v)(t) Delta t$
- *Ordre 2 (Accélération)* : "J'accélère, donc je courbe." $-> 1/2 arrow(a)(t) Delta t^2$
- *Ordre 3 (A-coup)* : "J'appuie de plus en plus fort..." $-> ...$

*La Formule Complète :*
$
arrow(r)(t + Delta t) = arrow(r)(t) + arrow(v)(t) Delta t + 1/2 arrow(a)(t) Delta t^2 + 1/6 arrow(j)(t) Delta t^3 + ...
$

#box(fill: luma(245), inset: 1em, radius: 5pt, width: 100%)[
  *Pourquoi Euler est une approximation ?*

  La méthode d'Euler *coupe* la série de Taylor après le terme de vitesse.
  $
  arrow(r)_(n+1) = arrow(r)_n + arrow(v)_n Delta t \ + underbrace(O(Delta t^2), "Termes ignorés (Erreur)")
  $
  C'est pour cela qu'on dit qu'Euler est une méthode du *Premier Ordre*. L'erreur commise à chaque pas est proportionnelle au carré du pas de temps ($Delta t^2$).
]

== 4. Conséquences Pratiques

Puisque Euler ignore la courbure de la trajectoire (l'accélération) à l'intérieur d'un pas de temps, il a tendance à "déraper" vers l'extérieur des virages ou à gagner de l'énergie (spirale vers l'extérieur) dans des systèmes orbitaux.

#figure(
  table(
    columns: (1fr, 1fr),
    inset: 10pt,
    stroke: 0.5pt + gray,
    table.header([*Euler (Ordre 1)*], [*Intégration exacte (Ordre 2)*]),
    [
      $arrow(r)_(n+1) = arrow(r)_n + arrow(v)_n Delta t$ \
      _Prend la pente au début et trace une ligne droite._
    ],
    [
      $arrow(r)_(n+1) = arrow(r)_n + arrow(v)_n Delta t + 1/2 arrow(a) Delta t^2$ \
      _Prend en compte la courbure (accélération)._
    ],
    [Facile à coder. Rapide.],
    [Exact pour la gravité constante (projectiles).]
  ),
  caption: [Comparaison pour un pas de temps $Delta t$]
)

*Conclusion pour le projet :*
Pour des projectiles simples soumis à une gravité constante, nous pourrions utiliser la formule exacte (Ordre 2). Cependant, Euler reste très utile car il fonctionne même quand l'accélération change tout le temps (ex: vent, ressorts, collisions), là où la formule exacte devient trop complexe.