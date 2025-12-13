# 🤖 Intégration du Bot IA

## Architecture

Le système de bot est composé de 3 fichiers principaux :

1. **`simulator.js`** - Simulateur de physique pour prédire les résultats
2. **`smartBot.js`** - Intelligence artificielle qui choisit les meilleurs coups
3. **`botManager.js`** - Gestionnaire pour intégrer le bot dans le jeu

## Comment ça marche ?

### 1. Le Simulateur (`PhysicsSimulator`)

Le simulateur clone l'état actuel du jeu et simule un tir complet :

```javascript
const simResult = simulator.simulateShot(angle, power, cueHeight, balls, whiteBall);
// Retourne: { ballsPotted, whiteScratched, finalWhitePos, collisions, ... }
```

### 2. Le Bot (`SmartBot`)

Le bot utilise une approche **bruteforce intelligente** :

1. Pour chaque bille ciblable
2. Pour chaque trou possible
3. Calcule l'angle géométrique optimal
4. **Simule le tir** avec le simulateur
5. **Évalue le résultat** avec un système de scoring
6. Garde le meilleur coup

```javascript
const bot = new SmartBot(0.8); // Difficulté 80%
await bot.playTurn(whiteBall, balls, shootBall);
```

### 3. Système de Scoring

Le bot évalue chaque tir simulé selon plusieurs critères :

- ✅ **+1000** : Empocher la bille ciblée
- ✅ **+500** : Empocher plusieurs billes
- ❌ **-10000** : Empocher la blanche (faute)
- ❌ **-5000** : Empocher la noire trop tôt
- 📍 **-10×distance** : Placement de la blanche (pour les pros)
- ⚡ **+0.5×vitesse** : Arrêt rapide (moins de risques)

## Intégration dans `main.js`

### Étape 1 : Importer le bot

```javascript
import { botManager } from './botManager.js';
```

### Étape 2 : Activer le bot au démarrage

```javascript
function init() {
    // ... code existant ...
    
    // Activer le bot pour le Joueur 2 avec difficulté 70%
    botManager.setEnabled(true, 0.7);
    botManager.setBotPlayer(2);
}
```

### Étape 3 : Déclencher le bot après chaque tour

Dans la fonction `handleTurnEnd()` de `main.js`, ajoutez :

```javascript
function handleTurnEnd() {
    // ... logique existante de changement de tour ...
    
    if (switchTurn) {
        gameState.switchPlayer();
    }
    
    updateHUD();
    
    // NOUVEAU : Vérifier si c'est au tour du bot
    if (botManager.shouldBotPlay()) {
        // Petit délai pour que le joueur voie le changement
        setTimeout(() => {
            botManager.playBotTurn(whiteBall, balls, shootBall);
        }, 500);
    }
}
```

### Étape 4 : Ajouter des contrôles UI (optionnel)

Ajoutez dans le menu des options :

```html
<div class="setting-row">
    <label>Mode Bot</label>
    <select id="bot-mode">
        <option value="off">Désactivé</option>
        <option value="easy">Facile (30%)</option>
        <option value="medium">Moyen (50%)</option>
        <option value="hard">Difficile (70%)</option>
        <option value="expert">Expert (90%)</option>
    </select>
</div>
```

Et dans `menuManager.js` :

```javascript
document.getElementById('bot-mode').onchange = (e) => {
    const mode = e.target.value;
    const difficulties = {
        'off': 0,
        'easy': 0.3,
        'medium': 0.5,
        'hard': 0.7,
        'expert': 0.9
    };
    
    if (mode === 'off') {
        botManager.setEnabled(false);
    } else {
        botManager.setEnabled(true, difficulties[mode]);
    }
};
```

## Niveaux de Difficulté

| Niveau | Difficulté | Comportement |
|--------|-----------|--------------|
| **Débutant** | 0.0 - 0.3 | Erreurs fréquentes (±0.2 rad), pas de stratégie |
| **Moyen** | 0.3 - 0.6 | Erreurs modérées (±0.1 rad), stratégie basique |
| **Difficile** | 0.6 - 0.8 | Erreurs rares (±0.05 rad), placement stratégique |
| **Expert** | 0.8 - 1.0 | Quasi parfait (±0.01 rad), placement optimal |

## Optimisations Possibles

### 1. Limiter le nombre de simulations

Pour accélérer le calcul, limitez les combinaisons testées :

```javascript
// Dans smartBot.js, méthode playTurn()
const maxSimulations = Math.floor(10 + this.difficulty * 40);
let simCount = 0;

for (let target of myBalls) {
    for (let pocket of pockets) {
        if (simCount++ > maxSimulations) break;
        // ... simulation ...
    }
    if (simCount > maxSimulations) break;
}
```

### 2. Pré-filtrage géométrique

Éliminez les tirs impossibles avant simulation :

```javascript
calculateGeometricAim(whitePos, targetPos, pocketPos) {
    // ... code existant ...
    
    // Vérifier l'angle : trop aigu = impossible
    const angle = Math.acos(toPocket.dot(shootDir.normalize()));
    if (angle > Math.PI / 3) return null; // > 60° = trop difficile
    
    return { angle, power };
}
```

### 3. Cache des simulations

Pour éviter de simuler deux fois le même tir :

```javascript
constructor(difficulty) {
    this.simulator = new PhysicsSimulator();
    this.difficulty = difficulty;
    this.simulationCache = new Map();
}

simulateWithCache(angle, power, balls, whiteBall) {
    const key = `${angle.toFixed(3)}_${power.toFixed(1)}`;
    if (this.simulationCache.has(key)) {
        return this.simulationCache.get(key);
    }
    
    const result = this.simulator.simulateShot(angle, power, 0, balls, whiteBall);
    this.simulationCache.set(key, result);
    return result;
}
```

## Exemple Complet

Voir le fichier `examples/bot_demo.js` pour un exemple complet d'intégration.

## Performance

- **Simulations par tour** : ~30-60 (selon difficulté)
- **Temps de calcul** : 0.5-2 secondes
- **Précision** : 85-95% (selon difficulté)

## Améliorations Futures

- [ ] Détection des obstacles (billes bloquant le chemin)
- [ ] Stratégie de sécurité (laisser la blanche loin de l'adversaire)
- [ ] Apprentissage par renforcement (ML)
- [ ] Coups avec effet (spin)
- [ ] Analyse multi-coups (prévoir 2-3 coups à l'avance)
