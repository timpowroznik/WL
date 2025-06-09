import SwiftUI

struct ShopView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var userManager: UserManager
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                
                VStack(spacing: 20) {
                    // Shop Items
                    ScrollView {
                        VStack(spacing: 15) {
                            ForEach(ShopItem.allCases, id: \.self) { item in
                                ShopItemView(item: item)
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Shop")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    CoinDisplay(coins: userManager.coins)
                }
            }
        }
    }
}

struct ShopItemView: View {
    let item: ShopItem
    @EnvironmentObject var userManager: UserManager
    @State private var isPressed = false
    
    var body: some View {
        HStack(spacing: 15) {
            // Item Icon
            ZStack {
                Circle()
                    .fill(item.gradient)
                    .frame(width: 50, height: 50)
                
                Image(systemName: item.icon)
                    .font(.system(size: 24))
                    .foregroundColor(.white)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.name)
                    .font(.headline)
                    .foregroundColor(.white)
                
                Text(item.description)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.7))
            }
            
            Spacer()
            
            // Price Button
            Button(action: {
                if userManager.coins >= item.price {
                    userManager.coins -= item.price
                    // TODO: Implement purchase logic
                }
            }) {
                HStack {
                    Image(systemName: "dollarsign.circle.fill")
                        .foregroundColor(.yellow)
                    Text("\(item.price)")
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(.ultraThinMaterial)
                )
            }
            .disabled(userManager.coins < item.price)
            .opacity(userManager.coins >= item.price ? 1 : 0.5)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(.ultraThinMaterial)
        )
        .scaleEffect(isPressed ? 0.98 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
        .onLongPressGesture(minimumDuration: .infinity, maximumDistance: .infinity, pressing: { pressing in
            isPressed = pressing
        }, perform: { })
    }
}

enum ShopItem: CaseIterable {
    case theme
    case powerup
    case character
    
    var name: String {
        switch self {
        case .theme: return "Premium Theme"
        case .powerup: return "Power-Up Pack"
        case .character: return "Special Character"
        }
    }
    
    var description: String {
        switch self {
        case .theme: return "Unlock exclusive visual themes"
        case .powerup: return "Get powerful game boosts"
        case .character: return "Unlock special characters"
        }
    }
    
    var icon: String {
        switch self {
        case .theme: return "paintpalette.fill"
        case .powerup: return "bolt.fill"
        case .character: return "person.fill"
        }
    }
    
    var price: Int {
        switch self {
        case .theme: return 100
        case .powerup: return 50
        case .character: return 200
        }
    }
    
    var gradient: LinearGradient {
        switch self {
        case .theme:
            return LinearGradient(colors: [.purple, .blue], startPoint: .topLeading, endPoint: .bottomTrailing)
        case .powerup:
            return LinearGradient(colors: [.orange, .red], startPoint: .topLeading, endPoint: .bottomTrailing)
        case .character:
            return LinearGradient(colors: [.green, .mint], startPoint: .topLeading, endPoint: .bottomTrailing)
        }
    }
} 