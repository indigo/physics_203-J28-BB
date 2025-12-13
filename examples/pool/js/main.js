// main.js
// Point d'entrée principal : initialisation, boucle de jeu et gestion globale

import * as THREE from 'three';
import { OrbitControls } from 'jsm/controls/OrbitControls.js';
import { BilliardBall, setParams as setBallParams } from './ball.js';
import { createTable } from './table.js';
import { updatePhysics, setParams as setPhysicsParams } from './physics.js';
import { setupGUI, setupEventListeners, setGlobalVariables, updateWhiteBall } from './ui.js';
import { TABLE_W, TABLE_H, BALL_RADIUS, INERTIA, BALL_MASS } from './constants.js';
import { gameState, GameStates } from './gameState.js';
import { setupUI, switchState, triggerGameOver, setMenuCallbacks, updateHUD } from './menuManager.js';
import { botManager } from './botManager.js';

// --- PARAMÈTRES MODIFIABLES ---
export const params = {
    muSlide: 0.2,    // Coefficient de glissement (Tapis)
    muRoll: 0.07,    // Résistance au roulement
    restitution: 0.90, // Rebond billes
    wallRestitution: 0.6,
    maxPower: 25.0, 
    cueHeight: 0.0, 
    showDebug: false
};

// Variables globales
export let scene, camera, renderer, controls, gui;
export let balls = [], whiteBall;
let cueStick, aimLine;

// Suivi du tour actuel (pour le système 2 joueurs)
let turnInfo = {
    whiteScratched: false,
    ballsPotted: []
};

// Initialisation
init();

function init() {
    scene = new THREE.Scene();
    scene.background = new THREE.Color(0x050505);
    
    camera = new THREE.PerspectiveCamera(45, window.innerWidth / window.innerHeight, 0.1, 100);
    camera.position.set(0, 12, 10);
    camera.lookAt(0, 0, 0);

    renderer = new THREE.WebGLRenderer({ antialias: true });
    renderer.setSize(window.innerWidth, window.innerHeight);
    renderer.shadowMap.enabled = true;
    document.body.appendChild(renderer.domElement);

    // Lumières - Éclairage amélioré pour bien voir le modèle
    scene.add(new THREE.AmbientLight(0xffffff, 0.6));  // Augmenté de 0.4 à 0.6
    
    // Lumière principale (au-dessus)
    const mainLight = new THREE.SpotLight(0xffffff, 1200);  // Augmenté de 800 à 1200
    mainLight.position.set(0, 15, 0);
    mainLight.castShadow = true;
    mainLight.shadow.mapSize.set(2048, 2048);
    mainLight.angle = Math.PI / 3;  // Angle plus large
    scene.add(mainLight);
    
    // Lumières d'appoint pour éviter les zones trop sombres
    const fillLight1 = new THREE.DirectionalLight(0xffffff, 0.3);
    fillLight1.position.set(10, 10, 10);
    scene.add(fillLight1);
    
    const fillLight2 = new THREE.DirectionalLight(0xffffff, 0.3);
    fillLight2.position.set(-10, 10, -10);
    scene.add(fillLight2);

    // Configuration
    setBallParams(params);
    setPhysicsParams(params);

    // Construction de la scène
    createTable(scene);
    resetGame();
    createCue();
    
    // Contrôles
    controls = new OrbitControls(camera, renderer.domElement);
    controls.enableDamping = true;
    controls.maxPolarAngle = Math.PI / 2 - 0.1;
    
    // UI et contrôles
    setGlobalVariables(scene, camera, controls, whiteBall, cueStick, aimLine, params);
    gui = setupGUI(params);
    setupEventListeners();

    // Rendre les variables globales accessibles pour les fonctions UI
    window.balls = balls;
    window.whiteBall = whiteBall;
    window.renderer = renderer;
    window.resetGame = resetGame;
    window.resetWhiteBall = resetWhiteBall;
    window.shootBall = shootBall;

    // Setup menu system
    setMenuCallbacks(onGameStart, resetGame, controls);
    setupUI();
    switchState(GameStates.MENU);

    renderer.setAnimationLoop(animate);
}

