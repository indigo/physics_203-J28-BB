// smartBot.js
// Bot intelligent avec simulation de physique pour jouer au billard

import * as THREE from 'three';
import { PhysicsSimulator } from './simulator.js';
import { TABLE_W, TABLE_H, BALL_RADIUS } from './constants.js';
import { gameState } from './gameState.js';
import { focusCameraOnTarget } from './ui.js';

export class SmartBot {
    constructor(difficulty = 0.5) {
        this.simulator = new PhysicsSimulator();
        this.difficulty = difficulty; // 0 (Stupide) à 1 (Dieu)
        this.isThinking = false;
    }

    /**
     * Le bot joue son tour
     * @param {Object} whiteBall - La bille blanche
     * @param {Array} balls - Toutes les billes
     * @param {Function} shootCallback - Fonction pour tirer (angle, power)
     */
    async playTurn(whiteBall, balls, shootCallback) {
        if (this.isThinking) return;
        this.isThinking = true;
        
        console.log("🧠 Le Bot réfléchit...");
        
        // 1. Identifier mes cibles
        const myBalls = this.getTargets(balls);
        if (myBalls.length === 0) {
            console.log("⚠️ Aucune cible disponible");
            this.isThinking = false;
            return;
        }

        let bestShot = null;
        let maxScore = -Infinity;

        // 2. Bruteforce intelligent
        // On teste chaque bille ciblable vers chaque trou possible
        const pockets = this.getPockets();
        
        console.log(`🎯 Analyse de ${myBalls.length} cibles × ${pockets.length} trous...`);

        for (let target of myBalls) {
            // 🎥 VISUALISATION : Déplacer la caméra vers la bille évaluée
            focusCameraOnTarget(target);
            
            // Petit délai pour voir la caméra bouger (effet "réflexion")
            await new Promise(r => setTimeout(r, 200));
            
            for (let pocket of pockets) {
                
                // Calcul géométrique de base (Angle théorique)
                const aimParams = this.calculateGeometricAim(whiteBall.pos, target.pos, pocket);
                if (!aimParams) continue; // Pas de ligne de vue directe (optionnel)

                // 3. LA SIMULATION
                // On simule ce tir exact
                const simResult = this.simulator.simulateShot(
                    aimParams.angle, 
                    aimParams.power, 
                    0, // Pas d'effet pour l'instant pour le bot
                    balls, 
                    whiteBall
                );

                // 4. Scoring du résultat
                const score = this.evaluateShot(simResult, target.number);

                if (score > maxScore) {
                    maxScore = score;
                    bestShot = { 
                        angle: aimParams.angle, 
                        power: aimParams.power,
                        target: target.number,
                        expectedPotted: simResult.ballsPotted
                    };
                }
            }
        }

        // Si aucun coup valide trouvé, on tire au hasard (cas de snook)
        if (!bestShot) {
            console.log("🎲 Aucun bon coup trouvé, tir aléatoire");
            bestShot = { 
                angle: Math.random() * Math.PI * 2, 
                power: 15 + Math.random() * 10 
            };
        } else {
            console.log(`✅ Meilleur coup: Cible ${bestShot.target}, Score ${maxScore.toFixed(0)}`);
            
            // 🎥 VISUALISATION FINALE : Montrer la bille choisie
            const finalTarget = balls.find(b => b.number === bestShot.target);
            if (finalTarget) {
                focusCameraOnTarget(finalTarget);
                await new Promise(r => setTimeout(r, 500)); // Pause pour bien voir
            }
        }

        // 5. Application de l'erreur humaine (Basée sur la difficulté)
        // Un bot pro a une déviation de 0.01 rad, un débutant de 0.2 rad
        const errorMargin = (1 - this.difficulty) * 0.2; 
        const finalAngle = bestShot.angle + (Math.random() - 0.5) * errorMargin;
        const finalPower = bestShot.power + (Math.random() - 0.5) * (1 - this.difficulty) * 5;

        // Délai pour le réalisme
        await new Promise(r => setTimeout(r, 800 + Math.random() * 500));
        
        console.log(`🎱 Bot tire: angle=${(finalAngle * 180 / Math.PI).toFixed(1)}°, power=${finalPower.toFixed(1)}`);
        
        shootCallback(finalAngle, finalPower);
        this.isThinking = false;
    }

