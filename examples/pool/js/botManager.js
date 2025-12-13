// botManager.js
// Gestion du bot IA dans le jeu

import { SmartBot } from './smartBot.js';
import { gameState } from './gameState.js';

export class BotManager {
    constructor() {
        this.bot = null;
        this.bot2 = null; // Deuxième bot pour le mode Bot vs Bot
        this.isEnabled = false;
        this.botPlayer = 2; // Le bot joue en tant que Joueur 2 par défaut
        this.difficulty = 0.5; // Difficulté moyenne par défaut
        this.isBotVsBot = false; // Mode Bot vs Bot
    }

    /**
     * Active ou désactive le bot
     */
    setEnabled(enabled, difficulty = 0.5) {
        this.isEnabled = enabled;
        this.difficulty = difficulty;
        this.isBotVsBot = false;
        
        if (enabled && !this.bot) {
            this.bot = new SmartBot(difficulty);
            console.log(`🤖 Bot activé (difficulté: ${(difficulty * 100).toFixed(0)}%)`);
        } else if (!enabled) {
            console.log('🤖 Bot désactivé');
        }
    }

    /**
     * Active le mode Bot vs Bot
     */
    setBotVsBot(difficulty1 = 0.6, difficulty2 = 0.7) {
        this.isEnabled = true;
        this.isBotVsBot = true;
        this.bot = new SmartBot(difficulty1);
        this.bot2 = new SmartBot(difficulty2);
        console.log(`🤖 Mode Bot vs Bot activé`);
        console.log(`   Bot 1 (Joueur 1): ${(difficulty1 * 100).toFixed(0)}%`);
        console.log(`   Bot 2 (Joueur 2): ${(difficulty2 * 100).toFixed(0)}%`);
    }

    /**
     * Change la difficulté du bot
     */
    setDifficulty(difficulty) {
        this.difficulty = difficulty;
        if (this.bot) {
            this.bot.difficulty = difficulty;
            console.log(`🤖 Difficulté du bot: ${(difficulty * 100).toFixed(0)}%`);
        }
    }

    /**
     * Définit quel joueur est le bot
     */
    setBotPlayer(playerNumber) {
        this.botPlayer = playerNumber;
        console.log(`🤖 Le bot joue en tant que Joueur ${playerNumber}`);
    }

    /**
     * Vérifie si c'est au tour du bot de jouer
     */
    shouldBotPlay() {
        if (!this.isEnabled || !gameState.isIdle()) return false;
        
        // Mode Bot vs Bot : les deux joueurs sont des bots
        if (this.isBotVsBot) return true;
        
        // Mode PvE : seulement le botPlayer est un bot
        return gameState.getCurrentPlayer() === this.botPlayer;
    }

    /**
     * Fait jouer le bot
     */
    async playBotTurn(whiteBall, balls, shootCallback) {
        if (!this.shouldBotPlay()) return;
        
        const currentPlayer = gameState.getCurrentPlayer();
        
        // Mode Bot vs Bot : choisir le bon bot
        if (this.isBotVsBot) {
            const activeBot = currentPlayer === 1 ? this.bot : this.bot2;
            console.log(`🤖 Bot ${currentPlayer} réfléchit...`);
            await activeBot.playTurn(whiteBall, balls, shootCallback);
        } else {
            // Mode PvE : un seul bot
            console.log(`🤖 C'est au tour du bot (Joueur ${this.botPlayer})`);
            await this.bot.playTurn(whiteBall, balls, shootCallback);
        }
    }
}

// Instance singleton
export const botManager = new BotManager();
