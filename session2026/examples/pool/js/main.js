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

    // Lumières
    scene.add(new THREE.AmbientLight(0xffffff, 0.4));
    const light = new THREE.SpotLight(0xffffff, 800);
    light.position.set(0, 15, 0);
    light.castShadow = true;
    light.shadow.mapSize.set(2048, 2048);
    scene.add(light);

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
    
    // Reset au Joueur 1
    gameState.resetPlayer();
    updateHUD();
}

function onGameStart() {
    // Called when game starts from menu
    console.log('Game started!');
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

// --- DETECTION FIN DE PARTIE ---
function checkWinCondition() {
    // Only check during gameplay
    if (!gameState.isPlaying()) return;
    
    // 1. Si la blanche est tombée -> Perdu
    if (whiteBall.inPocket) {
        triggerGameOver(false, "Faute : Blanche empochée !");
        return;
    }

    // 2. Si la noire (8) est tombée
    const blackBall = balls.find(b => b.number === 8);
    if (blackBall && blackBall.inPocket) {
        // Check if all other balls (except white and black) are pocketed
        const otherBalls = balls.filter(b => b.number !== 0 && b.number !== 8);
        const allOthersPocketed = otherBalls.every(b => b.inPocket);
        
        if (allOthersPocketed) {
            triggerGameOver(true, "Parfait ! Toutes les billes empochées !");
        } else {
            triggerGameOver(false, "Noire empochée trop tôt !");
        }
        return;
    }
    
    // 3. Logic simple : Si toutes les billes (sauf blanche et noire) sont rentrées
    const regularBalls = balls.filter(b => b.number !== 0 && b.number !== 8);
    const allRegularsPocketed = regularBalls.every(b => b.inPocket);
    
    if (allRegularsPocketed && blackBall && !blackBall.inPocket) {
        // All regular balls pocketed, only black ball remains
        // Player can now try to pocket the black ball
        console.log('Toutes les billes empochées sauf la noire !');
    }
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
}
