# 🖼️ Vue d'ensemble des écrans - Billard Master 3D

## 📱 Les 5 écrans du jeu

### 1️⃣ Menu Principal (`screen-menu`)

```
╔═══════════════════════════════════════════════════════╗
║                                                       ║
║                                                       ║
║              BILLARD MASTER 3D                        ║
║           (Effet néon vert brillant)                  ║
║                                                       ║
║                                                       ║
║                  ┌─────────────┐                      ║
║                  │   JOUER     │  ← Bouton primaire   ║
║                  └─────────────┘     (vert)           ║
║                                                       ║
║                  ┌─────────────┐                      ║
║                  │   OPTIONS   │  ← Bouton standard   ║
║                  └─────────────┘                      ║
║                                                       ║
║                    [ Crédits ]    ← Petit bouton      ║
║                                                       ║
║                                                       ║
║         🎱 Table de billard en arrière-plan           ║
║         (Caméra tourne automatiquement)               ║
║                                                       ║
╚═══════════════════════════════════════════════════════╝

État : MENU
Physique : Active (effet visuel)
Caméra : Rotation automatique
Interactions : Boutons uniquement
```

---

### 2️⃣ Écran Options (`screen-settings`)

```
╔═══════════════════════════════════════════════════════╗
║                                                       ║
║                    OPTIONS                            ║
║                                                       ║
║                                                       ║
║   Volume Musique    ●━━━━━━━━━○                      ║
║                     [0.0 - 1.0]                       ║
║                                                       ║
║   Volume SFX        ●━━━━━━━━━━━○                    ║
║                     [0.0 - 1.0]                       ║
║                                                       ║
║   Langue / Language  [ Français ▼ ]                   ║
║                      [ English    ]                   ║
║                                                       ║
║                                                       ║
║                  ┌─────────────┐                      ║
║                  │   RETOUR    │                      ║
║                  └─────────────┘                      ║
║                                                       ║
║                                                       ║
╚═══════════════════════════════════════════════════════╝

État : SETTINGS
Physique : Arrêtée
Caméra : Figée
Interactions : Sliders et boutons
Retour : Menu ou Pause selon contexte
```

---

### 3️⃣ HUD de jeu (`screen-hud`)

```
╔═══════════════════════════════════════════════════════╗
║ ┌──────────┐                              ┌───┐      ║
║ │ Joueur 1 │                              │ ⏸ │      ║
║ └──────────┘                              └───┘      ║
║                                                       ║
║                                                       ║
║                                                       ║
║                                                       ║
║              🎱 Table de billard                      ║
║                 (Gameplay actif)                      ║
║                                                       ║
║                                                       ║
║                                                       ║
║                                                       ║
║                                                       ║
║       Clic Bille: Viser | Glisser Blanche: Tirer     ║
║                                                       ║
╚═══════════════════════════════════════════════════════╝

État : IDLE / AIMING / SHOOTING
Physique : Active
Caméra : OrbitControls actifs
Interactions : Gameplay complet
Overlay : Semi-transparent, ne bloque pas le jeu
```

---

### 4️⃣ Menu Pause (`screen-pause`)

```
╔═══════════════════════════════════════════════════════╗
║ ┌──────────┐                              ┌───┐      ║
║ │ Joueur 1 │                              │ ⏸ │      ║
║ └──────────┘                              └───┘      ║
║                                                       ║
║          ┌─────────────────────────────┐              ║
║          │                             │              ║
║          │          PAUSE              │              ║
║          │                             │              ║
║          │     ┌───────────────┐       │              ║
║          │     │  REPRENDRE    │       │  ← Primaire  ║
║          │     └───────────────┘       │              ║
║          │                             │              ║
║          │     ┌───────────────┐       │              ║
║          │     │   OPTIONS     │       │              ║
║          │     └───────────────┘       │              ║
║          │                             │              ║
║          │     ┌───────────────┐       │              ║
║          │     │   QUITTER     │       │  ← Danger    ║
║          │     └───────────────┘       │              ║
║          │                             │              ║
║          └─────────────────────────────┘              ║
║                                                       ║
╚═══════════════════════════════════════════════════════╝

État : PAUSED
Physique : Arrêtée
Caméra : Figée
Interactions : Boutons uniquement
Fond : Semi-transparent (rgba(0,0,0,0.8))
Table visible en arrière-plan (figée)
```

---

### 5️⃣ Écran Fin de Partie (`screen-gameover`)

**Version Victoire ✅**
```
╔═══════════════════════════════════════════════════════╗
║                                                       ║
║                                                       ║
║                  VICTOIRE !                           ║
║              (Texte vert #2e8b57)                     ║
║                                                       ║
║                                                       ║
║        Parfait ! Toutes les billes empochées !        ║
║                                                       ║
║                                                       ║
║                  ┌─────────────┐                      ║
║                  │   REJOUER   │  ← Primaire (vert)   ║
║                  └─────────────┘                      ║
║                                                       ║
║                  ┌─────────────┐                      ║
║                  │MENU PRINCIPAL│                     ║
║                  └─────────────┘                      ║
║                                                       ║
║                                                       ║
╚═══════════════════════════════════════════════════════╝
```

