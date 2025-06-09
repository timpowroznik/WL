import SwiftUI

// MARK: - Realistic Glass Card
struct RealisticGlassCard<Content: View>: View {
    let content: Content
    let blur: CGFloat
    let opacity: Double
    
    init(blur: CGFloat = 20, opacity: Double = 0.15, @ViewBuilder content: () -> Content) {
        self.blur = blur
        self.opacity = opacity
        self.content = content()
    }
    
    var body: some View {
        content
            .padding(24)
            .background {
                ZStack {
                    // Main glass layer
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.ultraThinMaterial)
                        .environment(\.colorScheme, .dark)
                    
                    // Multiple glass layers for depth
                    RoundedRectangle(cornerRadius: 20)
                        .fill(
                            LinearGradient(
                                colors: [
                                    .white.opacity(0.25),
                                    .white.opacity(0.05),
                                    .clear,
                                    .black.opacity(0.1)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    
                    // Inner highlight
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    .white.opacity(0.6),
                                    .white.opacity(0.2),
                                    .clear,
                                    .black.opacity(0.2)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                        .blendMode(.overlay)
                    
                    // Outer border
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(.white.opacity(0.3), lineWidth: 0.5)
                }
            }
            .shadow(color: .black.opacity(0.3), radius: 25, x: 0, y: 15)
            .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 5)
    }
}

// MARK: - Realistic Glass Button
struct RealisticGlassButton<Content: View>: View {
    let action: () -> Void
    let content: Content
    @State private var isPressed = false
    
    init(action: @escaping () -> Void, @ViewBuilder content: () -> Content) {
        self.action = action
        self.content = content()
    }
    
    var body: some View {
        Button(action: action) {
            content
                .padding(.horizontal, 24)
                .padding(.vertical, 16)
                .background {
                    ZStack {
                        // Base glass
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.ultraThinMaterial)
                            .environment(\.colorScheme, .dark)
                        
                        // Gradient overlay
                        RoundedRectangle(cornerRadius: 16)
                            .fill(
                                LinearGradient(
                                    colors: isPressed ? [
                                        .white.opacity(0.1),
                                        .clear,
                                        .black.opacity(0.2)
                                    ] : [
                                        .white.opacity(0.3),
                                        .white.opacity(0.1),
                                        .clear,
                                        .black.opacity(0.1)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                        
                        // Border highlight
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        .white.opacity(0.5),
                                        .white.opacity(0.2),
                                        .clear
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                            .blendMode(.overlay)
                    }
                }
                .scaleEffect(isPressed ? 0.95 : 1.0)
                .shadow(
                    color: .black.opacity(isPressed ? 0.1 : 0.25),
                    radius: isPressed ? 5 : 15,
                    x: 0,
                    y: isPressed ? 2 : 8
                )
        }
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.15)) {
                isPressed = pressing
            }
        }, perform: {})
        .buttonStyle(.plain)
    }
}

// MARK: - Realistic Glass Text Field
struct RealisticGlassTextField: View {
    @Binding var text: String
    let placeholder: String
    let isDisabled: Bool
    @FocusState private var isFocused: Bool
    
