// constants.js
// Constantes physiques et dimensions de la table de billard

// --- CONSTANTES PHYSIQUES ---
export const BALL_RADIUS = 0.20;
export const BALL_MASS = 0.17;
export const GRAVITY = 9.81;
export const INERTIA = 0.4 * BALL_MASS * BALL_RADIUS * BALL_RADIUS; // Inertie d'une sphère pleine : 2/5 * m * r²

// Dimensions table
export const TABLE_W = 13.0;
export const TABLE_H = 7.0;

// Dimensions détaillées de la table
export const S = 0.007353;
export const VAL_CORNER_MOUTH = 115 * S;
export const VAL_SIDE_MOUTH = 150 * S;
export const VAL_OFFSET_CORNER = 50 * S;
export const VAL_OFFSET_SIDE = 78 * S;
export const VAL_HOLE_RADIUS = 80 * S;
export const CORNER_KNUCKLE = VAL_CORNER_MOUTH / Math.sqrt(2);
export const SIDE_KNUCKLE = VAL_SIDE_MOUTH / 2;
export const RAIL_HEIGHT = 0.32;
export const RUBBER_DEPTH = 0.40;
export const WOOD_DEPTH = 0.80;
export const FRAME_WIDTH = 1.2;
export const FRAME_HEIGHT = 0.45;