function createCue() {
    const g = new THREE.CylinderGeometry(0.04, 0.08, 3, 12);
    g.rotateX(-Math.PI / 2);
    g.translate(0, 0, 1.7);
    
    cueStick = new THREE.Mesh(g, new THREE.MeshStandardMaterial({ color: 0xdeb887 }));
    scene.add(cueStick);
    cueStick.visible = false;

    aimLine = new THREE.Line(
        new THREE.BufferGeometry().setFromPoints([
            new THREE.Vector3(0, 0, 0), 
            new THREE.Vector3(3, 0, 0)
        ]), 
        new THREE.LineBasicMaterial({ color: 0xffffff, transparent: true, opacity: 0.5 })
    );
    scene.add(aimLine);
    aimLine.visible = false;
}

export function resetGame() {
    // Nettoyer les billes existantes
    balls.forEach(b => scene.remove(b.mesh));
    balls = [];
    
    // Créer la nouvelle configuration
    whiteBall = new BilliardBall(-TABLE_W / 4, 0, 0);
    scene.add(whiteBall.mesh);
    balls.push(whiteBall);
    
    const startX = TABLE_W / 4;
    const rS = BALL_RADIUS * 1.732;
    const cS = BALL_RADIUS * 2.01;
    const p = [1, 10, 2, 3, 8, 11, 12, 5, 13, 4, 6, 14, 7, 15, 9];
    
    let k = 0;
    for (let r = 0; r < 5; r++) {
        for (let i = 0; i <= r; i++) {
            const ball = new BilliardBall(startX + r * rS, (i - r / 2) * cS, p[k++]);
            scene.add(ball.mesh);
            balls.push(ball);
        }
    }
    
    // Mettre à jour les variables globales
    window.balls = balls;
    window.whiteBall = whiteBall;
    
    // Update whiteBall reference in ui.js
    updateWhiteBall(whiteBall);
    
    // Reset game state only if not in menu
    if (!gameState.isMenu()) {
        gameState.setState(GameStates.IDLE);
    }
    
    // Reset au Joueur 1 et réinitialiser les balles capturées
    gameState.resetPlayer();
    gameState.resetBalls();
    updateHUD();
}

function onGameStart() {
    // Called when game starts from menu
    console.log('Game started!');
    
    // Si c'est le mode Bot vs Bot ou si le Bot 1 doit jouer, le déclencher
    if (botManager.shouldBotPlay()) {
        setTimeout(() => {
            botManager.playBotTurn(whiteBall, balls, shootBall);
        }, 1000); // Petit délai pour que le joueur voie la table
    }
}

export function resetWhiteBall() {
    whiteBall.inPocket = false;
    whiteBall.mesh.visible = true;
    whiteBall.pos.set(-TABLE_W / 4, BALL_RADIUS, 0);
    whiteBall.vel.set(0, 0, 0);
    whiteBall.angVel.set(0, 0, 0);
}

// --- NOUVEAU SHOOT : Gère correctement la vitesse angulaire ---
export function shootBall(angle, power) {
    // Réinitialiser les infos du tour au moment du tir
    turnInfo = {
        whiteScratched: false,
        ballsPotted: []
    };
    
    const dir = new THREE.Vector3(Math.cos(angle), 0, Math.sin(angle));
    
    // 1. Vitesse Linéaire
    const speed = power;
    whiteBall.vel.copy(dir.clone().multiplyScalar(speed));
    
    // 2. Vitesse Angulaire (Coup décentré)
    const h = params.cueHeight;
    const impactPoint = new THREE.Vector3(0, h, 0);
    
    // Force appliquée dans la direction du tir
    const forceDir = dir.clone();
    const forceMag = power * BALL_MASS * 50; // Facteur arbitraire pour sentir l'effet
    const forceVec = forceDir.multiplyScalar(forceMag);

    // Torque = r x F
    const torque = new THREE.Vector3().crossVectors(impactPoint, forceVec);
    
    // Angular Acc = Torque / Inertia -> AngVel += Angular Acc * dt (impulse approximation)
    const impulseDt = 0.01; // Temps de contact fictif
    whiteBall.angVel.add(torque.divideScalar(INERTIA).multiplyScalar(impulseDt));
    
    // IMPORTANT : Changer l'état en SHOOTING pour que la physique détecte la fin du mouvement
    gameState.setState(GameStates.SHOOTING);
}

