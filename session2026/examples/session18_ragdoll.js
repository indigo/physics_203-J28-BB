import * as THREE from 'three';
import { GUI } from 'https://unpkg.com/lil-gui@0.20.0/dist/lil-gui.esm.min.js';
import { FBXLoader } from 'jsm/loaders/FBXLoader.js';
import { OrbitControls } from 'jsm/controls/OrbitControls.js';
import RAPIER from 'rapier';

// ============================================================
//  SESSION 18 — RAGDOLL ET CORPS MOUS
//
//  Un personnage skinné (squelette UE5, 61 os) chargé depuis un
//  FBX, converti en RAGDOLL dans Rapier :
//    - 18 corps rigides (capsules) — les doigts et les os twist
//      sont ignorés, les clavicules fusionnées au spine
//    - 17 articulations REVOLUTE (1 ddl), chacune avec des butées
//      d'angle ET un moteur de position (le « tonus musculaire »)
//
//  TROIS MODES (GUI) :
//    - POSE    : le personnage est figé dans sa pose de repos
//                (l'équivalent du character controller de S16)
//    - RAGDOLL : la physique prend le dessus — le personnage
//                s'effondre. Sans tonus, c'est un tas de spaghettis.
//    - ACTIVE  : les mêmes moteurs, beaucoup plus raides — le
//                personnage RÉSISTE et revient à sa pose de repos.
//
//  LES QUATRE PIÈGES QUI ONT DEMANDÉ DU TRAVAIL (détaillés plus bas) :
//    1. Les corps ont TOUS la même orientation (l'identité) et la
//       rotation de l'os est portée par le COLLIDER. Sans ça, l'axe
//       d'un joint revolute est faux pour le parent (table RAGDOLL).
//    2. La synchro corps -> os doit conserver l'ÉCHELLE MONDE de
//       l'os, sinon la matrice de skinning rétracte le mesh
//       (syncBonesFromBodies).
//    3. Le solveur a besoin de plus de 4 itérations pour faire
//       converger une chaîne de 17 articulations (SOLVER_ITERATIONS).
//    4. Le frottement se combine en Max : baisser le sol SEUL ne
//       change rien, il faut baisser aussi les corps (applyFriction).
//
//  ESPACE : pousser (direction aléatoire) · R : reset · Souris : orbiter
//
//  ---------- SOMMAIRE (les blocs sont dans cet ordre) ----------
//    PARAMÈTRES ...................... réglages + constantes
//    DÉFINITION DU RAGDOLL ........... table os -> corps rigide
//    ÉTAT GLOBAL ..................... variables partagées
//    INITIALISATION .................. ordre : Rapier AVANT le modèle
//    MONDE PHYSIQUE .................. sol + couronne d'obstacles
//    CHARGEMENT DU MODÈLE ............ FBX + textures manuelles
//    LONGUEUR D'UN OS ................ pièges twist / échelle
//    AXE D'UNE ARTICULATION .......... axe monde des joints
//    LIMITES + MOTEUR ................ butées + tonus (solveur)
//    CONSTRUCTION DU RAGDOLL ......... corps puis joints
//    AIDES VISUELLES ................. capsules + lignes de joint
//    SYNCHRO OS -> CORPS ............. mode POSE et reset
//    SYNCHRO CORPS -> OS ............. modes RAGDOLL / ACTIVE
//    PONYTAIL ........................ chaîne PBD (Partie 4 du cours)
//    RAIDEUR ARTICULAIRE ............. (note : c'est le moteur du joint)
//    ACTIONS ......................... pousser / reset / changer de mode
//    GUI ............................. panneaux lil-gui
//    BOUCLE .......................... pas fixe + rendu
//    UTILITAIRES ..................... clavier, resize
// ============================================================

const FIXED_DT = 1 / 60;
const TARGET_HEIGHT = 1.7;          // hauteur du personnage en mètres
const MODEL_DIR = 'models/miami_boss/';
// Version RIGGÉE pour le ponytail (4 os pony_01..04 ajoutés dans Blender).
// L'ancien `miami_boss.fbx` reste à côté : remettre ce nom pour comparer.
const MODEL_FILE = 'miami_boss_pony.fbx';

// Itérations du solveur de contraintes (défaut Rapier : 4).
// Une chaîne de 17 articulations a besoin de plus d'itérations pour
// converger — sinon les ancres restent violées et le bassin se déboîte.
const SOLVER_ITERATIONS = 16;

// Taille du bassin, exprimée en FRACTION de la hauteur du personnage
// (donc indépendante de l'échelle du modèle). L'os `pelvis` d'un
// squelette UE5 est très court (~6 cm) : tel quel, il donne un corps
// 29x plus léger que chaque cuisse, et le solveur n'arrive pas à
// transmettre les forces entre le torse et les jambes.
const PELVIS_LEN_FRAC = 0.13;       // 0.13 x 1.7 m = 22 cm
const PELVIS_RADIUS_FRAC = 0.07;    // 0.07 x 1.7 m = 12 cm

// Groupes de collision (32 bits : 16 de membership, 16 de filtre).
// Les corps du ragdoll ne collisionnent PAS entre eux — seulement
// avec le monde. Sinon les capsules voisines (cuisses, bras) se
// repoussent et le ragdoll tremble en permanence.
const G_WORLD   = 0x0001;
const G_RAGDOLL = 0x0002;
const GROUPS_WORLD   = (G_WORLD   << 16) | (G_WORLD | G_RAGDOLL);
const GROUPS_RAGDOLL = (G_RAGDOLL << 16) | G_WORLD;

// ============================================================
//  PARAMÈTRES
// ============================================================
const params = {
    mode: 'pose',           // 'pose' | 'ragdoll' | 'active'
    limits: true,           // limites d'angle sur toutes les articulations
    // FROTTEMENT sol/personnage. Modérer (≈0.5), les pieds accrochent et
    // le personnage BASCULE vers l'avant ou l'arrière. Bas, les pieds
    // glissent et il s'affaisse sur place. 0 = verglas.
    friction: 0.25,
    showBodies: true,       // wireframes des colliders
    showJoints: true,       // lignes entre les corps

    // RAIDEUR ARTICULAIRE — le réglage qui change tout.
    // Chaque articulation est un revolute avec un moteur de position
    // (configureMotorPosition(0, stiffness, damping)). C'est un vrai
    // ressort PD résolu PAR le solveur — il ne peut pas être annulé
    // comme un couple externe. stiffness ~ rigidité du ressort.
    jointStiffness: 60,     // raideur articulaire (ragdoll)
    motorDamping: 6,        // amortissement du moteur
    angularDamping: 1.2,    // freine les rotations parasites

    // Mode ACTIVE : les mêmes moteurs, mais beaucoup plus raides.
    // Le ragdoll "lutte" pour revenir à sa pose de repos.
    activeStiffness: 900,   // raideur du rappel de pose
    activeDamping: 60,      // amortissement additionnel

    push: () => pushRagdoll(),
    reset: () => resetRagdoll(),
};

