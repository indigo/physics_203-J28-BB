# 📦 Scripts de compilation du code source

## 🎯 Objectif

Ces scripts permettent de concaténer tous les fichiers JavaScript du projet dans un seul fichier `compiled_source.txt` pour faciliter le partage du code complet.

## 📁 Fichiers disponibles

### 1. Script Bash (Linux/Mac)
**`compile_js.sh`**
```bash
./compile_js.sh
```

### 2. Script Python (Multiplateforme)
**`compile_js.py`**
```bash
python3 compile_js.py
```

## 🚀 Utilisation

### Option 1 : Bash (recommandé sur Mac/Linux)
```bash
# Rendre le script exécutable (une seule fois)
chmod +x compile_js.sh

# Exécuter le script
./compile_js.sh
```

### Option 2 : Python (fonctionne partout)
```bash
python3 compile_js.py
```

## 📄 Fichier généré

**`compiled_source.txt`**
- Contient tous les fichiers JS dans l'ordre logique
- En-tête avec date et heure
- Séparateurs visuels entre chaque fichier
- Statistiques en fin de fichier

### Structure du fichier
```
╔═══════════════════════════════════════════════╗
║     BILLARD MASTER 3D - CODE SOURCE COMPLET   ║
╚═══════════════════════════════════════════════╝

═══════════════════════════════════════════════
  FICHIER 1/10 : index.html
  Lignes : 85
═══════════════════════════════════════════════

[Contenu du fichier HTML...]

═══════════════════════════════════════════════
  FICHIER 2/10 : css/style.css
  Lignes : 170
═══════════════════════════════════════════════

[Contenu du fichier CSS...]

═══════════════════════════════════════════════
  FICHIER 3/10 : js/constants.js
  Lignes : 27
═══════════════════════════════════════════════

[Contenu du fichier...]

[... etc ...]

═══════════════════════════════════════════════
  FIN DE LA COMPILATION
═══════════════════════════════════════════════

Statistiques:
  - Fichiers compilés : 10/10
  - Lignes totales    : 1404
  - Date              : 08/12/2024 22:52:21
```

## 📋 Fichiers inclus (dans l'ordre)

1. **index.html** - Structure HTML complète avec les 5 écrans UI
2. **css/style.css** - Styles professionnels pour tous les écrans
3. **js/constants.js** - Constantes physiques et dimensions
4. **js/gameState.js** - Machine à états du jeu
5. **js/ball.js** - Classe BilliardBall
6. **js/table.js** - Création de la table
7. **js/physics.js** - Moteur physique
8. **js/ui.js** - Interface utilisateur et contrôles
9. **js/menuManager.js** - Gestionnaire de menus
10. **js/main.js** - Point d'entrée principal

## 📊 Statistiques

- **10 fichiers** (HTML + CSS + JavaScript)
- **~1400 lignes** de code total
- Ordre logique pour la lecture
- Code complet et prêt à l'emploi

## 🔄 Mise à jour

Pour régénérer le fichier après des modifications :
```bash
# Bash
./compile_js.sh

# Python
python3 compile_js.py
```

Le fichier `compiled_source.txt` sera écrasé et recréé avec les dernières modifications.

## 📤 Partage

Une fois généré, vous pouvez :
1. Copier le contenu de `compiled_source.txt`
2. Le coller dans un email, chat, forum, etc.
3. Le partager via GitHub Gist, Pastebin, etc.

## 💡 Avantages

- ✅ **Un seul fichier** à partager
- ✅ **Ordre logique** de lecture
- ✅ **Séparateurs visuels** clairs
- ✅ **Statistiques** incluses
- ✅ **Date et heure** de compilation
- ✅ **Facile à copier-coller**

## 🛠️ Personnalisation

### Modifier l'ordre des fichiers

**Dans `compile_js.sh`** :
```bash
FILES=(
    "index.html"
    "css/style.css"
    "js/constants.js"
    "js/gameState.js"
    # ... modifier l'ordre ici
)
```

**Dans `compile_js.py`** :
```python
FILES = [
    "index.html",
    "css/style.css",
    "js/constants.js",
    "js/gameState.js",
    # ... modifier l'ordre ici
]
```

### Ajouter d'autres fichiers

Ajoutez simplement le nom du fichier dans la liste `FILES`.

### Changer le nom du fichier de sortie

Modifiez la variable `OUTPUT_FILE` dans le script :
```bash
OUTPUT_FILE="mon_code_complet.txt"
```

## ⚠️ Notes

- Les scripts cherchent les fichiers dans le dossier `js/`
- Si un fichier n'existe pas, il sera ignoré avec un message
- Le fichier de sortie est écrasé à chaque exécution
- L'encodage UTF-8 est utilisé pour supporter les caractères spéciaux

## 🐛 Dépannage

### "Permission denied" (Bash)
```bash
chmod +x compile_js.sh
```

### "python3 not found" (Python)
```bash
# Essayer avec python au lieu de python3
python compile_js.py
```

### Fichier vide ou incomplet
Vérifiez que tous les fichiers JS existent dans le dossier `js/`.

## 📞 Support

En cas de problème, vérifiez :
1. Que vous êtes dans le bon dossier (`examples/pool`)
2. Que le dossier `js/` existe
3. Que les fichiers JS sont présents
4. Les permissions d'exécution du script

---

**Créé le 8 décembre 2024**
