# 🐛 Correction - Navigation OPTIONS depuis PAUSE

## Problème identifié

Quand on allait dans OPTIONS depuis le menu PAUSE, le bouton RETOUR ramenait au MENU PRINCIPAL au lieu de revenir à la PAUSE.

### Scénario du bug
```
1. Jouer une partie
2. Appuyer sur PAUSE (⏸)
3. Cliquer sur OPTIONS
4. Cliquer sur RETOUR
❌ Résultat : Retour au MENU PRINCIPAL (partie perdue)
✅ Attendu : Retour au menu PAUSE
```

## Cause du bug

Le code vérifiait `gameState.isPaused()` pour savoir où retourner, mais quand on clique sur OPTIONS, l'état change à `SETTINGS`, donc `isPaused()` retourne `false`.

### Code problématique
```javascript
document.getElementById('btn-back-menu').onclick = () => {
    // ❌ isPaused() retourne false car on est en SETTINGS
    if(gameState.isPaused()) {
        switchState(GameStates.PAUSED);
    } else {
        switchState(GameStates.MENU);
    }
};
```

## Solution implémentée

Ajout d'une variable `previousState` pour mémoriser l'état avant d'aller dans SETTINGS.

### Code corrigé

**1. Variable de mémorisation**
```javascript
// Mémoriser l'état avant d'aller dans SETTINGS
let previousState = null;
```

**2. Sauvegarder l'état depuis le MENU**
```javascript
document.getElementById('btn-settings').onclick = () => {
    previousState = GameStates.MENU; // ✅ Vient du menu principal
    document.getElementById('screen-menu').style.display = 'none';
    switchState(GameStates.SETTINGS);
};
```

**3. Sauvegarder l'état depuis la PAUSE**
```javascript
document.getElementById('btn-settings-pause').onclick = () => {
    previousState = GameStates.PAUSED; // ✅ Vient du menu pause
    document.getElementById('screen-pause').style.display = 'none';
    switchState(GameStates.SETTINGS);
};
```

**4. Utiliser previousState pour le retour**
```javascript
document.getElementById('btn-back-menu').onclick = () => {
    document.getElementById('screen-settings').style.display = 'none';
    // ✅ Retour à l'état précédent (MENU ou PAUSED)
    if(previousState === GameStates.PAUSED) {
        switchState(GameStates.PAUSED);
    } else {
        switchState(GameStates.MENU);
    }
    previousState = null; // Reset
};
```

## Flux corrigé

### Depuis le MENU PRINCIPAL
```
MENU → OPTIONS → RETOUR → MENU
  ↓       ↑
  └───────┘
(previousState = MENU)
```

### Depuis la PAUSE
```
PAUSE → OPTIONS → RETOUR → PAUSE
  ↓        ↑
  └────────┘
(previousState = PAUSED)
```

## Tests de validation

### Test 1 : Navigation depuis MENU
1. ✅ Menu principal → OPTIONS
2. ✅ OPTIONS → RETOUR → Menu principal

### Test 2 : Navigation depuis PAUSE
1. ✅ Jouer → PAUSE
2. ✅ PAUSE → OPTIONS
3. ✅ OPTIONS → RETOUR → PAUSE (la partie continue)
4. ✅ REPRENDRE → Retour au jeu

### Test 3 : Alternance
1. ✅ Menu → OPTIONS → RETOUR → Menu
2. ✅ Jouer → PAUSE → OPTIONS → RETOUR → PAUSE
3. ✅ QUITTER → Menu → OPTIONS → RETOUR → Menu

## Fichiers modifiés

**`js/menuManager.js`** (+6 lignes)
- Ajout de `previousState = null`
- Sauvegarde de l'état avant SETTINGS (2 endroits)
- Utilisation de `previousState` pour le retour
- Reset de `previousState` après utilisation

## Impact

- ✅ **Correction du bug** : Navigation correcte depuis PAUSE
- ✅ **Pas de régression** : Navigation depuis MENU fonctionne toujours
- ✅ **Code propre** : Solution simple et maintenable
- ✅ **Expérience utilisateur** : Plus de perte de partie accidentelle

## Avant / Après

### Avant (bugué)
```
Partie en cours
  ↓
PAUSE → OPTIONS → RETOUR
  ↓
❌ MENU (partie perdue !)
```

### Après (corrigé)
```
Partie en cours
  ↓
PAUSE → OPTIONS → RETOUR
  ↓
✅ PAUSE (partie préservée)
  ↓
REPRENDRE → Partie continue
```

## Notes techniques

### Pourquoi pas utiliser un historique d'états ?

Une pile d'états serait plus générique mais surdimensionnée pour ce cas simple :
- On a seulement 2 chemins vers SETTINGS (MENU et PAUSE)
- Une variable suffit
- Plus facile à comprendre et maintenir

### Alternative considérée

Passer l'état précédent en paramètre à `switchState()` :
```javascript
switchState(GameStates.SETTINGS, GameStates.PAUSED)
```

Mais cela compliquerait l'API pour un seul cas d'usage.

## Conclusion

Bug corrigé avec une solution simple et efficace. La navigation est maintenant cohérente dans tous les scénarios.

---

**Corrigé le 8 décembre 2025**
**Fichier modifié** : `js/menuManager.js`
**Lignes ajoutées** : +6
