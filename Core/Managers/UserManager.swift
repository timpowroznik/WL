import SwiftUI

class UserManager: ObservableObject {
    @Published var coins = 100
    @Published var unlockedThemes: [String] = ["default"]
    @Published var currentTheme = "default"
    @Published var jokerInventory: [String: Int] = [:]
    
    private let coinsKey = "userCoins"
    private let jokersKey = "jokerInventory"
    private let themesKey = "unlockedThemes"
    
    init() {
        loadUserData()
    }
    
    // MARK: - Coins Management
    func addCoins(_ amount: Int) {
        coins += amount
        saveUserData()
        
        // UI Update
        DispatchQueue.main.async {
            self.objectWillChange.send()
        }
        
        print("💰 Added \(amount) coins. Total: \(coins)")
    }
    
    func spendCoins(_ amount: Int) -> Bool {
        guard coins >= amount else {
            print("❌ Not enough coins! Have: \(coins), Need: \(amount)")
            return false
        }
        coins -= amount
        saveUserData()
        
        // UI Update
        DispatchQueue.main.async {
            self.objectWillChange.send()
        }
        
        print("💸 Spent \(amount) coins. Remaining: \(coins)")
        return true
    }
    
    // MARK: - Joker Management
    func addJoker(_ jokerId: String, quantity: Int = 1) {
        jokerInventory[jokerId, default: 0] += quantity
        saveUserData()
        
        // UI Update
        DispatchQueue.main.async {
            self.objectWillChange.send()
        }
        
        print("🃏 Added \(quantity)x \(jokerId). Total: \(jokerInventory[jokerId] ?? 0)")
    }
    
    func useJoker(_ jokerId: String) -> Bool {
        guard let quantity = jokerInventory[jokerId], quantity > 0 else {
            print("❌ No \(jokerId) jokers available!")
            return false
        }
        
        jokerInventory[jokerId] = quantity - 1
        saveUserData()
        
        // UI Update
        DispatchQueue.main.async {
            self.objectWillChange.send()
        }
        
        print("🃏 Used \(jokerId). Remaining: \(jokerInventory[jokerId] ?? 0)")
        return true
    }
    
    func getJokerCount(_ jokerId: String) -> Int {
        return jokerInventory[jokerId] ?? 0
    }
    
    // MARK: - Game Rewards
    func earnCoinsFromGame(mode: GameMode, score: Int, wordsCount: Int) {
        let coinsEarned = calculateCoinsEarned(mode: mode, score: score, wordsCount: wordsCount)
        addCoins(coinsEarned)
        
        print("🎮 Game finished! Mode: \(mode), Score: \(score), Earned: \(coinsEarned) coins")
    }
    
    func calculateCoinsEarned(mode: GameMode, score: Int, wordsCount: Int) -> Int {
        switch mode {
        case .endless:
            // 1 coin per word + score bonus
            return wordsCount + (score / 20)
        case .hardcore:
            // High risk, high reward
            return score > 0 ? 25 + (score / 10) : 0
        case .blitz:
            // Time pressure bonus
            return (score / 15) + (wordsCount / 2)
        case .classic1v1:
            // Multiplayer bonus
            return 30 + (score / 25)
        case .hardcore1v1:
            // Highest reward
            return score > 0 ? 50 + (score / 10) : 0
        default:
            return score / 20
        }
    }
    
    // MARK: - Data Persistence
    private func loadUserData() {
        coins = UserDefaults.standard.integer(forKey: coinsKey)
        if coins == 0 { coins = 100 } // Starting coins
        
        if let themesData = UserDefaults.standard.data(forKey: themesKey),
           let themes = try? JSONDecoder().decode([String].self, from: themesData) {
            unlockedThemes = themes
        }
        
        if let jokersData = UserDefaults.standard.data(forKey: jokersKey),
           let jokers = try? JSONDecoder().decode([String: Int].self, from: jokersData) {
            jokerInventory = jokers
        }
        
        print("📱 Loaded user data - Coins: \(coins), Jokers: \(jokerInventory)")
    }
    
    private func saveUserData() {
        UserDefaults.standard.set(coins, forKey: coinsKey)
        
        if let themesData = try? JSONEncoder().encode(unlockedThemes) {
            UserDefaults.standard.set(themesData, forKey: themesKey)
        }
        
        if let jokersData = try? JSONEncoder().encode(jokerInventory) {
            UserDefaults.standard.set(jokersData, forKey: jokersKey)
        }
        
        UserDefaults.standard.synchronize()
    }
    
    // MARK: - Debug Functions
    func resetUserData() {
        coins = 100
        jokerInventory = [:]
        unlockedThemes = ["default"]
        currentTheme = "default"
        saveUserData()
        
        print("🔄 User data reset!")
    }
    
    func addTestCoins() {
        addCoins(500)
        print("🧪 Added 500 test coins!")
    }
}
