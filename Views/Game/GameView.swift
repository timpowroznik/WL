import SwiftUI
import Combine

struct GameView: View {
    let mode: GameMode
    @Binding var showingGame: Bool
    @StateObject private var viewModel: GameViewModel
    @EnvironmentObject var gameManager: GameManager
    @EnvironmentObject var userManager: UserManager
    @State private var inputWord = ""
    @State private var showingGameOver = false
    @State private var showingAchievement = false
    @State private var currentAchievement: Achievement?
    @FocusState private var isInputFocused: Bool
    @State private var pulseAnimation = false

    init(mode: GameMode, showingGame: Binding<Bool>) {
        self.mode = mode
        self._showingGame = showingGame
        self._viewModel = StateObject(wrappedValue: GameViewModel(mode: mode))
    }

    var body: some View {
        ZStack {
            BackgroundView()

            VStack(spacing: 25) {
                // Top Bar
                HStack {
                    // Close Button
                    Button(action: { showingGame = false }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 28))
                            .foregroundColor(.white.opacity(0.8))
                            .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
                    }

                    Spacer()

                    // Score Display
                    HStack(spacing: 12) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.yellow)
                            .shadow(color: .yellow.opacity(0.6), radius: 3, x: 0, y: 1)
                            .scaleEffect(pulseAnimation ? 1.1 : 1.0)
                            .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: pulseAnimation)
                        
