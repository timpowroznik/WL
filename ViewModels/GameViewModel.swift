import SwiftUI
import Combine

class GameViewModel: ObservableObject {
    @Published var currentWord: String?
    @Published var score = 0
    @Published var lives = 3
    @Published var timeRemaining: TimeInterval = 20
    @Published var errorMessage: String?
    @Published var gameOver = false
    @Published var wordsUsed: Set<String> = []
    @Published var isProcessing = false
    @Published var successMessage: String?
    
    let mode: GameMode
    let timePerWord: TimeInterval = 20
    private var timer: Timer?
    private var cancellables = Set<AnyCancellable>()
    var longestWord = ""
    
    // Joker system
    @Published var availableJokers: [String: Int] = [:]
    private var userManager: UserManager?
    
    init(mode: GameMode) {
        self.mode = mode
        setupGame()
        setupBindings()
    }
    
    func setUserManager(_ userManager: UserManager) {
        self.userManager = userManager
        loadAvailableJokers()
    }
    
    private func loadAvailableJokers() {
        availableJokers = userManager?.jokerInventory ?? [:]
    }
    
    private func setupBindings() {
        // Auto-clear error messages
        $errorMessage
            .compactMap { $0 }
            .delay(for: .seconds(3), scheduler: RunLoop.main)
            .sink { [weak self] _ in
                self?.errorMessage = nil
            }
            .store(in: &cancellables)
        
        // Auto-clear success messages
        $successMessage
            .compactMap { $0 }
            .delay(for: .seconds(2), scheduler: RunLoop.main)
            .sink { [weak self] _ in
                self?.successMessage = nil
            }
            .store(in: &cancellables)
    }
    
    func setupGame() {
        switch mode {
        case .endless:
            lives = -1 // Unlimited
        case .hardcore, .hardcore1v1:
            lives = 1
        case .classic1v1:
            lives = 3
        case .blitz:
            lives = -1
            timeRemaining = 300 // 5 minutes total
        default:
            lives = 3
        }
        
        // Reset game state
        score = 0
        wordsUsed.removeAll()
        errorMessage = nil
        successMessage = nil
        gameOver = false
        isProcessing = false
        loadAvailableJokers()
    }
    
    func startGame() {
        setupGame()
        startTimer()
    }
    
