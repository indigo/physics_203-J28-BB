#import "@preview/theorion:0.4.1": *
#import cosmos.rainbow: *
#show: show-theorion

// ===================== SESSION 06 =====================

#heading(level: 1)[Session 6 : L’impulsion, les collisions]

#heading(level: 2)[Objectifs de la session]
- Comprendre l'impulsion comme changement de quantité de mouvement.
- Apprendre la loi de restitution et la vitesse relative.
- Calculer l'impulsion d'une collision entre deux objets.
- Implémenter un laboratoire de chocs 1D.

#heading(level: 3)[1. D'où vient l'Impulsion ?]

#definition-box(title: "Théorème de l'Impulsion")[
  La force est la dérivée de la quantité de mouvement :
  $ arrow(F) = (d arrow(p)) / (d t) $

  En intégrant sur un choc instantané ($Delta t approx 0$) :
  $ arrow(J) = Delta arrow(p) = m dot Delta arrow(v) $
]

*Interprétation :* L'impulsion est l'aire sous la courbe force-temps. Un choc bref et intense peut changer la vitesse instantanément.

#heading(level: 3)[2. La Loi de Restitution]

#definition-box(title: "Coefficient de restitution ($e$)")[
  La vitesse à laquelle deux objets s'éloignent après un choc est proportionnelle à la vitesse à laquelle ils se rapprochaient avant le choc.
  $ v_"rel" ("après") = -e dot v_"rel" ("avant") $
]

- $e = 1$ : choc élastique (billes de billard).
- $e = 0$ : choc mou (pâte à modeler).

#heading(level: 3)[3. Vitesse Relative et Normale]

#definition-box(title: "Vitesse relative scalaire")[
  La vitesse de rapprochement projetée sur la normale de collision :
  $ v_"rel" = (arrow(v)_A - arrow(v)_B) dot arrow(n) $
  
  - $v_"rel" < 0$ : les objets se rapprochent.
  - $v_"rel" > 0$ : les objets s'éloignent.
  - $v_"rel" = 0$ : ils glissent l'un contre l'autre.
]

#heading(level: 3)[4. Calcul de l'Impulsion]

#important-box(title: "Formule de l'impulsion")[
  $ j = underbrace(-(1+e) v_"rel", "Vitesse à changer") dot underbrace(((m_A m_B) / (m_A + m_B)), "Masse réduite") $
]

*Application aux vitesses :*
$ v'_A = v_A + (j / m_A) dot arrow(n) $
$ v'_B = v_B - (j / m_B) dot arrow(n) $

#heading(level: 3)[5. TP : Laboratoire de Chocs 1D]

#tip-box(title: "Objectifs du TP")[
  Implémenter la réponse physique d'une collision entre deux boules de masses différentes dans un espace 1D sans gravité ni friction.
]

#definition-box(title: "Missions")[
  1. Créer deux boules : A ($m=5$) lancée vers B ($m=1$).
  2. Calculer la normale $arrow(n)$.
  3. Calculer la vitesse relative $v_"rel"$.
  4. Si $v_"rel" > 0$, sortir (les objets s'éloignent).
  5. Calculer l'impulsion $j$ avec la masse réduite.
  6. Appliquer le changement de vitesse aux deux boules.
]

#definition-box(title: "Scénarios à observer")[
  - *Pendule de Newton* : masses égales, $e=1$ — A s'arrête, B repart.
  - *Le Mur* : $m_A = 1$, $m_B = 100$ — A rebondit, B bouge à peine.
  - *Bulldozer* : $m_A = 100$, $m_B = 1$ — A continue, B repart à environ $2 v_A$.
  - *Pâte à modeler* : $e=0$ — les boules se collent.
]