                        Text("\(viewModel.score)")
                            .font(.system(size: 26, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.ultraThinMaterial)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(.white.opacity(0.3), lineWidth: 1)
                            )
                    )
                    .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)

                    Spacer()

                    // Lives Display (for applicable modes)
                    if mode == .classic1v1 || mode == .hardcore1v1 {
                        HStack(spacing: 6) {
                            ForEach(0..<viewModel.lives, id: \.self) { _ in
                                Image(systemName: "heart.fill")
                                    .font(.system(size: 20))
                                    .foregroundColor(.red)
                                    .shadow(color: .red.opacity(0.5), radius: 2, x: 0, y: 1)
                            }
                            ForEach(0..<(3 - viewModel.lives), id: \.self) { _ in
                                Image(systemName: "heart")
                                    .font(.system(size: 20))
                                    .foregroundColor(.white.opacity(0.3))
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(.ultraThinMaterial)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(.white.opacity(0.3), lineWidth: 1)
                                )
                        )
                        .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)

                // Timer
                if mode != .endless {
                    TimerView(timeRemaining: viewModel.timeRemaining, totalTime: viewModel.timePerWord)
                        .padding(.horizontal, 32)
                }

                Spacer()

                // Current Word Display with enhanced glass effect
                VStack {
                    if let currentWord = viewModel.currentWord {
                        Text(currentWord.uppercased())
                            .font(.system(size: 36, weight: .bold, design: .rounded))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.white, .cyan.opacity(0.8)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .shadow(color: .black.opacity(0.3), radius: 3, x: 0, y: 2)
                            .transition(.scale.combined(with: .opacity))
                    } else {
                        VStack(spacing: 8) {
                            Text("Starte mit einem Wort...")
                                .font(.system(size: 24, weight: .semibold))
                                .foregroundColor(.white.opacity(0.9))
                                .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
                            
                            Text("Mindestens 4 Buchstaben")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.white.opacity(0.7))
                        }
                    }
                }
                .frame(minHeight: 80)
                .padding(.horizontal, 30)
                .padding(.vertical, 20)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.ultraThinMaterial)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(.white.opacity(0.3), lineWidth: 1)
                        )
                )
                .shadow(color: .black.opacity(0.3), radius: 15, x: 0, y: 8)
                .padding(.horizontal, 30)
                
                Spacer()

                // Enhanced Input Section
                VStack(spacing: 20) {
                    HStack(spacing: 15) {
                        TextField("Dein Wort...", text: $inputWord)
                            .textFieldStyle(PlainTextFieldStyle())
                            .font(.system(size: 24, weight: .medium))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .autocorrectionDisabled(true)
                            .textInputAutocapitalization(.never)
                            .focused($isInputFocused)
                            .onSubmit {
                                submitWord()
                            }
                            .disabled(viewModel.isProcessing)
                            .padding(16)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(.ultraThinMaterial)
                                    .background(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(isInputFocused ? .white.opacity(0.6) : .white.opacity(0.3), lineWidth: isInputFocused ? 2 : 1)
                                    )
                            )
                            .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
                            .animation(.easeInOut(duration: 0.3), value: isInputFocused)

                        Button(action: submitWord) {
                            Image(systemName: "arrow.right.circle.fill")
                                .font(.system(size: 32))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: viewModel.isProcessing ? [.gray, .gray.opacity(0.7)] : [.white, .cyan.opacity(0.8)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .shadow(color: viewModel.isProcessing ? .clear : .cyan.opacity(0.5), radius: 5, x: 0, y: 2)
                        }
                        .disabled(viewModel.isProcessing)
                    }
                    .padding(.horizontal, 30)

                    // Messages
                    VStack(spacing: 12) {
                        if let error = viewModel.errorMessage {
                            Text(error)
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.red)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 10)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(.red.opacity(0.2))
                                        .background(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(.red.opacity(0.5), lineWidth: 1)
                                        )
                                )
                                .transition(.opacity.combined(with: .scale))
                        }
                        
                        if let success = viewModel.successMessage {
                            Text(success)
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.green)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 10)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(.green.opacity(0.2))
                                        .background(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(.green.opacity(0.5), lineWidth: 1)
                                        )
                                )
                                .transition(.opacity.combined(with: .scale))
                        }
                    }
                    .padding(.horizontal, 40)
                }

                Spacer()

                // Enhanced Jokers Section
                if hasAnyJokers {
                    VStack(spacing: 12) {
                        Text("Joker")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white.opacity(0.8))
                        
                        HStack(spacing: 15) {
                            WorkingJokerButton(
                                icon: "arrow.triangle.2.circlepath",
                                title: "Buchstabe\nändern",
                                count: viewModel.getJokerCount(.changeLetter),
                                action: {
                                    viewModel.useJoker(.changeLetter)
                                }
                            )
                            
                            WorkingJokerButton(
                                icon: "timer",
                                title: "Zeit\nverdoppeln",
                                count: viewModel.getJokerCount(.doubleTime),
                                action: {
                                    viewModel.useJoker(.doubleTime)
                                }
                            )
                            
                            WorkingJokerButton(
                                icon: "forward.fill",
                                title: "Wort\nüberspringen",
                                count: viewModel.getJokerCount(.skipWord),
                                action: {
                                    viewModel.useJoker(.skipWord)
                                }
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
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
            }
        }
        .onAppear {
            viewModel.setUserManager(userManager)
            viewModel.startGame()
            isInputFocused = true
            pulseAnimation = true
        }
        .onDisappear {
            viewModel.endGame()
        }
        .onChange(of: viewModel.gameOver) { oldValue, newValue in
            if newValue {
                gameManager.updateScore(viewModel.score, for: mode)
                gameManager.updateLongestWord(viewModel.longestWord)
                showingGameOver = true
            }
        }
        .sheet(isPresented: $showingGameOver) {
            GameOverView(
                score: viewModel.score,
                wordsFound: viewModel.wordsUsed.count,
                longestWord: viewModel.longestWord,
                coinsEarned: viewModel.calculateCoinsEarned()
            ) {
                showingGame = false
            }
        }
        .overlay {
            if showingAchievement, let achievement = currentAchievement {
                EnhancedAchievementView(achievement: achievement) {
                    showingAchievement = false
                }
                .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
    }
    
    private var hasAnyJokers: Bool {
        viewModel.getJokerCount(.changeLetter) > 0 ||
        viewModel.getJokerCount(.doubleTime) > 0 ||
        viewModel.getJokerCount(.skipWord) > 0
    }

    private func submitWord() {
        viewModel.submitWord(inputWord)
        if viewModel.errorMessage == nil {
            inputWord = ""
        }
    }
}

// MARK: - Working Joker Button
struct WorkingJokerButton: View {
    let icon: String
    let title: String
    let count: Int
    let action: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 22, weight: .medium))
                    .foregroundStyle(
                        LinearGradient(
                            colors: count > 0 ? [.yellow, .orange] : [.gray, .gray.opacity(0.7)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .shadow(color: count > 0 ? .yellow.opacity(0.5) : .clear, radius: 3, x: 0, y: 1)
                
                Text(title)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(count > 0 ? .white.opacity(0.9) : .white.opacity(0.5))
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                
                // Count Badge
                Text("\(count)")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(count > 0 ? .black : .white.opacity(0.5))
                    .frame(width: 24, height: 24)
                    .background(
                        Circle()
                            .fill(count > 0 ? .yellow : .gray.opacity(0.3))
                    )
                    .shadow(color: count > 0 ? .yellow.opacity(0.3) : .clear, radius: 2, x: 0, y: 1)
            }
            .frame(width: 85, height: 85)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(.ultraThinMaterial)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(.white.opacity(count > 0 ? 0.4 : 0.2), lineWidth: 1)
                    )
            )
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
            .opacity(count > 0 ? 1.0 : 0.6)
        }
        .disabled(count <= 0)
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
        .buttonStyle(.plain)
    }
}

// MARK: - Enhanced Achievement View
struct EnhancedAchievementView: View {
    let achievement: Achievement
    let onDismiss: () -> Void
    @State private var showingAnimation = false
    
    var body: some View {
        VStack(spacing: 15) {
            Image(systemName: "trophy.fill")
                .font(.system(size: 50))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.yellow, .orange],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(color: .yellow.opacity(0.6), radius: 10, x: 0, y: 5)
                .scaleEffect(showingAnimation ? 1.2 : 1.0)
                .animation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true), value: showingAnimation)
            
            Text("Achievement freigeschaltet!")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)
            
            Text(achievement.title)
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.yellow)
            
            Text(achievement.description)
                .font(.system(size: 16))
                .multilineTextAlignment(.center)
                .foregroundColor(.white.opacity(0.8))
        }
        .padding(.horizontal, 30)
        .padding(.vertical, 25)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(.white.opacity(0.3), lineWidth: 1)
                )
        )
        .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: 10)
        .padding(.horizontal, 40)
        .onAppear {
            showingAnimation = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation(.easeOut(duration: 0.5)) {
                    onDismiss()
                }
            }
        }
    }
}

#Preview {
    GameView(mode: .endless, showingGame: .constant(true))
        .environmentObject(GameManager())
        .environmentObject(UserManager())
}
