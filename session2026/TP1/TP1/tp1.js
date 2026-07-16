import * as THREE from 'three';
import { OrbitControls } from 'jsm/controls/OrbitControls.js';
import { GUI } from 'https://cdn.jsdelivr.net/npm/lil-gui@0.19/+esm';

// --- CONFIGURATION ---
const CUBE_SIZE = 10;
const BALL_RADIUS = 0.2;

const tmpDelta = new THREE.Vector3();
const tmpNormal = new THREE.Vector3();
const tmpRelVel = new THREE.Vector3();

let scene, camera, renderer, balls = [];
let grid; 

const params = {
    nbBalls: 200,
    restitution: 0.8,
    useBroadPhase: true, // Pour comparer !
    gravity: 0,
    reset: () => initSimulation()
};

// --- CLASSE À COMPLÉTER (BROAD PHASE) ---
class SpatialGrid {
    constructor(size, cellSize) {
        this.cellSize = cellSize;
        this.grid = {};
    }

    // Convertir une position 3D en clé de dictionnaire (ex: "1,2,-1")
    getKey(pos) {
        const x = Math.floor(pos.x / this.cellSize);
        const y = Math.floor(pos.y / this.cellSize);
        const z = Math.floor(pos.z / this.cellSize);
        return `${x},${y},${z}`;
    }

    update(balls) {
        this.grid = {};
        // 1. [À COMPLÉTER] : Parcourir les boules et les ranger dans les bonnes cases
        balls.forEach(ball => {
            const key = this.getKey(ball.position);
            if (!this.grid[key]) this.grid[key] = [];
            this.grid[key].push(ball);
        });
    }

    getNeighbors(ball) {
        // 2. [À COMPLÉTER] : Récupérer les boules dans la case actuelle + 26 cases voisines
        const neighbors = [];
        const baseX = Math.floor(ball.position.x / this.cellSize);
        const baseY = Math.floor(ball.position.y / this.cellSize);
        const baseZ = Math.floor(ball.position.z / this.cellSize);

        for (let dx = -1; dx <= 1; dx++) {
            for (let dy = -1; dy <= 1; dy++) {
                for (let dz = -1; dz <= 1; dz++) {
                    const key = `${baseX + dx},${baseY + dy},${baseZ + dz}`;
                    if (this.grid[key]) {
                        neighbors.push(...this.grid[key]);
                    }
                }
            }
        }

        return neighbors;
    }
}

// --- INITIALISATION ---
function init() {
    scene = new THREE.Scene();
    camera = new THREE.PerspectiveCamera(75, window.innerWidth/window.innerHeight, 0.1, 1000);
    camera.position.set(15, 15, 15);
    
    renderer = new THREE.WebGLRenderer({ antialias: true });
    renderer.setSize(window.innerWidth, window.innerHeight);
    document.body.appendChild(renderer.domElement);
    
    // Wireframe du cube conteneur
    const geo = new THREE.BoxGeometry(CUBE_SIZE, CUBE_SIZE, CUBE_SIZE);
    const wireframe = new THREE.LineSegments(
        new THREE.EdgesGeometry(geo),
        new THREE.LineBasicMaterial({ color: 0xffffff })
    );
    scene.add(wireframe);

    const ambientLight = new THREE.AmbientLight(0xffffff, 0.4);
    scene.add(ambientLight);

    const directionalLight = new THREE.DirectionalLight(0xffffff, 0.8);
    directionalLight.position.set(10, 20, 10);
    scene.add(directionalLight);

    grid = new SpatialGrid(CUBE_SIZE, BALL_RADIUS * 4);
    
    initSimulation();
    setupGUI();
    new OrbitControls(camera, renderer.domElement);
    animate();
}

