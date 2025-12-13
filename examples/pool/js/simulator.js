// simulator.js
// Simulateur de physique pour prédire les résultats des tirs (utilisé par le bot)

import * as THREE from 'three';
import { BALL_RADIUS, BALL_MASS, TABLE_W, TABLE_H, VAL_HOLE_RADIUS, VAL_OFFSET_CORNER, VAL_OFFSET_SIDE } from './constants.js';
import { walls2D } from './table.js';

export class PhysicsSimulator {
    constructor() {
        this.maxSteps = 500; // Nombre max d'itérations de simulation
        this.dt = 0.016; // Pas de temps (16ms)
        this.subSteps = 15; // Sous-étapes pour la précision
        
        // Paramètres physiques (copiés de physics.js)
        this.muSlide = 0.2;
        this.muRoll = 0.07;
        this.restitution = 0.90;
        this.wallRestitution = 0.6;
    }

    /**
     * Simule un tir complet et retourne les événements
     * @param {number} angle - Angle du tir
     * @param {number} power - Puissance du tir
     * @param {number} cueHeight - Hauteur du point d'impact (effet)
     * @param {Array} balls - Tableau des billes actuelles
     * @param {Object} whiteBall - La bille blanche
     * @returns {Object} Résultat de la simulation
     */
    simulateShot(angle, power, cueHeight, balls, whiteBall) {
        // Cloner l'état actuel des billes pour ne pas modifier l'original
        const simBalls = this.cloneBalls(balls);
        const simWhite = simBalls.find(b => b.number === 0);
        
        // Appliquer le tir initial
        const dir = new THREE.Vector3(Math.cos(angle), 0, Math.sin(angle));
        simWhite.vel.copy(dir.clone().multiplyScalar(power));
        
        // Appliquer l'effet (spin) si nécessaire
        if (cueHeight !== 0) {
            const impactPoint = new THREE.Vector3(0, cueHeight, 0);
            const forceDir = dir.clone();
            const forceMag = power * BALL_MASS * 50;
            const forceVec = forceDir.multiplyScalar(forceMag);
            const torque = new THREE.Vector3().crossVectors(impactPoint, forceVec);
            const INERTIA = 0.4 * BALL_MASS * BALL_RADIUS * BALL_RADIUS;
            const impulseDt = 0.01;
            simWhite.angVel.add(torque.divideScalar(INERTIA).multiplyScalar(impulseDt));
        }
        
        // Événements à tracker
        const events = {
            ballsPotted: [],
            whiteScratched: false,
            finalWhitePos: null,
            finalBallPositions: [],
            collisions: [],
            stoppedAt: 0
        };
        
        // Simulation de la physique
        let step = 0;
        while (step < this.maxSteps) {
            const allStopped = this.simulateStep(simBalls, events);
            
            if (allStopped) {
                events.stoppedAt = step;
                break;
            }
            
            step++;
        }
        
        // Enregistrer les positions finales
        events.finalWhitePos = simWhite.pos.clone();
        events.finalBallPositions = simBalls.map(b => ({
            number: b.number,
            pos: b.pos.clone(),
            inPocket: b.inPocket
        }));
        
        return events;
    }

    /**
     * Clone les billes pour la simulation
     */
    cloneBalls(balls) {
        return balls.map(ball => ({
            number: ball.number,
            pos: ball.pos.clone(),
            vel: ball.vel.clone(),
            angVel: ball.angVel.clone(),
            inPocket: ball.inPocket,
            mesh: null // Pas besoin du mesh dans la simulation
        }));
    }

