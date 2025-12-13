// table.js
// Construction de la table de billard avec modèle 3D et physique

import * as THREE from 'three';
import { GLTFLoader } from 'jsm/loaders/GLTFLoader.js';
import { applyMaterialsToModel, createPocketMaterial } from './materials.js';
import { 
    TABLE_W, TABLE_H, RUBBER_DEPTH, RAIL_HEIGHT, WOOD_DEPTH, 
    FRAME_WIDTH, FRAME_HEIGHT, VAL_HOLE_RADIUS, VAL_OFFSET_CORNER, 
    VAL_OFFSET_SIDE, CORNER_KNUCKLE, SIDE_KNUCKLE, S
} from './constants.js';

export let walls2D = [];

export function createTable(scene) {
    // 1. CHARGER LE MODÈLE 3D (Visuel)
    const loader = new GLTFLoader();
    
    loader.load('assets/pool_table.glb', (gltf) => {
        const model = gltf.scene;
        
        console.log('Modèle GLB chargé avec succès');
        
        // Appliquer les matériaux avec le système de shaders
        applyMaterialsToModel(model);
        
        // Positionnement : Le modèle doit être centré à (0,0,0) dans Blender
        scene.add(model);
               // createFallbackTable(scene);
        console.log('Modèle 3D ajouté à la scène');
        console.log('Position:', model.position);
        console.log('Échelle:', model.scale);
        
    }, undefined, (error) => {
        console.error('Erreur lors du chargement de la table 3D:', error);
        console.log('Création de la table procédurale de secours...');
        createFallbackTable(scene);
    });

    // 2. GÉNÉRER LA PHYSIQUE (Invisible mais essentielle)
    walls2D = [];
    generatePhysicsBoundaries();
    
    // 3. Ajouter les trous visuels (cylindres noirs)
    createHoles(scene);
}

// Fonction de secours si le modèle GLB ne charge pas
function createFallbackTable(scene) {
    console.log('Création de la table procédurale simple...');
    
    // Tapis principal
    const floorW = TABLE_W + (RUBBER_DEPTH + FRAME_WIDTH) * 2;
    const floorH = TABLE_H + (RUBBER_DEPTH + FRAME_WIDTH) * 2;
    const floor = new THREE.Mesh(
        new THREE.PlaneGeometry(floorW, floorH), 
        new THREE.MeshStandardMaterial({ color: 0x2e8b57, roughness: 0.8 })
    );
    floor.rotation.x = -Math.PI / 2;
    floor.receiveShadow = true;
    scene.add(floor);
    
    // Bandes simplifiées (4 rectangles)
    const cushionHeight = RAIL_HEIGHT;
    const cushionMat = new THREE.MeshStandardMaterial({ color: 0x247a46, roughness: 0.6 });
    
    // Bande Nord
    const northCushion = new THREE.Mesh(
        new THREE.BoxGeometry(TABLE_W, cushionHeight, RUBBER_DEPTH),
        cushionMat
    );
    northCushion.position.set(0, cushionHeight/2, -TABLE_H/2 - RUBBER_DEPTH/2);
    northCushion.castShadow = true;
    scene.add(northCushion);
    
    // Bande Sud
    const southCushion = new THREE.Mesh(
        new THREE.BoxGeometry(TABLE_W, cushionHeight, RUBBER_DEPTH),
        cushionMat
    );
    southCushion.position.set(0, cushionHeight/2, TABLE_H/2 + RUBBER_DEPTH/2);
    southCushion.castShadow = true;
    scene.add(southCushion);
    
    // Bande Est
    const eastCushion = new THREE.Mesh(
        new THREE.BoxGeometry(RUBBER_DEPTH, cushionHeight, TABLE_H + RUBBER_DEPTH * 2),
        cushionMat
    );
    eastCushion.position.set(TABLE_W/2 + RUBBER_DEPTH/2, cushionHeight/2, 0);
    eastCushion.castShadow = true;
    scene.add(eastCushion);
    
    // Bande Ouest
    const westCushion = new THREE.Mesh(
        new THREE.BoxGeometry(RUBBER_DEPTH, cushionHeight, TABLE_H + RUBBER_DEPTH * 2),
        cushionMat
    );
    westCushion.position.set(-TABLE_W/2 - RUBBER_DEPTH/2, cushionHeight/2, 0);
    westCushion.castShadow = true;
    scene.add(westCushion);
    
    // Cadre en bois
    const frameMat = new THREE.MeshStandardMaterial({ color: 0x5c4033, roughness: 0.4 });
    const frameThickness = FRAME_WIDTH;
    const frameH = FRAME_HEIGHT;
    
    // Cadre Nord
    const northFrame = new THREE.Mesh(
        new THREE.BoxGeometry(TABLE_W + RUBBER_DEPTH * 2 + frameThickness * 2, frameH, frameThickness),
        frameMat
    );
    northFrame.position.set(0, frameH/2, -TABLE_H/2 - RUBBER_DEPTH - frameThickness/2);
    scene.add(northFrame);
    
    // Cadre Sud
    const southFrame = new THREE.Mesh(
        new THREE.BoxGeometry(TABLE_W + RUBBER_DEPTH * 2 + frameThickness * 2, frameH, frameThickness),
        frameMat
    );
    southFrame.position.set(0, frameH/2, TABLE_H/2 + RUBBER_DEPTH + frameThickness/2);
    scene.add(southFrame);
    
    // Cadre Est
    const eastFrame = new THREE.Mesh(
        new THREE.BoxGeometry(frameThickness, frameH, TABLE_H + RUBBER_DEPTH * 2),
        frameMat
    );
    eastFrame.position.set(TABLE_W/2 + RUBBER_DEPTH + frameThickness/2, frameH/2, 0);
    scene.add(eastFrame);
    
    // Cadre Ouest
    const westFrame = new THREE.Mesh(
        new THREE.BoxGeometry(frameThickness, frameH, TABLE_H + RUBBER_DEPTH * 2),
        frameMat
    );
    westFrame.position.set(-TABLE_W/2 - RUBBER_DEPTH - frameThickness/2, frameH/2, 0);
    scene.add(westFrame);
}