// ============================================================
//  DÉFINITION DU RAGDOLL
//
//  Chaque entrée : un os -> un corps rigide.
//  'parent' est l'os PARENT dans le ragdoll (pas dans le squelette) :
//  les clavicules sont sautées, donc upperarm_* pend de spine_03.
//
//  CHAQUE articulation est un joint REVOLUTE (1 ddl) avec une
//  amplitude [min,max] et un moteur de position. Pourquoi pas des
//  joints sphériques ? Parce que dans Rapier 0.19 ils n'ont AUCUNE
//  limite et AUCUN moteur : le ragdoll se plie dans tous les sens.
//  Un revolute, lui, a `setLimits` et `configureMotorPosition` —
//  les deux sont résolus comme de vraies contraintes par le solveur,
//  donc ils ne peuvent pas être "annulés" comme un couple externe.
//
//  ATTENTION — PIÈGE MAJEUR DE L'API RAPIER :
//  `JointData.revolute(a1, a2, axe)` ne prend qu'UN SEUL axe, et
//  cet axe est interprété dans l'espace LOCAL DES DEUX corps
//  (cf. RevoluteJoint::new -> local_axis1(axis).local_axis2(axis)).
//  Si on le calcule dans le repère de l'enfant, il devient faux pour
//  le parent, et le solveur applique une impulsion colossale pour
//  aligner deux axes qui ne peuvent pas l'être -> le ragdoll explose.
//
//  La parade : donner à TOUS les corps la MÊME orientation (l'identité)
//  et porter la rotation de l'os sur le COLLIDER. Du coup un axe monde
//  est valide pour les deux corps à la fois, sans aucun calcul de
//  repère. (Les versions plus récentes de rapier.js ont
//  `revoluteWithAxes`, mais pas la 0.19.3.)
//
//  `axis` : 'limb' -> axe dérivé de la direction de l'os
//           'side' -> axe gauche-droite du personnage (X)
//           'up'   -> axe vertical du personnage (Y)
//           'fwd'  -> axe avant-arrière du personnage (Z)
//  `range` : amplitude [min,max] en degrés (0 = pose de repos).
// ============================================================
//  SIGNES — mesurés sur ce personnage, pas devinés.
//  L'axe est X (gauche-droite) et le personnage regarde vers +Z.
//  Le sens de « positif » dépend du SENS DE L'OS :
//    - os qui monte (colonne, cou) : + = penche vers l'AVANT (+Z)
//    - os qui descend (cuisse, tibia) : + = part vers l'ARRIÈRE (-Z)
//  C'est pour ça que la colonne et la hanche n'ont pas les mêmes
//  bornes alors qu'elles partagent le même axe. L'anatomie humaine
//  plie beaucoup dans un sens et très peu dans l'autre.
const RAGDOLL = [
    { bone: 'pelvis',     parent: null,         axis: 'side', range: [0,   0]    },
    // Colonne : on se plie en avant (20°), très peu en arrière (5°).
    { bone: 'spine_01',   parent: 'pelvis',     axis: 'side', range: [-5,  20]   },
    { bone: 'spine_02',   parent: 'spine_01',   axis: 'side', range: [-5,  20]   },
    { bone: 'spine_03',   parent: 'spine_02',   axis: 'side', range: [-5,  20]   },
    { bone: 'neck_01',    parent: 'spine_03',   axis: 'side', range: [-15, 25]   },
    { bone: 'head',       parent: 'neck_01',    axis: 'side', range: [-10, 15]   },

    { bone: 'upperarm_l', parent: 'spine_03',   axis: 'limb', range: [-100, 100] },
    { bone: 'lowerarm_l', parent: 'upperarm_l', axis: 'limb', range: [0,   135]  },
    { bone: 'hand_l',     parent: 'lowerarm_l', axis: 'limb', range: [-45, 45]   },
    { bone: 'upperarm_r', parent: 'spine_03',   axis: 'limb', range: [-100, 100] },
    { bone: 'lowerarm_r', parent: 'upperarm_r', axis: 'limb', range: [0,   135]  },
    { bone: 'hand_r',     parent: 'lowerarm_r', axis: 'limb', range: [-45, 45]   },

    // Hanche : jambe très haute en avant (-90°), presque rien en
    // arrière (+15°) — l'extension de hanche humaine est minime.
    { bone: 'thigh_l',    parent: 'pelvis',     axis: 'side', range: [-90, 15]   },
    { bone: 'calf_l',     parent: 'thigh_l',    axis: 'side', range: [0,   135]  },
    { bone: 'foot_l',     parent: 'calf_l',     axis: 'side', range: [-25, 45]   },
    { bone: 'thigh_r',    parent: 'pelvis',     axis: 'side', range: [-90, 15]   },
    { bone: 'calf_r',     parent: 'thigh_r',    axis: 'side', range: [0,   135]  },
    { bone: 'foot_r',     parent: 'calf_r',     axis: 'side', range: [-25, 45]   },
];

// ============================================================
//  ÉTAT GLOBAL
// ============================================================
let scene, camera, renderer, controls, world, gui;
let modelRoot = null;
let skinnedMeshes = [];
const bonesByName = {};
let bodies = [];                 // entrées ragdoll, triées par profondeur
const byName = {};
let bodyHelpers = [], jointHelpers = [];
// Colliders dont on pilote le frottement à chaud (GUI).
let groundCollider = null;
let obstacleColliders = [];
let accumulator = 0;
let modelScale = 1;
let hudEl, loadingEl;

const _v1 = new THREE.Vector3();
const _v2 = new THREE.Vector3();
const _q1 = new THREE.Quaternion();
const _m1 = new THREE.Matrix4();
const _m2 = new THREE.Matrix4();
const IDENTITY = new THREE.Matrix4();

// ============================================================
//  INITIALISATION
// ============================================================
// Ordre à respecter : RAPIER.init() AVANT le chargement du modèle.
// Charger le FBX d'abord puis initialiser le WASM a suffi à faire
// planter world.step() (panique wasm) dans nos tests hors navigateur.
async function init() {
    hudEl = document.getElementById('hud');
    loadingEl = document.getElementById('loading');

    await RAPIER.init({});

    scene = new THREE.Scene();
    scene.background = new THREE.Color(0x0b0e13);
    scene.fog = new THREE.Fog(0x0b0e13, 12, 40);

    camera = new THREE.PerspectiveCamera(45, innerWidth / innerHeight, 0.1, 200);
    camera.position.set(2.6, 1.9, 3.4);

    renderer = new THREE.WebGLRenderer({ antialias: true });
    renderer.setSize(innerWidth, innerHeight);
    renderer.setPixelRatio(Math.min(devicePixelRatio, 2));
    renderer.shadowMap.enabled = true;
    renderer.shadowMap.type = THREE.PCFSoftShadowMap;
    document.body.appendChild(renderer.domElement);

    controls = new OrbitControls(camera, renderer.domElement);
    controls.target.set(0, 0.9, 0);
    controls.enableDamping = true;
    controls.dampingFactor = 0.08;
    controls.maxPolarAngle = Math.PI * 0.495;

    setupLights();
    setupWorld();

    try {
        await loadModel();
    } catch (err) {
        loadingEl.textContent = 'Erreur de chargement : ' + err.message;
        console.error(err);
        return;
    }

    buildRagdoll();
    buildPonytail();
    setupGUI();
    resetRagdoll();

    loadingEl.style.display = 'none';

    addEventListener('resize', onResize);
    addEventListener('keydown', onKey);
    renderer.setAnimationLoop(animate);
}

// ============================================================
//  LUMIÈRES
// ============================================================
function setupLights() {
    scene.add(new THREE.HemisphereLight(0x9fc4e8, 0x2a2f38, 8.1));

    const key = new THREE.DirectionalLight(0xffffff, 2.2);
    key.position.set(4, 8, 5);
    key.castShadow = true;
    key.shadow.mapSize.set(2048, 2048);
    key.shadow.camera.near = 0.5;
    key.shadow.camera.far = 30;
    key.shadow.camera.left = -6;
    key.shadow.camera.right = 6;
    key.shadow.camera.top = 6;
    key.shadow.camera.bottom = -6;
    key.shadow.bias = -0.0008;
    scene.add(key);

    const rim = new THREE.DirectionalLight(0x6aa0ff, 0.9);
    rim.position.set(-5, 3, -6);
    scene.add(rim);
}

