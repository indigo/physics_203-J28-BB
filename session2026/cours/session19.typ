#import "@preview/theorion:0.4.1": *
#import cosmos.rainbow: *
#show: show-theorion

// ===================== SESSION 19 =====================

#heading(level: 1)[Session 19 : Physique, GPU et IA]

#heading(level: 2)[Objectifs de la session]
- Découvrir comment l'IA combine physique pour générer du mouvement.
- Comprendre Reinforcement Learning et Neuroevolution.
- Voir les capteurs physiques comme inputs d'un réseau de neurones.
- Introduire l'optimisation des particules avec le GPU.

#heading(level: 3)[1. Physique et IA : Mouvement Organique]

#definition-box(title: "Pourquoi mélanger IA et physique ?")[
  Les animations pré-enregistrées sont rigides. La physique + l'IA permet de générer du mouvement en temps réel, adapté au terrain.
]

#heading(level: 3)[2. Reinforcement Learning (RL)]

#definition-box(title: "La boucle RL")[
  - *Agent :* le personnage.
  - *Environment :* le monde physique (Rapier).
  - *State :* ce que l'agent voit (capteurs, positions, vitesses).
  - *Action :* forces ou torques appliqués.
  - *Reward :* note de l'action.
]

*Exemple :* apprendre à marcher. Reward = distance parcourue. Pénalité = tomber.

#heading(level: 3)[3. Neuroevolution (Genetic Algorithms)]

#definition-box(title: "Principe")[
  1. Créer une population d'agents avec des réseaux de neurones aléatoires.
  2. Les faire évoluer dans le monde.
  3. Évaluer le fitness (distance, score).
  4. Sélectionner les meilleurs.
  5. Crossover et mutation.
  6. Nouvelle génération.
]

#heading(level: 3)[4. Capteurs Physiques comme Inputs]

#definition-box(title: "Inputs du réseau")[
  - *Raycasts :* N rayons vers l'avant, distance au premier obstacle.
  - *Vitesse :* vélocité actuelle.
  - *Orientation :* angle par rapport à la cible.
]

*Exemple :* 5 raycasts + vitesse + orientation = 7 inputs. 8 neurones cachés. 2 outputs (accélération + direction).

#heading(level: 3)[5. Optimisation GPU pour les Particules]

#definition-box(title: "Pourquoi le GPU ?")[
  - Les particules sont indépendantes, idéales pour le parallélisme.
  - Le GPU possède des milliers de cœurs.
  - Les données restent sur le GPU (pas de transfert CPU/GPU).
]

#definition-box(title: "Compute Shaders")[
  - Programme qui s'exécute sur le GPU mais n'est pas un shader de rendu.
  - Les particules sont stockées dans un SSBO (Shader Storage Buffer Object).
  - Le compute shader met à jour positions, vitesses, lifetime.
  
  *Pipeline :* CPU envoie les paramètres -> Compute Shader update -> Vertex/Fragment Shaders rendent.
]

#heading(level: 3)[6. TP : Voiture Autonome]

#definition-box(title: "Objectif")[
  Créer une voiture qui apprend à naviguer un circuit :
  1. Créer un circuit (murs, checkpoints).
  2. Créer N voitures avec un Raycast Vehicle.
  3. Chaque voiture a un réseau de neurones simple.
  4. Inputs : 5 raycasts + vitesse.
  5. Outputs : accélération + direction.
  6. Fitness : distance parcourue avant de crasher.
  7. Implémenter sélection, crossover, mutation.
]