    /**
     * Simule un pas de temps
     */
    simulateStep(balls, events) {
        const subDt = this.dt / this.subSteps;
        
        for (let s = 0; s < this.subSteps; s++) {
            // Collisions entre billes
            for (let i = 0; i < balls.length; i++) {
                for (let j = i + 1; j < balls.length; j++) {
                    const b1 = balls[i], b2 = balls[j];
                    if (b1.inPocket || b2.inPocket) continue;
                    
                    const dv = new THREE.Vector3().subVectors(b2.pos, b1.pos);
                    const d = dv.length();
                    
                    if (d < BALL_RADIUS * 2) {
                        const n = dv.normalize();
                        const pen = (BALL_RADIUS * 2 - d) * 0.5;
                        
                        b1.pos.sub(n.clone().multiplyScalar(pen));
                        b2.pos.add(n.clone().multiplyScalar(pen));
                        
                        const vRel = new THREE.Vector3().subVectors(b1.vel, b2.vel).dot(n);
                        if (vRel < 0) continue;
                        
                        const imp = n.multiplyScalar(-(1 + this.restitution) * vRel * 0.5);
                        b1.vel.add(imp);
                        b2.vel.sub(imp);
                        
                        // Enregistrer la collision
                        events.collisions.push({ ball1: b1.number, ball2: b2.number });
                    }
                }
            }

            // Collisions avec les murs
            balls.forEach(b => {
                if (b.inPocket) return;
                
                for (let w of walls2D) {
                    const abx = w.p2.x - w.p1.x;
                    const abz = w.p2.z - w.p1.z;
                    const apx = b.pos.x - w.p1.x;
                    const apz = b.pos.z - w.p1.z;
                    
                    let t = (apx * abx + apz * abz) / w.lenSq;
                    t = Math.max(0, Math.min(1, t));
                    
                    const cx = w.p1.x + t * abx;
                    const cz = w.p1.z + t * abz;
                    const dx = b.pos.x - cx;
                    const dz = b.pos.z - cz;
                    const dSq = dx * dx + dz * dz;
                    
                    if (dSq < BALL_RADIUS * BALL_RADIUS) {
                        const dist = Math.sqrt(dSq);
                        let nx, nz;
                        
                        if (dist < 1e-5) {
                            nx = w.normal.x;
                            nz = w.normal.z;
                        } else {
                            nx = dx / dist;
                            nz = dz / dist;
                        }
                        
                        b.pos.x += nx * (BALL_RADIUS - dist);
                        b.pos.z += nz * (BALL_RADIUS - dist);
                        
                        const vn = b.vel.x * nx + b.vel.z * nz;
                        if (vn < 0) {
                            const j = -(1 + this.wallRestitution) * vn;
                            b.vel.x += nx * j;
                            b.vel.z += nz * j;
                            b.angVel.multiplyScalar(0.9);
                        }
                    }
                }

                // Détection des trous
                this.checkPockets(b, events);

                // Mise à jour physique (friction, etc.)
                this.updateBallPhysics(b, subDt);
            });
        }
        
        // Vérifier si toutes les billes sont arrêtées
        return balls.every(b => b.inPocket || b.vel.lengthSq() < 0.0001);
    }

    /**
     * Vérifie si une bille tombe dans un trou
     */
    checkPockets(ball, events) {
        if (ball.inPocket) return;
        
        const W = TABLE_W / 2;
        const H = TABLE_H / 2;
        const dX = Math.cos(Math.PI / 4) * VAL_OFFSET_CORNER;
        const dZ = Math.sin(Math.PI / 4) * VAL_OFFSET_CORNER;
        
        const pockets = [
            { x: -W - dX, z: -H - dZ },
            { x: W + dX, z: -H - dZ },
            { x: 0, z: -H - VAL_OFFSET_SIDE },
            { x: -W - dX, z: H + dZ },
            { x: W + dX, z: H + dZ },
            { x: 0, z: H + VAL_OFFSET_SIDE }
        ];
        
        for (let p of pockets) {
            const dx = ball.pos.x - p.x;
            const dz = ball.pos.z - p.z;
            if (dx * dx + dz * dz < VAL_HOLE_RADIUS * VAL_HOLE_RADIUS) {
                ball.inPocket = true;
                ball.vel.set(0, 0, 0);
                ball.angVel.set(0, 0, 0);
                
                if (ball.number === 0) {
                    events.whiteScratched = true;
                } else {
                    events.ballsPotted.push(ball.number);
                }
                break;
            }
        }
    }

    /**
     * Met à jour la physique d'une bille (friction, roulement)
     */
    updateBallPhysics(ball, dt) {
        if (ball.inPocket) return;
        
        const speed = ball.vel.length();
        if (speed < 0.001) {
            ball.vel.set(0, 0, 0);
            ball.angVel.set(0, 0, 0);
            return;
        }
        
        // Friction de glissement
        const frictionForce = this.muSlide * BALL_MASS * 9.81;
        const frictionAcc = frictionForce / BALL_MASS;
        const velDir = ball.vel.clone().normalize();
        ball.vel.sub(velDir.multiplyScalar(frictionAcc * dt));
        
        // Friction de roulement
        const rollResistance = this.muRoll * 9.81;
        const newSpeed = Math.max(0, speed - rollResistance * dt);
        if (speed > 0) {
            ball.vel.multiplyScalar(newSpeed / speed);
        }
        
        // Décroissance du spin
        ball.angVel.multiplyScalar(Math.max(0, 1 - dt * 2));
        
        // Mise à jour de la position
        ball.pos.add(ball.vel.clone().multiplyScalar(dt));
    }
}