// ============================================================
//  MONDE PHYSIQUE — sol + couronne d'obstacles
// ============================================================
function setupWorld() {
    world = new RAPIER.World({ x: 0, y: -9.81, z: 0 });
    world.timestep = FIXED_DT;

    // ITÉRATIONS DU SOLVEUR — le réglage qui compte le plus pour un
    // ragdoll. Un personnage est une CHAÎNE PROFONDE de contraintes
    // (pelvis -> colonne -> épaules -> coudes -> mains) et chaque
    // articulation dépend de ses voisines. Avec les 4 itérations par
    // défaut, les contraintes du haut de la chaîne n'ont pas convergé
    // quand le solveur s'arrête : les ancres restent violées et on voit
    // le bassin se « désarticuler » (jusqu'à 11 cm d'écart mesuré).
    // 16 itérations ramènent cet écart sous le millimètre.
    world.integrationParameters.numSolverIterations = SOLVER_ITERATIONS;

    // Sol
    const groundBody = world.createRigidBody(RAPIER.RigidBodyDesc.fixed());
    // FROTTEMENT — réglable à chaud depuis la GUI.
    // Attention à la règle de combinaison : elle est en Max, donc le
    // frottement effectif d'un contact = max(sol, corps). Il FAUT donc
    // baisser les DEUX (cf. applyFriction) pour que le sol devienne
    // vraiment glissant — baisser le sol seul ne changerait rien.
    groundCollider = world.createCollider(
        RAPIER.ColliderDesc.cuboid(20, 0.1, 20)
            .setTranslation(0, -0.1, 0)
            .setFriction(params.friction)
            .setRestitution(0.0)          // aucun rebond
            .setRestitutionCombineRule(RAPIER.CoefficientCombineRule.Min)
            .setFrictionCombineRule(RAPIER.CoefficientCombineRule.Max)
            .setCollisionGroups(GROUPS_WORLD),
        groundBody
    );

    // Visuel du sol
    const groundMesh = new THREE.Mesh(
        new THREE.PlaneGeometry(40, 40),
        new THREE.MeshStandardMaterial({ color: 0x2a3038, roughness: 0.95, metalness: 0.0 })
    );
    groundMesh.rotation.x = -Math.PI / 2;
    groundMesh.receiveShadow = true;
    scene.add(groundMesh);

    const grid = new THREE.GridHelper(40, 40, 0x3d4a58, 0x222932);
    grid.position.y = 0.002;
    scene.add(grid);

    // Décor d'obstacles AUTOUR du personnage : le ragdoll tombe donc
    // toujours sur quelque chose, quelle que soit la direction de la
    // poussée. Petits cubes bas, en anneaux concentriques.
    // Placement DÉTERMINISTE (pas de Math.random) : la scène est
    // identique à chaque chargement, ce qui compte pour une démo.
    const obstacles = [];
    const RINGS = [
        { r: 0.85, n: 6, h: 0.20, s: 0.26 },
        { r: 1.40, n: 9, h: 0.28, s: 0.34 },
        { r: 2.00, n: 7, h: 0.36, s: 0.42 },
    ];
    for (let k = 0; k < RINGS.length; k++) {
        const { r, n, h, s } = RINGS[k];
        for (let i = 0; i < n; i++) {
            // Décalage par anneau : les cubes ne s'alignent pas en rayons.
            const a = (i / n) * Math.PI * 2 + k * 0.7;
            // Empreinte légèrement variée, mais toujours déterministe.
            const sx = s * (0.75 + 0.5 * ((i * 3 + k) % 4) / 3);
            const sz = s * (0.75 + 0.5 * ((i * 5 + k) % 4) / 3);
            obstacles.push({
                pos: [Math.cos(a) * r, h / 2, Math.sin(a) * r],
                size: [sx, h, sz],
                rot: a + Math.PI / 4,
            });
        }
    }
    for (const o of obstacles) {
        const q = new THREE.Quaternion().setFromEuler(new THREE.Euler(0, o.rot, 0));
        const body = world.createRigidBody(
            RAPIER.RigidBodyDesc.fixed()
                .setTranslation(o.pos[0], o.pos[1], o.pos[2])
                .setRotation({ x: q.x, y: q.y, z: q.z, w: q.w })
        );
        obstacleColliders.push(world.createCollider(
            RAPIER.ColliderDesc.cuboid(o.size[0] / 2, o.size[1] / 2, o.size[2] / 2)
                .setFriction(params.friction)
                .setRestitution(0.0)
                .setCollisionGroups(GROUPS_WORLD),
            body
        ));

        const mesh = new THREE.Mesh(
            new THREE.BoxGeometry(o.size[0], o.size[1], o.size[2]),
            new THREE.MeshStandardMaterial({ color: 0x46525f, roughness: 0.85 })
        );
        mesh.position.set(o.pos[0], o.pos[1], o.pos[2]);
        mesh.quaternion.copy(q);
        mesh.castShadow = true;
        mesh.receiveShadow = true;
        scene.add(mesh);
    }
}

// ============================================================
//  CHARGEMENT DU MODÈLE (FBX + textures manuelles)
//
//  Le FBX référence ses textures par des chemins absolus du
//  serveur Tripo — ils n'existent pas ici. On les charge donc
//  à la main depuis models/miami_boss/.
// ============================================================
async function loadModel() {
    // Le FBX de Tripo référence ses textures par des chemins ABSOLUS
    // du serveur de génération (/mnt/pfs/server/tripo-studio/...) qui
    // n'existent pas ici → 4 erreurs 404 dans la console pour rien.
    // On redirige ces URLs vers nos fichiers locaux : FBXLoader charge
    // donc les bonnes textures, et on n'a plus de bruit.
    const manager = new THREE.LoadingManager();
    manager.setURLModifier((url) => {
        const u = url.toLowerCase();
        if (u.includes('roughness')) return MODEL_DIR + 'miami_boss_roughness.jpg';
        if (u.includes('metallic'))  return MODEL_DIR + 'miami_boss_metallic.jpg';
        if (u.includes('normal'))    return MODEL_DIR + 'miami_boss_normal.jpg';
        if (u.includes('rgb'))       return MODEL_DIR + 'miami_boss_basecolor.jpg';
        return url;
    });

    const loader = new FBXLoader(manager);
    const fbx = await loader.loadAsync(MODEL_DIR + MODEL_FILE);

    // --- Textures PBR (résolution réduite : 1024²) ---
    const texLoader = new THREE.TextureLoader(manager);
    const [map, normalMap, roughnessMap, metalnessMap] = await Promise.all([
        texLoader.loadAsync(MODEL_DIR + 'miami_boss_basecolor.jpg'),
        texLoader.loadAsync(MODEL_DIR + 'miami_boss_normal.jpg'),
        texLoader.loadAsync(MODEL_DIR + 'miami_boss_roughness.jpg'),
        texLoader.loadAsync(MODEL_DIR + 'miami_boss_metallic.jpg'),
    ]);
    map.colorSpace = THREE.SRGBColorSpace;
    for (const t of [map, normalMap, roughnessMap, metalnessMap]) {
        t.anisotropy = renderer.capabilities.getMaxAnisotropy();
        t.wrapS = t.wrapT = THREE.RepeatWrapping;
    }

    // --- Application du matériau PBR ---
    const mat = new THREE.MeshStandardMaterial({
        map,
        normalMap,
        roughnessMap,
        metalnessMap,
        roughness: 1.0,
        metalness: 1.0,
        normalScale: new THREE.Vector2(1.0, 1.0),
    });

    modelRoot = new THREE.Group();
    modelRoot.add(fbx);

    fbx.traverse((o) => {
        if (o.isMesh || o.isSkinnedMesh) {
            o.material = mat;
            o.castShadow = true;
            o.receiveShadow = true;
            o.frustumCulled = false;          // le skinning déplace la bounding box
            if (o.isSkinnedMesh) skinnedMeshes.push(o);
        }
    });

    // --- Normalisation de la hauteur ---
    // Le FBX peut arriver en cm (échelle 100) ou en mètres selon
    // la façon dont il a été exporté. On mesure, puis on remet à
    // TARGET_HEIGHT — la physique a besoin d'unités réalistes.
    modelRoot.updateMatrixWorld(true);
    const box = new THREE.Box3().setFromObject(modelRoot);
    const height = box.max.y - box.min.y;
    modelScale = TARGET_HEIGHT / height;
    fbx.scale.setScalar(modelScale);

    // Pieds au sol, centré sur l'origine
    modelRoot.updateMatrixWorld(true);
    const box2 = new THREE.Box3().setFromObject(modelRoot);
    fbx.position.y -= box2.min.y;
    fbx.position.x -= (box2.min.x + box2.max.x) / 2;
    fbx.position.z -= (box2.min.z + box2.max.z) / 2;

    scene.add(modelRoot);
    modelRoot.updateMatrixWorld(true);

    // --- Index des os ---
    let boneCount = 0;
    modelRoot.traverse((o) => {
        if (o.isBone) {
            bonesByName[o.name] = o;
            boneCount++;
        }
    });

    // Vérifie qu'on a bien tous les os du ragdoll
    const missing = RAGDOLL.filter(r => !bonesByName[r.bone]).map(r => r.bone);
    if (missing.length) {
        throw new Error('os manquants dans le FBX : ' + missing.join(', '));
    }

    console.log(`[ragdoll] modèle chargé — ${boneCount} os, ${skinnedMeshes.length} mesh(es) skinné(s), ` +
                `hauteur ${height.toFixed(3)} → échelle ${modelScale.toFixed(3)}`);
}

