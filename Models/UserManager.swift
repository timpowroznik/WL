import SwiftUI

class UserManager: ObservableObject {
    @Published var coins: Int = 0
    @Published var highScore: Int = 0
    @Published var unlockedThemes: Set<String> = []
    @Published var unlockedCharacters: Set<String> = []
    @Published var unlockedPowerups: Set<String> = []
    
    // Singleton instance
    static let shared = UserManager()
    
    init() {
        // TODO: Load saved data
    }
    
    func addCoins(_ amount: Int) {
        coins += amount
        // TODO: Save data
    }
    
    func updateHighScore(_ score: Int) {
        if score > highScore {
            highScore = score
            // TODO: Save data
        }
    }
    
    func unlockTheme(_ themeId: String) {
        unlockedThemes.insert(themeId)
        // TODO: Save data
    }
    
    func unlockCharacter(_ characterId: String) {
        unlockedCharacters.insert(characterId)
        // TODO: Save data
    }
    
    func unlockPowerup(_ powerupId: String) {
        unlockedPowerups.insert(powerupId)
        // TODO: Save data
    }
} 