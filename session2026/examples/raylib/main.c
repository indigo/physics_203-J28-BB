#include "raylib.h"

typedef struct {
    Vector2 pos;     // Position actuelle
    Vector2 old_pos; // Position à la frame précédente
    Vector2 accel;   // Accélération (gravité)
    float radius;
} Ball;

int main(void) {
    // Initialisation
    InitWindow(800, 600, "Physique 203 - Verlet Minimaliste - raylib");
    SetTargetFPS(60);

    Ball ball;
    ball.pos = (Vector2){ 400, 100 };
    ball.old_pos = (Vector2){ 395, 100 }; // Un petit décalage initial crée une vitesse X
    ball.accel = (Vector2){ 0, 1000 };     // Gravité
    ball.radius = 20;

    while (!WindowShouldClose()) {
        float dt = GetFrameTime();

        // --- ÉTAPE 1 : CALCUL DE LA VITESSE (Implicite) ---
        // vitesse = position_actuelle - position_precedente
        Vector2 velocity = {
            ball.pos.x - ball.old_pos.x,
            ball.pos.y - ball.old_pos.y
        };

        // --- ÉTAPE 2 : MISE À JOUR DES POSITIONS ---
        // On sauvegarde la position actuelle (qui deviendra l'ancienne)
        ball.old_pos = ball.pos;

        // Formule de Verlet : pos = pos + vitesse + (accel * dt * dt)
        ball.pos.x += velocity.x + ball.accel.x * dt * dt;
        ball.pos.y += velocity.y + ball.accel.y * dt * dt;

        // --- ÉTAPE 3 : GESTION DES MURS (Contraintes) ---
        // Au sol
        if (ball.pos.y > GetScreenHeight() - ball.radius) {
            ball.pos.y = GetScreenHeight() - ball.radius;
        }
        // Murs latéraux
        if (ball.pos.x > GetScreenWidth() - ball.radius) ball.pos.x = GetScreenWidth() - ball.radius;
        if (ball.pos.x < ball.radius) ball.pos.x = ball.radius;

        // --- DESSIN ---
        BeginDrawing();
            ClearBackground(RAYWHITE);
            DrawCircleV(ball.pos, ball.radius, MAROON);
            DrawText("L'inertie est calculée via (pos - old_pos)", 10, 10, 20, DARKGRAY);
        EndDrawing();
    }

    CloseWindow();
    return 0;
}