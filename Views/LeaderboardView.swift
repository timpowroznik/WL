import SwiftUI

struct LeaderboardView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                // Use your existing BackgroundView
                BackgroundView()
                
                ScrollView {
                    VStack(spacing: 15) {
                        ForEach(0..<10) { index in
                            LeaderboardRow(
                                rank: index + 1,
                                name: "Spieler \(index + 1)",
                                score: 1000 - (index * 100)
                            )
                        }
                    }
                    .padding()
                }
                .navigationTitle("Rangliste")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Fertig") {
                            dismiss()
                        }
                        .foregroundColor(.white)
                        .font(.system(size: 17, weight: .medium))
                    }
                }
            }
        }
    }
}

struct LeaderboardRow: View {
    let rank: Int
    let name: String
    let score: Int
    
    var rankColor: Color {
        switch rank {
        case 1: return .yellow
        case 2: return Color(white: 0.75)
        case 3: return Color(red: 0.8, green: 0.5, blue: 0.2)
        default: return .white
        }
    }
    
    var body: some View {
        HStack(spacing: 15) {
            // Rank Circle
            ZStack {
                Circle()
                    .fill(rankColor.opacity(0.2))
                    .frame(width: 50, height: 50)
                    .background(
                        Circle()
                            .fill(.ultraThinMaterial)
                    )
                
                if rank <= 3 {
                    Image(systemName: "crown.fill")
                        .foregroundColor(rankColor)
                        .font(.system(size: 22, weight: .bold))
                        .shadow(color: rankColor.opacity(0.5), radius: 3, x: 0, y: 1)
                } else {
                    Text("\(rank)")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
                }
            }
            
            // Player Name
            Text(name)
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(.white)
                .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
            
            Spacer()
            
            // Score with icon
            HStack(spacing: 8) {
                Image(systemName: "star.fill")
                    .font(.system(size: 16))
                    .foregroundColor(.yellow)
                    .shadow(color: .yellow.opacity(0.5), radius: 2, x: 0, y: 1)
                
                Text("\(score)")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(.white.opacity(0.3), lineWidth: 1)
                )
        )
        .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
    }
}

#Preview {
    LeaderboardView()
}
