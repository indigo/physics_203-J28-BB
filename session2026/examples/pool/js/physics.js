// physics.js
// Moteur physique : collisions, murs, trous et mise à jour des billes

import * as THREE from 'three';
import { BALL_RADIUS, TABLE_W, TABLE_H, VAL_HOLE_RADIUS, VAL_OFFSET_CORNER, VAL_OFFSET_SIDE } from './constants.js';
import { walls2D } from './table.js';

// Paramètres globaux
let params = null;

export function setParams(p) {
    params = p;
}

// --- MOTEUR PHYSIQUE ---
export function updatePhysics(balls, dt, turnInfo = null) {
    const sub = 15;
    const subDt = dt / sub;
    
    for (let s = 0; s < sub; s++) {
        // Collisions Balles (Choc Elastique Simple sur la vitesse linéaire)
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
                    
                    const imp = n.multiplyScalar(-(1 + params.restitution) * vRel * 0.5);
                    b1.vel.add(imp);
                    b2.vel.sub(imp);
                    
                    // Note : Le transfert de spin entre billes est ignoré ici pour simplifier,
                    // mais la friction table/bille va rétablir le roulement naturel après le choc.
                }
            }
        }

        balls.forEach(b => {
            // Murs 2D
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
                        const j = -(1 + params.wallRestitution) * vn;
                        b.vel.x += nx * j;
                        b.vel.z += nz * j;
                        // On réduit un peu le spin au contact bande
                        b.angVel.multiplyScalar(0.9);
                    }
                }
            }

            // Trous
            const W = TABLE_W / 2;
            const H = TABLE_H / 2;
            const dX = Math.cos(Math.PI / 4) * VAL_OFFSET_CORNER;
            const dZ = Math.sin(Math.PI / 4) * VAL_OFFSET_CORNER;
            
            const pp = [
                { x: -W - dX, z: -H - dZ },
                { x: W + dX, z: -H - dZ },
                { x: 0, z: -H - VAL_OFFSET_SIDE },
                { x: -W - dX, z: H + dZ },
                { x: W + dX, z: H + dZ },
                { x: 0, z: H + VAL_OFFSET_SIDE }
            ];
            
            for (let p of pp) {
                const dx = b.pos.x - p.x;
                const dz = b.pos.z - p.z;
                if (dx * dx + dz * dz < VAL_HOLE_RADIUS * VAL_HOLE_RADIUS) {
                    if (!b.inPocket) { // Éviter de compter plusieurs fois
                        b.inPocket = true;
                        b.vel.set(0, 0, 0);
                        b.angVel.set(0, 0, 0);
                        b.mesh.visible = false;
                        
                        // Enregistrer l'événement pour le système de tour
                        if (turnInfo) {
                            if (b === window.whiteBall) {
                                turnInfo.whiteScratched = true;
                                setTimeout(() => window.resetWhiteBall(), 1000);
                            } else {
                                // Bille normale empochée
                                turnInfo.ballsPotted.push(b.number);
                                console.log(`Bille ${b.number} empochée`);
                            }
                        } else if (b === window.whiteBall) {
                            setTimeout(() => window.resetWhiteBall(), 1000);
                        }
                    }
                }
            }

            // Mise à jour Physique (Frottement, Rotation, Glissement)
            b.update(subDt);
        });
    }
}