// ============================================================
//  LONGUEUR D'UN OS
//
//  1. Mesurée en ESPACE MONDE (pas via c.position, qui est la position
//     LOCALE de l'enfant) : le modèle est mis à l'échelle après le
//     chargement, donc les positions locales sont fausses d'un facteur
//     modelScale. Les corps rigides vivant en espace monde, les
//     capsules doivent l'être aussi.
//
//  2. On vise l'enfant qui FAIT PARTIE du ragdoll, pas « le premier os
//     enfant ». Sur un squelette UE5 les os de *twist* sont souvent
//     placés AVANT l'os de la chaîne :
//         upperarm_l -> [upperarm_twist_01_l, lowerarm_l]
//     Un twist bone est à la même position que son parent : la distance
//     vaut 0 et la capsule retombe sur sa taille minimale. Pire, l'ordre
//     n'est pas symétrique — upperarm_r liste lowerarm_r en premier —
//     donc le bras GAUCHE était minuscule et le droit correct.
// ============================================================
function boneLength(boneName, bone) {
    const head = bone.getWorldPosition(new THREE.Vector3());

    // 1. L'enfant du ragdoll : c'est forcément l'os SUIVANT DE LA CHAÎNE.
    //    (Les twist bones ne sont pas dans RAGDOLL, donc ils sont ignorés
    //    même quand ils sont listés en premier.)
    const childDef = RAGDOLL.find(r => r.parent === boneName);
    if (childDef && bonesByName[childDef.bone]) {
        const tail = bonesByName[childDef.bone].getWorldPosition(new THREE.Vector3());
        return Math.max(head.distanceTo(tail), 0.02);
    }

    // 2. Sinon, l'enfant le plus ÉLOIGNÉ qui n'est pas un os de twist :
    //    les os terminaux ont quand même une suite physique
    //    (foot -> ball, hand -> doigts). On prend le plus loin pour que
    //    la gauche et la droite donnent la même longueur (sinon hand_l
    //    tombe sur pinky_01_l et hand_r sur thumb_01_r).
    let best = 0;
    for (const c of bone.children) {
        if (!c.isBone || /twist/i.test(c.name)) continue;
        best = Math.max(best, head.distanceTo(c.getWorldPosition(new THREE.Vector3())));
    }
    if (best > 0) return Math.max(best, 0.02);

    // 3. Os vraiment terminal (tête, sans enfant).
    return 0.15;
}

// ============================================================
//  AXE D'UNE ARTICULATION
//
//  Un coude / genou tourne autour d'un axe précis. On le DÉRIVE
//  de la pose de repos au lieu de le deviner :
//    - membre : perpendiculaire à l'os et à la verticale
//               → axis = boneDir × up
//               (pour les os verticaux — colonne, jambes — ça
//                dégénère, on retombe sur l'axe X)
//
//  L'axe est renvoyé en ESPACE MONDE : comme tous les corps ont la
//  même orientation (identité), un axe monde est valide à la fois
//  pour le parent et pour l'enfant. C'est tout l'intérêt du choix
//  d'orientation commune (cf. commentaire de la table RAGDOLL).
//
//  Le sens de rotation compte : les bornes de la table RAGDOLL sont
//  asymétriques et tiennent compte du sens de l'os (cf. commentaire
//  de la table). Un os qui monte et un os qui descend n'ont pas le
//  même sens de « positif » alors qu'ils partagent le même axe.
// ============================================================
const AXIS_SIDE = new THREE.Vector3(1, 0, 0);
const AXIS_UP   = new THREE.Vector3(0, 1, 0);
const AXIS_FWD  = new THREE.Vector3(0, 0, 1);

function jointAxisWorld(bone, kind) {
    if (kind === 'side') return AXIS_SIDE.clone();
    if (kind === 'up')   return AXIS_UP.clone();
    if (kind === 'fwd')  return AXIS_FWD.clone();

    // 'limb' : perpendiculaire à l'os et à la verticale
    const head = bone.getWorldPosition(new THREE.Vector3());
    const tail = head.clone();
    for (const c of bone.children) {
        if (c.isBone) { tail.copy(c.getWorldPosition(new THREE.Vector3())); break; }
    }
    const dir = tail.sub(head).normalize();

    const axis = new THREE.Vector3().crossVectors(dir, AXIS_UP);
    if (axis.lengthSq() < 1e-6) axis.copy(AXIS_SIDE);
    return axis.normalize();
}

// ============================================================
//  LIMITES + MOTEUR DES ARTICULATIONS
//
//  setLimits(min, max)          -> butée d'angle (degrés -> radians)
//  configureMotorPosition(0,k,d)-> ressort PD vers l'angle de repos.
//  Les deux sont résolus PAR le solveur : c'est ce qui rend la
//  raideur stable, contrairement à un couple ou une projection.
// ============================================================
function applyJointLimits(entry) {
    if (!entry.joint) return;

    const [lo, hi] = entry.def.range || [0, 0];

    if (!params.limits) {
        entry.joint.setLimits(-Math.PI, Math.PI);
    } else {
        entry.joint.setLimits(
            THREE.MathUtils.degToRad(Math.min(lo, hi)),
            THREE.MathUtils.degToRad(Math.max(lo, hi))
        );
    }

    // Moteur : raideur de repos (ragdoll) ou rappel fort (active)
    const k = params.mode === 'active' ? params.activeStiffness : params.jointStiffness;
    const d = params.mode === 'active' ? params.activeDamping   : params.motorDamping;
    entry.joint.configureMotorPosition(0, k, d);
}

