// ui.js
// Interface utilisateur : GUI, contrôles de visée et gestion des événements

import * as THREE from 'three';
import GUI from 'lil-gui';
import { BALL_RADIUS } from './constants.js';
import { gameState, GameStates } from './gameState.js';

// Variables globales
let scene, camera, controls, whiteBall, cueStick, aimLine;
let params = null;

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
    const gui = new GUI({ title: 'Billard Physique' });
    
    gui.add(params, 'cueHeight', -BALL_RADIUS * 0.8, BALL_RADIUS * 0.8)
        .name('↕ Point d\'impact')
        .onChange(() => {
            if (cueStick.visible) cueStick.position.y = BALL_RADIUS + params.cueHeight;
        });
    
    gui.add(params, 'maxPower', 10, 50).name('Puissance Max');
    
    const f = gui.addFolder('Réglages Physique').close();
    f.add(params, 'muSlide', 0.05, 0.5).name('Frottement Tapis');
    f.add(params, 'muRoll', 0.001, 0.1).name('Résist. Roulement');
    f.add(params, 'restitution', 0.1, 1.0).name('Rebond Billes');
    f.add(params, 'wallRestitution', 0.1, 1.0).name('Rebond Bandes');
    
    return gui;
}

export function setupEventListeners() {
    window.addEventListener('resize', onResize);
    window.addEventListener('mousedown', onMouseDown);
    window.addEventListener('mousemove', onMouseMove);
    window.addEventListener('mouseup', onMouseUp);
    window.addEventListener('keydown', (e) => {
        if (e.code === 'Space') window.resetGame();
    });
}

// --- LOGIQUE CAMERA & VISÉE ---
function onMouseDown(e) {
    // Only allow interaction when game is idle (not in menu, pause, settings, etc)
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

function focusCameraOnTarget(target) {
    const direction = new THREE.Vector3().subVectors(target.pos, whiteBall.pos).normalize();
    const angle = Math.atan2(direction.z, direction.x);
    mouseState.angle = angle;
    
    const camPos = whiteBall.pos.clone()
        .sub(direction.clone().multiplyScalar(8))
        .add(new THREE.Vector3(0, 10, 0));
    
    camera.position.copy(camPos);
    controls.target.copy(whiteBall.pos);
    controls.update();
    
    cueStick.visible = true;
    cueStick.position.copy(whiteBall.pos);
    cueStick.position.y = BALL_RADIUS + params.cueHeight;
    cueStick.rotation.y = -angle - Math.PI / 2;
    cueStick.translateZ(0.2);
    
    aimLine.visible = true;
    aimLine.position.copy(whiteBall.pos);
    aimLine.rotation.y = -angle;
}

function onMouseMove(e) {
    if (!mouseState.isAiming) return;
    
    updateMouse(e);
    raycaster.setFromCamera(mouse, camera);
    raycaster.ray.intersectPlane(planeY, mouseState.currentPos);
    
    const v = new THREE.Vector3().subVectors(whiteBall.pos, mouseState.currentPos);
    const angle = Math.atan2(v.z, v.x);
    const dist = Math.min(v.length() * 4, params.maxPower);
    
    mouseState.angle = angle;
    mouseState.power = dist;

    cueStick.position.copy(whiteBall.pos);
    cueStick.position.y = BALL_RADIUS + params.cueHeight;
    cueStick.rotation.y = -angle - Math.PI / 2;
    cueStick.translateZ(dist * 0.1);

    aimLine.position.copy(whiteBall.pos);
    aimLine.rotation.y = -angle;
}

function onMouseUp() {
    if (!mouseState.isAiming) return;
    
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
