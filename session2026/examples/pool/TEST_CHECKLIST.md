# ✅ Checklist de test - Billard Master 3D

## 🎮 Tests du Menu

### Menu Principal
- [ ] Le titre "BILLARD MASTER 3D" s'affiche avec effet néon vert
- [ ] La caméra tourne automatiquement autour de la table
- [ ] Les billes sont visibles sur la table
- [ ] Bouton "JOUER" fonctionne → Lance le jeu
- [ ] Bouton "OPTIONS" fonctionne → Ouvre les settings
- [ ] Bouton "Crédits" fonctionne → Affiche une alerte

### Écran Options
- [ ] Slider "Volume Musique" se déplace (0.0 - 1.0)
- [ ] Slider "Volume SFX" se déplace (0.0 - 1.0)
- [ ] Sélecteur de langue affiche FR/EN
- [ ] Bouton "RETOUR" ramène au menu principal
- [ ] Depuis la pause, "RETOUR" ramène au menu pause

## 🎯 Tests du Jeu

### Démarrage du jeu
- [ ] Clic sur "JOUER" → HUD s'affiche
- [ ] "Joueur 1" visible en haut à gauche
- [ ] Bouton pause (⏸) visible en haut à droite
- [ ] Tips visibles en bas : "Clic Bille: Viser | Glisser Blanche: Tirer"
- [ ] OrbitControls fonctionnent (rotation caméra)

### Gameplay
- [ ] Clic sur bille blanche → Mode visée activé
- [ ] Queue de billard apparaît
- [ ] Ligne de visée blanche apparaît
- [ ] Glisser souris → Queue recule selon la distance
- [ ] Relâcher souris → Tir exécuté
- [ ] Billes bougent avec physique réaliste
- [ ] Après arrêt des billes → Retour en mode IDLE

### Interactions caméra
- [ ] Clic sur bille colorée → Caméra se positionne pour viser
- [ ] Queue et ligne de visée s'orientent vers la cible
- [ ] OrbitControls désactivés pendant la visée
- [ ] OrbitControls réactivés après le tir

## ⏸️ Tests de Pause

### Menu Pause
- [ ] Clic sur bouton pause → Menu pause s'affiche
- [ ] Physique s'arrête (billes figées)
- [ ] OrbitControls désactivés
- [ ] Bouton "REPRENDRE" → Retour au jeu
- [ ] Bouton "OPTIONS" → Ouvre settings
- [ ] Bouton "QUITTER" → Retour au menu principal

## 🏆 Tests de Fin de Partie

### Victoire
- [ ] Empocher toutes les billes sauf la noire
- [ ] Console affiche : "Toutes les billes empochées sauf la noire !"
- [ ] Empocher la noire → Écran "VICTOIRE !"
- [ ] Message : "Parfait ! Toutes les billes empochées !"
- [ ] Titre en vert (#2e8b57)
- [ ] Bouton "REJOUER" → Reset et relance le jeu
- [ ] Bouton "MENU PRINCIPAL" → Retour au menu

### Défaite - Blanche empochée
- [ ] Empocher la blanche → Écran "DÉFAITE..."
- [ ] Message : "Faute : Blanche empochée !"
- [ ] Titre en rouge (#8b0000)
- [ ] Boutons REJOUER et MENU fonctionnent

### Défaite - Noire trop tôt
- [ ] Empocher la noire avant les autres → Écran "DÉFAITE..."
- [ ] Message : "Noire empochée trop tôt !"
- [ ] Titre en rouge

## 🌍 Tests de Localisation

### Français (par défaut)
- [ ] HUD affiche "Joueur 1"
- [ ] Victoire : "VICTOIRE !" / "Table nettoyée !"
- [ ] Défaite : "DÉFAITE..." / "La blanche est tombée ou faute."

### English
- [ ] Changer langue dans OPTIONS → EN
- [ ] HUD affiche "Player 1"
- [ ] Victoire : "YOU WIN!" / "Table cleared!"
- [ ] Défaite : "GAME OVER" / "Scratch or foul."

## 🎨 Tests Visuels

### Style général
- [ ] Fond noir avec dégradé radial
- [ ] Boutons avec bordures et hover effects
- [ ] Bouton primaire vert (#2e8b57)
- [ ] Bouton danger rouge (#8b0000)
- [ ] Transitions douces (0.2s)

### Responsive
- [ ] Redimensionner fenêtre → UI s'adapte
- [ ] Boutons restent centrés
- [ ] Texte reste lisible

## 🔧 Tests Techniques

### États du jeu
- [ ] Console log : "Game state: menu -> idle" au démarrage
- [ ] Console log : "Game state: idle -> aiming" en visée
- [ ] Console log : "Game state: aiming -> shooting" au tir
- [ ] Console log : "Game state: shooting -> idle" après arrêt
- [ ] Console log : "Game state: idle -> paused" en pause

### Physique
- [ ] En MENU : Physique active (billes peuvent bouger)
- [ ] En PLAYING : Physique active
- [ ] En PAUSED : Physique arrêtée
- [ ] En SETTINGS : Physique arrêtée
- [ ] En GAME_OVER : Physique arrêtée

### Interactions bloquées
- [ ] En MENU : Impossible de cliquer sur les billes
- [ ] En PAUSED : Impossible de viser/tirer
- [ ] En SETTINGS : Impossible de viser/tirer
- [ ] En GAME_OVER : Impossible de viser/tirer

## 🐛 Tests de Bugs Potentiels

### Edge cases
- [ ] Clic rapide sur JOUER plusieurs fois → Pas de duplication
- [ ] Pause pendant un tir → Billes s'arrêtent
- [ ] Reprendre après pause → Jeu continue normalement
- [ ] Reset pendant un tir → Billes replacées correctement
- [ ] Changer de langue → Textes mis à jour immédiatement

### Performance
- [ ] FPS stable (60fps) en jeu
- [ ] Pas de lag pendant les transitions
- [ ] Mémoire stable (pas de fuites)

## 📊 Résultats

**Date du test** : _______________

**Testeur** : _______________

**Bugs trouvés** :
- 
- 
- 

**Notes** :
- 
- 
- 

**Status global** : ⬜ PASS  ⬜ FAIL  ⬜ NEEDS WORK
