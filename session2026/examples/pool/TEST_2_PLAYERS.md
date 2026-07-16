# ✅ Checklist de test - Système 2 Joueurs

## 🎯 Tests de base

### Démarrage
- [ ] Le jeu démarre avec "Joueur 1" affiché
- [ ] La bordure est bleue (#0055ff)
- [ ] Console affiche : "Game started!"

### Premier tir
- [ ] Joueur 1 peut viser et tirer
- [ ] Les billes bougent normalement
- [ ] La physique fonctionne correctement

## 🔄 Tests de changement de joueur

### Cas 1 : Tir réussi (bille empochée)
1. [ ] Joueur 1 empoche une bille
2. [ ] Console affiche : "Bille X empochée"
3. [ ] Console affiche : "Joli coup ! Rejouez."
4. [ ] L'affichage reste "Joueur 1"
5. [ ] La bordure reste bleue
6. [ ] Joueur 1 peut tirer à nouveau

### Cas 2 : Tir raté (aucune bille)
1. [ ] Joueur 1 tire sans empocher
2. [ ] Console affiche : "Raté ! Au tour de l'adversaire."
3. [ ] Console affiche : "Changement de joueur → Joueur 2"
4. [ ] L'affichage change pour "Joueur 2"
5. [ ] La bordure devient orange (#ff5500)
6. [ ] Joueur 2 peut tirer

### Cas 3 : Faute (blanche empochée)
1. [ ] Joueur 1 empoche la blanche
2. [ ] Console affiche : "Faute ! Blanche empochée."
3. [ ] Console affiche : "Changement de joueur → Joueur 2"
4. [ ] La blanche disparaît
5. [ ] Après 1 seconde, la blanche réapparaît au centre
6. [ ] L'affichage change pour "Joueur 2"
7. [ ] La bordure devient orange
8. [ ] Joueur 2 peut tirer

## 🎮 Tests de séquence

### Séquence A : Alternance simple
```
J1 tire → Rate → J2
J2 tire → Rate → J1
J1 tire → Rate → J2
```
- [ ] Les changements se font correctement
- [ ] L'affichage est toujours à jour
- [ ] Les couleurs alternent (bleu/orange)

### Séquence B : Série de coups
```
J1 tire → Empoche → Rejoue
J1 tire → Empoche → Rejoue
J1 tire → Rate → J2
J2 tire → Empoche → Rejoue
J2 tire → Rate → J1
```
- [ ] Joueur 1 joue 3 fois de suite
- [ ] Changement correct après le raté
- [ ] Joueur 2 joue 2 fois de suite
- [ ] Changement correct après le raté

### Séquence C : Avec fautes
```
J1 tire → Empoche → Rejoue
J1 tire → Faute (blanche) → J2
J2 tire → Empoche → Rejoue
J2 tire → Faute (blanche) → J1
```
- [ ] Les fautes provoquent un changement
- [ ] La blanche se replace correctement
- [ ] L'affichage est correct après chaque faute

## 🎨 Tests visuels

### Affichage Joueur 1
- [ ] Texte : "Joueur 1" (FR) ou "Player 1" (EN)
- [ ] Bordure gauche : 5px solid #0055ff (bleu)
- [ ] Couleur texte : blanc
- [ ] Position : en haut à gauche

### Affichage Joueur 2
- [ ] Texte : "Joueur 2" (FR) ou "Player 2" (EN)
- [ ] Bordure gauche : 5px solid #ff5500 (orange)
- [ ] Couleur texte : blanc
- [ ] Position : en haut à gauche

### Transition visuelle
- [ ] Le changement de couleur est instantané
- [ ] Le texte se met à jour immédiatement
- [ ] Pas de clignotement ou glitch

## 🌍 Tests de localisation

### En Français
- [ ] "Joueur 1" / "Joueur 2"
- [ ] "Joli coup ! Rejouez."
- [ ] "Faute ! Blanche empochée."
- [ ] "Raté ! Au tour de l'adversaire."

### En English
1. [ ] Changer la langue dans OPTIONS
2. [ ] Retourner au jeu
3. [ ] Vérifier "Player 1" / "Player 2"
4. [ ] Tirer et vérifier les messages en anglais

## 🔄 Tests de reset

### Reset pendant une partie
1. [ ] Joueur 2 est actif (orange)
2. [ ] Appuyer sur ESPACE (ou bouton reset)
3. [ ] Vérifier que l'affichage revient à "Joueur 1"
4. [ ] Vérifier que la bordure est bleue
5. [ ] Vérifier que les billes sont replacées

### Reset depuis le menu
1. [ ] Joueur 2 est actif
2. [ ] Aller au menu (PAUSE → QUITTER)
3. [ ] Cliquer sur JOUER
4. [ ] Vérifier que c'est "Joueur 1" qui commence

### Reset après Game Over
1. [ ] Finir une partie (victoire ou défaite)
2. [ ] Cliquer sur REJOUER
3. [ ] Vérifier que c'est "Joueur 1" qui commence

## 🐛 Tests de bugs potentiels

### Bug 1 : Comptage multiple
- [ ] Empocher plusieurs billes en un coup
- [ ] Vérifier que toutes sont comptées
- [ ] Console affiche : "Empochées: X"
- [ ] Le joueur rejoue (pas de changement)

### Bug 2 : Blanche + autre bille
- [ ] Empocher la blanche ET une autre bille
- [ ] Vérifier que c'est considéré comme une faute
- [ ] Changement de joueur
- [ ] Message de faute affiché

### Bug 3 : Noire empochée
- [ ] Empocher la noire (bille 8)
- [ ] Vérifier que `checkWinCondition()` est appelé
- [ ] Vérifier victoire/défaite selon les règles

### Bug 4 : Changement rapide
1. [ ] Joueur 1 tire très vite
2. [ ] Avant l'arrêt complet, observer
3. [ ] Vérifier qu'on ne peut pas tirer pendant le mouvement
4. [ ] Vérifier que le changement attend l'arrêt complet

## 📊 Tests de console

### Logs attendus (tir réussi)
```
Bille 3 empochée
Fin du tour. Empochées: 1. Faute: false. Prochain: J1
Joli coup ! Rejouez.
```

### Logs attendus (tir raté)
```
Fin du tour. Empochées: 0. Faute: false. Prochain: J2
Raté ! Au tour de l'adversaire.
Changement de joueur → Joueur 2
```

### Logs attendus (faute)
```
Faute ! Blanche empochée.
Changement de joueur → Joueur 2
Fin du tour. Empochées: 0. Faute: true. Prochain: J2
```

## 🎯 Tests de gameplay

### Partie complète
1. [ ] Jouer une partie complète à 2
2. [ ] Alterner les joueurs naturellement
3. [ ] Vérifier que le système est fluide
4. [ ] Vérifier qu'il n'y a pas de confusion sur qui joue
5. [ ] Vérifier que la victoire est attribuée correctement

### Stratégie
1. [ ] Joueur 1 essaie d'empocher plusieurs billes de suite
2. [ ] Vérifier qu'il peut jouer tant qu'il empoche
3. [ ] Joueur 2 essaie de faire une faute volontaire
4. [ ] Vérifier que le changement se fait

## 🔧 Tests techniques

### turnInfo
- [ ] `turnInfo` est réinitialisé à chaque tir
- [ ] `whiteScratched` est correctement mis à `true`
- [ ] `ballsPotted` contient les bons numéros
- [ ] Le tableau est vidé entre les tours

### gameState
- [ ] `getCurrentPlayer()` retourne 1 ou 2
- [ ] `switchPlayer()` alterne correctement
- [ ] `resetPlayer()` remet à 1
- [ ] Les logs de changement sont corrects

### updateHUD()
- [ ] Est appelé après chaque changement
- [ ] Met à jour le texte correctement
- [ ] Met à jour la couleur correctement
- [ ] Fonctionne en FR et EN

## 📱 Tests d'interface

### Responsive
- [ ] Redimensionner la fenêtre
- [ ] Vérifier que l'affichage du joueur reste visible
- [ ] Vérifier que les couleurs sont toujours visibles

### Contraste
- [ ] Bleu sur fond noir : lisible ✓
- [ ] Orange sur fond noir : lisible ✓
- [ ] Texte blanc : lisible ✓

## 🎉 Validation finale

### Checklist globale
- [ ] Le système 2 joueurs fonctionne parfaitement
- [ ] Les règles sont respectées
- [ ] L'affichage est clair
- [ ] Les messages sont corrects
- [ ] La localisation fonctionne
- [ ] Pas de bugs détectés
- [ ] Le gameplay est fluide
- [ ] C'est amusant à jouer !

## 📝 Notes de test

**Date** : _______________

**Testeur** : _______________

**Bugs trouvés** :
- 
- 
- 

**Améliorations suggérées** :
- 
- 
- 

**Commentaires** :
- 
- 
- 

**Status** : ⬜ PASS  ⬜ FAIL  ⬜ NEEDS WORK

---

**Bon test ! 🎱**
