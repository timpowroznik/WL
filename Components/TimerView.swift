import SwiftUI

struct TimerView: View {
    let timeRemaining: TimeInterval
    let totalTime: TimeInterval
    
    var progress: Double {
        guard totalTime > 0 else { return 0 }
        return max(0, min(1, timeRemaining / totalTime))
    }
    
    var timeColor: Color {
        if progress > 0.5 {
            return .green
        } else if progress > 0.25 {
            return .yellow
        } else {
            return .red
        }
    }
    
    var formattedTime: String {
        let minutes = Int(timeRemaining) / 60
        let seconds = Int(timeRemaining) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    var body: some View {
        VStack(spacing: 8) {
            // Progress Bar - jetzt responsive!
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Background
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.white.opacity(0.2))
                        .frame(height: 12)
                    
                    // Progress Fill
                    RoundedRectangle(cornerRadius: 8)
                        .fill(
                            LinearGradient(
                                colors: [timeColor, timeColor.opacity(0.7)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geometry.size.width * progress, height: 12)
                        .animation(.linear(duration: 0.1), value: progress)
                }
            }
            .frame(height: 12)
            
            // Time Display
            Text(formattedTime)
                .font(.system(size: 16, weight: .bold, design: .monospaced))
                .foregroundColor(timeColor)
                .shadow(color: .black.opacity(0.3), radius: 1, x: 0, y: 1)
        }
        .padding(.horizontal, 20) // Padding für bessere Optik
    }
}