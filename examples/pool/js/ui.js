// ui.js
// Interface utilisateur : GUI, contrôles de visée et gestion des événements

import * as THREE from 'three';
import GUI from 'lil-gui';
import { BALL_RADIUS, TABLE_W, TABLE_H } from './constants.js';
import { gameState, GameStates } from './gameState.js';
import { PhysicsSimulator } from './simulator.js';

// Variables globales
let scene, camera, controls, whiteBall, cueStick, aimLine;
let params = null;
let simulator = new PhysicsSimulator();
let guideLines = [];

// État de la souris
const mouseState = {
    isAiming: false,
    startPos: new THREE.Vector3(),
    currentPos: new THREE.Vector3(),
    power: 0,
    angle: 0
};

const raycaster = new THREE.Raycaster();
const mouse = new THREE.Vector2();
const planeY = new THREE.Plane(new THREE.Vector3(0, 1, 0), 0);

export function setGlobalVariables(s, c, ctrls, wb, cs, al, p) {
    scene = s;
    camera = c;
    controls = ctrls;
    whiteBall = wb;
    cueStick = cs;
    aimLine = al;
    params = p;
}

export function updateWhiteBall(wb) {
    whiteBall = wb;
}

export function setupGUI(params) {
    const gui = new GUI({ title: 'Billard Pro' });
    gui.add(params, 'cueHeight', -BALL_RADIUS * 0.8, BALL_RADIUS * 0.8).name('Effet (Haut/Bas)');
    gui.add(params, 'showDebug').name('Ligne de visée (Cheat)').onChange(v => clearGuideLines());
    return gui;
}

export function setupEventListeners() {
    window.addEventListener('resize', onResize);
    window.addEventListener('mousedown', onMouseDown);
    window.addEventListener('mousemove', onMouseMove);
    window.addEventListener('mouseup', onMouseUp);
    
    // --- SUPPORT MOBILE (TOUCH) ---
    window.addEventListener('touchstart', (e) => {
        if(e.touches.length > 0) {
            const touch = e.touches[0];
            const fakeEvent = { clientX: touch.clientX, clientY: touch.clientY, target: e.target };
            onMouseDown(fakeEvent);
        }
    }, {passive: false});

    window.addEventListener('touchmove', (e) => {
        if(e.touches.length > 0) {
            const touch = e.touches[0];
            const fakeEvent = { clientX: touch.clientX, clientY: touch.clientY };
            onMouseMove(fakeEvent);
        }
    }, {passive: false});

    window.addEventListener('touchend', (e) => {
        onMouseUp();
    });

    window.addEventListener('keydown', (e) => {
        if (e.code === 'Space') window.resetGame();
    });
}

// --- LOGIQUE CAMERA & VISÉE ---
function onMouseDown(e) {
    // Si on clique sur l'interface (boutons), on ignore
    if (e.target.closest && (e.target.closest('button') || e.target.closest('.screen'))) return;
    if (!gameState.canAim() || !gameState.isPlaying()) return;
    
    updateMouse(e);
    raycaster.setFromCamera(mouse, camera);

    const intersects = raycaster.intersectObjects(window.balls.map(b => b.mesh));
    if (intersects.length > 0) {
        const hitObj = intersects[0].object;
        if (hitObj === whiteBall.mesh) {
            mouseState.isAiming = true;
            gameState.setState(GameStates.AIMING);
            controls.enabled = false;
            raycaster.ray.intersectPlane(planeY, mouseState.startPos);
            cueStick.visible = true;
            cueStick.position.y = BALL_RADIUS + params.cueHeight;
            aimLine.visible = true;
        } else {
            focusCameraOnTarget(window.balls.find(b => b.mesh === hitObj));
        }
    }
}

export function focusCameraOnTarget(target) {
    const direction = new THREE.Vector3().subVectors(target.pos, whiteBall.pos).normalize();
    const angle = Math.atan2(direction.z, direction.x);
    mouseState.angle = angle;
    
    // Position caméra type "TV Broadcast"
    const camPos = whiteBall.pos.clone()
        .sub(direction.clone().multiplyScalar(7))
        .add(new THREE.Vector3(0, 8, 0));
    
    camera.position.copy(camPos);
    controls.target.copy(whiteBall.pos);
    controls.update();
}

function onMouseMove(e) {
    if (!mouseState.isAiming) return;
    
    updateMouse(e);
    raycaster.setFromCamera(mouse, camera);
    raycaster.ray.intersectPlane(planeY, mouseState.currentPos);
    
    const v = new THREE.Vector3().subVectors(whiteBall.pos, mouseState.currentPos);
    const angle = Math.atan2(v.z, v.x);
    const dist = Math.min(v.length() * 3, params.maxPower);
    
    mouseState.angle = angle;
    mouseState.power = dist;

    cueStick.position.copy(whiteBall.pos);
    cueStick.position.y = BALL_RADIUS + params.cueHeight;
    cueStick.rotation.y = -angle - Math.PI / 2;
    cueStick.translateZ(dist * 0.1 + 0.2);

    aimLine.position.copy(whiteBall.pos);
    aimLine.rotation.y = -angle;

    // --- LE POUVOIR : Visualisation de trajectoire (Simulation) ---
    if (params.showDebug) {
        updatePredictionLine();
    }
}

function updatePredictionLine() {
    const result = simulator.simulateShot(
        mouseState.angle,
        mouseState.power,
        params.cueHeight,
        window.balls,
        window.whiteBall
    );

    clearGuideLines();
    const material = new THREE.LineBasicMaterial({ color: 0xffffff, transparent: true, opacity: 0.4 });
    
    if (result.finalWhitePos) {
        const points = [whiteBall.pos.clone(), result.finalWhitePos];
        points.forEach(p => p.y = BALL_RADIUS);
        
        const geometry = new THREE.BufferGeometry().setFromPoints(points);
        const line = new THREE.Line(geometry, material);
        scene.add(line);
        guideLines.push(line);
    }
}

function clearGuideLines() {
    guideLines.forEach(l => scene.remove(l));
    guideLines = [];
}

function onMouseUp() {
    if (!mouseState.isAiming) return;
    
    clearGuideLines();
    window.shootBall(mouseState.angle, mouseState.power);
    mouseState.isAiming = false;
    gameState.setState(GameStates.SHOOTING);
    cueStick.visible = false;
    aimLine.visible = false;
    controls.enabled = true;
}

function updateMouse(e) {
    mouse.x = (e.clientX / window.innerWidth) * 2 - 1;
    mouse.y = -(e.clientY / window.innerHeight) * 2 + 1;
}

function onResize() {
    camera.aspect = window.innerWidth / window.innerHeight;
    camera.updateProjectionMatrix();
    window.renderer.setSize(window.innerWidth, window.innerHeight);
}
