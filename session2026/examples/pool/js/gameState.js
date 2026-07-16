// gameState.js
// Machine à états pour gérer les différentes phases du jeu

// --- GAME STATE MACHINE ---

export const GameStates = {
    MENU: 'menu',           // Main menu screen
    SETTINGS: 'settings',   // Settings screen
    IDLE: 'idle',           // Waiting for player interaction
    AIMING: 'aiming',       // Player is aiming the cue
    SHOOTING: 'shooting',   // Shot has been taken, balls are moving
    PAUSED: 'paused',       // Game is paused
    GAME_OVER: 'game_over'  // Game ended
};

class GameStateMachine {
    constructor() {
        this.currentState = GameStates.IDLE;
        this.listeners = [];
        
        // Gestion des joueurs (mode 2 joueurs)
        this.currentPlayer = 1; // 1 ou 2
    }

    setState(newState) {
        const oldState = this.currentState;
        this.currentState = newState;
        console.log(`Game state: ${oldState} -> ${newState}`);
        
        // Notify listeners
        this.listeners.forEach(listener => listener(newState, oldState));
    }

    getState() {
        return this.currentState;
    }

    isIdle() {
        return this.currentState === GameStates.IDLE;
    }

    isAiming() {
        return this.currentState === GameStates.AIMING;
    }

    isShooting() {
        return this.currentState === GameStates.SHOOTING;
    }

    canAim() {
        return this.currentState === GameStates.IDLE;
    }

    canShoot() {
        return this.currentState === GameStates.AIMING;
    }

    isMenu() {
        return this.currentState === GameStates.MENU;
    }

    isPaused() {
        return this.currentState === GameStates.PAUSED;
    }

    isSettings() {
        return this.currentState === GameStates.SETTINGS;
    }

    isPlaying() {
        return this.currentState === GameStates.IDLE || 
               this.currentState === GameStates.AIMING || 
               this.currentState === GameStates.SHOOTING;
    }

    // Add listener for state changes
    onStateChange(callback) {
        this.listeners.push(callback);
    }

    // Remove listener
    removeStateChangeListener(callback) {
        this.listeners = this.listeners.filter(l => l !== callback);
    }

    // Player management
    getCurrentPlayer() {
        return this.currentPlayer;
    }

    switchPlayer() {
        this.currentPlayer = this.currentPlayer === 1 ? 2 : 1;
        console.log(`Changement de joueur → Joueur ${this.currentPlayer}`);
        return this.currentPlayer;
    }
    
    resetPlayer() {
        this.currentPlayer = 1;
    }
}

// Export singleton instance
export const gameState = new GameStateMachine();