// ============================================================
//  CONSTRUCTION DU RAGDOLL
//
//  1. Un corps rigide par os (capsule), placé EXACTEMENT à la
//     transformation monde de l'os au repos. Conséquence utile :
//     synchroniser le corps -> l'os devient une simple copie,
//     sans décalage à gérer.
//  2. Un joint par os (sauf la racine), ancré à l'origine de
//     l'os enfant.
// ============================================================
function buildRagdoll() {
    modelRoot.updateMatrixWorld(true);

    // Ordre parent -> enfant (pour la synchro des os)
    const depthOf = (name) => {
        let d = 0, cur = name;
        while (true) {
            const e = RAGDOLL.find(r => r.bone === cur);
            if (!e || !e.parent) break;
            cur = e.parent;
            d++;
        }
        return d;
    };
    const ordered = RAGDOLL
        .map(def => ({ def, depth: depthOf(def.bone) }))
        .sort((a, b) => a.depth - b.depth);

    // --- Passe 1 : les corps rigides ---
    for (const { def } of ordered) {
        const bone = bonesByName[def.bone];
        let len = boneLength(def.bone, bone);
        // Capsules plus généreuses que l'os : un ragdoll trop maigre
        // s'enfonce dans le décor et ressemble à un squelette.
        let radius = Math.min(Math.max(len * 0.40, 0.05), 0.15);

        // Le bassin est traité à part : l'os `pelvis` d'UE5 est si court
        // qu'il donnerait un corps 29x plus léger que chaque cuisse, et
        // le solveur n'arrive alors plus à faire tenir le torse sur les
        // jambes (le bassin se déboîte). On lui impose donc des
        // dimensions de bassin humain, proportionnelles au personnage.
        if (def.bone === 'pelvis') {
            len = PELVIS_LEN_FRAC * TARGET_HEIGHT;
            radius = PELVIS_RADIUS_FRAC * TARGET_HEIGHT;
        }

        const halfHeight = Math.max(len / 2 - radius, 0.012);

        const worldPos = bone.getWorldPosition(new THREE.Vector3());
        const worldQuat = bone.getWorldQuaternion(new THREE.Quaternion());
        // Le modèle est mis à l'échelle (modelScale) : l'os a donc une
        // échelle monde ≠ 1. Il FAUT la conserver à la synchro, sinon
        // la matrice de skinning change d'échelle et le mesh se rétracte
        // vers l'origine de chaque os (le personnage paraît étiré/squelettique).
        const worldScale = bone.getWorldScale(new THREE.Vector3());

        // ORIENTATION COMMUNE (identité) pour TOUS les corps.
        // C'est ce qui rend l'axe des joints revolute valide pour le
        // parent ET l'enfant (cf. commentaire de la table RAGDOLL).
        // La rotation de l'os est reportée sur le collider.
        const body = world.createRigidBody(
            RAPIER.RigidBodyDesc.dynamic()
                .setTranslation(worldPos.x, worldPos.y, worldPos.z)
                .setRotation({ x: 0, y: 0, z: 0, w: 1 })
                .setLinearDamping(0.08)
                .setAngularDamping(params.angularDamping)
                .setCcdEnabled(true)
        );

        // La capsule est centrée à mi-longueur de l'os et tournée
        // comme l'os, mais dans le repère du corps (resté identité).
        const capOff = new THREE.Vector3(0, len / 2, 0).applyQuaternion(worldQuat);
        const collider = world.createCollider(
            RAPIER.ColliderDesc.capsule(halfHeight, radius)
                .setTranslation(capOff.x, capOff.y, capOff.z)
                .setRotation({ x: worldQuat.x, y: worldQuat.y, z: worldQuat.z, w: worldQuat.w })
                .setDensity(650)
                .setFriction(params.friction)
                .setRestitution(0.0)
                .setCollisionGroups(GROUPS_RAGDOLL),
            body
        );

        const entry = {
            name: def.bone,
            def,
            bone,
            body,
            collider,
            length: len,
            radius,
            restWorldPos: worldPos.clone(),
            restWorldQuat: worldQuat.clone(),
            restWorldScale: worldScale.clone(),
            restLocalPos: bone.position.clone(),
            restLocalQuat: bone.quaternion.clone(),
            joint: null,
            jointType: null,
            hingeAxis: null,
            restRelQuat: null,
            // Inertie scalaire (moyenne des 3 moments principaux).
            inertia: 1,
        };
        byName[def.bone] = entry;
    }

    // L'inertie n'est calculable qu'une fois les colliders attachés
    for (const e of Object.values(byName)) {
        const pi = e.body.principalInertia();
        e.inertia = Math.max((pi.x + pi.y + pi.z) / 3, 1e-5);
    }

    // La liste ordonnée parent -> enfant, en ENTRIES cette fois
    // (c'est ce que parcourent la synchro, les moteurs et le HUD)
    bodies = ordered.map(({ def }) => byName[def.bone]);

    // --- Passe 2 : les joints ---
    for (const entry of bodies) {
        const def = entry.def;
        if (!def.parent) continue;

        const parent = byName[def.parent];
        const child = entry;

        // Position du joint = origine de l'os enfant (monde)
        const jointWorld = child.restWorldPos.clone();

        // Ancre côté parent : comme les corps ont tous l'orientation
        // identité, l'espace local du corps == espace monde translaté.
        // Une simple soustraction suffit (pas de quaternion).
        const anchor1 = jointWorld.clone().sub(parent.restWorldPos);
        const a1 = { x: anchor1.x, y: anchor1.y, z: anchor1.z };
        const a2 = { x: 0, y: 0, z: 0 };

        // Axe du revolute, en espace MONDE. Grâce à l'orientation
        // commune des corps, ce même axe est correct pour le parent
        // comme pour l'enfant — c'est exactement ce que Rapier attend.
        const axis = jointAxisWorld(child.bone, def.axis);
        child.hingeAxis = axis;

        const jointData = RAPIER.JointData.revolute(
            a1, a2, { x: axis.x, y: axis.y, z: axis.z }
        );

        const joint = world.createImpulseJoint(jointData, parent.body, child.body, true);
        joint.setContactsEnabled(false);   // évite le jitter entre os voisins

        child.joint = joint;
        child.jointType = 'revolute';
        applyJointLimits(child);
    }

    console.log(`[ragdoll] ${bodies.length} corps, ` +
                `${bodies.filter(b => b.joint).length} articulations revolute ` +
                `(limites + moteur de position)`);

    buildHelpers();
}

// ============================================================
//  AIDES VISUELLES — capsules des corps + lignes des joints
// ============================================================
function buildHelpers() {
    for (const h of [...bodyHelpers, ...jointHelpers]) {
        scene.remove(h);
        if (h.geometry) h.geometry.dispose();
        if (h.material) h.material.dispose();
    }
    bodyHelpers = [];
    jointHelpers = [];

    const bodyMat = new THREE.MeshBasicMaterial({
        color: 0x4fd1ff, wireframe: true, transparent: true, opacity: 0.35, depthTest: false
    });
    const jointMat = new THREE.LineBasicMaterial({ color: 0xffc857, transparent: true, opacity: 0.85 });

    for (const e of Object.values(byName)) {
        // Capsule alignée sur le +Y local de l'os
        const geo = new THREE.CapsuleGeometry(
            e.radius,
            Math.max(e.length - 2 * e.radius, 0.02),
            4, 12
        );
        geo.translate(0, e.length / 2, 0);
        const mesh = new THREE.Mesh(geo, bodyMat);
        mesh.renderOrder = 999;
        scene.add(mesh);
        bodyHelpers.push(mesh);
        e.helper = mesh;

        // Ligne vers le parent
        if (e.def.parent) {
            const geo2 = new THREE.BufferGeometry().setFromPoints([
                new THREE.Vector3(), new THREE.Vector3()
            ]);
            const line = new THREE.Line(geo2, jointMat);
            line.frustumCulled = false;
            scene.add(line);
            jointHelpers.push(line);
            e.jointHelper = line;
        }
    }
}

// ============================================================
//  SYNCHRO : OS  ->  CORPS  (mode POSE, et au reset)
//
//  On remet chaque corps sur la transformation monde de son os.
//  Comme l'os est dans une hiérarchie, on lit d'abord la pose
//  LOCALE de repos (restLocalPos/Quat) qu'on a mémorisée.
// ============================================================
function syncBodiesFromRestPose() {
    for (const e of bodies) {
        e.bone.position.copy(e.restLocalPos);
        e.bone.quaternion.copy(e.restLocalQuat);
    }
    modelRoot.updateMatrixWorld(true);

    for (const e of bodies) {
        const p = e.bone.getWorldPosition(new THREE.Vector3());
        // Orientation identité : c'est l'orientation commune de tous
        // les corps (cf. table RAGDOLL).
        e.body.setTranslation({ x: p.x, y: p.y, z: p.z }, true);
        e.body.setRotation({ x: 0, y: 0, z: 0, w: 1 }, true);
        e.body.setLinvel({ x: 0, y: 0, z: 0 }, true);
        e.body.setAngvel({ x: 0, y: 0, z: 0 }, true);
    }
}

