#import "@preview/theorion:0.4.1": *
#import cosmos.rainbow: *
#show: show-theorion

// ===================== SESSION 03 =====================

#heading(level: 1)[Session 3 : Les lois de Newton – La méthode physique]

#heading(level: 2)[Objectifs de la session]
- Réviser la cinématique vue précédemment.
- Introduire les trois lois de Newton comme fondement du moteur physique.
- Comprendre la démarche scientifique : modéliser, prédire, confronter à l'expérience.
- Préparer le lien entre forces et mouvement pour la simulation.

#heading(level: 2)[La démarche physique : modéliser l'univers]

#tip-box(title: "Physique du Jeu : Comment programmer l'univers")[
  Isaac Newton n'a jamais codé en JavaScript, mais sans lui, aucun jeu vidéo moderne n'existerait. Les lois de Newton sont des modèles mathématiques basés sur l'observation. On les utilise tant qu'aucune expérience ne les invalide.
]

#heading(level: 3)[1. La Première Loi : L'Inertie]

#definition-box(title: "La Loi")[
  Un objet au repos reste au repos, et un objet en mouvement continue en ligne droite à vitesse constante, *sauf* si une force extérieure agit sur lui.
]

*Ce que ça veut dire :* Les objets résistent au changement. Pour modifier leur vitesse (accélérer, freiner, tourner), il faut appliquer une force.

*Exemples :*
- Bus qui freine : le corps continue d'avancer.
- *Space Invaders* : le personnage s'arrête instantanément quand on lâche la manette — physiquement faux, comme s'il y avait une friction infinie.
- *Asteroids* : le vaisseau continue en ligne droite sans friction — plus réaliste.

#heading(level: 3)[2. La Deuxième Loi : La Dynamique]

#important-box(title: "La Formule")[
  $arrow(F) = m dot arrow(a)$

  En pratique, on cherche l'accélération :
  $ arrow(a) = arrow(F) / m $
]

*Ce que ça veut dire :* L'accélération dépend de la force appliquée et de la masse de l'objet.

*Exemples :*
- Caddie de supermarché : vide, il part vite ; plein, il part lentement avec la même force.
- *Balancing FPS* : un Scout léger (50 kg) accélère à 10 m/s² avec 500 N, tandis qu'un Tank lourd (200 kg) n'accélère qu'à 2.5 m/s².

#heading(level: 3)[3. La Troisième Loi : Action-Réaction]

#definition-box(title: "La Loi")[
  Pour toute action (force), il y a une réaction égale et opposée.
  $ arrow(F)_(A -> B) = - arrow(F)_(B -> A) $
]

*Exemples :*
- Skateboard : on pousse le sol vers l'arrière, le sol nous pousse vers l'avant.
- *Recul d'arme* : la balle part vers l'avant, l'arme recule vers l'arrière.
- *Rocket jump* : la roquette pousse le sol vers le bas, le joueur est propulsé vers le haut.
- *Collisions* : la boule blanche de billard transmet son impulsion à la boule rouge.

#heading(level: 3)[Résumé pour le développeur]

#figure(
  table(
    columns: (auto, 1fr, 1fr),
    inset: 12pt,
    stroke: 0.5pt + gray,
    table.header([*Loi*], [*Concept*], [*Implémentation Code*]),
    [*1. Inertie*], [Les objets gardent leur vitesse.], [Ne remettez pas `velocity` à 0 à chaque frame !],
    [*2. F = ma*], [Force -> Accélération.], [`acc = forces / mass`],
    [*3. Action-Réaction*], [Les interactions sont doubles.], [Collision : A repousse B, B repousse A.]
  ),
  caption: [Aide-mémoire des lois de Newton]
)

#heading(level: 3)[Annexe : Pourquoi des objets de masses différentes tombent-ils avec la même vitesse ?]

La force de pesanteur est le poids : $arrow(P) = m dot arrow(g)$.

La deuxième loi donne : $arrow(a) = arrow(F) / m = (m dot arrow(g)) / m = arrow(g)$.

La masse s'annule. L'accélération gravitationnelle est donc la même pour tous les objets.