**Version Défaite ❌**
```
╔═══════════════════════════════════════════════════════╗
║                                                       ║
║                                                       ║
║                  DÉFAITE...                           ║
║              (Texte rouge #8b0000)                    ║
║                                                       ║
║                                                       ║
║          Faute : Blanche empochée !                   ║
║                                                       ║
║                                                       ║
║                  ┌─────────────┐                      ║
║                  │   REJOUER   │  ← Primaire (vert)   ║
║                  └─────────────┘                      ║
║                                                       ║
║                  ┌─────────────┐                      ║
║                  │MENU PRINCIPAL│                     ║
║                  └─────────────┘                      ║
║                                                       ║
║                                                       ║
╚═══════════════════════════════════════════════════════╝

État : GAME_OVER
Physique : Arrêtée
Caméra : Figée
Interactions : Boutons uniquement
Titre dynamique : Vert (victoire) ou Rouge (défaite)
Message personnalisé selon la raison
```

---

## 🔄 Navigation entre écrans

```
                    ┌──────────────┐
                    │              │
                    │    MENU      │
                    │  PRINCIPAL   │
                    │              │
                    └──────┬───────┘
                           │
              ┌────────────┼────────────┐
              │                         │
         "JOUER"                   "OPTIONS"
              │                         │
              ▼                         ▼
      ┌──────────────┐          ┌──────────────┐
      │              │          │              │
      │   HUD JEU    │◄─────────│   SETTINGS   │
      │              │ "RETOUR" │              │
      └──────┬───────┘          └──────────────┘
             │
      ┌──────┼──────┐
      │             │
   "PAUSE"      Fin partie
      │             │
      ▼             ▼
┌──────────┐  ┌──────────────┐
│          │  │              │
│  PAUSE   │  │  GAME OVER   │
│          │  │              │
└──────────┘  └──────┬───────┘
      │              │
      │         "REJOUER"
      │              │
      └──────────────┼─────────► Retour au HUD
                     │
                "MENU"
                     │
                     └─────────► Retour au MENU
```

---

## 🎨 Hiérarchie visuelle

### Niveaux de z-index
```
z-index: 10  → Écrans pleins (Menu, Settings, Pause, GameOver)
z-index: 0   → HUD (overlay transparent)
z-index: -1  → Canvas Three.js (table de billard)
```

### Opacité des fonds
```
Menu Principal : Opaque (dégradé radial)
Settings       : Opaque (dégradé radial)
HUD            : Transparent (pointer-events: none)
Pause          : Semi-transparent (rgba(0,0,0,0.8))
Game Over      : Opaque (dégradé radial)
```

---

## 📐 Layout responsive

### Écrans pleins (`.screen`)
```css
position: absolute;
width: 100%;
height: 100%;
display: flex;
flex-direction: column;
align-items: center;
justify-content: center;
```

### HUD (`.overlay`)
```css
position: absolute;
width: 100%;
height: 100%;
pointer-events: none;  /* Ne bloque pas les clics */
```

### Éléments du HUD
```css
.top-bar {
    position: absolute;
    top: 0;
    width: 100%;
    display: flex;
    justify-content: space-between;
}

#game-tips {
    position: absolute;
    bottom: 20px;
    text-align: center;
}
```

---

## 🎯 États et écrans

| État | Écran visible | Physique | Caméra | Interactions |
|------|---------------|----------|--------|--------------|
| **MENU** | screen-menu | Active | Rotation auto | Boutons |
| **SETTINGS** | screen-settings | Arrêtée | Figée | Sliders + boutons |
| **IDLE** | screen-hud | Active | OrbitControls | Gameplay |
| **AIMING** | screen-hud | Active | Désactivés | Visée |
| **SHOOTING** | screen-hud | Active | OrbitControls | Aucune |
| **PAUSED** | screen-pause + hud | Arrêtée | Figée | Boutons |
| **GAME_OVER** | screen-gameover | Arrêtée | Figée | Boutons |

---

## 🔧 Gestion du display

### Fonction `switchState()`
```javascript
// Cacher tous les écrans
['screen-menu', 'screen-settings', 'screen-hud', 
 'screen-pause', 'screen-gameover'].forEach(id => {
    document.getElementById(id).style.display = 'none';
});

// Afficher le bon écran selon l'état
switch(newState) {
    case GameStates.MENU:
        document.getElementById('screen-menu').style.display = 'flex';
        break;
    case GameStates.IDLE:
        document.getElementById('screen-hud').style.display = 'block';
        break;
    // ...
}
```

---

## 💡 Conseils UX

### Transitions
- Utiliser `display: flex` pour les écrans pleins (centrage automatique)
- Utiliser `display: block` pour le HUD (overlay)
- Pas d'animations pour l'instant (à ajouter plus tard)

### Feedback visuel
- Boutons avec `:hover` effects
- Couleurs distinctes (vert = action, rouge = danger)
- Texte clair et lisible

### Accessibilité
- Taille de police suffisante (1.2em minimum)
- Contraste élevé (texte blanc sur fond noir)
- Boutons assez grands (min-width: 200px)

---

## 📱 Responsive design

Les écrans s'adaptent automatiquement à la taille de la fenêtre :
- Flexbox pour le centrage
- Tailles relatives (em, %)
- Pas de breakpoints nécessaires pour l'instant

---

**Tous les écrans sont maintenant opérationnels ! 🎉**