    var body: some View {
        HStack {
            TextField(placeholder, text: $text)
                .font(.title3.weight(.medium))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .autocorrectionDisabled(true)
                .textInputAutocapitalization(.never)
                .focused($isFocused)
                .disabled(isDisabled)
        }
        .padding(20)
        .background {
            ZStack {
                // Base glass
                RoundedRectangle(cornerRadius: 18)
                    .fill(.ultraThinMaterial)
                    .environment(\.colorScheme, .dark)
                
                // Inner glow when focused
                if isFocused {
                    RoundedRectangle(cornerRadius: 18)
                        .fill(
                            RadialGradient(
                                colors: [
                                    .white.opacity(0.15),
                                    .clear
                                ],
                                center: .center,
                                startRadius: 0,
                                endRadius: 100
                            )
                        )
                }
                
                // Gradient overlay
                RoundedRectangle(cornerRadius: 18)
                    .fill(
                        LinearGradient(
                            colors: [
                                .white.opacity(0.2),
                                .white.opacity(0.05),
                                .clear,
                                .black.opacity(0.1)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                
                // Border
                RoundedRectangle(cornerRadius: 18)
                    .stroke(
                        LinearGradient(
                            colors: isFocused ? [
                                .white.opacity(0.8),
                                .white.opacity(0.4),
                                .clear
                            ] : [
                                .white.opacity(0.4),
                                .white.opacity(0.2),
                                .clear
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: isFocused ? 2 : 1
                    )
                    .blendMode(.overlay)
            }
        }
        .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
        .opacity(isDisabled ? 0.5 : 1.0)
        .animation(.easeInOut(duration: 0.3), value: isFocused)
    }
}

// MARK: - Enhanced Game Mode Button
struct EnhancedGameModeButton: View {
    let title: String
    let icon: String
    let description: String
    let gradient: [Color]
    let action: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        RealisticGlassButton(action: action) {
            HStack(spacing: 16) {
                // Icon with glow
                ZStack {
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [
                                    gradient[0].opacity(0.3),
                                    gradient[1].opacity(0.1),
                                    .clear
                                ],
                                center: .center,
                                startRadius: 0,
                                endRadius: 30
                            )
                        )
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: icon)
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(
                            LinearGradient(
                                colors: gradient,
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .shadow(color: gradient[0].opacity(0.5), radius: 5, x: 0, y: 2)
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(title)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
                    
                    Text(description)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
                
                // Arrow with subtle animation
                Image(systemName: "chevron.right")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white.opacity(0.6))
                    .scaleEffect(isPressed ? 1.2 : 1.0)
                    .animation(.easeInOut(duration: 0.1), value: isPressed)
            }
        }
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
    }
}

// MARK: - Realistic Progress Bar
struct RealisticProgressBar: View {
    let percentage: Double
    let color: Color
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Background track
                RoundedRectangle(cornerRadius: 8)
                    .fill(.ultraThinMaterial)
                    .environment(\.colorScheme, .dark)
                    .overlay {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        .black.opacity(0.2),
                                        .clear,
                                        .white.opacity(0.1)
                                    ],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                    }
                    .frame(height: 12)
                
                // Progress fill with glass effect
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(
                            LinearGradient(
                                colors: [
                                    color.opacity(0.8),
                                    color.opacity(0.6)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                    
                    // Glass highlight on progress
                    RoundedRectangle(cornerRadius: 8)
                        .fill(
                            LinearGradient(
                                colors: [
                                    .white.opacity(0.4),
                                    .white.opacity(0.1),
                                    .clear
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                    
                    // Inner glow
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(color.opacity(0.8), lineWidth: 1)
                        .blur(radius: 1)
                }
                .frame(width: geometry.size.width * percentage, height: 12)
                .animation(.easeInOut(duration: 0.3), value: percentage)
                
                // Shimmer effect
                RoundedRectangle(cornerRadius: 8)
                    .fill(
                        LinearGradient(
                            colors: [
                                .clear,
                                .white.opacity(0.3),
                                .clear
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: 30, height: 12)
                    .offset(x: -50)
                    .animation(
                        .linear(duration: 2)
                        .repeatForever(autoreverses: false),
                        value: percentage
                    )
            }
        }
        .frame(height: 12)
        .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 2)
    }
}

// MARK: - Glass Container with Floating Effect
struct FloatingGlassContainer<Content: View>: View {
    let content: Content
    @State private var isFloating = false
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .background {
                ZStack {
                    // Main glass layer with enhanced blur
                    RoundedRectangle(cornerRadius: 24)
                        .fill(.ultraThinMaterial)
                        .environment(\.colorScheme, .dark)
                    
                    // Multiple gradient layers for realism
                    RoundedRectangle(cornerRadius: 24)
                        .fill(
                            LinearGradient(
                                colors: [
                                    .white.opacity(0.3),
                                    .white.opacity(0.1),
                                    .clear,
                                    .black.opacity(0.1),
                                    .black.opacity(0.2)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    
                    // Border with enhanced glow
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    .white.opacity(0.8),
                                    .white.opacity(0.3),
                                    .clear,
                                    .black.opacity(0.2)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1.5
                        )
                        .blendMode(.overlay)
                }
            }
            .shadow(color: .black.opacity(0.4), radius: 30, x: 0, y: 15)
            .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
            .offset(y: isFloating ? -2 : 0)
            .animation(
                .easeInOut(duration: 3)
                .repeatForever(autoreverses: true),
                value: isFloating
            )
            .onAppear {
                isFloating = true
            }
    }
} 