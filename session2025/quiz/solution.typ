#set document(
  author: ("Richard Rispoli"),
  title: [Quiz : Simulation Physique Sessions 1-5]
)

#set page(
  paper: "us-letter",
  margin: 2cm,
  header: align(
    right + horizon,
    text(fill: gray)[Physics 203 - Quiz de Mi-Parcours],
  ),
  numbering: "1/1",
)

#set text(
  font: "Georgia",
  lang: "fr",
  size: 11pt
)

// --- Design du QCM ---
#let question-box(num, title, options, hint) = {
  block(
    width: 100%,
    stroke: (left: 4pt + rgb("#406372")),
    inset: (left: 1em, top: 0.5em, bottom: 1em),
    below: 2em,
    breakable: false,
    [
      #text(weight: "bold", size: 1.1em, fill: rgb("#005F87"))[Question #num : #title]
      \ \
      #for opt in options [
        #box(width: 1em, height: 1em, stroke: 1pt + gray, radius: 2pt) #h(0.5em) #opt \
        #v(0.3em)
      ]
      #v(0.5em)
      #text(style: "italic", size: 0.9em, fill: rgb("#666"))[💡 Indice : #hint]
    ]
  )
}

#let theme-header(title) = {
  block(
    fill: rgb("#E6F3F7"),
    width: 100%,
    inset: 1em,
    radius: 4pt,
    below: 1.5em,
    text(weight: "bold", size: 1.2em, fill: rgb("#005F87"))[#title]
  )
}

// --- Titre ---
#align(center)[
  #text(size: 20pt, weight: "bold", fill: rgb("#406372"))[Quiz : Fondamentaux de la Physique]
  \
  #text(size: 12pt, style: "italic")[Vecteurs, Forces et Intégration Numérique]
]
#line(length: 100%, stroke: 1pt + rgb("#406372"))
#v(1cm)

// ==========================================
// THEME 1 : MATHÉMATIQUES VECTORIELLES
// ==========================================

#theme-header("Thème 1 : Les Outils Mathématiques")

#question-box(1, "Que signifie 'Normaliser' un vecteur ?", (
  "A) Le rendre perpendiculaire.",
  "B) Changer sa longueur à 1 en gardant sa direction.",
  "C) Mettre toutes ses composantes positives."
), "Pensez au 'Vecteur Unitaire'.")

#question-box(2, "Si le Produit Scalaire (Dot) de deux vecteurs normalisés vaut -1 :", (
  "A) Ils pointent dans la même direction.",
  "B) Ils sont perpendiculaires.",
  "C) Ils sont exactement opposés."
), "Cos(180°) = ?")

#question-box(3, "Quel est le résultat d'un Produit Vectoriel (Cross) ?", (
  "A) Un nombre (scalaire).",
  "B) Un vecteur perpendiculaire aux deux autres.",
  "C) Un vecteur qui est la moyenne des deux."
), "Utile pour trouver la normale d'une face.")

#question-box(4, "Si le Produit Scalaire entre le regard et la cible est 0 :", (
  "A) La cible est devant.",
  "B) La cible est derrière.",
  "C) La cible est exactement sur le côté."
), "L'angle est de 90 degrés.")

#question-box(5, "L'ordre (AxB vs BxA) est-il important pour le produit vectoriel ?", (
  "A) Non, c'est comme une multiplication (3x2 = 2x3).",
  "B) Oui, le résultat est inversé (opposé).",
  "C) Oui, mais seulement en 2D."
), "Règle de la main droite : pouce vers le haut ou le bas ?")

#pagebreak()

// ==========================================
// THEME 2 : CINÉMATIQUE & FORCES
// ==========================================

#theme-header("Thème 2 : Le Mouvement (Newton)")

#question-box(6, "Quelle est la formule fondamentale pour obtenir l'accélération ?", (
  "A) a = m / F",
  "B) a = F * m",
  "C) a = F / m"
), "Newton a dit F=ma, donc...")

#question-box(7, "Pour un projectile dans le vide (sans air), qu'est-ce qui change ?", (
  "A) Seulement la vitesse horizontale (X).",
  "B) Seulement la vitesse verticale (Y).",
  "C) Les deux vitesses changent."
), "La gravité ne tire que vers le bas.")

#question-box(8, "Si on lâche une plume et un marteau dans le vide absolu :", (
  "A) Le marteau tombe plus vite.",
  "B) Ils tombent à la même vitesse.",
  "C) La plume tombe plus vite."
), "L'accélération 'g' ne dépend pas de la masse 'm'.")

