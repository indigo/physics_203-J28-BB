// table.js
// Construction de la table de billard avec bandes, trous et géométrie

import * as THREE from 'three';
import { 
    TABLE_W, TABLE_H, RUBBER_DEPTH, RAIL_HEIGHT, WOOD_DEPTH, 
    FRAME_WIDTH, FRAME_HEIGHT, VAL_HOLE_RADIUS, VAL_OFFSET_CORNER, 
    VAL_OFFSET_SIDE, CORNER_KNUCKLE, SIDE_KNUCKLE, S
} from './constants.js';

export let walls2D = [];

export function createTable(scene) {
    const floorW = TABLE_W + (RUBBER_DEPTH + FRAME_WIDTH) * 2;
    const floorH = TABLE_H + (RUBBER_DEPTH + FRAME_WIDTH) * 2;
    const floor = new THREE.Mesh(
        new THREE.PlaneGeometry(floorW, floorH), 
        new THREE.MeshStandardMaterial({ color: 0x2e8b57, roughness: 0.8 })
    );
    floor.rotation.x = -Math.PI / 2;
    floor.receiveShadow = true;
    scene.add(floor);

    walls2D = [];

    function buildSolidRail(p1, p2, normal) {
        const vecDir = new THREE.Vector3().subVectors(p2, p1).normalize();
        const facingSpread = RUBBER_DEPTH * 0.7;
        const p4 = p1.clone().add(normal.clone().multiplyScalar(RUBBER_DEPTH)).add(vecDir.clone().multiplyScalar(-facingSpread));
        const p3 = p2.clone().add(normal.clone().multiplyScalar(RUBBER_DEPTH)).add(vecDir.clone().multiplyScalar(facingSpread));

        const shape = new THREE.Shape();
        shape.moveTo(p1.x, p1.z);
        shape.lineTo(p2.x, p2.z);
        shape.lineTo(p3.x, p3.z);
        shape.lineTo(p4.x, p4.z);
        
        const geom = new THREE.ExtrudeGeometry(shape, { depth: RAIL_HEIGHT, bevelEnabled: false });
        geom.rotateX(Math.PI / 2);
        geom.translate(0, RAIL_HEIGHT, 0);
        const mesh = new THREE.Mesh(geom, new THREE.MeshStandardMaterial({ color: 0x247a46, roughness: 0.6 }));
        mesh.castShadow = true;
        scene.add(mesh);

        const w1 = p4.clone();
        const w2 = p3.clone();
        const w3 = w2.clone().add(normal.clone().multiplyScalar(WOOD_DEPTH));
        const w4 = w1.clone().add(normal.clone().multiplyScalar(WOOD_DEPTH));
        const mitre = WOOD_DEPTH * 0.8;
        w3.add(vecDir.clone().multiplyScalar(mitre));
        w4.add(vecDir.clone().multiplyScalar(-mitre));
        
        const wShape = new THREE.Shape();
        wShape.moveTo(w1.x, w1.z);
        wShape.lineTo(w2.x, w2.z);
        wShape.lineTo(w3.x, w3.z);
        wShape.lineTo(w4.x, w4.z);
        
        const wGeom = new THREE.ExtrudeGeometry(wShape, { depth: RAIL_HEIGHT + 0.05, bevelEnabled: false });
        wGeom.rotateX(Math.PI / 2);
        wGeom.translate(0, RAIL_HEIGHT + 0.05, 0);
        scene.add(new THREE.Mesh(wGeom, new THREE.MeshStandardMaterial({ color: 0x5c4033 })));

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
    
    buildSolidRail(
        new THREE.Vector3(-W + CORNER_KNUCKLE, 0, -H), 
        new THREE.Vector3(-SIDE_KNUCKLE, 0, -H), 
        new THREE.Vector3(0, 0, -1)
    );
    buildSolidRail(
        new THREE.Vector3(SIDE_KNUCKLE, 0, -H), 
        new THREE.Vector3(W - CORNER_KNUCKLE, 0, -H), 
        new THREE.Vector3(0, 0, -1)
    );
    buildSolidRail(
        new THREE.Vector3(W, 0, -H + CORNER_KNUCKLE), 
        new THREE.Vector3(W, 0, H - CORNER_KNUCKLE), 
        new THREE.Vector3(1, 0, 0)
    );
    buildSolidRail(
        new THREE.Vector3(W - CORNER_KNUCKLE, 0, H), 
        new THREE.Vector3(SIDE_KNUCKLE, 0, H), 
        new THREE.Vector3(0, 0, 1)
    );
    buildSolidRail(
        new THREE.Vector3(-SIDE_KNUCKLE, 0, H), 
        new THREE.Vector3(-W + CORNER_KNUCKLE, 0, H), 
        new THREE.Vector3(0, 0, 1)
    );
    buildSolidRail(
        new THREE.Vector3(-W, 0, H - CORNER_KNUCKLE), 
        new THREE.Vector3(-W, 0, -H + CORNER_KNUCKLE), 
        new THREE.Vector3(-1, 0, 0)
    );

    // Cadre & Trous
    createCabinet(scene);
    createHoles(scene);
}

function createCabinet(scene) {
    const W = TABLE_W / 2;
    const H = TABLE_H / 2;
    const innerW = W + RUBBER_DEPTH;
    const innerH = H + RUBBER_DEPTH;
    const outerW = innerW + FRAME_WIDTH;
    const outerH = innerH + FRAME_WIDTH;
    
    const shape = new THREE.Shape();
    shape.moveTo(-outerW, -outerH);
    shape.lineTo(outerW, -outerH);
    shape.lineTo(outerW, outerH);
    shape.lineTo(-outerW, outerH);
    shape.lineTo(-outerW, -outerH);
    
    const hole = new THREE.Path();
    hole.moveTo(-innerW, -innerH);
    hole.lineTo(innerW, -innerH);
    hole.lineTo(innerW, innerH);
    hole.lineTo(-innerW, innerH);
    hole.lineTo(-innerW, -innerH);
    shape.holes.push(hole);
    
    const geom = new THREE.ExtrudeGeometry(shape, { 
        depth: FRAME_HEIGHT, 
        bevelEnabled: true, 
        bevelThickness: 0.05, 
        bevelSize: 0.05, 
        bevelSegments: 2 
    });
    geom.rotateX(Math.PI / 2);
    geom.translate(0, FRAME_HEIGHT, 0);
    scene.add(new THREE.Mesh(geom, new THREE.MeshStandardMaterial({ 
        color: 0x5c4033, 
        roughness: 0.4 
    })));
}

function createHoles(scene) {
    const holeGeo = new THREE.CylinderGeometry(VAL_HOLE_RADIUS, VAL_HOLE_RADIUS, 0.5, 32);
    const holeMat = new THREE.MeshBasicMaterial({ color: 0x000000 });
    
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
        m.position.set(p.x, -0.1, p.z);
        scene.add(m);
    });
}
