#import "@preview/theorion:0.4.1": *
#import cosmos.rainbow: *
#show: show-theorion

// ===================== SESSION 05 =====================

#heading(level: 1)[Session 5 : Intégration numérique 101 - Méthode d’Euler]

#heading(level: 2)[Objectifs de la session]
- Comprendre pourquoi l'ordinateur discrétise le temps (frames, pas $Delta t$).
- Apprendre la méthode d'Euler pour intégrer position et vitesse.
- Introduire la série de Taylor comme fondement des méthodes d'intégration.
- Identifier les limites d'Euler et quand l'utiliser malgré tout.

#tip-box(title: "Comment l'ordinateur prédit le futur")[
  Dans nos simulations, le temps n'est pas continu. L'ordinateur calcule le monde image par image (souvent 60 FPS, soit $Delta t approx 0.016$ s). Les équations physiques continues (dérivées) doivent devenir des instructions discrètes (additions).
]

#heading(level: 3)[1. La Méthode d'Euler]

#definition-box(title: "L'Algorithme")[
  Pour chaque pas de temps $Delta t$ :
  1. Calculer l'accélération : $arrow(a)_n = arrow(F) / m$
  2. Mettre à jour la vitesse : $arrow(v)_(n+1) = arrow(v)_n + arrow(a)_n dot Delta t$
  3. Mettre à jour la position : $arrow(r)_(n+1) = arrow(r)_n + arrow(v)_n dot Delta t$
]

*Intuition :* On suppose que la vitesse est constante pendant tout le pas de temps.

#heading(level: 3)[2. D'où ça vient ? La dérivée discrète]

La vitesse est la dérivée de la position :
$ arrow(v)(t) = (d arrow(r)) / (d t) approx (arrow(r)(t + Delta t) - arrow(r)(t)) / (Delta t) $

En isolant le terme futur :
$ underbrace(arrow(r)(t + Delta t), "Futur") approx underbrace(arrow(r)(t), "Présent") + underbrace(arrow(v)(t) dot Delta t, "Pas") $

#heading(level: 3)[3. La Série de Taylor]

#definition-box(title: "Approximation d'une fonction")[
  La série de Taylor dit qu'une trajectoire peut être reconstruite en additionnant ses dérivées successives :
  $ arrow(r)(t + Delta t) = arrow(r)(t) + arrow(v)(t) Delta t + 1/2 arrow(a)(t) Delta t^2 + 1/6 arrow(j)(t) Delta t^3 + ... $
]

Euler ne garde que le premier terme. C'est une méthode du *premier ordre*.

#definition-box(title: "Pourquoi Euler est une approximation ?")[
  $ arrow(r)_(n+1) = arrow(r)_n + arrow(v)_n Delta t + underbrace(O(Delta t^2), "Erreur") $
]

#heading(level: 3)[4. Conséquences pratiques]

- Euler ignore la courbure de la trajectoire (l'accélération) à l'intérieur du pas.
- Il tend à "déraper" vers l'extérieur des virages ou à gagner de l'énergie.
- Malgré cela, il reste simple et rapide, et fonctionne quand l'accélération change (vent, ressorts, collisions).

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
      _Prend en compte la courbure._
    ],
    [Facile à coder. Rapide.],
    [Exact pour la gravité constante.]
  ),
  caption: [Comparaison pour un pas de temps $Delta t$]
)