function initSimulation() {
    // Nettoyage
    balls.forEach(b => scene.remove(b));
    balls = [];

    for(let i=0; i < params.nbBalls; i++) {
        const mesh = new THREE.Mesh(
            new THREE.SphereGeometry(BALL_RADIUS),
            new THREE.MeshStandardMaterial({ color: Math.random() * 0xffffff })
        );
        mesh.position.set(
            (Math.random()-0.5) * (CUBE_SIZE - 1),
            (Math.random()-0.5) * (CUBE_SIZE - 1),
            (Math.random()-0.5) * (CUBE_SIZE - 1)
        );
        mesh.userData.velocity = new THREE.Vector3(
            (Math.random()-0.5) * 5,
            (Math.random()-0.5) * 5,
            (Math.random()-0.5) * 5
        );
        mesh.userData.mass = 1;
        balls.push(mesh);
        scene.add(mesh);
    }
}

function updatePhysics(dt) {
    // 1. Intégration
    balls.forEach(b => {
        b.userData.velocity.y -= params.gravity * dt;
        b.position.addScaledVector(b.userData.velocity, dt);

        // 2. Murs (Narrow Phase contre le cube)
        // [À COMPLÉTER] : Rebond sur les 6 faces avec correction de position
        
        ['x','y','z'].forEach(axis => {
            const half = CUBE_SIZE/2 - BALL_RADIUS;
            if (b.position[axis] < -half) {
                b.position[axis] = -half;
                b.userData.velocity[axis] *= -params.restitution;
            }
            if (b.position[axis] > half) {
                b.position[axis] = half;
                b.userData.velocity[axis] *= -params.restitution;
            }
        });
    });

    // 3. Collisions entre boules

    if (params.useBroadPhase) {
        grid.update(balls);
        balls.forEach(ballA => {
            const potentialTargets = grid.getNeighbors(ballA);
            potentialTargets.forEach(ballB => {
                if (ballA !== ballB) resolveCollision(ballA, ballB);
            });
        });
    } else {
        // Brute force O(N^2)
        for(let i=0; i<balls.length; i++) {
            for(let j=i+1; j<balls.length; j++) {
                resolveCollision(balls[i], balls[j]);
            }
        }
    }
}

function resolveCollision(ballA, ballB) {
    tmpDelta.subVectors(ballB.position, ballA.position);
    const dist = tmpDelta.length();
    const minDist = BALL_RADIUS * 2;
    if (dist >= minDist) return;

    tmpNormal.copy(tmpDelta).divideScalar(dist);

    tmpRelVel.subVectors(ballB.userData.velocity, ballA.userData.velocity);
    const velAlongNormal = tmpRelVel.dot(tmpNormal);

    if (velAlongNormal > 0) return;

    const e = params.restitution;
    const j = -(1 + e) * velAlongNormal / (1/ballA.userData.mass + 1/ballB.userData.mass);

    tmpNormal.multiplyScalar(j);
    ballA.userData.velocity.x -= tmpNormal.x / ballA.userData.mass;
    ballA.userData.velocity.y -= tmpNormal.y / ballA.userData.mass;
    ballA.userData.velocity.z -= tmpNormal.z / ballA.userData.mass;

    ballB.userData.velocity.x += tmpNormal.x / ballB.userData.mass;
    ballB.userData.velocity.y += tmpNormal.y / ballB.userData.mass;
    ballB.userData.velocity.z += tmpNormal.z / ballB.userData.mass;

    const penetration = minDist - dist;
    tmpNormal.divideScalar(j);
    ballA.position.addScaledVector(tmpNormal, -penetration/2);
    ballB.position.addScaledVector(tmpNormal, penetration/2);
}

// [À COMPLÉTER] : 
    // 1. Calcul de la normale
    // 2. Calcul de l'impulsion (J) en 3D
    // 3. Mise à jour des vitesses
    // 4. Correction de l'interpénétration (très important pour éviter que les boules collent)

function animate() {
    requestAnimationFrame(animate);
    updatePhysics(0.016);
    renderer.render(scene, camera);
}

function setupGUI() {
    const gui = new GUI();
    gui.add(params, 'nbBalls', 10, 5000, 1).name("Nb Boules").onFinishChange(initSimulation);
    gui.add(params, 'useBroadPhase').name("Broad Phase");
    gui.add(params, 'restitution', 0, 1).name("Restitution");
    gui.add(params, 'gravity', -10, 10).name("Gravité");
    gui.add(params, 'reset').name("Reset");
}

init();