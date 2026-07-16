// menuManager.js
// Gestion des écrans UI, transitions et logique de menu

import { gameState, GameStates } from './gameState.js';

// Settings
export const settings = {
    musicVol: 0.5,
    sfxVol: 0.8,
    lang: 'fr'
};

// Textes (Localization)
const TEXTS = {
    fr: { 
        win: "VICTOIRE !", 
        lose: "DÉFAITE...", 
        msgWin: "Table nettoyée !", 
        msgLose: "La blanche est tombée ou faute.",
        niceShotContinue: "Joli coup ! Rejouez.",
        foulScratch: "Faute ! Blanche empochée.",
        missedTurn: "Raté ! Au tour de l'adversaire."
    },
    en: { 
        win: "YOU WIN!", 
        lose: "GAME OVER", 
        msgWin: "Table cleared!", 
        msgLose: "Scratch or foul.",
        niceShotContinue: "Nice shot! Play again.",
        foulScratch: "Foul! White ball pocketed.",
        missedTurn: "Missed! Opponent's turn."
    }
};

// Variables globales pour les callbacks
let onPlayCallback = null;
let onResetCallback = null;
let controls = null;

// Mémoriser l'état avant d'aller dans SETTINGS
let previousState = null;

export function setMenuCallbacks(onPlay, onReset, ctrls) {
    onPlayCallback = onPlay;
    onResetCallback = onReset;
    controls = ctrls;
}

// Fonction principale pour changer d'état et afficher le bon écran
export function switchState(newState) {
    gameState.setState(newState);
    
    // Cacher tous les écrans
    ['screen-menu', 'screen-settings', 'screen-hud', 'screen-pause', 'screen-gameover'].forEach(id => {
        const el = document.getElementById(id);
        if (el) el.style.display = 'none';
    });

    // Logique par état
    switch(newState) {
        case GameStates.MENU:
            document.getElementById('screen-menu').style.display = 'flex';
            if (controls) controls.enabled = true;
            break;
            
        case GameStates.IDLE:
        case GameStates.AIMING:
        case GameStates.SHOOTING:
            document.getElementById('screen-hud').style.display = 'block';
            if (controls) controls.enabled = true;
            updateHUD();
            break;
            
        case GameStates.PAUSED:
            document.getElementById('screen-hud').style.display = 'block';
            document.getElementById('screen-pause').style.display = 'flex';
            if (controls) controls.enabled = false;
            break;
            
        case GameStates.SETTINGS:
            document.getElementById('screen-settings').style.display = 'flex';
            break;
            
        case GameStates.GAME_OVER:
            document.getElementById('screen-gameover').style.display = 'flex';
            if (controls) controls.enabled = false;
            break;
    }
}

// Mise à jour du HUD
export function updateHUD() {
    const player = gameState.getCurrentPlayer();
    const t = TEXTS[settings.lang];
    
    const label = settings.lang === 'fr' ? `Joueur ${player}` : `Player ${player}`;
    const el = document.getElementById('score-display');
    
    el.innerText = label;
    
    // Couleur distinctive par joueur
    if (player === 1) {
        el.style.borderLeft = "5px solid #0055ff"; // Bleu pour J1
        el.style.color = "white";
    } else {
        el.style.borderLeft = "5px solid #ff5500"; // Orange pour J2
        el.style.color = "white";
    }
}

// Afficher l'écran de fin de partie
export function triggerGameOver(isWin, reason) {
    switchState(GameStates.GAME_OVER);
    const t = TEXTS[settings.lang];
    document.getElementById('end-title').innerText = isWin ? t.win : t.lose;
    document.getElementById('end-message').innerText = reason || (isWin ? t.msgWin : t.msgLose);
    document.getElementById('end-title').style.color = isWin ? '#2e8b57' : '#8b0000';
}

// Configuration des événements UI
export function setupUI() {
    // MENU
    document.getElementById('btn-play').onclick = () => {
        if (onResetCallback) onResetCallback();
        switchState(GameStates.IDLE);
        if (onPlayCallback) onPlayCallback();
    };
    
    document.getElementById('btn-settings').onclick = () => {
        previousState = GameStates.MENU; // Vient du menu principal
        document.getElementById('screen-menu').style.display = 'none';
        switchState(GameStates.SETTINGS);
    };

    document.getElementById('btn-credits').onclick = () => {
        alert('Billard Master 3D\nDéveloppé avec Three.js\n© 2024');
    };

    // SETTINGS
    document.getElementById('btn-back-menu').onclick = () => {
        document.getElementById('screen-settings').style.display = 'none';
        // Retour à l'état précédent (MENU ou PAUSED)
        if(previousState === GameStates.PAUSED) {
            switchState(GameStates.PAUSED);
        } else {
            switchState(GameStates.MENU);
        }
        previousState = null; // Reset
    };
    
    document.getElementById('vol-music').oninput = (e) => { 
        settings.musicVol = parseFloat(e.target.value);
        // TODO: Update Audio when implemented
    };
    
    document.getElementById('vol-sfx').oninput = (e) => { 
        settings.sfxVol = parseFloat(e.target.value);
        // TODO: Update Audio when implemented
    };
    
    document.getElementById('lang-select').onchange = (e) => { 
        settings.lang = e.target.value;
        updateHUD();
    };

    // HUD / PAUSE
    document.getElementById('btn-pause').onclick = () => {
        switchState(GameStates.PAUSED);
    };
    
    document.getElementById('btn-resume').onclick = () => {
        switchState(GameStates.IDLE);
    };
    
    document.getElementById('btn-settings-pause').onclick = () => {
        previousState = GameStates.PAUSED; // Vient du menu pause
        document.getElementById('screen-pause').style.display = 'none';
        switchState(GameStates.SETTINGS);
    };
    
    document.getElementById('btn-quit').onclick = () => {
        switchState(GameStates.MENU);
    };

    // GAME OVER
    document.getElementById('btn-restart').onclick = () => {
        if (onResetCallback) onResetCallback();
        switchState(GameStates.IDLE);
    };
    
    document.getElementById('btn-quit-end').onclick = () => {
        switchState(GameStates.MENU);
    };
}