    func startTimer() {
        timer?.invalidate()
        
        if mode != .endless {
            timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
                guard let self = self else { return }
                
                if self.timeRemaining > 0 {
                    self.timeRemaining -= 0.1
                } else {
                    self.handleTimeout()
                }
            }
        }
    }
    
    func submitWord(_ word: String) {
        guard !isProcessing else { return }
        isProcessing = true
        
        errorMessage = nil
        successMessage = nil
        
        // Validation
        guard !word.isEmpty else {
            errorMessage = "Bitte gib ein Wort ein"
            isProcessing = false
            return
        }
        
        guard word.count >= 4 else {
            errorMessage = "Wort muss mindestens 4 Buchstaben haben"
            isProcessing = false
            return
        }
        
        if let lastWord = currentWord {
            let lastChar = lastWord.last!
            let firstChar = word.first!
            
            guard lastChar.lowercased() == firstChar.lowercased() else {
                errorMessage = "Wort muss mit '\(lastChar.uppercased())' beginnen"
                isProcessing = false
                return
            }
        }
        
        guard !wordsUsed.contains(word.lowercased()) else {
            errorMessage = "Wort wurde bereits verwendet"
            isProcessing = false
            return
        }
        
        guard WordValidator.isValid(word) else {
            errorMessage = "Kein gültiges Wort"
            isProcessing = false
            return
        }
        
        // Success
        wordsUsed.insert(word.lowercased())
        currentWord = word
        
        // Calculate points
        var points = 1
        if word.count > 6 {
            points += 1
        }
        if timeRemaining > 10 {
            points += 2 // Speed bonus
        }
        
        score += points
        
        if word.count > longestWord.count {
            longestWord = word
        }
        
        // Show success message
        var message = "+\(points) Punkte!"
        if word.count > 6 { message += " (Langes Wort!)" }
        if timeRemaining > 10 { message += " (Speed Bonus!)" }
        successMessage = message
        
        // Reset timer for next word
        if mode != .endless && mode != .blitz {
            timeRemaining = timePerWord
        }
        
        isProcessing = false
    }
    
    func handleTimeout() {
        if mode == .hardcore || mode == .hardcore1v1 {
            endGame()
            return
        }
        
        if lives > 0 {
            lives -= 1
            errorMessage = "Zeit abgelaufen!"
            timeRemaining = timePerWord
        } else {
            endGame()
        }
    }
    
    func endGame() {
        timer?.invalidate()
        timer = nil
        gameOver = true
        
        // Award coins to user
        if let userManager = userManager {
            userManager.earnCoinsFromGame(
                mode: mode,
                score: score,
                wordsCount: wordsUsed.count
            )
        }
    }
    
    // MARK: - Joker System
    func useJoker(_ type: JokerType) {
        guard let userManager = userManager else {
            errorMessage = "Joker-System nicht verfügbar"
            return
        }
        
        let jokerId = jokerTypeToId(type)
        
        guard userManager.useJoker(jokerId) else {
            errorMessage = "Keine \(jokerTypeToName(type)) mehr verfügbar"
            return
        }
        
        // Update local joker count
        availableJokers[jokerId] = userManager.getJokerCount(jokerId)
        
        // Apply joker effect
        switch type {
        case .changeLetter:
            applyChangeLetterJoker()
        case .doubleTime:
            applyDoubleTimeJoker()
        case .skipWord:
            applySkipWordJoker()
        }
        
        successMessage = "\(jokerTypeToName(type)) eingesetzt!"
        
        // Haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
    }
    
    private func applyChangeLetterJoker() {
        if let word = currentWord {
            // Generate random new last letter
            let alphabet = "abcdefghijklmnopqrstuvwxyz"
            let randomLetter = alphabet.randomElement()!
            let newWord = String(word.dropLast()) + String(randomLetter)
            currentWord = newWord
            successMessage = "Letzter Buchstabe geändert zu '\(randomLetter.uppercased())'"
        } else {
            successMessage = "Joker gespeichert für das nächste Wort"
        }
    }
    
    private func applyDoubleTimeJoker() {
        if mode != .endless && mode != .blitz {
            timeRemaining = min(timeRemaining * 2, timePerWord * 2)
            successMessage = "Zeit verdoppelt!"
        } else {
            successMessage = "Zeit-Joker im \(mode.displayName) nicht verfügbar"
        }
    }
    
    private func applySkipWordJoker() {
        currentWord = nil
        successMessage = "Wort übersprungen - starte neu!"
    }
    
    private func jokerTypeToId(_ type: JokerType) -> String {
        switch type {
        case .changeLetter: return "change_letter"
        case .doubleTime: return "double_time"
        case .skipWord: return "skip_word"
        }
    }
    
    private func jokerTypeToName(_ type: JokerType) -> String {
        switch type {
        case .changeLetter: return "Buchstabe ändern"
        case .doubleTime: return "Zeit verdoppeln"
        case .skipWord: return "Wort überspringen"
        }
    }
    
    func getJokerCount(_ type: JokerType) -> Int {
        let jokerId = jokerTypeToId(type)
        return availableJokers[jokerId] ?? 0
    }
    
    func calculateCoinsEarned() -> Int {
        guard let userManager = userManager else { return 0 }
        // This is calculated in UserManager.earnCoinsFromGame
        return userManager.calculateCoinsEarned(mode: mode, score: score, wordsCount: wordsUsed.count)
    }
    
    deinit {
        timer?.invalidate()
        cancellables.removeAll()
    }
}