// ============================================================
//  SYNCHRO : CORPS  ->  OS  (modes RAGDOLL / ACTIVE)
//
//  Pour chaque corps, on reconstruit la matrice monde de l'os,
//  puis on la convertit en espace LOCAL du parent.
//  IMPORTANT : on parcourt dans l'ordre parent -> enfant, sinon
//  la matrice monde du parent n'est pas encore à jour.
// ============================================================
function syncBonesFromBodies() {
    modelRoot.updateMatrixWorld(true);

    for (const e of bodies) {
        const t = e.body.translation();
        const r = e.body.rotation();

        // Le corps porte l'orientation commune (identité) ; l'os, lui,
        // a sa propre orientation de repos. Le décalage est donc
        // CONSTANT : qOsMonde = qCorps · qOsRepos.
        _q1.set(r.x, r.y, r.z, r.w).multiply(e.restWorldQuat);

        // Matrice monde voulue pour cet os (position = origine du corps).
        // On conserve l'ÉCHELLE MONDE de repos de l'os : c'est elle qui
        // donne à la matrice de skinning sa bonne échelle. La forcer à 1
        // rétracte le mesh vers les os (personnage étiré/squelettique).
        _m1.compose(_v1.set(t.x, t.y, t.z), _q1, e.restWorldScale);

        // On la ramène dans l'espace local du parent
        const parentObj = e.bone.parent;

        // Les os NON simulés (clavicules, twist bones…) sont sautés par
        // la physique. Leur matrixWorld date du updateMatrixWorld() du
        // début de frame, donc d'AVANT que le torse ne bouge : le bras
        // se décale d'une frame. On recalcule toute la chaîne
        // intermédiaire depuis le premier ancêtre simulé (déjà à jour,
        // puisqu'on parcourt parent -> enfant).
        if (parentObj) {
            const chain = [];
            let cur = parentObj;
            while (cur && cur.isBone && !byName[cur.name]) {
                chain.push(cur);
                cur = cur.parent;
            }
            for (let i = chain.length - 1; i >= 0; i--) {
                const b = chain[i];
                b.updateMatrix();
                b.matrixWorld.multiplyMatrices(
                    b.parent ? b.parent.matrixWorld : IDENTITY, b.matrix
                );
            }
            _m1.premultiply(_m2.copy(parentObj.matrixWorld).invert());
        }
        _m1.decompose(e.bone.position, e.bone.quaternion, e.bone.scale);

        // Le parent doit être à jour AVANT ses enfants : on recalcule
        // sa matrice monde tout de suite (sinon les enfants utilisent
        // l'ancienne et tout se décale).
        e.bone.updateMatrix();
        e.bone.matrixWorld.multiplyMatrices(
            parentObj ? parentObj.matrixWorld : IDENTITY,
            e.bone.matrix
        );
    }
}

// ============================================================
//  PONYTAIL — chaîne PBD (Verlet + contraintes de distance)
//
//  Les os `pony_*` ne sont PAS dans la table RAGDOLL : le ragdoll ne
//  les pilote donc pas. On les simule à part, avec exactement le
//  principe de la Partie 4 du cours :
//
//    1. le point 0 est ÉPINGLÉ sur l'os `head` — il le suit ;
//    2. les autres points sont intégrés en Verlet (position précédente
//       + gravité) ;
//    3. N itérations de contraintes de distance rétablissent les
//       longueurs de repos ;
//    4. une raideur rappelle la chaîne vers sa forme de repos tournée
//       par la tête, sinon la queue se plie en accordéon.
//
//  Le maillage suit tout seul : les os `pony_*` portent déjà les poids
//  (transfert fait dans Blender) et Three.js re-skinne à partir de
//  leur `matrixWorld`.
// ============================================================
const PONYTAIL_BONES = ['pony_01', 'pony_02', 'pony_03', 'pony_04'];

// Réglages (exposés dans la GUI)
const ponyParams = {
    enabled: true,
    gravity: 9.81,
    // Amorti par FRAME (pas par seconde) : 0.94 laissait à peine
    // bouger la queue (la vitesse tombe à 2 % en une seconde).
    damping: 0.985,     // 1 = aucune perte d'énergie
    iterations: 8,
    stiffness: 0.35,    // 0 = chaîne libre · 1 = queue rigide
    // Tenue du PREMIER segment : sans ça la queue tombe trop à la
    // racine et vient trop près du dos. 1 = le segment suit la tête.
    rootStiffness: 0.55,
};

let ponytail = null;    // null si le FBX n'a pas les os pony_*

const _pv = new THREE.Vector3();
const _pv2 = new THREE.Vector3();
const _pq = new THREE.Quaternion();

function buildPonytail() {
    ponytail = null;
    const bones = PONYTAIL_BONES.map(n => bonesByName[n]).filter(Boolean);
    if (bones.length < 2) {
        console.log('[ponytail] pas d\'os pony_* dans ce FBX — chaîne désactivée');
        return;
    }

    // Points de la chaîne = origine de chaque os, + la queue du dernier.
    const pts = bones.map(b => b.getWorldPosition(new THREE.Vector3()));

    // Three.js ne stocke PAS la longueur d'un os terminal (pas de `tail`).
    // On la déduit du maillage : le vertex le plus lointain qui est
    // pondéré sur le dernier os.
    const last = bones[bones.length - 1];
    const lastHead = pts[pts.length - 1];
    let tip = null, bestD = -1;
    for (const sm of skinnedMeshes) {
        const g = sm.geometry;
        const si = g.attributes.skinIndex, sw = g.attributes.skinWeight;
        if (!si || !sw) continue;
        const li = sm.skeleton.bones.findIndex(b => b.name === last.name);
        if (li < 0) continue;
        for (let v = 0; v < si.count; v++) {
            let w = 0;
            for (let k = 0; k < 4; k++) {
                if (si.getComponent(v, k) === li) w = Math.max(w, sw.getComponent(v, k));
            }
            if (w < 0.5) continue;
            const p = new THREE.Vector3().fromBufferAttribute(g.attributes.position, v);
            sm.localToWorld(p);                       // repos == bind pose
            const d = p.distanceTo(lastHead);
            if (d > bestD) { bestD = d; tip = p; }
        }
    }
    if (!tip) tip = lastHead.clone().add(new THREE.Vector3(0, -0.15, 0));
    pts.push(tip);

    const rest = [];
    for (let i = 0; i < pts.length - 1; i++) rest.push(pts[i].distanceTo(pts[i + 1]));

    // Distances de REPLI : entre points espacés de deux (i et i+2).
    // C'est la raideur de pliage — cf. stepPonytail.
    const rest2 = [];
    for (let i = 0; i < pts.length - 2; i++) rest2.push(pts[i].distanceTo(pts[i + 2]));

    // Le point 0 est épinglé : on le garde en espace LOCAL de l'os
    // parent (le `head`) pour pouvoir le replacer à chaque frame.
    const parent = bones[0].parent;

    ponytail = {
        bones,
        parent,
        rootLocal: parent.worldToLocal(pts[0].clone()),
        // Position de repos du 2e point dans le repère de la tête :
        // sert à tenir le premier segment (cf. rootStiffness).
        p1Local: parent.worldToLocal(pts[1].clone()),
        restPts: pts.map(p => p.clone()),
        pts: pts.map(p => p.clone()),
        prev: pts.map(p => p.clone()),
        rest,
        rest2,
        restQuat: bones.map(b => b.getWorldQuaternion(new THREE.Quaternion())),
        restScale: bones.map(b => b.getWorldScale(new THREE.Vector3())),
    };
    console.log(`[ponytail] chaîne PBD prête — ${bones.length} os, ${pts.length} points, ` +
                `longueur ${rest.reduce((a, b) => a + b, 0).toFixed(3)} m`);
}

// Remet la chaîne sur sa forme de repos (le corps étant lui-même au
// repos après un reset / un changement de mode).
function resetPonytail() {
    if (!ponytail) return;
    const P = ponytail;
    for (let i = 0; i < P.pts.length; i++) {
        P.pts[i].copy(P.restPts[i]);
        P.prev[i].copy(P.restPts[i]);
    }
}

// Une passe de contraintes de distance. Le point 0 est infiniment
// lourd : il ne bouge pas (c'est le point épinglé).
function ponyDistancePass(P) {
    const N = P.pts.length;
    for (let i = 0; i < N - 1; i++) {
        const a = P.pts[i], b = P.pts[i + 1];
        _pv.copy(b).sub(a);
        const len = _pv.length() || 1e-9;
        const corr = (len - P.rest[i]) / len;
        if (i === 0) {
            b.addScaledVector(_pv, -corr);
        } else {
            a.addScaledVector(_pv, corr * 0.5);
            b.addScaledVector(_pv, -corr * 0.5);
        }
    }
}

