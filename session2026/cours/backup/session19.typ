#import "@preview/theorion:0.4.1": *
#import cosmos.rainbow: *
#show: show-theorion

// ===================== SESSION 19 =====================

#heading(level: 1)[Session 19 : Physique & IA]

#definition-box(title: "1. Le Besoin : Mouvement Organique")[
  Les animations pré-enregistrées (keyframes) sont rigides. Si un personnage doit s'adapter à un terrain inconnu, on ne peut pas tout pré-enregistrer.
  
  *Solution :* Utiliser la physique $+$ l'IA pour générer du mouvement en temps réel.
  
  Deux approches dominent :
  - *Reinforcement Learning (RL)*
  - *Neuroevolution (Genetic Algorithms)*
]

#definition-box(title: "2. Reinforcement Learning (RL)")[
  *La Boucle RL :*
  1. *Agent :* Le personnage (ex: un robot).
  2. *Environment :* Le monde physique (Rapier).
  3. *State :* Ce que le robot "voit" (capteurs, positions, vitesses).
  4. *Action :* Ce que le robot fait (appliquer des forces/torques).
  5. *Reward :* Une note qui dit si l'action était bonne ou mauvaise.
  
  *Le Cerveau :* Un Réseau de Neurones (Neural Network).
  - Input : L'état (State).
  - Output : Les actions (forces à appliquer).
  - Entraînement : Le réseau ajuste ses poids pour maximiser la reward.
  
  *Exemple : Apprendre à marcher*
  - Reward : Avancer le plus loin possible.
  - Pénalité : Tomber.
  - Après des millions d'itérations, le robot apprend à marcher tout seul.
]

#definition-box(title: "3. Neuroevolution (Genetic Algorithms)")[
  C'est une alternative à RL, inspirée de l'évolution biologique.
  
  *Principe :*
  1. Créer une population de N agents (ex: 50 voitures), chacune avec un réseau de neurones aléatoire.
  2. Les faire rouler dans le circuit.
  3. Évaluer : Celles qui vont le plus loin ont le meilleur "fitness".
  4. *Sélection :* Garder les meilleures, tuer les autres.
  5. *Crossover :* Mélanger les réseaux des meilleures.
  6. *Mutation :* Ajouter de petites modifications aléatoires.
  7. Nouvelle génération $->$ Retour à l'étape 2.
  
  *Avantage :* Plus simple à implémenter que RL. Pas besoin de gradients.
  *Inconvénient :* Plus lent à converger. Moins efficace pour des problèmes complexes.
]

#definition-box(title: "4. Les Capteurs Physiques comme Inputs")[
  Le réseau de neurones a besoin d'informations sur le monde. On utilise des capteurs physiques :
  
  *Raycasts (Vision) :*
  - Comme les capteurs d'une voiture autonome.
  - N rayons vers l'avant à différents angles.
  - Chaque rayon retourne la distance au premier obstacle.
  - C'est l'"œil" de l'IA.
  
  *Vitesse :*
  - La vélocité actuelle du véhicule (vector).
  
  *Orientation :*
  - L'angle entre le véhicule et la direction de la piste.
  
  *Exemple de réseau simple :*
  - Input : 5 raycasts $+$ vitesse $+$ orientation = 7 inputs.
  - Hidden : 8 neurones.
  - Output : 2 (accélération $+$ direction).
  - Total : $7 times 8 + 8 times 2 = 72$ poids à optimiser.
]

#definition-box(title: "TP : Voiture Autonome")[
  *Objectif :* Créer une voiture qui apprend à naviguer un circuit toute seule.
  1. Créer un circuit (murs, checkpoints).
  2. Créer N voitures avec un Raycast Vehicle.
  3. Chaque voiture a un réseau de neurones simple.
  4. Inputs : 5 raycasts $+$ vitesse.
  5. Outputs : accélération $+$ direction.
  6. Fitness : Distance parcourue avant de crasher.
  7. Implémenter la sélection, le crossover et la mutation.
  8. Lancer la simulation et observer l'évolution !
]