// --- MOTEUR PHYSIQUE ---
function animate() {
    // Si PAUSED, on arrête la physique mais on continue le rendu
    if (gameState.isPaused() || gameState.isSettings()) {
        renderer.render(scene, camera);
        return;
    }

    controls.update();
    
    // Physique active en MENU (pour l'effet visuel) et pendant le jeu
    if (gameState.isPlaying() || gameState.isMenu()) {
        // Passer turnInfo à updatePhysics pour tracker les billes empochées
        updatePhysics(balls, 0.016, gameState.isPlaying() ? turnInfo : null);
        
        // Check if all balls have stopped moving (only during gameplay)
        if (gameState.isShooting()) {
            const allStopped = balls.every(b => 
                b.inPocket || b.vel.lengthSq() < 0.0001
            );
            
            if (allStopped) {
                gameState.setState(GameStates.IDLE);
                
                // Logique de changement de tour
                handleTurnEnd();
                
                checkWinCondition();
            }
        }
    }
    
    // Camera rotation in menu for visual effect
    if (gameState.isMenu()) {
        const time = Date.now() * 0.0003;
        camera.position.x = Math.sin(time) * 12;
        camera.position.z = Math.cos(time) * 12;
        camera.lookAt(0, 0, 0);
    }
    
    renderer.render(scene, camera);
}

// --- DETECTION FIN DE PARTIE (CORRIGÉE - Règles WPA 8-Ball) ---
function checkWinCondition() {
    // On ne vérifie que si le jeu est en cours
    if (!gameState.isPlaying()) return;
    
    const blackBall = balls.find(b => b.number === 8);

    // CAS CRITIQUE : La Noire est tombée
    if (blackBall && blackBall.inPocket) {
        
        // 1. Si la Blanche est AUSSI tombée en même temps -> DÉFAITE
        if (whiteBall.inPocket) {
            triggerGameOver(false, "DÉFAITE : Blanche et Noire empochées !");
            return;
        }

        // 2. Vérifier si le joueur avait le droit de rentrer la noire
        // (Toutes les autres billes - sauf blanche et noire - doivent être rentrées)
        const otherBalls = balls.filter(b => b.number !== 0 && b.number !== 8);
        const allOthersPocketed = otherBalls.every(b => b.inPocket);
        
        if (allOthersPocketed) {
            triggerGameOver(true, "VICTOIRE ! Table nettoyée.");
        } else {
            triggerGameOver(false, "DÉFAITE : Noire empochée trop tôt !");
        }
        return;
    }
    
    // Si SEULEMENT la blanche est tombée :
    // Ce n'est PAS un Game Over. C'est juste une faute.
    // La fonction handleTurnEnd() s'occupera de passer la main à l'adversaire.
    // Et physics.js s'occupera de remettre la blanche sur la table via le setTimeout.
}

// --- GESTION DES TOURS (2 JOUEURS) ---
function handleTurnEnd() {
    let switchTurn = true;
    let message = "";

    // 1. Faute : La blanche est tombée
    if (turnInfo.whiteScratched) {
        message = "Faute ! Blanche empochée.";
        switchTurn = true;
    }
    // 2. Succès : Au moins une bille (autre que blanche/noire) est tombée
    else if (turnInfo.ballsPotted.length > 0) {
        const hasBlack = turnInfo.ballsPotted.includes(8);
        
        if (!hasBlack) {
            // Bon tir ! Le joueur garde la main
            // Enregistrer les balles capturées pour le joueur actuel
            turnInfo.ballsPotted.forEach(ballNum => {
                gameState.addBallToCurrentPlayer(ballNum);
            });
            switchTurn = false;
            message = "Joli coup ! Rejouez.";
        }
        // Si la noire est tombée, checkWinCondition() gère la victoire/défaite
    }
    // 3. Rien n'est tombé
    else {
        switchTurn = true;
        message = "Raté ! Au tour de l'adversaire.";
    }

    if (switchTurn) {
        gameState.switchPlayer();
    }
    
    // Mettre à jour l'affichage du joueur
    updateHUD();
    
    console.log(`Fin du tour. Empochées: ${turnInfo.ballsPotted.length}. Faute: ${turnInfo.whiteScratched}. Prochain: J${gameState.getCurrentPlayer()}`);
    if (message) console.log(message);
    
    // NOUVEAU : Vérifier si c'est au tour du bot
    if (botManager.shouldBotPlay()) {
        // Petit délai pour que le joueur voie le changement
        setTimeout(() => {
            botManager.playBotTurn(whiteBall, balls, shootBall);
        }, 500);
    }
}
