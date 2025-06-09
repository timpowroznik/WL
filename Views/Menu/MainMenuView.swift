import SwiftUI

// Alle deine Komponenten sind bereits im gleichen Target - kein extra Import nötig!

struct MainMenuView: View {
    @EnvironmentObject var userManager: UserManager
    @Binding var showingGame: Bool
    @Binding var selectedMode: GameMode
    @State private var showingShop = false
    @State private var showingLeaderboard = false
    @State private var showingSettings = false
    
    var body: some View {
        ZStack {
            // Use your existing BackgroundView - enhanced
            BackgroundView()
            
            VStack(spacing: 40) {
                // Logo with enhanced glass effect
                VStack(spacing: 12) {
                    Text("WordLoop")
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.white, Color.cyan.opacity(0.8)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 2)
                    
                    Text("Pure Skills. Pure Style.")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white.opacity(0.8))
                }
                .padding(.vertical, 20)
                .padding(.horizontal, 30)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.ultraThinMaterial)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(.white.opacity(0.3), lineWidth: 1)
                        )
                )
                .shadow(color: .black.opacity(0.3), radius: 15, x: 0, y: 8)
                .padding(.top, 30)
                
                Spacer()
                
                // Game Modes - using your existing GameModeButton
                VStack(spacing: 16) {
                    GameModeButton(
                        title: "Endless",
                        icon: "infinity",
                        description: "Spiele ohne Zeitlimit und sammle Punkte",
                        gradient: LinearGradient(
                            colors: [Color.blue, Color.cyan],
                            startPoint: .leading,
                            endPoint: .trailing
                        ),
                        action: {
                            selectedMode = .endless
                            showingGame = true
                        }
                    )
                    
                    GameModeButton(
                        title: "Hardcore",
                        icon: "flame.fill",
                        description: "Ein Fehler und das Spiel ist vorbei",
                        gradient: LinearGradient(
                            colors: [Color.red, Color.orange],
                            startPoint: .leading,
                            endPoint: .trailing
                        ),
                        action: {
                            selectedMode = .hardcore
                            showingGame = true
                        }
                    )
                    
                    GameModeButton(
                        title: "Blitz",
                        icon: "bolt.fill",
                        description: "5 Minuten Zeit - wie viele Wörter schaffst du?",
                        gradient: LinearGradient(
                            colors: [Color.yellow, Color.orange],
                            startPoint: .leading,
                            endPoint: .trailing
                        ),
                        action: {
                            selectedMode = .blitz
                            showingGame = true
                        }
                    )
                    
                    GameModeButton(
                        title: "Classic 1v1",
                        icon: "person.2.fill",
                        description: "Spiele gegen einen Freund im klassischen Modus",
                        gradient: LinearGradient(
                            colors: [Color.purple, Color.pink],
                            startPoint: .leading,
                            endPoint: .trailing
                        ),
                        action: {
                            // Placeholder für Multiplayer
                            // selectedMode = .classic1v1
                            // showingGame = true
                        }
                    )
                }
                .padding(.horizontal, 25)
                
                Spacer()
                
                // Bottom Bar with enhanced glass
                HStack(spacing: 40) {
                    BottomBarButton(icon: "paintbrush.fill", title: "Shop") {
                        showingShop = true
                    }
                    
                    BottomBarButton(icon: "trophy.fill", title: "Rangliste") {
                        showingLeaderboard = true
                    }
                    
                    BottomBarButton(icon: "gearshape.fill", title: "Settings") {
                        showingSettings = true
                    }
                }
                .padding(.vertical, 15)
                .padding(.horizontal, 30)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.ultraThinMaterial)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(.white.opacity(0.3), lineWidth: 1)
                        )
                )
                .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                .padding(.horizontal, 30)
                .padding(.bottom, 20)
            }
            
            // Enhanced Coin Display
            VStack {
                HStack {
                    Spacer()
                    
                    CoinDisplay(coins: userManager.coins)
                        .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
                        .padding(.trailing, 20)
                        .padding(.top, 10)
                }
                Spacer()
            }
        }
        .sheet(isPresented: $showingShop) {
            ShopView()
        }
        .sheet(isPresented: $showingLeaderboard) {
            LeaderboardView()
        }
        .sheet(isPresented: $showingSettings) {
            SettingsView()
        }
    }
}
