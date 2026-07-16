#include <iostream>
#include <raylib.h>
#include <raymath.h>
#include <vector>
#include <stdlib.h>

using namespace std;

const float REST_VELOCITY = 4.0f;
const Vector2 gravity = {0, 9.8};
typedef struct {
    Vector2 pos{0,0};     // Position actuelle
    //Vector2 old_pos; // Position à la frame précédente
    Vector2 accel{0,0};   // Accélération (gravité)
    float radius = 10;
    float masse = 5;
    float speed = 0;
    float magnitude = 0;
    float restitution = 0.8;
    //Vector2 direction;
    Vector2 force{0,0};
    Vector2 velocity{1,0};
} Ball;

void UpdatePhysicsEulerMethod(vector<Ball>&);
void UpdatePixel(vector<Ball>&);

int main() {
    srand(NULL);
    // Initialisation
    InitWindow(800, 600, "Physique 203 - Verlet Minimaliste - raylib");
    SetTargetFPS(60);
    vector<Ball> listBall;
    //ball.old_pos = (Vector2){ 395, 100 }; // Un petit décalage initial crée une vitesse X
    //ball.accel = (Vector2){ 0, 9.8 };     // Gravité

    for (int i = 0; i < 10; i++)
    {
        Ball b;
        float randX = rand() % GetScreenWidth();
        float randY = rand() % 50;
        b.pos = {randX, randY};
        listBall.push_back(b);
    }
    while (!WindowShouldClose()) {
        // --- ÉTAPE 1 : CALCUL DE LA VITESSE (Implicite) ---
        // vitesse = position_actuelle - position_precedente
        // Murs latéraux
        //if (ball.pos.x > GetScreenWidth() - ball.radius) ball.pos.x = GetScreenWidth() - ball.radius;
        //if (ball.pos.x < ball.radius) ball.pos.x = ball.radius;

        // --- DESSIN ---
        BeginDrawing();
            ClearBackground(RAYWHITE);
            UpdatePhysicsEulerMethod(listBall);
            UpdatePixel(listBall);
            //DrawCircleV(ball.pos, ball.radius, RED);
            DrawText("L'inertie est calculée via (pos - old_pos)", 10, 10, 20, DARKGRAY);
        EndDrawing();
    }



    CloseWindow();
    return 0;
}

void UpdatePhysicsEulerMethod(vector<Ball> &listBall)
{
    float dt = GetFrameTime();
    for (int i = 0; i < listBall.size(); i++)
    {
                
        listBall[i].force = {0,0};
        Vector2 gravityForce = Vector2Scale(gravity, listBall[i].masse);
        // new position
        listBall[i].force += gravityForce;
        listBall[i].accel = listBall[i].force / listBall[i].masse;

        listBall[i].velocity = Vector2Add(listBall[i].velocity, Vector2Scale(listBall[i].accel, dt));

        // --- ÉTAPE 2 : MISE À JOUR DES POSITIONS ---
        // On sauvegarde la position actuelle (qui deviendra l'ancienne)
        //ball.pos = Vector2Add(ball.pos , Vector2Scale(velocity, dt));

        // Formule de Verlet : pos = pos + vitesse + (accel * dt * dt)
        
        //ball.pos.x += velocity.x + ball.accel.x * dt * dt;
        //ball.pos.y += velocity.y + ball.accel.y * dt * dt;
        
        // --- ÉTAPE 3 : GESTION DES MURS (Contraintes) ---
        // Au sol
        if (listBall[i].pos.y > GetScreenHeight() - listBall[i].radius) {
            listBall[i].pos.y = GetScreenHeight() - listBall[i].radius; // pour ne pas traverser vers le sol
            
            if (listBall[i].velocity.y < REST_VELOCITY)
            {
                listBall[i].velocity.y = 0;
            }

            listBall[i].velocity.y *= -listBall[i].restitution ; //bounce
        }

        if (listBall[i].pos.x > GetScreenWidth() - listBall[i].radius) {
            listBall[i].pos.x = GetScreenWidth() - listBall[i].radius; // pour ne pas traverser vers le sol
            listBall[i].velocity.y *= -listBall[i].restitution ; //bounce
        }

        for (int j = i + 1; j < listBall.size(); j++)
        {
            if (CheckCollisionCircles(listBall[i].pos, listBall[i].radius, listBall[j].pos, listBall[j].radius))
            {
                Vector2 newVelocity = listBall[i].velocity;

                Vector2 normal = Vector2Subtract(listBall[j].pos, listBall[i].pos);
                float len = sqrt(normal.x * normal.x + normal.y * normal.y);
                if (len == 0.0f) continue;
                normal /= len;

                float reflecX = listBall[i].velocity.x - (2 * (listBall[i].velocity.x * normal.x + listBall[i].velocity.y * normal.y) * normal.x);
                float reflecY = listBall[i].velocity.y - (2 * (listBall[i].velocity.x * normal.x + listBall[i].velocity.y * normal.y) * normal.y);
                newVelocity = {reflecX, reflecY};
                listBall[i].velocity = newVelocity;
            }
        }
        
        
        listBall[i].pos = Vector2Add(listBall[i].pos, Vector2Add(listBall[i].velocity, Vector2Scale(listBall[i].accel, dt * dt)));
    }

}

void UpdatePixel(vector<Ball> &listBall)
{
    for (int i = 0; i < listBall.size(); i++)
    {
        DrawCircleV(listBall[i].pos, listBall[i].radius, RED);
    }
    
}