    /**
     * Évalue la qualité d'un tir simulé
     * @param {Object} simEvents - Résultat de la simulation
     * @param {number} targetNumber - Numéro de la bille ciblée
     * @returns {number} Score du tir
     */
    evaluateShot(simEvents, targetNumber) {
        let score = 0;

        // CRITIQUE : Ne pas empocher la blanche
        if (simEvents.whiteScratched) return -10000;

        // POSITIF : Empocher la bonne bille
        if (simEvents.ballsPotted.includes(targetNumber)) {
            score += 1000;
        }

        // BONUS : Empocher plusieurs billes d'un coup
        const validPots = simEvents.ballsPotted.filter(n => n !== 0 && n !== 8);
        score += validPots.length * 500;

        // NÉGATIF : Empocher la noire trop tôt
        if (simEvents.ballsPotted.includes(8)) {
            score -= 5000;
        }

        // STRATÉGIQUE : Placement de la blanche
        // Si je suis un pro (difficulty > 0.8), je veux que la blanche finisse au centre
        if (this.difficulty > 0.8 && simEvents.finalWhitePos) {
            const distToCenter = simEvents.finalWhitePos.length(); // distance de (0,0,0)
            score -= distToCenter * 10; // On préfère le centre
        }

        // BONUS : Nombre de collisions (plus il y en a, plus c'est risqué)
        if (this.difficulty > 0.5) {
            score -= simEvents.collisions.length * 5;
        }

        // BONUS : Arrêt rapide (moins de risques)
        score += (this.simulator.maxSteps - simEvents.stoppedAt) * 0.5;

        return score;
    }

    /**
     * Calcule l'angle et la puissance pour viser une bille vers un trou
     * @param {THREE.Vector3} whitePos - Position de la blanche
     * @param {THREE.Vector3} targetPos - Position de la cible
     * @param {THREE.Vector3} pocketPos - Position du trou
     * @returns {Object|null} {angle, power} ou null si impossible
     */
    calculateGeometricAim(whitePos, targetPos, pocketPos) {
        // Vecteur Cible -> Trou
        const toPocket = new THREE.Vector3().subVectors(pocketPos, targetPos).normalize();
        
        // Point fantôme derrière la cible (où doit frapper la blanche)
        const ghostPos = targetPos.clone().sub(toPocket.clone().multiplyScalar(BALL_RADIUS * 2));
        
        // Vecteur de tir (Blanche -> Point fantôme)
        const shootDir = new THREE.Vector3().subVectors(ghostPos, whitePos);
        const distance = shootDir.length();
        
        // Vérification basique : la blanche n'est pas trop proche
        if (distance < BALL_RADIUS * 2.5) return null;
        
        // Calcul de la puissance en fonction de la distance
        // Distance courte = puissance faible, distance longue = puissance forte
        const basePower = 15;
        const powerFactor = Math.min(distance / 10, 1.5); // Normaliser
        const power = basePower + powerFactor * 10;
        
        return {
            angle: Math.atan2(shootDir.z, shootDir.x),
            power: Math.min(power, 25) // Limiter la puissance max
        };
    }

    /**
     * Récupère les billes ciblables pour le joueur actuel
     * @param {Array} balls - Toutes les billes
     * @returns {Array} Billes ciblables
     */
    getTargets(balls) {
        // Vérifier si toutes les billes régulières sont empochées
        const regularBalls = balls.filter(b => b.number !== 0 && b.number !== 8 && !b.inPocket);
        
        // Si toutes les billes régulières sont empochées, viser la noire (8)
        if (regularBalls.length === 0) {
            const blackBall = balls.find(b => b.number === 8 && !b.inPocket);
            return blackBall ? [blackBall] : [];
        }
        
        // Sinon, viser les billes régulières (tout sauf blanche et noire)
        return regularBalls;
    }

    /**
     * Retourne les positions des 6 trous
     * @returns {Array<THREE.Vector3>} Positions des trous
     */
    getPockets() {
        const W = TABLE_W / 2;
        const H = TABLE_H / 2;
        const dX = Math.cos(Math.PI / 4) * 0.368; // VAL_OFFSET_CORNER
        const dZ = Math.sin(Math.PI / 4) * 0.368;
        const sideOffset = 0.574; // VAL_OFFSET_SIDE
        
        return [
            new THREE.Vector3(-W - dX, 0, -H - dZ),  // Coin haut-gauche
            new THREE.Vector3(W + dX, 0, -H - dZ),   // Coin haut-droit
            new THREE.Vector3(0, 0, -H - sideOffset), // Milieu haut
            new THREE.Vector3(-W - dX, 0, H + dZ),   // Coin bas-gauche
            new THREE.Vector3(W + dX, 0, H + dZ),    // Coin bas-droit
            new THREE.Vector3(0, 0, H + sideOffset)  // Milieu bas
        ];
    }
}
