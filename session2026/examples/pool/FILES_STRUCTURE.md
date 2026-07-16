# 📂 Structure des fichiers - Billard Master 3D

## 🎯 Vue d'ensemble

```
pool/
├── 📄 index.html                    # Page principale (85 lignes)
├── 📁 css/
│   └── 📄 style.css                 # Styles UI (170 lignes)
├── 📁 js/
│   ├── 📄 constants.js              # Constantes (27 lignes)
│   ├── 📄 gameState.js              # États du jeu (85 lignes)
│   ├── 📄 ball.js                   # Classe bille (140 lignes)
│   ├── 📄 table.js                  # Table de billard (181 lignes)
│   ├── 📄 physics.js                # Moteur physique (127 lignes)
│   ├── 📄 ui.js                     # Interface utilisateur (162 lignes)
│   ├── 📄 menuManager.js            # Gestionnaire de menus (170 lignes)
│   └── 📄 main.js                   # Point d'entrée (257 lignes)
├── 📁 docs/
│   ├── 📄 GAME_UI_README.md
│   ├── 📄 INTEGRATION_GUIDE.md
│   ├── 📄 BEFORE_AFTER.md
│   ├── 📄 SCREENS_OVERVIEW.md
│   ├── 📄 TEST_CHECKLIST.md
│   ├── 📄 CHANGELOG.md
│   ├── 📄 SUMMARY.md
│   └── 📄 README_UI_SYSTEM.md
├── 🔧 compile_js.sh                 # Script Bash
├── 🔧 compile_js.py                 # Script Python
├── 📦 compiled_source.txt           # CODE COMPLET (49 KB)
├── 📖 COMPILE_README.md
├── 📖 QUICK_START_COMPILE.md
├── 📖 COMPILE_SUMMARY.md
└── 📖 FILES_STRUCTURE.md            # Ce fichier
```

## 📊 Statistiques par catégorie

### Code source (10 fichiers)
```
HTML    : 1 fichier   (85 lignes)   - 6%
CSS     : 1 fichier   (170 lignes)  - 12%
JS      : 8 fichiers  (1149 lignes) - 82%
────────────────────────────────────────
TOTAL   : 10 fichiers (1404 lignes) - 100%
```

### Documentation (11 fichiers)
```
Guides UI        : 8 fichiers
Guides Compile   : 3 fichiers
```

### Scripts (2 fichiers)
```
Bash   : compile_js.sh
Python : compile_js.py
```

## 🎯 Fichiers essentiels

### Pour jouer
```
✅ index.html
✅ css/style.css
✅ js/*.js (tous les fichiers)
```

### Pour partager
```
✅ compiled_source.txt
```

### Pour compiler
```
✅ compile_js.sh (Mac/Linux)
✅ compile_js.py (Multiplateforme)
```

## 📦 Contenu de compiled_source.txt

```
╔════════════════════════════════════════╗
║  49 KB - 1404 lignes - 10 fichiers    ║
╚════════════════════════════════════════╝

┌─────────────────────────────────────┐
│ 1. index.html          (85 lignes)  │
│    Structure HTML + 5 écrans UI     │
└─────────────────────────────────────┘

┌─────────────────────────────────────┐
│ 2. css/style.css       (170 lignes) │
│    Styles professionnels            │
└─────────────────────────────────────┘

┌─────────────────────────────────────┐
│ 3. js/constants.js     (27 lignes)  │
│    Constantes physiques             │
└─────────────────────────────────────┘

┌─────────────────────────────────────┐
│ 4. js/gameState.js     (85 lignes)  │
│    Machine à états (7 états)        │
└─────────────────────────────────────┘

┌─────────────────────────────────────┐
│ 5. js/ball.js          (140 lignes) │
│    Classe BilliardBall              │
└─────────────────────────────────────┘

┌─────────────────────────────────────┐
│ 6. js/table.js         (181 lignes) │
│    Table + bandes + poches          │
└─────────────────────────────────────┘

┌─────────────────────────────────────┐
│ 7. js/physics.js       (127 lignes) │
│    Moteur physique complet          │
└─────────────────────────────────────┘

┌─────────────────────────────────────┐
│ 8. js/ui.js            (162 lignes) │
│    Interface + contrôles            │
└─────────────────────────────────────┘

┌─────────────────────────────────────┐
│ 9. js/menuManager.js   (170 lignes) │
│    Menus + transitions              │
└─────────────────────────────────────┘

┌─────────────────────────────────────┐
│ 10. js/main.js         (257 lignes) │
│     Point d'entrée + boucle         │
└─────────────────────────────────────┘
```

