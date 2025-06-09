import SwiftUI

class GameManager: ObservableObject {
    @Published var currentMode: GameMode?
    @Published var isPlaying = false
    @Published var totalGames = 0
    @Published var highScore = 0
    @Published var longestWord = ""
    @Published var modeHighScores: [GameMode: Int] = [:]
    @Published var achievements: [Achievement] = []
    
    private let defaults = UserDefaults.standard
    private let totalGamesKey = "totalGames"
    private let highScoreKey = "highScore"
    private let longestWordKey = "longestWord"
    private let modeHighScoresKey = "modeHighScores"
    private let achievementsKey = "achievements"
    
    init() {
        loadStats()
    }
    
    func startGame(mode: GameMode) {
        currentMode = mode
        isPlaying = true
        totalGames += 1
        saveStats()
        
        // Wichtig: UI sofort aktualisieren
        DispatchQueue.main.async {
            self.objectWillChange.send()
        }
    }
    
    func endGame() {
        isPlaying = false
        
        // UI aktualisieren
        DispatchQueue.main.async {
            self.objectWillChange.send()
        }
    }
    
    func updateScore(_ score: Int, for mode: GameMode) {
        print("📊 Updating score: \(score) for mode: \(mode)") // Debug
        
        if score > highScore {
            highScore = score
            print("🏆 New high score: \(highScore)")
        }
        
        let currentHighScore = modeHighScores[mode] ?? 0
        if score > currentHighScore {
            modeHighScores[mode] = score
            print("🎮 New mode high score for \(mode): \(score)")
        }
        
        saveStats()
        checkAchievements(score: score, mode: mode)
        
        // UI sofort aktualisieren
        DispatchQueue.main.async {
            self.objectWillChange.send()
        }
    }
    
    func updateLongestWord(_ word: String) {
        print("📝 Checking longest word: \(word) (current: \(longestWord))")
        
        if word.count > longestWord.count {
            longestWord = word
            print("📏 New longest word: \(longestWord)")
            saveStats()
            
            // UI aktualisieren
            DispatchQueue.main.async {
                self.objectWillChange.send()
            }
        }
    }
    
    func getHighScore(for mode: GameMode) -> Int {
        let score = modeHighScores[mode] ?? 0
        print("🔍 Getting high score for \(mode): \(score)")
        return score
    }
    
    func loadStats() {
        print("📥 Loading stats...")
        
        totalGames = defaults.integer(forKey: totalGamesKey)
        highScore = defaults.integer(forKey: highScoreKey)
        longestWord = defaults.string(forKey: longestWordKey) ?? ""
        
        if let data = defaults.data(forKey: modeHighScoresKey),
           let scores = try? JSONDecoder().decode([GameMode: Int].self, from: data) {
            modeHighScores = scores
        }
        
        if let data = defaults.data(forKey: achievementsKey),
           let achievements = try? JSONDecoder().decode([Achievement].self, from: data) {
            self.achievements = achievements
        } else {
            // Initialisiere leere Achievements wenn keine vorhanden
            self.achievements = []
        }
        
        print("📊 Loaded stats - Games: \(totalGames), High Score: \(highScore), Longest: \(longestWord)")
        print("🎮 Mode scores: \(modeHighScores)")
        
        // UI aktualisieren nach dem Laden
        DispatchQueue.main.async {
            self.objectWillChange.send()
        }
    }
    
    private func saveStats() {
        print("💾 Saving stats...")
        
        defaults.set(totalGames, forKey: totalGamesKey)
        defaults.set(highScore, forKey: highScoreKey)
        defaults.set(longestWord, forKey: longestWordKey)
        
        if let data = try? JSONEncoder().encode(modeHighScores) {
            defaults.set(data, forKey: modeHighScoresKey)
        }
        
        if let data = try? JSONEncoder().encode(achievements) {
            defaults.set(data, forKey: achievementsKey)
        }
        
        // Force sync
        defaults.synchronize()
        
        print("✅ Stats saved successfully")
    }
    
    private func checkAchievements(score: Int, mode: GameMode) {
        let newAchievements = [
            Achievement(id: "first_game", title: "Erstes Spiel", description: "Spiele dein erstes Spiel", isUnlocked: totalGames >= 1),
            Achievement(id: "score_100", title: "Score 100", description: "Erreiche 100 Punkte", isUnlocked: score >= 100),
            Achievement(id: "word_master", title: "Wortmeister", description: "Finde ein Wort mit 10 Buchstaben", isUnlocked: longestWord.count >= 10),
            Achievement(id: "hardcore_master", title: "Hardcore Meister", description: "Gewinne im Hardcore-Modus", isUnlocked: mode == .hardcore && score > 0),
            Achievement(id: "blitz_master", title: "Blitz Meister", description: "Erreiche 200 Punkte im Blitz-Modus", isUnlocked: mode == .blitz && score >= 200)
        ]
        
        var achievementUnlocked = false
        
        for achievement in newAchievements {
            if !achievements.contains(where: { $0.id == achievement.id }) && achievement.isUnlocked {
                achievements.append(achievement)
                achievementUnlocked = true
                print("🏆 Achievement unlocked: \(achievement.title)")
                
                NotificationCenter.default.post(
                    name: NSNotification.Name("AchievementUnlocked"),
                    object: nil,
                    userInfo: ["achievement": achievement]
                )
            }
        }
        
        if achievementUnlocked {
            saveStats()
        }
    }
    
    // Neue Methode zum manuellen Refresh
    func refreshStats() {
        loadStats()
    }
}