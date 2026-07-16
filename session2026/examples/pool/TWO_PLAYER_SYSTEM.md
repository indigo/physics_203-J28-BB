# 🎮 Système 2 Joueurs - Tour par Tour

## 🎯 Vue d'ensemble

Le jeu de billard supporte maintenant le **mode 2 joueurs** avec un système de tour par tour basé sur les règles du 8-Ball simplifié.

## 📋 Règles implémentées

### Tour par tour
1. **Bille empochée** → Le joueur rejoue
2. **Aucune bille empochée** → Changement de joueur
3. **Blanche empochée (faute)** → Changement de joueur + replacement de la blanche

### Affichage
- **Joueur 1** : Bordure bleue (#0055ff)
- **Joueur 2** : Bordure orange (#ff5500)
- Le nom du joueur actif s'affiche en haut à gauche

## 🔧 Modifications apportées

### 1. gameState.js
```javascript
// Ajout de la gestion des joueurs
this.currentPlayer = 1; // 1 ou 2

getCurrentPlayer()    // Retourne 1 ou 2
switchPlayer()        // Alterne entre J1 et J2
resetPlayer()         // Remet à Joueur 1
```

### 2. menuManager.js
```javascript
// updateHUD() modifié pour afficher le joueur actuel
export function updateHUD() {
    const player = gameState.getCurrentPlayer();
    const label = `Joueur ${player}` / `Player ${player}`;
    
    // Couleur distinctive
    if (player === 1) {
        borderLeft: "5px solid #0055ff" // Bleu
    } else {
        borderLeft: "5px solid #ff5500" // Orange
    }
}
```

### 3. physics.js
```javascript
// Signature modifiée pour tracker les billes
export function updatePhysics(balls, dt, turnInfo = null)

// Enregistrement des événements
if (turnInfo) {
    if (b === whiteBall) {
        turnInfo.whiteScratched = true;
    } else {
        turnInfo.ballsPotted.push(b.number);
    }
}
```

### 4. main.js
```javascript
// Variable de suivi du tour
let turnInfo = {
    whiteScratched: false,
    ballsPotted: []
};

// Fonction de gestion des tours
function handleTurnEnd() {
    // 1. Faute → Changement
    // 2. Bille empochée → Rejoue
    // 3. Raté → Changement
}
```

## 🎮 Flux de jeu

```
┌─────────────────────────────────────────┐
│  JOUEUR 1 (Bleu) commence              │
└──────────────┬──────────────────────────┘
               │
               ▼
┌─────────────────────────────────────────┐
│  Joueur tire                            │
└──────────────┬──────────────────────────┘
               │
               ▼
┌─────────────────────────────────────────┐
│  Billes en mouvement...                 │
│  (physics.js enregistre les événements) │
└──────────────┬──────────────────────────┘
               │
               ▼
┌─────────────────────────────────────────┐
│  Toutes les billes arrêtées             │
└──────────────┬──────────────────────────┘
               │
               ▼
┌─────────────────────────────────────────┐
│  handleTurnEnd() analyse le résultat    │
└──────────────┬──────────────────────────┘
               │
       ┌───────┴───────┐
       │               │
       ▼               ▼
┌──────────┐    ┌──────────────┐
│ Bille    │    │ Raté ou      │
│ empochée │    │ Faute        │
└────┬─────┘    └──────┬───────┘
     │                 │
     ▼                 ▼
┌──────────┐    ┌──────────────┐
│ Rejoue   │    │ Changement   │
│ (même    │    │ de joueur    │
│ joueur)  │    │              │
└──────────┘    └──────┬───────┘
                       │
                       ▼
              ┌─────────────────┐
              │ JOUEUR 2 (Orange)│
              └─────────────────┘
```

## 📊 Logique de décision

### handleTurnEnd()

```javascript
if (whiteScratched) {
    → Faute
    → Changement de joueur
    → Message: "Faute ! Blanche empochée."
}
else if (ballsPotted.length > 0) {
    if (!hasBlack) {
        → Succès
        → Même joueur rejoue
        → Message: "Joli coup ! Rejouez."
    }
    else {
        → Noire empochée
        → checkWinCondition() gère victoire/défaite
    }
}
else {
    → Raté
    → Changement de joueur
    → Message: "Raté ! Au tour de l'adversaire."
}
```

## 🎨 Affichage visuel

### HUD Joueur 1
```
┌─────────────────────────────────────┐
│ ┃ Joueur 1                    ⏸    │
│ ┃ (Bordure bleue)                   │
└─────────────────────────────────────┘
```

### HUD Joueur 2
```
┌─────────────────────────────────────┐
│ ┃ Joueur 2                    ⏸    │
│ ┃ (Bordure orange)                  │
└─────────────────────────────────────┘
```

## 🔍 Détails techniques

### turnInfo
```javascript
{
    whiteScratched: false,  // true si blanche empochée
    ballsPotted: []         // [1, 3, 5] numéros des billes empochées
}
```

### Réinitialisation
- **Au début de chaque tir** : `turnInfo` est réinitialisé
- **Pendant le tir** : `physics.js` remplit `turnInfo`
- **Fin du tir** : `handleTurnEnd()` analyse `turnInfo`

### Console logs
```
Bille 3 empochée
Bille 5 empochée
Changement de joueur → Joueur 2
Fin du tour. Empochées: 2. Faute: false. Prochain: J2
Joli coup ! Rejouez.
```

## 🎯 Cas d'usage

### Cas 1 : Tir réussi
```
Joueur 1 tire
→ Bille 3 empochée
→ Joueur 1 rejoue
→ "Joli coup ! Rejouez."
```

### Cas 2 : Tir raté
```
Joueur 1 tire
→ Aucune bille empochée
→ Changement → Joueur 2
→ "Raté ! Au tour de l'adversaire."
```

### Cas 3 : Faute
```
Joueur 1 tire
→ Blanche empochée
→ Changement → Joueur 2
→ "Faute ! Blanche empochée."
→ Blanche replacée au centre après 1 seconde
```

### Cas 4 : Série de coups
```
Joueur 1 tire → Bille 2 empochée → Rejoue
Joueur 1 tire → Bille 4 empochée → Rejoue
Joueur 1 tire → Raté → Changement
Joueur 2 tire → Bille 6 empochée → Rejoue
...
```

## 🏆 Victoire

La victoire est attribuée au joueur qui :
1. Empoche toutes ses billes (1-7 ou 9-15)
2. Empoche la noire (8) en dernier

**Note** : Dans la version actuelle simplifiée, tous les joueurs visent toutes les billes. Pour une version complète du 8-Ball, il faudrait assigner "pleines" (1-7) à un joueur et "rayées" (9-15) à l'autre.

## 🔄 Reset du jeu

Lors d'un reset (bouton REJOUER ou nouveau jeu) :
- Le joueur revient à **Joueur 1**
- `turnInfo` est réinitialisé
- Le HUD affiche "Joueur 1" avec bordure bleue

## 📝 Textes localisés

### Français
- "Joueur 1" / "Joueur 2"
- "Joli coup ! Rejouez."
- "Faute ! Blanche empochée."
- "Raté ! Au tour de l'adversaire."

### English
- "Player 1" / "Player 2"
- "Nice shot! Play again."
- "Foul! White ball pocketed."
- "Missed! Opponent's turn."

## 🎮 Expérience de jeu

### Avant (Solo)
```
1. Tirer
2. Tirer
3. Tirer
4. ...
```

### Après (2 Joueurs)
```
1. Joueur 1 tire → Empoche → Rejoue
2. Joueur 1 tire → Rate → Changement
3. Joueur 2 tire → Empoche → Rejoue
4. Joueur 2 tire → Empoche → Rejoue
5. Joueur 2 tire → Faute → Changement
6. Joueur 1 tire → ...
```

## 🚀 Améliorations futures possibles

### Court terme
- [ ] Afficher un message temporaire lors du changement de joueur
- [ ] Animation de transition entre joueurs
- [ ] Compteur de coups par joueur

### Moyen terme
- [ ] Assigner pleines/rayées à chaque joueur
- [ ] Règles complètes du 8-Ball
- [ ] Placement manuel de la blanche après faute
- [ ] Historique des coups

### Long terme
- [ ] Mode en ligne (2 joueurs sur réseau)
- [ ] IA pour jouer contre l'ordinateur
- [ ] Tournois et classements
- [ ] Replay des parties

## 📊 Statistiques

### Code ajouté
- **gameState.js** : +18 lignes
- **menuManager.js** : +20 lignes
- **physics.js** : +15 lignes
- **main.js** : +59 lignes
- **Total** : ~112 lignes

### Fonctionnalités
- ✅ Gestion de 2 joueurs
- ✅ Tour par tour automatique
- ✅ Affichage du joueur actif
- ✅ Couleurs distinctives
- ✅ Messages contextuels
- ✅ Tracking des billes empochées
- ✅ Gestion des fautes
- ✅ Localisation FR/EN

## 🎉 Résultat

Le jeu est maintenant **jouable à 2 joueurs** avec :
- Tour par tour automatique
- Règles du 8-Ball simplifiées
- Interface claire et intuitive
- Feedback visuel et console

**Prêt pour des parties endiablées ! 🎱**

---

*Système 2 joueurs implémenté le 8 décembre 2025*