## 🔗 Dépendances entre fichiers

```
main.js
  ├─→ constants.js
  ├─→ gameState.js
  ├─→ ball.js ────→ constants.js
  ├─→ table.js ───→ constants.js
  ├─→ physics.js ─→ constants.js
  ├─→ ui.js ──────→ constants.js, gameState.js
  └─→ menuManager.js ─→ gameState.js

index.html
  ├─→ style.css
  └─→ main.js (module)
```

## 📏 Taille des fichiers

```
Fichier                 Lignes    Taille    %
────────────────────────────────────────────
index.html              85        3.2 KB    6%
css/style.css           170       4.8 KB    12%
js/constants.js         27        939 B     2%
js/gameState.js         85        2.1 KB    6%
js/ball.js              140       5.2 KB    10%
js/table.js             181       6.0 KB    13%
js/physics.js           127       4.7 KB    9%
js/ui.js                162       5.0 KB    11%
js/menuManager.js       170       5.2 KB    12%
js/main.js              257       8.3 KB    19%
────────────────────────────────────────────
TOTAL                   1404      49 KB     100%
```

## 🎯 Ordre de lecture recommandé

### Pour comprendre le jeu
1. **constants.js** - Commencer par les constantes
2. **gameState.js** - Comprendre les états
3. **ball.js** - Physique d'une bille
4. **table.js** - Structure de la table
5. **physics.js** - Moteur physique
6. **ui.js** - Interactions utilisateur
7. **menuManager.js** - Système de menus
8. **main.js** - Tout assembler
9. **index.html** - Structure HTML
10. **style.css** - Styles visuels

### Pour modifier le jeu
1. **main.js** - Point d'entrée
2. **menuManager.js** - Ajouter des écrans
3. **gameState.js** - Ajouter des états
4. **style.css** - Changer le design
5. **index.html** - Modifier la structure

## 🔍 Recherche rapide

### Trouver une fonctionnalité

**Menu principal**
- `index.html` : Structure HTML
- `style.css` : Styles
- `menuManager.js` : Logique

**Physique**
- `constants.js` : Paramètres
- `ball.js` : Bille individuelle
- `physics.js` : Collisions

**Interface**
- `ui.js` : Contrôles de visée
- `menuManager.js` : Écrans
- `style.css` : Apparence

**États du jeu**
- `gameState.js` : Machine à états
- `menuManager.js` : Transitions
- `main.js` : Intégration

## 📦 Packages nécessaires

### CDN (déjà inclus dans index.html)
```html
Three.js   : https://unpkg.com/three@0.160.0
lil-gui    : https://unpkg.com/lil-gui@0.19.1
```

### Aucune installation requise !
- ✅ Pas de npm install
- ✅ Pas de build
- ✅ Pas de bundler
- ✅ Juste un serveur HTTP

## 🚀 Démarrage rapide

```bash
# 1. Aller dans le dossier
cd pool/

# 2. Lancer un serveur
python3 -m http.server 8080

# 3. Ouvrir le navigateur
http://localhost:8080
```

## 📤 Partage

### Fichier unique
```
compiled_source.txt (49 KB)
→ Tout le code en un seul fichier
→ Facile à copier-coller
→ Prêt à partager
```

### Archive complète
```bash
# Créer une archive
zip -r billard-master-3d.zip pool/

# Contient :
# - Code source (10 fichiers)
# - Documentation (11 fichiers)
# - Scripts de compilation (2 fichiers)
```

## 🎓 Pour les débutants

### Fichiers à lire en premier
1. `README_UI_SYSTEM.md` - Vue d'ensemble
2. `index.html` - Structure HTML
3. `main.js` - Point d'entrée
4. `INTEGRATION_GUIDE.md` - Guide complet

### Fichiers à modifier en premier
1. `style.css` - Changer les couleurs
2. `menuManager.js` - Modifier les textes
3. `constants.js` - Ajuster la physique

## 🏆 Résumé

```
📦 10 fichiers de code source
📚 11 fichiers de documentation
🔧 2 scripts de compilation
📄 1 fichier compilé (49 KB)
───────────────────────────────
✅ Projet complet et prêt !
```

---

*Structure mise à jour le 8 décembre 2025*
