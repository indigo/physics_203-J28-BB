// materials.js
// Système de matériaux et shaders PBR pour la table de billard

import * as THREE from 'three';

/**
 * Matériau AVANCÉ pour le tapis (Felt)
 * Utilise MeshStandardMaterial modifié via onBeforeCompile pour :
 * 1. Garder les ombres et l'éclairage réaliste de la scène
 * 2. Générer une texture de feutre procédurale haute résolution
 */
export function createFeltMaterial() {
    const material = new THREE.MeshStandardMaterial({
        color: 0x1a8c35, // Vert billard de base (légèrement plus sombre pour le contraste)
        roughness: 0.9,  // Très rugueux, ne brille pas comme du plastique
        metalness: 0.0,
        side: THREE.FrontSide
    });

    // Injection du shader personnalisé dans le pipeline standard de Three.js
    material.onBeforeCompile = function(shader) {
        // 1. Uniformes : On augmente drastiquement l'échelle
        // Une échelle de 1.0 = des vagues de 1 mètre
        // Une échelle de 1500.0 = des fibres de 1 millimètre
        shader.uniforms.noiseScale = { value: 1000.0 }; 
        shader.uniforms.fiberIntensity = { value: 0.08 }; // Contraste du grain (ni trop fort, ni trop faible)
        
        // 2. Fonction de bruit "Hash" (Bruit statique)
        // C'est beaucoup mieux pour simuler du tissu/sable que le bruit de Perlin
        const noiseFunction = `
            // Hash sans sinus (plus rapide et plus "croustillant")
            float hash(vec2 p) {
                vec3 p3  = fract(vec3(p.xyx) * .1031);
                p3 += dot(p3, p3.yzx + 33.33);
                return fract((p3.x + p3.y) * p3.z);
            }
            
            // Varying pour passer la position locale du vertex au fragment
            varying vec3 vLocalPosition;
        `;

        // Modification du Vertex Shader pour récupérer la position locale
        // On utilise la position locale (le modèle 3D) plutôt que les UVs pour éviter les déformations
        shader.vertexShader = 'varying vec3 vLocalPosition;\n' + shader.vertexShader;
        shader.vertexShader = shader.vertexShader.replace(
            '#include <begin_vertex>',
            `
            #include <begin_vertex>
            vLocalPosition = position; // On capture la position brute du modèle
            `
        );
        
        // Modification du Fragment Shader
        shader.fragmentShader = noiseFunction + '\n' + shader.fragmentShader;
        shader.fragmentShader = 'uniform float noiseScale;\nuniform float fiberIntensity;\n' + shader.fragmentShader;

shader.fragmentShader = shader.fragmentShader.replace(
            '#include <map_fragment>',
            `
            #include <map_fragment>
            
            // --- 1. CALCUL DU GRAIN ---
            vec2 pos = vLocalPosition.xz;
            float grain = hash(pos * noiseScale);
            float microGrain = hash(pos * noiseScale * 3.5);
            float combinedGrain = (grain * 0.7 + microGrain * 0.3);
            
            // --- 2. EFFET DE VIGNETTE RECTANGULAIRE (CORRIGÉ) ---
            // Rappel : pos est un vec2, donc on utilise .x et .y
            
            // Axe X (Largeur ~13m) -> abs(pos.x)
            float edgeX = smoothstep(4.0, 6.5, abs(pos.x));
            
            // Axe Z (Profondeur ~7m) -> abs(pos.y) car c'est le 2eme composant du vec2
            float edgeZ = smoothstep(1.5, 3.5, abs(pos.y));
            
            // On prend le maximum des deux pour assombrir si on est près de n'importe quel bord
            float shadowStrength = max(edgeX, edgeZ);
            
            // Vignette finale : 1.0 au centre, 0.4 aux bords
            float vignette = 1.0 - (shadowStrength * 0.2); 
            
            // --- 3. APPLICATION SUR LA COULEUR ---
            // On modifie diffuseColor (variable interne de Three.js)
            vec3 finalColor = diffuseColor.rgb + (combinedGrain - 0.5) * fiberIntensity;
            
            // Appliquer la vignette
            finalColor *= vignette;

            diffuseColor.rgb = finalColor;
            `
        );
    };

    return material;}

/**
 * Matériau pour les bandes (cushions)
 * Caoutchouc/Tissu légèrement différent
 */
export function createCushionMaterial() {
    return new THREE.MeshStandardMaterial({
        color: 0x146b2b, // Un peu plus foncé que le tapis
        roughness: 0.85,
        metalness: 0.05
    });
}

/**
 * Matériau pour le cadre en bois
 * Ajout d'une texture procédurale simple pour simuler des veines
 */
export function createWoodMaterial() {
    const mat = new THREE.MeshStandardMaterial({
        color: 0x5c3a21, // Bois acajou
        roughness: 0.3,  // Un peu brillant (vernis)
        metalness: 0.0
    });
    
    // Petite astuce : on peut ajouter une map ici si tu as une texture bois.jpg
    // Pour l'instant on reste procédural/couleur simple
    return mat;
}

/**
 * Matériau pour les trous (pockets)
 */
export function createPocketMaterial() {
    return new THREE.MeshStandardMaterial({
        color: 0x050505, // Presque noir
        roughness: 0.5,
        metalness: 0.1
    });
}

/**
 * Matériau pour les coins métalliques (si présents dans ton modèle 3D)
 */
export function createChromeMaterial() {
    return new THREE.MeshStandardMaterial({
        color: 0xffffff,
        roughness: 0.15,
        metalness: 0.9 // Très métallique
    });
}

/**
 * Applique les matériaux appropriés au modèle GLB
 */
export function applyMaterialsToModel(model) {
    const feltMat = createFeltMaterial();
    const cushionMat = createCushionMaterial();
    const woodMat = createWoodMaterial();
    const pocketMat = createPocketMaterial();
    const chromeMat = createChromeMaterial();
    
    console.log('Application des matériaux PBR avancés...');
    
    model.traverse((child) => {
        if (child.isMesh) {
            // Ombres dynamiques (ESSENTIEL pour le réalisme)
            child.receiveShadow = true;
            child.castShadow = true;
            
            const name = child.name.toLowerCase();
            
            // Logique d'attribution intelligente
            if (name.includes('felt') || name.includes('tapis') || name.includes('surface')) {
                child.material = feltMat;
            }
            else if (name.includes('cushion') || name.includes('bande') || name.includes('rail')) {
                child.material = cushionMat;
            }
            else if (name.includes('wood') || name.includes('frame') || name.includes('cadre') || name.includes('bois')) {
                child.material = woodMat;
            }
            else if (name.includes('metal') || name.includes('chrome') || name.includes('corner')) {
                child.material = chromeMat;
            }
            else if (name.includes('pocket') || name.includes('liner') || name.includes('trou')) {
                child.material = pocketMat;
            }
            else {
                // Par défaut, on suppose que c'est du bois ou du décor
                child.material = woodMat; 
            }
            
            // Correction pour éviter les bugs d'affichage sur certains angles
            child.frustumCulled = false;
        }
    });
}