function stepPonytail(dt) {
    if (!ponytail || !ponyParams.enabled) return;
    const P = ponytail;
    const N = P.pts.length;

    // --- 1. le point 0 suit l'os parent (le `head`) ---
    P.parent.updateMatrixWorld(true);
    P.pts[0].copy(P.parent.localToWorld(_pv2.copy(P.rootLocal)));

    // --- 2. intégration de Verlet ---
    const gdt = ponyParams.gravity * dt * dt;
    for (let i = 1; i < N; i++) {
        const p = P.pts[i], q = P.prev[i];
        const vx = (p.x - q.x) * ponyParams.damping;
        const vy = (p.y - q.y) * ponyParams.damping;
        const vz = (p.z - q.z) * ponyParams.damping;
        q.copy(p);
        p.set(p.x + vx, p.y + vy - gdt, p.z + vz);
    }

    // --- 3. contraintes de distance (PBD) ---
    for (let it = 0; it < ponyParams.iterations; it++) ponyDistancePass(P);

    // --- 4. raideur de REPLI ---
    // Contrainte de distance entre points espacés de DEUX (i et i+2) :
    // c'est le moyen le plus simple de limiter le pliage d'une chaîne.
    // Appliquée à 100 % la chaîne est rigide ; partiellement, elle
    // résiste au pliage sans se figer.
    //
    // Pourquoi pas un « shape matching » vers la pose de repos ? Parce
    // que la correction y est proportionnelle à l'ÉCART, et c'est le
    // bout de la queue qui s'écarte le plus : le bout devenait donc
    // plus raide que la racine. Ici la contrainte est la même pour
    // chaque triplet, donc la raideur est UNIFORME.
    if (ponyParams.stiffness > 0) {
        const k = ponyParams.stiffness;
        for (let i = 0; i < N - 2; i++) {
            const a = P.pts[i], b = P.pts[i + 2];
            _pv.copy(b).sub(a);
            const len = _pv.length() || 1e-9;
            const corr = ((len - P.rest2[i]) / len) * k;
            // le point 0 est épinglé : il ne bouge jamais
            if (i === 0) {
                b.addScaledVector(_pv, -corr);
            } else {
                a.addScaledVector(_pv, corr * 0.5);
                b.addScaledVector(_pv, -corr * 0.5);
            }
        }
        ponyDistancePass(P);
    }

    // --- 5. tenue du premier segment ---
    // Le point 0 est épinglé mais le segment reste libre de tourner :
    // la gravité le fait tomber vers le dos. On rappelle le point 1
    // vers sa position de repos dans le repère de la tête.
    if (ponyParams.rootStiffness > 0) {
        P.pts[1].lerp(P.parent.localToWorld(_pv2.copy(P.p1Local)), ponyParams.rootStiffness);
        ponyDistancePass(P);
    }
}

// Écrit les os `pony_*` à partir de la chaîne. Même logique que
// syncBonesFromBodies : matrice monde voulue -> espace local du parent,
// en conservant l'ÉCHELLE MONDE de repos de l'os.
function applyPonytail() {
    if (!ponytail || !ponyParams.enabled) return;
    const P = ponytail;

    for (let i = 0; i < P.bones.length; i++) {
        const bone = P.bones[i];

        // direction actuelle et direction de repos, en espace monde
        _pv.copy(P.pts[i + 1]).sub(P.pts[i]).normalize();
        _pv2.copy(P.restPts[i + 1]).sub(P.restPts[i]).normalize();

        _pq.setFromUnitVectors(_pv2, _pv).multiply(P.restQuat[i]);

        _m1.compose(P.pts[i], _pq, P.restScale[i]);
        const parentObj = bone.parent;
        if (parentObj) _m1.premultiply(_m2.copy(parentObj.matrixWorld).invert());
        _m1.decompose(bone.position, bone.quaternion, bone.scale);

        bone.updateMatrix();
        bone.matrixWorld.multiplyMatrices(
            parentObj ? parentObj.matrixWorld : IDENTITY, bone.matrix
        );
    }
}

// ============================================================
//  RAIDEUR ARTICULAIRE
//
//  Elle n'est PLUS appliquée ici par une projection de position :
//  c'est le MOTEUR de chaque joint revolute qui s'en charge
//  (configureMotorPosition, cf. applyJointLimits). Le solveur
//  résout cette contrainte en même temps que les ancres, donc elle
//  ne peut pas être annulée par le step — et une projection externe
//  ne peut pas non plus déchirer les ancres du parent.
// ============================================================

// ============================================================
//  ACTIONS
// ============================================================

// Direction tirée au hasard.
// On tire un AZIMUT uniforme plutôt que x et z indépendamment : deux
// uniformes normalisées se concentrent vers les DIAGONALES, donc on ne
// voit presque jamais partir « tout droit » ou « pile de côté ».
// `up` dose la composante verticale (0 = poussée horizontale).
function randomPushDir(up) {
    const az = Math.random() * Math.PI * 2;
    return new THREE.Vector3(Math.cos(az), up, Math.sin(az)).normalize();
}

// Petite rotation parasite, mise à l'échelle par l'inertie du corps
// (sinon les petits corps — tête, mains — partent en vrille).
function applyRandomSpin(body, inertia, amount) {
    body.applyTorqueImpulse({
        x: (Math.random() - 0.5) * 2 * inertia * amount,
        y: (Math.random() - 0.5) * 2 * inertia * amount,
        z: (Math.random() - 0.5) * 2 * inertia * amount,
    }, true);
}

// Déséquilibre initial : sans lui, le personnage tient debout sur son
// équilibre instable et on ne voit rien tomber. Direction ET intensité
// aléatoires — sinon tous les essais basculent du même côté.
function nudgeRagdoll(strength) {
    const e = byName['spine_03'];
    if (!e) return;
    const dir = randomPushDir(0)
        .multiplyScalar(e.body.mass() * strength * (0.7 + Math.random() * 0.6));
    e.body.applyImpulse({ x: dir.x, y: dir.y, z: dir.z }, true);
}

// Dernier azimut de poussée (radians) — affiché dans le HUD, pour voir
// d'un coup d'œil que la direction change bien à chaque poussée.
let lastPushAz = null;

// Poussée aléatoire sur le torse et la tête. `scale` dose l'intensité :
// 1 = poussée Espace, ~0.7 = poussée de reset.
//
// Une poussée vient d'UNE direction : on tire donc un SEUL azimut pour
// toute la poussée. Avec un azimut par corps, le torse, la tête et le
// bassin partiraient chacun de leur côté et la silhouette se
// cisaillerait. Seule l'INTENSITÉ varie d'un corps à l'autre.
function applyRandomPush(scale) {
    const az = Math.random() * Math.PI * 2;
    const up = 0.25 + Math.random() * 0.45;
    const dir = new THREE.Vector3(Math.cos(az), up, Math.sin(az)).normalize();
    const strength = (2.2 + Math.random() * 1.6) * scale;

    for (const name of ['spine_02', 'head', 'pelvis']) {
        const e = byName[name];
        if (!e) continue;
        const s = e.body.mass() * strength * (0.85 + Math.random() * 0.3);
        e.body.applyImpulse({ x: dir.x * s, y: dir.y * s, z: dir.z * s }, true);
        applyRandomSpin(e.body, e.inertia, 1.2 * scale);
    }
    lastPushAz = az;
}

function pushRagdoll() {
    // IMPORTANT : basculer en ragdoll AVANT d'appliquer l'impulsion.
    // setMode() remet les corps sur la pose de repos et remet les
    // vitesses à zéro — une impulsion donnée avant serait effacée.
    if (params.mode === 'pose') setMode('ragdoll');
    applyRandomPush(1.0);
}

function resetRagdoll() {
    syncBodiesFromRestPose();
    resetPonytail();
    // Une VRAIE poussée aléatoire, pas seulement le petit déséquilibre
    // de setMode : sinon, d'un reset à l'autre, la chute se ressemble
    // toujours (le petit déséquilibre ne suffit pas à contrer
    // l'asymétrie de la pose de repos).
    if (params.mode === 'ragdoll') applyRandomPush(0.7);
}

function setMode(mode) {
    params.mode = mode;

    // On repart toujours de la pose de repos : les vitesses sont remises
    // à zéro, donc aucun résidu de l'état précédent ne peut s'accumuler.
    syncBodiesFromRestPose();
    resetPonytail();
    accumulator = 0;

    // La raideur du moteur dépend du mode : on la réapplique.
    refreshMotors();

    // Léger déséquilibre (direction aléatoire) : sinon le personnage
    // reste debout sur son équilibre instable et on ne voit rien tomber.
    if (mode === 'ragdoll') nudgeRagdoll(1.0);
    if (gui) gui.controllersRecursive().forEach(c => c.updateDisplay());
}