#question-box(9, "La force de trainée (Air Drag) augmente généralement avec :", (
  "A) Le carré de la vitesse (v²).",
  "B) La masse de l'objet.",
  "C) L'inverse de la vitesse."
), "Plus je vais vite, plus le mur d'air est dur (fonction quadratique).")

#question-box(10, "Qu'est-ce que la 'Vitesse Terminale' ?", (
  "A) La vitesse max du CPU.",
  "B) L'équilibre entre Gravité et Frottement de l'air.",
  "C) La vitesse au moment de l'impact au sol."
), "Quand l'accélération nette devient nulle.")

#question-box(11, "Quelle est la différence entre Frottement Statique et Cinétique ?", (
  "A) Le statique est plus faible.",
  "B) Le statique empêche le démarrage, le cinétique freine le glissement.",
  "C) C'est la même chose en code."
), "C'est plus dur de pousser une armoire à l'arrêt que de la faire glisser.")

#pagebreak()

// ==========================================
// THEME 3 : INTÉGRATION NUMÉRIQUE
// ==========================================

#theme-header("Thème 3 : Le Moteur d'Intégration")

#question-box(12, "Formule d'Euler Explicite pour la position :", (
  "A) Pos = Pos + Vitesse * dt",
  "B) Pos = Pos + Accélération * dt",
  "C) Pos = Vitesse * dt"
), "La vitesse est le taux de changement de la position.")

#question-box(13, "Que représente le 'dt' (Delta Time) ?", (
  "A) Le temps total depuis le lancement.",
  "B) Le temps écoulé depuis la dernière frame.",
  "C) Une constante universelle."
), "Le pas de temps entre deux calculs.")

#question-box(14, "Quel est le défaut majeur d'Euler Explicite ?", (
  "A) Trop complexe.",
  "B) Accumule de l'énergie (instable).",
  "C) Perd de l'énergie (amortissement)."
), "La spirale part vers l'extérieur.")

#question-box(15, "Quel est l'ordre correct de mise à jour ?", (
  "A) Position -> Vitesse -> Forces",
  "B) Forces -> Accélération -> Vitesse -> Position",
  "C) Vitesse -> Position -> Forces"
), "Cause (Force) -> Conséquence (Mouvement).")

#question-box(16, "Associez la méthode à sa description : 'Complexe, Lourd (4 appels/frame), mais extrêmement précis' :", (
  "A) Euler Semi-Implicite",
  "B) Verlet",
  "C) Runge-Kutta 4 (RK4)"
), "Utilisé pour les simulations scientifiques, pas souvent dans les jeux.")

// ==========================================
// THEME 4 : BONUS (LOGIQUE & CODE)
// ==========================================

#theme-header("Bonus : Logique Code & Optimisation")

#question-box(17, "Pourquoi éviter 'if(x == 0.0)' avec des floats ?", (
  "A) Le compilateur l'interdit.",
  "B) Erreurs d'arrondi binaire (précision).",
  "C) C'est plus lent."
), "Rien n'est jamais vraiment égal à zéro en informatique.")

#question-box(18, "Qu'est-ce que le 'Tunneling' ?", (
  "A) Un objet traverse un mur car il va trop vite.",
  "B) Un bug graphique d'affichage.",
  "C) Une technique d'optimisation."
), "Il s'est téléporté de l'autre côté en une frame.")

#question-box(19, "Quel coefficient de restitution donne un rebond parfait ?", (
  "A) 0.0",
  "B) 0.5",
  "C) 1.0"
), "Aucune perte d'énergie cinétique.")

#question-box(20, "Si Accélération = (-2, 0, 0) et Vitesse = (10, 0, 0) :", (
  "A) L'objet recule immédiatement.",
  "B) L'objet freine mais avance encore.",
  "C) L'objet s'arrête instantanément."
), "La vitesse reste positive pour l'instant, mais diminue.")

// --- CORRIGÉ (Sur une nouvelle page) ---
#pagebreak()
#align(center)[
  #text(size: 16pt, weight: "bold", fill: gray)[Corrigé Rapide]
  \ \ 
  #grid(
    columns: (1fr, 1fr),
    gutter: 2em,
    align(left)[
      *Thème 1* \
      1. B \
      2. C \
      3. B \
      4. C \
      5. B \
      \
      *Thème 2* \
      6. C \
      7. B \
      8. B \
      9. A \
      10. B \
      11. B
    ],
    align(left)[
      *Thème 3* \
      12. A \
      13. B \
      14. B \
      15. B \
      16. C \
      \
      *Bonus* \
      17. B \
      18. A \
      19. C \
      20. B
    ]
  )
]