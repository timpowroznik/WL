import SwiftUI

struct ContentView: View {
    @EnvironmentObject var gameManager: GameManager
    @State private var showingGame = false
    @State private var selectedMode: GameMode = .endless
    @State private var showingStats = false
    
    // Nur die im Menü sichtbaren Modi
    let visibleGameModes: [GameMode] = [.endless, .hardcore, .blitz, .classic1v1]
    
    var body: some View {
        ZStack {
            if showingGame {
                GameView(mode: selectedMode, showingGame: $showingGame)
            } else {
                MainMenuView(showingGame: $showingGame, selectedMode: $selectedMode)
            }
            
            // Globale Statistiken-Button
            VStack {
                HStack {
                    Spacer()
                    Button(action: { showingStats = true }) {
                        Image(systemName: "chart.bar.fill")
                            .font(.system(size: 22))
                            .foregroundColor(.white)
                            .padding(12)
                            .background(
                                Circle()
                                    .fill(.ultraThinMaterial)
                            )
                    }
                    .padding(.trailing, 16)
                    .padding(.top, 8)
                }
                Spacer()
            }
        }
        .sheet(isPresented: $showingStats) {
            StatsView(visibleGameModes: visibleGameModes)
        }
    }
}

struct StatsView: View {
    @EnvironmentObject var gameManager: GameManager
    @Environment(\.dismiss) var dismiss
    let visibleGameModes: [GameMode]
    
    var body: some View {
        NavigationView {
            List {
                Section("Allgemeine Statistiken") {
                    StatRow(label: "Gesamtspiele", value: "\(gameManager.totalGames)")
                    StatRow(label: "Höchster Score", value: "\(gameManager.highScore)")
                    StatRow(label: "Längstes Wort", value: gameManager.longestWord.isEmpty ? "Noch keins" : gameManager.longestWord)
                }
                
                Section("Spielmodi") {
                    ForEach(visibleGameModes, id: \.self) { mode in
                        StatRow(
                            label: mode.displayName, 
                            value: "\(gameManager.getHighScore(for: mode))"
                        )
                    }
                }
                
                if !gameManager.achievements.isEmpty {
                    Section("Achievements (\(gameManager.achievements.count))") {
                        ForEach(gameManager.achievements) { achievement in
                            HStack(spacing: 12) {
                                Image(systemName: achievement.isUnlocked ? "trophy.fill" : "trophy")
                                    .font(.system(size: 20))
                                    .foregroundColor(achievement.isUnlocked ? .yellow : .gray)
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(achievement.title)
                                        .font(.system(size: 16, weight: .semibold))
                                    Text(achievement.description)
                                        .font(.system(size: 14))
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                                if achievement.isUnlocked {
                                    Text("✅")
                                        .font(.title2)
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                } else {
                    Section("Achievements") {
                        Text("Spiele ein paar Runden um Achievements freizuschalten!")
                            .foregroundColor(.secondary)
                            .italic()
                    }
                }
                
                // Debug Section (nur während Entwicklung)
                #if DEBUG
                Section("Debug") {
                    Button("Stats neu laden") {
                        gameManager.refreshStats()
                    }
                    Button("Test Achievement") {
                        gameManager.updateScore(150, for: .blitz)
                    }
                    Button("Reset Stats") {
                        UserDefaults.standard.removeObject(forKey: "totalGames")
                        UserDefaults.standard.removeObject(forKey: "highScore")
                        UserDefaults.standard.removeObject(forKey: "longestWord")
                        UserDefaults.standard.removeObject(forKey: "modeHighScores")
                        UserDefaults.standard.removeObject(forKey: "achievements")
                        gameManager.refreshStats()
                    }
                }
                #endif
            }
            .navigationTitle("Statistiken")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Fertig") {
                        dismiss()
                    }
                    .font(.system(size: 17, weight: .medium))
                }
            }
            .refreshable {
                // Pull-to-refresh
                gameManager.refreshStats()
            }
        }
        .onAppear {
            print("📱 StatsView appeared, refreshing...")
            gameManager.refreshStats()
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(GameManager())
        .environmentObject(UserManager())
}