// GÉNÉRATION DE LA PHYSIQUE (Murs invisibles)
function generatePhysicsBoundaries() {

    // Fonction pour construire les murs physiques (sans visuel)
    function buildPhysicsRail(p1, p2, normal) {
        const vecDir = new THREE.Vector3().subVectors(p2, p1).normalize();
        const facingSpread = RUBBER_DEPTH * 0.7;
        const p4 = p1.clone().add(normal.clone().multiplyScalar(RUBBER_DEPTH)).add(vecDir.clone().multiplyScalar(-facingSpread));
        const p3 = p2.clone().add(normal.clone().multiplyScalar(RUBBER_DEPTH)).add(vecDir.clone().multiplyScalar(facingSpread));

        // On ne crée plus de Mesh, juste les segments de collision
        addWallSegment(p4, p1);
        addWallSegment(p1, p2);
        addWallSegment(p2, p3);
    }

    function addWallSegment(a, b) {
        const dx = b.x - a.x;
        const dz = b.z - a.z;
        const len = Math.sqrt(dx * dx + dz * dz);
        walls2D.push({ 
            p1: a, 
            p2: b, 
            normal: { x: dz / len, z: -dx / len }, 
            lenSq: len * len 
        });
    }

    const W = TABLE_W / 2;
    const H = TABLE_H / 2;
    
    // Construire les 6 segments de bandes (physique uniquement)
    buildPhysicsRail(
        new THREE.Vector3(-W + CORNER_KNUCKLE, 0, -H), 
        new THREE.Vector3(-SIDE_KNUCKLE, 0, -H), 
        new THREE.Vector3(0, 0, -1)
    );
    buildPhysicsRail(
        new THREE.Vector3(SIDE_KNUCKLE, 0, -H), 
        new THREE.Vector3(W - CORNER_KNUCKLE, 0, -H), 
        new THREE.Vector3(0, 0, -1)
    );
    buildPhysicsRail(
        new THREE.Vector3(W, 0, -H + CORNER_KNUCKLE), 
        new THREE.Vector3(W, 0, H - CORNER_KNUCKLE), 
        new THREE.Vector3(1, 0, 0)
    );
    buildPhysicsRail(
        new THREE.Vector3(W - CORNER_KNUCKLE, 0, H), 
        new THREE.Vector3(SIDE_KNUCKLE, 0, H), 
        new THREE.Vector3(0, 0, 1)
    );
    buildPhysicsRail(
        new THREE.Vector3(-SIDE_KNUCKLE, 0, H), 
        new THREE.Vector3(-W + CORNER_KNUCKLE, 0, H), 
        new THREE.Vector3(0, 0, 1)
    );
    buildPhysicsRail(
        new THREE.Vector3(-W, 0, H - CORNER_KNUCKLE), 
        new THREE.Vector3(-W, 0, -H + CORNER_KNUCKLE), 
        new THREE.Vector3(-1, 0, 0)
    );
}

function createHoles(scene) {
    const holeGeo = new THREE.CylinderGeometry(VAL_HOLE_RADIUS, VAL_HOLE_RADIUS, 0.5, 32);
    const holeMat = createPocketMaterial();
    
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
    
    pp.forEach(p => {
        const m = new THREE.Mesh(holeGeo, holeMat);
        m.position.set(p.x, -0.2, p.z);  // Légèrement plus bas pour éviter le z-fighting
        m.renderOrder = -1;  // Rendre en premier pour éviter les conflits
        scene.add(m);
    });
}
