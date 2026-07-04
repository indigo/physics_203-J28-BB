#import "@preview/theorion:0.4.1": *
#show: show-theorion

#set document(title: [Session 19 : Physique & IA], author: ("Richard Rispoli"))
#set page(header: align(right)[Physics 203 - AI & Physics])
#show heading: set text(fill: rgb("#005F87"))

#title()

#tip-box(title: "Vers le Mouvement Organique")[
  Jusqu'à présent, nous avons codé le mouvement manuellement (formules, sinusoïdes, machines à états).
  
  Mais comment font les studios (Ubisoft, EA) pour avoir des personnages qui s'adaptent au terrain ou des voitures qui apprennent à conduire ?
  
  Réponse : Ils connectent le **Moteur Physique** à un **Réseau de Neurones**.
]

#heading(level: 1)[1. Le concept : Reinforcement Learning (RL)]

L'IA ne "connait" pas les maths du jeu. Elle apprend par essai-erreur, exactement comme un enfant qui apprend à marcher.

#definition-box(title: "La Boucle RL")[
  1. **Agent :** L'objet physique (Robot, Voiture).
  2. **Environnement :** Le monde physique (Gravité, Murs, Sol).
  3. **État (Input) :** Ce que l'agent "sent" (Vitesse, Raycasts, Rotation).
  4. **Action (Output) :** Ce que l'agent "fait" (Forces sur les joints, Couple moteur).
  5. **Récompense (Reward) :** Score positif si l'agent réussit (avance), négatif s'il échoue (tombe).
]

#heading(level: 1)[2. Neuroévolution (Algorithmes Génétiques)]

Plutôt que d'utiliser des maths complexes (Backpropagation) pour entraîner un cerveau, on utilise la méthode de la sélection naturelle. C'est très efficace pour la physique.

1. **Population :** On génère 50 voitures avec des cerveaux (réseaux de neurones) aléatoires.
2. **Simulation :** On les laisse conduire 10 secondes. 90% vont foncer dans le mur.
3. **Sélection :** On garde les 2 meilleures (celles qui sont allées le plus loin).
4. **Croisement & Mutation :** On copie les meilleures, on change légèrement quelques connexions (mutation), et on repeuple la génération suivante.
5. **Répétition :** Après 20 générations, les voitures conduisent parfaitement.

#heading(level: 1)[3. Les Capteurs Physiques (Inputs)]

Pour qu'une IA puisse conduire, elle doit "voir". On utilise les outils vus en cours.

- **Raycasts (Lidar) :** 5 rayons lancés devant la voiture. La distance retournée ($0.0$ à $1.0$) est l'entrée principale du cerveau.
- **Vélocité Locale :** La vitesse actuelle de l'objet.
- **Orientation :** L'angle par rapport à la cible.

#heading(level: 1)[4. Le Cerveau (Réseau de Neurones Simple)]

Pas besoin de librairie lourde (TensorFlow). Un "cerveau" pour le jeu vidéo est une simple multiplication de matrices.

$ "Output" = "Activation" ( "Input" times "Poids" + "Biais" ) $

- *Inputs :* 5 distances de raycast.
- *Hidden Layer :* 8 neurones (traitement).
- *Outputs :* 2 valeurs (Accélération, Volant).

#heading(level: 1)[5. Travail Pratique : La voiture autonome]

*Objectif :* Reprendre le véhicule de la Session 18 et lui apprendre à faire le tour d'un circuit sans intervention humaine.

#heading(level: 3)[Étape A : Les "Yeux" (Sensors)]
Ajouter 5 Raycasts à l'avant du véhicule (angles : -45°, -20°, 0°, 20°, 45°). Normaliser les distances entre 0 et 1.

#heading(level: 3)[Étape B : Le Cerveau (Perceptron)]
Coder une classe `NeuralNetwork` simple (ou fournir un script "Black Box").
- Entrée : Tableau de 5 floats (Raycasts).
- Sortie : Tableau de 2 floats (Moteur, Direction).

#heading(level: 3)[Étape C : Le Manager Génétique]
Au lieu d'une seule voiture, en instancier 20 au point de départ (avec des couleurs différentes).
Leur donner à chacune un cerveau aléatoire.

#heading(level: 3)[Étape D : La boucle d'apprentissage]
1. Lancer la simulation (TimeScale x 5 pour aller plus vite).
2. Si une voiture touche un mur (Collision Event) -> `Détruire`.
3. Si une voiture recule ou n'avance pas -> `Détruire`.
4. Quand toutes sont mortes :
   - Prendre la voiture qui a parcouru la plus grande distance.
   - Copier son cerveau sur 20 nouvelles voitures en ajoutant une petite variation aléatoire (Mutation).
   - Recommencer.

#important-box(title: "Observation attendue")[
  - *Gen 1 :* Chaos total, elles tournent en rond.
  - *Gen 5 :* Certaines arrivent à passer le premier virage.
  - *Gen 15 :* Elles maîtrisent le circuit et optimisent la trajectoire (corde).
]