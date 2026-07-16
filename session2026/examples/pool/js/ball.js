// ball.js
// Classe BilliardBall avec physique de glissement, rotation et rendu

import * as THREE from 'three';
import { BALL_RADIUS, BALL_MASS, GRAVITY, INERTIA } from './constants.js';

// Paramètres globaux (seront mis à jour depuis main.js)
let params = null;

export function setParams(p) {
    params = p;
}

// --- CLASSE BALLE ---
export class BilliardBall {
    constructor(x, z, number) {
        this.number = number; // Store ball number for game logic
        this.pos = new THREE.Vector3(x, BALL_RADIUS, z);
        this.vel = new THREE.Vector3(0, 0, 0);
        this.angVel = new THREE.Vector3(0, 0, 0); // Vitesse angulaire (rad/s)
        this.quat = new THREE.Quaternion();
        this.inPocket = false;
        
        // Visuals
        const colors = {1:0xeebb00, 2:0x0000ee, 3:0xee0000, 4:0x800080, 5:0xffa500, 6:0x006400, 7:0x800000, 8:0x111111};
        let c = (number > 8 ? colors[number - 8] : colors[number]) || 0x000000;
        const geo = new THREE.SphereGeometry(BALL_RADIUS, 32, 16);
        const mat = new THREE.MeshStandardMaterial({ 
            map: this.createBallTexture(number, c), 
            roughness: 0.1, 
            metalness: 0.1 
        });
        this.mesh = new THREE.Mesh(geo, mat);
        this.mesh.castShadow = true;
        if (number !== 0) this.mesh.rotation.set(Math.random() * 6, Math.random() * 6, Math.random() * 6);
        this.mesh.position.copy(this.pos);
    }

    createBallTexture(number, colorHex) {
        const size = 512;
        const ctx = document.createElement('canvas').getContext('2d');
        ctx.canvas.width = size;
        ctx.canvas.height = size / 2;
        const w = size, h = size / 2;
        
        ctx.fillStyle = '#fffae6';
        ctx.fillRect(0, 0, w, h);
        
        if (number === 0) {
            ctx.fillStyle = '#ff0000';
            ctx.beginPath();
            ctx.arc(w * 0.5, h * 0.5, h * 0.05, 0, Math.PI * 2);
            ctx.fill();
            return new THREE.CanvasTexture(ctx.canvas);
        }
        
        ctx.fillStyle = '#' + new THREE.Color(colorHex).getHexString();
        if (number > 8) {
            ctx.fillRect(0, h * 0.25, w, h * 0.5);
        } else {
            ctx.fillRect(0, 0, w, h);
        }
        
        [w * 0.25, w * 0.75].forEach(x => {
            ctx.beginPath();
            ctx.arc(x, h * 0.5, h * 0.35, 0, Math.PI * 2);
            ctx.fillStyle = '#fffae6';
            ctx.fill();
            ctx.fillStyle = 'black';
            ctx.font = `bold ${h * 0.4}px Arial`;
            ctx.textAlign = 'center';
            ctx.textBaseline = 'middle';
            ctx.fillText(number, x, h * 0.52);
        });
        
        const t = new THREE.CanvasTexture(ctx.canvas);
        t.minFilter = THREE.LinearFilter;
        return t;
    }

    update(dt) {
        if (this.inPocket) return;

        // 1. Calcul de la vitesse relative au point de contact (v_slide)
        // v_contact = v + (omega x r)
        // r est le vecteur du centre vers le bas (0, -R, 0)
        const rVector = new THREE.Vector3(0, -BALL_RADIUS, 0);
        const vRot = new THREE.Vector3().crossVectors(this.angVel, rVector);
        const vSlide = new THREE.Vector3().addVectors(this.vel, vRot);
        vSlide.y = 0; // On reste sur le plan 2D

        const slideSpeed = vSlide.length();

        // 2. Application des forces
        if (slideSpeed > 0.01) {
            // --- ETAT GLISSEMENT (SLIDING) ---
            // Force de friction opposée au glissement
            const frictionDir = vSlide.normalize().negate();
            const frictionMag = params.muSlide * BALL_MASS * GRAVITY;
            const frictionForce = frictionDir.multiplyScalar(frictionMag);

            // a. Impact sur la vitesse linéaire (F = ma)
            const linearAcc = frictionForce.clone().divideScalar(BALL_MASS);
            this.vel.addScaledVector(linearAcc, dt);

            // b. Impact sur la vitesse angulaire (Torque = r x F)
            const torque = new THREE.Vector3().crossVectors(rVector, frictionForce);
            const angularAcc = torque.divideScalar(INERTIA);
            this.angVel.addScaledVector(angularAcc, dt);
        } else {
            // --- ETAT ROULEMENT (ROLLING) ---
            // Résistance simple au roulement pour arrêter la bille progressivement
            const k = 1 - (params.muRoll * dt * 10);
            this.vel.multiplyScalar(k);
            this.angVel.multiplyScalar(k);
            
            // Seuil d'arrêt
            if (this.vel.lengthSq() < 0.0001) {
                this.vel.set(0, 0, 0);
                this.angVel.set(0, 0, 0);
            }
        }

        // 3. Intégration Position
        this.pos.addScaledVector(this.vel, dt);

        // 4. Intégration Rotation (Quaternion) via angVel réel
        const omegaLen = this.angVel.length();
        if (omegaLen > 0.000001) {
            const axis = this.angVel.clone().normalize();
            const angle = omegaLen * dt;
            const q = new THREE.Quaternion().setFromAxisAngle(axis, angle);
            this.quat.premultiply(q);
        }

        // 5. Mise à jour Mesh
        this.mesh.position.copy(this.pos);
        this.mesh.quaternion.copy(this.quat);
    }
}
