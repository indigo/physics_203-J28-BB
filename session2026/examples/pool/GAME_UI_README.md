# 🎱 Billard Master 3D - Système UI Complet

## 🎮 Vue d'ensemble

Ce système transforme le prototype technique en un vrai jeu avec une boucle de jeu complète :
**Menu → Jeu → Pause/Settings → Fin de partie**

## 📁 Architecture

### Fichiers modifiés/créés :

1. **`index.html`** - Ajout des écrans UI (Menu, Settings, HUD, Pause, GameOver)
2. **`css/style.css`** - Styles professionnels pour tous les écrans
3. **`js/gameState.js`** - États étendus (MENU, SETTINGS, PAUSED)
4. **`js/ball.js`** - Ajout de `this.number` pour la logique de jeu
5. **`js/menuManager.js`** - ⭐ NOUVEAU : Gestionnaire de menus et transitions
6. **`js/main.js`** - Intégration du menu manager et détection de victoire/défaite
7. **`js/ui.js`** - Protection des interactions pendant les menus

## 🎯 États du jeu

```
MENU → IDLE ⇄ AIMING ⇄ SHOOTING → GAME_OVER
  ↓                                      ↑
SETTINGS ← PAUSED ←──────────────────────┘
```

### États disponibles :
- **MENU** : Écran principal avec rotation automatique de la caméra
- **SETTINGS** : Options (volume, langue)
- **IDLE** : En jeu, en attente d'action du joueur
- **AIMING** : Le joueur vise avec la queue
- **SHOOTING** : Les billes sont en mouvement
- **PAUSED** : Jeu en pause (physique arrêtée)
- **GAME_OVER** : Victoire ou défaite

## 🎨 Écrans UI

### 1. Menu Principal (`screen-menu`)
- Titre avec effet néon vert
- Boutons : JOUER, OPTIONS, Crédits
- Caméra qui tourne autour de la table

### 2. Options (`screen-settings`)
- Volume Musique (slider)
- Volume SFX (slider)
- Sélection de langue (FR/EN)
- Bouton RETOUR

### 3. HUD de jeu (`screen-hud`)
- Score/Joueur en haut à gauche
- Bouton Pause en haut à droite
- Tips en bas de l'écran

### 4. Menu Pause (`screen-pause`)
- Fond semi-transparent
- REPRENDRE, OPTIONS, QUITTER

### 5. Fin de partie (`screen-gameover`)
- Titre dynamique (VICTOIRE/DÉFAITE)
- Message personnalisé
- REJOUER, MENU PRINCIPAL

## 🏆 Logique de victoire

### Conditions de victoire :
1. ✅ Empocher toutes les billes (1-7 ou 9-15 selon les pleines/rayées)
2. ✅ Empocher la noire (8) en dernier

### Conditions de défaite :
1. ❌ Empocher la blanche (faute)
2. ❌ Empocher la noire trop tôt

### Détection automatique :
La fonction `checkWinCondition()` est appelée après chaque coup :
- Vérifie si la blanche est empochée
- Vérifie l'état de la bille noire
- Compte les billes restantes

## 🎛️ Fonctionnalités

### Gestion de la physique :
- **MENU** : Physique active (effet visuel)
- **PLAYING** : Physique active (jeu normal)
- **PAUSED** : Physique arrêtée, rendu figé
- **SETTINGS** : Physique arrêtée

### Contrôles caméra :
- **MENU** : Rotation automatique
- **PLAYING** : OrbitControls activés
- **PAUSED** : OrbitControls désactivés

### Interactions souris :
- Bloquées dans MENU, SETTINGS, PAUSED, GAME_OVER
- Actives uniquement en IDLE/AIMING/SHOOTING

## 🌍 Localisation

Textes disponibles en **Français** et **English** :
```javascript
const TEXTS = {
    fr: { 
        win: "VICTOIRE !", 
        lose: "DÉFAITE...", 
        msgWin: "Table nettoyée !",
        msgLose: "La blanche est tombée ou faute."
    },
    en: { 
        win: "YOU WIN!", 
        lose: "GAME OVER",
        msgWin: "Table cleared!",
        msgLose: "Scratch or foul."
    }
};
```

## 🎨 Design

### Palette de couleurs :
- **Fond** : Dégradé radial noir (#1a1a1a → #000000)
- **Accent principal** : Vert billard (#2e8b57)
- **Texte** : Blanc/Gris clair
- **Danger** : Rouge foncé (#8b0000)

### Typographie :
- **Titre** : Impact, 4em, effet néon vert
- **Boutons** : Sans-serif, uppercase, transitions douces
- **HUD** : Fond semi-transparent noir

## 🔧 API du Menu Manager

### Fonctions principales :

```javascript
// Changer d'état et afficher l'écran correspondant
switchState(GameStates.MENU)

// Afficher l'écran de fin
triggerGameOver(isWin, reason)

// Configurer les callbacks
setMenuCallbacks(onPlay, onReset, controls)

// Initialiser les événements UI
setupUI()
```

### Settings :
```javascript
export const settings = {
    musicVol: 0.5,   // 0.0 - 1.0
    sfxVol: 0.8,     // 0.0 - 1.0
    lang: 'fr'       // 'fr' | 'en'
};
```

## 🚀 Prochaines étapes

### Améliorations suggérées :
1. **Audio** : Ajouter musique de fond et effets sonores
2. **Scores** : Système de points et high scores
3. **Multijoueur** : Tour par tour (Joueur 1 vs Joueur 2)
4. **Animations** : Transitions entre écrans
5. **Tutoriel** : Premier lancement avec instructions
6. **SDK GameDistribution** : Intégration pour monétisation

### Hooks pour l'audio :
Les sliders de volume sont déjà connectés à `settings.musicVol` et `settings.sfxVol`.
Il suffit d'ajouter la logique audio dans les callbacks.

## 📝 Notes techniques

- **Pas de dépendances externes** : Tout est vanilla JS + Three.js
- **Responsive** : Les écrans s'adaptent à la taille de la fenêtre
- **Performance** : La physique s'arrête en pause pour économiser les ressources
- **État centralisé** : Un seul `GameStateMachine` pour tout le jeu
- **Séparation des responsabilités** : UI, physique, et logique de jeu bien séparées

## 🎯 Résultat

Vous avez maintenant un **vrai jeu** avec :
- ✅ Menu principal professionnel
- ✅ Système de pause
- ✅ Écran de paramètres
- ✅ Détection de victoire/défaite
- ✅ Localisation FR/EN
- ✅ Design élégant "bar de nuit"
- ✅ Boucle de jeu complète

**Prêt pour l'intégration GameDistribution !** 🚀