// Réapplique butées + moteur à toutes les articulations (changement de
// mode ou de raideur dans la GUI).
function refreshMotors() {
    for (const e of Object.values(byName)) applyJointLimits(e);
}

// Applique le frottement au sol, au personnage ET aux obstacles.
// Il faut TOUT toucher : la règle de combinaison du sol est en Max,
// donc le contact effectif vaut max(sol, corps) — baisser un seul des
// deux ne changerait rien.
function applyFriction(v) {
    if (groundCollider) groundCollider.setFriction(v);
    for (const e of Object.values(byName)) if (e.collider) e.collider.setFriction(v);
    for (const c of obstacleColliders) c.setFriction(v);
}

// ============================================================
//  GUI
// ============================================================
function setupGUI() {
    gui = new GUI({ title: 'Session 18 — Ragdoll' });

    gui.add(params, 'mode', {
        'Pose (contrôlé)': 'pose',
        'Ragdoll (physique)': 'ragdoll',
        'Active ragdoll (PD)': 'active',
    }).name('Mode').onChange(setMode);

    const fContraintes = gui.addFolder('Contraintes');
    fContraintes.add(params, 'limits').name('Butées d\'angle').onChange(() => {
        for (const e of Object.values(byName)) applyJointLimits(e);
    });
    // LE réglage qui change la CHUTE : à 1.0 les pieds accrochent et le
    // personnage bascule ; bas, il glisse et s'affaisse sur place.
    fContraintes.add(params, 'friction', 0, 1.5, 0.05)
        .name('Frottement sol').onChange(applyFriction);

    // LE réglage important : la raideur articulaire. C'est la raideur
    // du moteur de position de chaque joint revolute — résolue par le
    // solveur, donc elle tient vraiment (contrairement à un couple).
    const fTonus = gui.addFolder('Raideur articulaire (ragdoll)');
    fTonus.add(params, 'jointStiffness', 0, 400, 5).name('Raideur k_p').onChange(refreshMotors);
    fTonus.add(params, 'motorDamping', 0, 60, 1).name('Amorti moteur k_d').onChange(refreshMotors);
    fTonus.add(params, 'angularDamping', 0, 4, 0.1).name('Amorti angulaire')
        .onChange(v => {
            for (const e of Object.values(byName)) e.body.setAngularDamping(v);
        });

    const fMoteur = gui.addFolder('Rappel de pose (mode active)');
    fMoteur.add(params, 'activeStiffness', 0, 3000, 25).name('Raideur k_p').onChange(refreshMotors);
    fMoteur.add(params, 'activeDamping', 0, 300, 5).name('Amorti k_d').onChange(refreshMotors);

    // --- Ponytail (chaîne PBD) ---
    if (ponytail) {
        const fPony = gui.addFolder('Ponytail (chaîne PBD)');
        fPony.add(ponyParams, 'enabled').name('Simulé');
        fPony.add(ponyParams, 'stiffness', 0, 1, 0.02).name('Raideur');
        fPony.add(ponyParams, 'rootStiffness', 0, 1, 0.02).name('Tenue racine');
        fPony.add(ponyParams, 'gravity', 0, 25, 0.5).name('Gravité');
        fPony.add(ponyParams, 'damping', 0.8, 1, 0.005).name('Amorti');
        fPony.add(ponyParams, 'iterations', 1, 20, 1).name('Itérations');
    }

    const fDebug = gui.addFolder('Débogage');
    fDebug.add(params, 'showBodies').name('Corps (capsules)').onChange(v => {
        for (const h of bodyHelpers) h.visible = v;
    });
    fDebug.add(params, 'showJoints').name('Joints (lignes)').onChange(v => {
        for (const h of jointHelpers) h.visible = v;
    });

    gui.add(params, 'push').name('Pousser (Espace)');
    gui.add(params, 'reset').name('Reset (R)');
}

// ============================================================
//  BOUCLE
// ============================================================
function animate() {
    const dt = Math.min(clockDelta(), 0.1);

    if (params.mode === 'pose') {
        // Rien à simuler : le personnage reste dans sa pose de repos
        syncBodiesFromRestPose();
    } else {
        // Pas de temps FIXE : on accumule le temps réel et on avance la
        // physique par tranches de 1/60 s. Un ragdoll simulé avec un dt
        // variable tremble (les contraintes ne convergent pas de la même
        // façon d'une frame à l'autre). Le plafond de 5 pas évite la
        // spirale de la mort si l'onglet a été en arrière-plan.
        accumulator += dt;
        let steps = 0;
        while (accumulator >= FIXED_DT && steps < 5) {
            world.timestep = FIXED_DT;
            // Tout est résolu par le solveur : contraintes d'ancre des
            // joints revolute + butées d'angle + moteurs de position.
            // Aucune correction externe après le step -> rien à défaire,
            // donc rien à injecter comme énergie.
            world.step();
            accumulator -= FIXED_DT;
            steps++;
        }
        syncBonesFromBodies();
    }

    // Le ponytail est simulé dans TOUS les modes (il doit pendre
    // naturellement même quand le personnage est figé en pose). Il est
    // steppé APRÈS la synchro : le point épinglé lit alors la position
    // à jour de l'os `head`.
    stepPonytail(dt);
    applyPonytail();

    updateHelpers();
    controls.update();
    renderer.render(scene, camera);
    updateHUD();
}

function updateHelpers() {
    for (const e of Object.values(byName)) {
        if (e.helper) {
            const t = e.body.translation();
            const r = e.body.rotation();
            // Comme pour l'os : le corps porte l'orientation commune,
            // l'os (et donc la capsule) a son orientation de repos.
            e.helper.position.set(t.x, t.y, t.z);
            e.helper.quaternion.set(r.x, r.y, r.z, r.w).multiply(e.restWorldQuat);
        }
        if (e.jointHelper && e.def.parent) {
            const p = byName[e.def.parent];
            const tp = p.body.translation(), tc = e.body.translation();
            const pos = e.jointHelper.geometry.attributes.position;
            pos.setXYZ(0, tp.x, tp.y, tp.z);
            pos.setXYZ(1, tc.x, tc.y, tc.z);
            pos.needsUpdate = true;
            e.jointHelper.geometry.computeBoundingSphere();
        }
    }
}

function updateHUD() {
    const modeLabel = {
        pose: 'POSE — le code décide (équivalent S16)',
        ragdoll: 'RAGDOLL — la physique décide',
        active: 'ACTIVE RAGDOLL — la physique décide, le PD résiste',
    }[params.mode];

    let energy = 0;
    for (const e of Object.values(byName)) {
        const v = e.body.linvel();
        energy += 0.5 * e.body.mass() * (v.x * v.x + v.y * v.y + v.z * v.z);
    }

    // Azimut de la dernière poussée : permet de VOIR que la direction
    // change bien à chaque Espace / reset.
    const az = lastPushAz === null
        ? '—'
        : `${((THREE.MathUtils.radToDeg(lastPushAz) + 360) % 360).toFixed(0)}°`;

    hudEl.textContent =
        `${modeLabel}\n` +
        `${bodies.length} corps · ${bodies.filter(b => b.joint).length} articulations ` +
        `revolute ${params.limits ? '(limitées)' : '(libres)'}\n` +
        `Raideur k_p = ${params.mode === 'active' ? params.activeStiffness : params.jointStiffness}` +
        ` · frottement µ = ${params.friction.toFixed(2)}` +
        ` · E_cin = ${energy.toFixed(1)} J` +
        ` · dernière poussée ${az}`;}

// ============================================================
//  UTILITAIRES
// ============================================================
let _lastT = performance.now();
function clockDelta() {
    const now = performance.now();
    const dt = (now - _lastT) / 1000;
    _lastT = now;
    return dt;
}

function onKey(ev) {
    if (ev.code === 'Space') { ev.preventDefault(); pushRagdoll(); }
    if (ev.code === 'KeyR') resetRagdoll();
}

function onResize() {
    camera.aspect = innerWidth / innerHeight;
    camera.updateProjectionMatrix();
    renderer.setSize(innerWidth, innerHeight);
}

// ============================================================
//  GO
// ============================================================
init();
