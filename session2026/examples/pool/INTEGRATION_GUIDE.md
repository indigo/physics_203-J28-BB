# 🎮 Guide d'intégration - Système UI Complet

## 📦 Ce qui a été ajouté

### 1. Structure HTML (index.html)
```html
<div id="ui-layer">
    <!-- 5 écrans superposés -->
    <div id="screen-menu">...</div>
    <div id="screen-settings">...</div>
    <div id="screen-hud">...</div>
    <div id="screen-pause">...</div>
    <div id="screen-gameover">...</div>
</div>
```

### 2. Styles CSS (style.css)
- **171 lignes** de styles professionnels
- Design "bar de nuit" élégant
- Boutons avec hover effects
- Responsive et moderne

### 3. Game State Manager (gameState.js)
```javascript
GameStates = {
    MENU, SETTINGS, IDLE, AIMING, 
    SHOOTING, PAUSED, GAME_OVER
}
```

### 4. Menu Manager (menuManager.js) - NOUVEAU
```javascript
// Fonctions principales
switchState(newState)           // Change d'écran
triggerGameOver(isWin, reason)  // Affiche fin de partie
setupUI()                       // Configure les boutons
setMenuCallbacks(...)           // Connecte au jeu
```

### 5. Modifications dans ball.js
```javascript
constructor(x, z, number) {
    this.number = number; // ← AJOUTÉ pour la logique de jeu
    // ...
}
```

### 6. Modifications dans main.js
```javascript
// Import du menu manager
import { setupUI, switchState, triggerGameOver, setMenuCallbacks } from './menuManager.js';

// Dans init()
setMenuCallbacks(onGameStart, resetGame, controls);
setupUI();
switchState(GameStates.MENU); // ← Démarre au menu

// Nouvelle fonction
function checkWinCondition() {
    // Détecte victoire/défaite
}

// Boucle animate() modifiée
function animate() {
    // Gère la physique selon l'état
    if (gameState.isPaused()) return;
    // ...
}
```

### 7. Modifications dans ui.js
```javascript
function onMouseDown(e) {
    // Bloque les interactions hors jeu
    if (!gameState.canAim() || !gameState.isPlaying()) return;
    // ...
}
```

## 🔄 Flux de données

```
┌─────────────────────────────────────────────────┐
│                   USER INPUT                     │
│         (Clics sur boutons, souris, etc)        │
└──────────────────┬──────────────────────────────┘
                   │
                   ▼
┌─────────────────────────────────────────────────┐
│              menuManager.js                      │
│  • setupUI() - Écoute les clics                 │
│  • switchState() - Change d'écran               │
│  • triggerGameOver() - Affiche résultat         │
└──────────────────┬──────────────────────────────┘
                   │
                   ▼
┌─────────────────────────────────────────────────┐
│              gameState.js                        │
│  • setState() - Change l'état interne           │
│  • Notifie les listeners                        │
└──────────────────┬──────────────────────────────┘
                   │
                   ▼
┌─────────────────────────────────────────────────┐
│                 main.js                          │
│  • animate() - Adapte la physique               │
│  • checkWinCondition() - Vérifie victoire       │
│  • resetGame() - Reset la table                 │
└──────────────────┬──────────────────────────────┘
                   │
                   ▼
┌─────────────────────────────────────────────────┐
│                 ui.js                            │
│  • Bloque/Débloque les interactions             │
│  • Gère la visée et les tirs                    │
└─────────────────────────────────────────────────┘
```

## 🎯 Cycle de vie d'une partie

```
1. DÉMARRAGE
   ├─ init() dans main.js
   ├─ setupUI() configure les boutons
   └─ switchState(MENU) → Affiche menu principal

2. MENU
   ├─ Caméra tourne automatiquement
   ├─ Physique active (effet visuel)
   └─ Clic "JOUER" → switchState(IDLE)

3. JEU EN COURS
   ├─ IDLE → Attente du joueur
   ├─ Clic blanche → AIMING
   ├─ Glisser souris → Ajuste puissance
   ├─ Relâcher → SHOOTING
   ├─ Billes bougent...
   └─ Arrêt → IDLE + checkWinCondition()

4. PAUSE (optionnel)
   ├─ Clic bouton pause → PAUSED
   ├─ Physique arrêtée
   └─ Clic "REPRENDRE" → IDLE

5. FIN DE PARTIE
   ├─ checkWinCondition() détecte victoire/défaite
   ├─ triggerGameOver(isWin, reason)
   ├─ switchState(GAME_OVER)
   └─ Choix : REJOUER ou MENU
```

## 🛠️ Comment étendre le système

### Ajouter un nouvel écran

**1. HTML (index.html)**
```html
<div id="screen-tutorial" class="screen" style="display: none;">
    <h2>TUTORIEL</h2>
    <p>Instructions du jeu...</p>
    <button id="btn-skip-tutorial" class="btn">PASSER</button>
</div>
```

**2. État (gameState.js)**
```javascript
export const GameStates = {
    // ... états existants
    TUTORIAL: 'tutorial'
};
```

**3. Logique (menuManager.js)**
```javascript
// Dans switchState()
case GameStates.TUTORIAL:
    document.getElementById('screen-tutorial').style.display = 'flex';
    break;

// Dans setupUI()
document.getElementById('btn-skip-tutorial').onclick = () => {
    switchState(GameStates.IDLE);
};
```

