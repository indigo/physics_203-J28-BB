#import "@preview/theorion:0.4.1": *
#import cosmos.rainbow: *
#show: show-theorion

#set document(
  author: ("Richard Rispoli"),
  title: [TP : Le Laboratoire de Chocs 1D]
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
    "Physics 203-j28-TP1 - " + context document.author.at(0),
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

#tip-box(title: "Objectifs du TP")[
  Nous allons implémenter la réponse physique d'une collision entre deux boules de masses différentes.
  
  Pour simplifier le problème et isoler les mathématiques de l'impulsion, nous travaillons dans un **"Laboratoire 1D"** :
  - Pas de gravité.
  - Mouvement uniquement sur l'axe X.
  - Pas de friction pour l'instant.
]

#definition-box(title: "1. Analyse de la Scène")[
  Le code de démarrage (`Template.js`) contient :
  - Une *Boule Rouge (A)* : Lourde ($m=5$), lancée vers la droite.
  - Une *Boule Verte (B)* : Légère ($m=1$), immobile (actuellement désactivée).
  - Une interface *GUI* : Pour modifier les masses, la vitesse et le temps en direct.
  
  *État actuel :* La boule rouge traverse le vide et rebondit bêtement sur les murs (inversion simple de vitesse).
]

#important-box(title: "2. Rappel Théorique : L'Impulsion")[
  Lors d'un choc, nous devons calculer une impulsion $j$ (scalaire) et l'appliquer aux deux objets.
  
  *Formule de l'Impulsion (avec Masse Réduite) :*
  
  $ j = -(1+e) dot v_"rel" dot ((m_A m_B) / (m_A + m_B)) $
  
  - $e$ : Coefficient de restitution (1 = Élastique, 0 = Mou).
  - $v_"rel"$ : Vitesse relative de rapprochement 
  
  $ (arrow(v)_A - arrow(v)_B) dot arrow(n) $.
  
  *Application (Action-Réaction) :*
  $ arrow(v)'_A = arrow(v)_A + (j / m_A) arrow(n) $
  $ arrow(v)'_B = arrow(v)_B - (j / m_B) arrow(n) $
]

#definition-box(title: "3. Vos Missions (Code)")[
  
  *Étape A : Activer la Boule B*
  Dans le fichier `init()`, décommentez les lignes créant la deuxième boule. Relancez : les boules devraient se traverser comme des fantômes.
  
  *Étape B : Implémenter le "Solver" (Fonction `resolveBallCollision`)*
  Repérez la zone `TODO ÉTUDIANT`. Vous devez traduire la physique en JavaScript (Three.js).
  
  1. Calculez la **Normale** $arrow(n)$ (Vecteur unitaire de B vers A).
  2. Calculez la **Vitesse Relative** $v_"rel"$ (Produit scalaire).
  3. *Sécurité :* Si $v_"rel" > 0$ (elles s'éloignent), on arrête (`return`).
  4. Calculez la **Masse Réduite** et l'**Impulsion** $j$.
  5. Appliquez le changement aux vitesses `velA` et `velB`.
  
  _Indice : Utilisez `addScaledVector(vector, scale)`._
]

#definition-box(title: "4. Expérimentations (Observations)")[
  Une fois votre code fonctionnel, utilisez la GUI pour tester ces scénarios physiques classiques.
  
  *Scénario 1 : Le Pendule de Newton*
  - Réglez $m_A = 5$ et $m_B = 5$ (Masses égales).
  - Restitution $e = 1$.
  - *Observation :* La boule rouge doit s'arrêter net. La verte doit partir avec toute la vitesse.
  
  *Scénario 2 : Le Mur*
  - Réglez $m_A = 1$ (Légère) et $m_B = 100$ (Très lourde).
  - *Observation :* La rouge rebondit en arrière. La verte bouge à peine.
  
  *Scénario 3 : Le Bulldozer (Effet Catapulte)*
  - Réglez $m_A = 100$ (Très lourde) et $m_B = 1$ (Légère).
  - *Observation :* La rouge continue presque sans ralentir. À quelle vitesse part la verte ? (Indice : $2 times v_A$).
  
  *Scénario 4 : La Pâte à modeler*
  - Mettez la restitution $e = 0$.
  - *Observation :* Les boules doivent se coller et avancer ensemble à une vitesse moyenne.
]

#tip-box(title: "Astuce Debug")[
  Si vos boules disparaissent ou accélèrent à l'infini :
  1. Vérifiez le signe dans l'application de l'impulsion ($-j$ pour B).
  2. Vérifiez la condition `if (vRel > 0) return;`.
  3. Utilisez le slider "Time Scale" pour mettre le temps au ralenti ($0.1$) et voir exactement ce qui se passe au moment de l'impact.
]