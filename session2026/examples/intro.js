import * as THREE from 'three';
import { OrbitControls } from 'jsm/controls/OrbitControls.js';

// --- Variables Globales ---
let camera, scene, renderer;
let spheres = [];    // Les balles
let velArrows = [];  // Flèches de Vitesse (Noir)
let accArrows = [];  // Flèches d'Accélération (Jaune/Or)

// Paramètres de l'animation
const clock = new THREE.Clock();

init();

function init() {
    // 1. Configuration de la Scène
    scene = new THREE.Scene();
    scene.background = new THREE.Color( 0xbfd1e5 );

    // 2. Caméra
    camera = new THREE.PerspectiveCamera( 50, window.innerWidth / window.innerHeight, 0.1, 100 );
    camera.position.set( 0, 5, 10 );

    // 3. Rendu
    renderer = new THREE.WebGLRenderer( { antialias: true } );
    renderer.setSize( window.innerWidth, window.innerHeight );
    renderer.shadowMap.enabled = true;
    document.body.appendChild( renderer.domElement );

    // 4. Lumières
    const ambient = new THREE.HemisphereLight( 0xffeeee, 0xaaccaa );
    scene.add( ambient );

    const light = new THREE.DirectionalLight( 0xFFFF22, 1 );
    light.position.set( 5, 10, 7 );
    light.castShadow = true;
    scene.add( light );

    // 5. Sol
    const floorGeometry = new THREE.PlaneGeometry( 20, 20 );
    const floorMaterial = new THREE.MeshStandardMaterial( { color: 0xaaaaaa } );
    const floor = new THREE.Mesh( floorGeometry, floorMaterial );
    floor.rotation.x = - Math.PI / 2;
    floor.receiveShadow = true;
    scene.add( floor );
    
    const gridHelper = new THREE.GridHelper( 20, 20 );
    scene.add( gridHelper );

    // 6. Contrôles
    const controls = new OrbitControls( camera, renderer.domElement );
    controls.target.set( 0, 1, 0 );
    controls.update();

    // 7. Création des Objets
    createMotionObjects();

    // 8. Events
    window.addEventListener( 'resize', onWindowResize, false );
    
    // 9. Boucle
    renderer.setAnimationLoop( animate );
}

function createMotionObjects() {
    const sphereRadius = 0.3;
    const colors = [0xff0000, 0x00ff00]; // Rouge, Vert

    for (let i = 0; i < 2; i++) {
        // A. La Boule
        const geometry = new THREE.SphereGeometry(sphereRadius, 32, 32);
        const material = new THREE.MeshStandardMaterial({ color: colors[i] });
        const sphere = new THREE.Mesh(geometry, material);
        sphere.castShadow = true;
        sphere.position.y = 1;
        scene.add(sphere);
        spheres.push(sphere);

        // B. Flèche Vitesse (Noire/Grise)
        const vArrow = new THREE.ArrowHelper(
            new THREE.Vector3(1, 0, 0), sphere.position, 1, 0x333333
        );
        scene.add(vArrow);
        velArrows.push(vArrow);

        // C. Flèche Accélération (Jaune Foncé/Or)
        const aArrow = new THREE.ArrowHelper(
            new THREE.Vector3(0, 1, 0), sphere.position, 1, 0xAA8800
        );
        scene.add(aArrow);
        accArrows.push(aArrow);
    }
}

// --- MATHÉMATIQUES ---

// Mouvement 1 : Linéaire Harmonique (Ressort)
function updateLinearMotion(t, index) {
    const amplitude = 4; 
    const omega = 1.5;   // Vitesse angulaire

    // 1. Position: x = A * sin(wt)
    const x = amplitude * Math.sin(omega * t);
    const pos = new THREE.Vector3(x, 1, -2);

    // 2. Vitesse: v = A * w * cos(wt)
    const vx = amplitude * omega * Math.cos(omega * t);
    const vel = new THREE.Vector3(vx, 0, 0);

    // 3. Accélération: a = -A * w² * sin(wt)
    // Note: C'est l'opposé de la position !
    const ax = -amplitude * omega * omega * Math.sin(omega * t);
    const acc = new THREE.Vector3(ax, 0, 0);

    updateObject3D(index, pos, vel, acc);
}

// Mouvement 2 : Circulaire Uniforme
function updateCircularMotion(t, index) {
    const radius = 3;
    const omega = 1.0;

    // 1. Position
    const x = radius * Math.cos(omega * t);
    const z = radius * Math.sin(omega * t);
    const pos = new THREE.Vector3(x, 1, z + 2);

    // 2. Vitesse (Tangente)
    // Dérivée de cos -> -sin
    // Dérivée de sin -> cos
    const vx = -radius * omega * Math.sin(omega * t);
    const vz = radius * omega * Math.cos(omega * t);
    const vel = new THREE.Vector3(vx, 0, vz);

    // 3. Accélération (Centripète)
    // Dérivée de -sin -> -cos
    // Dérivée de cos -> -sin
    const ax = -radius * omega * omega * Math.cos(omega * t);
    const az = -radius * omega * omega * Math.sin(omega * t);
    const acc = new THREE.Vector3(ax, 0, az);

    updateObject3D(index, pos, vel, acc);
}

// Mise à jour visuelle
function updateObject3D(index, pos, vel, acc) {
    // Boule
    spheres[index].position.copy(pos);

    // Vitesse (Noir)
    velArrows[index].position.copy(pos);
    velArrows[index].setDirection(vel.clone().normalize());
    velArrows[index].setLength(vel.length() * 0.3, 0.2, 0.1);

    // Accélération (Or)
    accArrows[index].position.copy(pos);
    // Petite sécurité pour éviter les erreurs si l'accélération est nulle
    if (acc.lengthSq() > 0.001) {
        accArrows[index].setDirection(acc.clone().normalize());
        accArrows[index].setLength(acc.length() * 0.3, 0.2, 0.1);
    }
}

function animate() {
    const t = clock.getElapsedTime();

    updateLinearMotion(t, 0);
    updateCircularMotion(t, 1);

    renderer.render(scene, camera);
}

function onWindowResize() {
    camera.aspect = window.innerWidth / window.innerHeight;
    camera.updateProjectionMatrix();
    renderer.setSize( window.innerWidth, window.innerHeight );
}