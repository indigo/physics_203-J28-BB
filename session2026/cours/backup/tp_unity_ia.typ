#import "@preview/theorion:0.4.1": *
#import cosmos.rainbow: *
#show: show-theorion

// ===================== TP : Unity & IA =====================

#heading(level: 1)[TP Guide : Unity & IA]

#tip-box(title: "Objectif")[
  Implémenter une voiture autonome dans Unity en utilisant un réseau de neurones simple et un algorithme génétique.
]

#definition-box(title: "1. Le Réseau de Neurones (C\#)")[
  Voici une classe C\# simple pour un réseau de neurones :
  
  ```csharp
  using System;
  using UnityEngine;
  
  public class NeuralNetwork
  {
      private int[] layers;
      private float[][] neurons;
      private float[][][] weights;
  
      public NeuralNetwork(int[] layers)
      {
          this.layers = layers;
          InitNeurons();
          InitWeights();
      }
  
      private void InitNeurons()
      {
          neurons = new float[layers.Length][];
          for (int i = 0; i < layers.Length; i++)
              neurons[i] = new float[layers[i]];
      }
  
      private void InitWeights()
      {
          weights = new float[layers.Length - 1][][];
          for (int i = 0; i < layers.Length - 1; i++)
          {
              weights[i] = new float[neurons[i + 1].Length][];
              for (int j = 0; j < neurons[i + 1].Length; j++)
              {
                  weights[i][j] = new float[neurons[i].Length];
                  for (int k = 0; k < neurons[i].Length; k++)
                      weights[i][j][k] = Random.Range(-1f, 1f);
              }
          }
      }
  
      public float[] FeedForward(float[] inputs)
      {
          for (int i = 0; i < inputs.Length; i++)
              neurons[0][i] = inputs[i];
  
          for (int i = 1; i < layers.Length; i++)
          {
              for (int j = 0; j < neurons[i].Length; j++)
              {
                  float value = 0f;
                  for (int k = 0; k < neurons[i - 1].Length; k++)
                      value += weights[i - 1][j][k] * neurons[i - 1][k];
                  neurons[i][j] = Mathf.Tanh(value); // Activation
              }
          }
          return neurons[neurons.Length - 1];
      }
  
      public NeuralNetwork Copy()
      {
          NeuralNetwork nn = new NeuralNetwork(layers);
          for (int i = 0; i < weights.Length; i++)
              for (int j = 0; j < weights[i].Length; j++)
                  for (int k = 0; k < weights[i][j].Length; k++)
                      nn.weights[i][j][k] = weights[i][j][k];
          return nn;
      }
  
      public void Mutate(float rate)
      {
          for (int i = 0; i < weights.Length; i++)
              for (int j = 0; j < weights[i].Length; j++)
                  for (int k = 0; k < weights[i][j].Length; k++)
                      if (Random.Range(0f, 1f) < rate)
                          weights[i][j][k] += Random.Range(-0.5f, 0.5f);
      }
  }
  ```
]

#definition-box(title: "2. Collecter les Données des Capteurs")[
  On utilise des raycasts pour détecter les murs du circuit :
  
  ```csharp
  float[] GetSensorData()
  {
      float[] sensors = new float[5];
      float[] angles = { -60f, -30f, 0f, 30f, 60f };
  
      for (int i = 0; i < 5; i++)
      {
          Vector3 dir = Quaternion.Euler(0, angles[i], 0) * transform.forward;
          RaycastHit hit;
          if (Physics.Raycast(transform.position, dir, out hit, 10f))
              sensors[i] = hit.distance / 10f; // Normalisé 0-1
          else
              sensors[i] = 1f; // Rien détecté
      }
      return sensors;
  }
  ```
]

#definition-box(title: "3. Connecter le Cerveau à la Voiture")[
  On récupère les sensors, on les passe au réseau, et on applique les outputs :
  
  ```csharp
  void Update()
  {
      float[] inputs = GetSensorData();
      float[] outputs = brain.FeedForward(inputs);
  
      float throttle = outputs[0]; // -1 à 1
      float steering = outputs[1]; // -1 à 1
  
      // Appliquer au Rigidbody
      rb.AddForce(transform.forward * throttle * motorForce);
      rb.AddTorque(transform.up * steering * steerForce);
  }
  ```
]

#definition-box(title: "4. L'Algorithme Génétique")[
  On gère une population de voitures :
  
  ```csharp
  void NextGeneration()
  {
      // Trier par fitness (distance parcourue)
      population.Sort((a, b) => b.fitness.CompareTo(a.fitness));
  
      // Garder les meilleures (ex: top 20%)
      int survivors = population.Count / 5;
  
      // Créer la nouvelle génération
      for (int i = 0; i < population.Count; i++)
      {
          int parentIndex = i % survivors;
          NeuralNetwork child = population[parentIndex].brain.Copy();
          child.Mutate(0.1f); // 10% de mutation
          population[i].brain = child;
          population[i].fitness = 0;
      }
  }
  ```
]

#tip-box(title: "5. Accélérer l'Entraînement")[
  L'entraînement peut être très lent en temps réel. Pour l'accélérer :
  
  ```csharp
  Time.timeScale = 5f; // 5x plus vite
  ```
  
  On peut aussi désactiver le rendu visuel et ne garder que la physique pour aller encore plus vite.
  
  *Astuce :* Si la voiture ne progresse pas après plusieurs générations, augmentez le taux de mutation (ex: 0.2) pour explorer de nouvelles stratégies.
]