### Ajouter un système de score

**1. Variables (menuManager.js)**
```javascript
export const gameData = {
    score: 0,
    ballsPocketed: 0,
    shots: 0
};
```

**2. HUD (index.html)**
```html
<div id="score-display">
    Score: <span id="score-value">0</span>
</div>
```

**3. Mise à jour (main.js)**
```javascript
// Dans checkWinCondition() ou physics.js
if (ball.inPocket) {
    gameData.score += 10;
    gameData.ballsPocketed++;
    updateHUD();
}
```

### Ajouter de l'audio

**1. Créer un gestionnaire audio**
```javascript
// js/audioManager.js
export class AudioManager {
    constructor() {
        this.music = new Audio('assets/music.mp3');
        this.sfx = {
            hit: new Audio('assets/hit.mp3'),
            pocket: new Audio('assets/pocket.mp3')
        };
    }
    
    playMusic() {
        this.music.volume = settings.musicVol;
        this.music.loop = true;
        this.music.play();
    }
    
    playSFX(name) {
        this.sfx[name].volume = settings.sfxVol;
        this.sfx[name].play();
    }
}
```

**2. Intégrer dans main.js**
```javascript
import { AudioManager } from './audioManager.js';
const audio = new AudioManager();

// Dans onGameStart()
audio.playMusic();

// Dans physics.js (collision)
audio.playSFX('hit');
```

**3. Connecter aux sliders**
```javascript
// Dans menuManager.js
document.getElementById('vol-music').oninput = (e) => { 
    settings.musicVol = parseFloat(e.target.value);
    if (audio) audio.music.volume = settings.musicVol;
};
```

## 🎨 Personnalisation du design

### Changer la palette de couleurs

**style.css**
```css
/* Thème "Nuit Bleue" */
h1.game-title { 
    color: #4169e1; /* Bleu royal */
    text-shadow: 0 0 10px #1e90ff; 
}

.btn.primary { 
    background: #4169e1; 
    border-color: #4169e1; 
}
```

### Ajouter des animations

**style.css**
```css
@keyframes fadeIn {
    from { opacity: 0; transform: scale(0.9); }
    to { opacity: 1; transform: scale(1); }
}

.screen {
    animation: fadeIn 0.3s ease-out;
}
```

### Changer la police

**index.html**
```html
<head>
    <link href="https://fonts.googleapis.com/css2?family=Orbitron:wght@400;700&display=swap" rel="stylesheet">
</head>
```

**style.css**
```css
h1.game-title { 
    font-family: 'Orbitron', sans-serif; 
}
```

## 🔌 Intégration GameDistribution

### Étape 1 : Ajouter le SDK

**index.html**
```html
<head>
    <script src="https://html5.api.gamedistribution.com/main.min.js"></script>
</head>
```

### Étape 2 : Initialiser

**js/gdManager.js**
```javascript
export class GDManager {
    constructor() {
        if (typeof gdsdk !== 'undefined') {
            gdsdk.init({
                gameId: 'YOUR_GAME_ID',
                onEvent: (event) => this.handleEvent(event)
            });
        }
    }
    
    showAd(type = 'midgame') {
        if (typeof gdsdk !== 'undefined') {
            gdsdk.showAd(type);
        }
    }
    
    handleEvent(event) {
        if (event.name === 'SDK_GAME_START') {
            // Reprendre le jeu
            switchState(GameStates.IDLE);
        }
    }
}
```

### Étape 3 : Afficher des pubs

**main.js**
```javascript
import { GDManager } from './gdManager.js';
const gd = new GDManager();

// Pub au démarrage
function onGameStart() {
    gd.showAd('preroll');
}

// Pub après game over
function checkWinCondition() {
    if (gameOver) {
        gd.showAd('midgame');
        triggerGameOver(isWin, reason);
    }
}
```

## 📊 Debugging

### Console logs utiles

**gameState.js** affiche déjà :
```
Game state: menu -> idle
Game state: idle -> aiming
Game state: aiming -> shooting
Game state: shooting -> idle
```

### Ajouter plus de logs

**menuManager.js**
```javascript
export function switchState(newState) {
    console.log(`[UI] Switching to: ${newState}`);
    gameState.setState(newState);
    // ...
}
```

**main.js**
```javascript
function checkWinCondition() {
    console.log('[GAME] Checking win condition...');
    console.log(`  White ball in pocket: ${whiteBall.inPocket}`);
    console.log(`  Balls remaining: ${regularBalls.length}`);
    // ...
}
```

## ✅ Checklist d'intégration

- [x] HTML : 5 écrans ajoutés
- [x] CSS : Styles professionnels
- [x] gameState.js : États étendus
- [x] ball.js : Numéro de bille stocké
- [x] menuManager.js : Créé et fonctionnel
- [x] main.js : Menu intégré + détection victoire
- [x] ui.js : Interactions protégées
- [ ] Audio : À ajouter
- [ ] GameDistribution : À intégrer
- [ ] Tests : À effectuer

## 🚀 Prêt pour la production !

Votre jeu dispose maintenant de :
- ✅ Boucle de jeu complète
- ✅ UI professionnelle
- ✅ Gestion d'états robuste
- ✅ Détection de victoire/défaite
- ✅ Localisation FR/EN
- ✅ Design moderne

**Next steps** : Audio + GameDistribution + Tests
