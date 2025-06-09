import SwiftUI

// MARK: - Enhanced ShopView with Pull-to-Dismiss
struct ShopView: View {
    @EnvironmentObject var userManager: UserManager
    @Environment(\.dismiss) var dismiss
    @State private var dragOffset: CGSize = .zero
    @State private var isDragging = false
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 0) {
                // Drag Handle
                VStack(spacing: 8) {
                    RoundedRectangle(cornerRadius: 3)
                        .fill(.white.opacity(0.5))
                        .frame(width: 40, height: 5)
                        .padding(.top, 8)
                    
                    Text("Shop")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
                        .padding(.top, 8)
                }
                .padding(.bottom, 20)
                
                // Coins Display
                HStack {
                    Spacer()
                    CoinDisplay(coins: userManager.coins)
                        .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
                    Spacer()
                }
                .padding(.bottom, 30)
                
                // Shop Content
                ScrollView {
                    VStack(spacing: 25) {
                        // Jokers Section
                        ShopSection(title: "🃏 Joker") {
                            VStack(spacing: 15) {
                                ShopItemCard(
                                    item: ShopItem(
                                        id: "change_letter",
                                        name: "Buchstabe ändern",
                                        description: "Ändere den letzten Buchstaben des Wortes",
                                        price: 30
                                    ),
                                    icon: "arrow.triangle.2.circlepath",
                                    quantity: userManager.jokerInventory["change_letter"] ?? 0
                                )
                                
                                ShopItemCard(
                                    item: ShopItem(
                                        id: "double_time",
                                        name: "Zeit verdoppeln",
                                        description: "Verdoppelt die Zeit für das nächste Wort",
                                        price: 40
                                    ),
                                    icon: "timer",
                                    quantity: userManager.jokerInventory["double_time"] ?? 0
                                )
                                
                                ShopItemCard(
                                    item: ShopItem(
                                        id: "skip_word",
                                        name: "Wort überspringen",
                                        description: "Überspringe ein schwieriges Wort",
                                        price: 35
                                    ),
                                    icon: "forward.fill",
                                    quantity: userManager.jokerInventory["skip_word"] ?? 0
                                )
                            }
                        }
                        
                        // Themes Section (coming soon)
                        ShopSection(title: "🎨 Themes") {
                            VStack(spacing: 15) {
                                ComingSoonCard(title: "Ocean Theme", description: "Beruhigende Ozean-Farben")
                                ComingSoonCard(title: "Galaxy Theme", description: "Animierte Sterne und Nebel")
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
                }
            }
        }
        .offset(y: dragOffset.height)
        .gesture(
            DragGesture()
                .onChanged { value in
                    if value.translation.height > 0 {
                        dragOffset = value.translation
                        isDragging = true
                    }
                }
                .onEnded { value in
                    if value.translation.height > 100 {
                        dismiss()
                    } else {
                        withAnimation(.spring()) {
                            dragOffset = .zero
                        }
                    }
                    isDragging = false
                }
        )
        .animation(.spring(), value: dragOffset)
    }
}

// MARK: - Shop Item Card with Quantity
struct ShopItemCard: View {
    let item: ShopItem
    let icon: String
    let quantity: Int
    @EnvironmentObject var userManager: UserManager
    @State private var showingPurchase = false
    @State private var purchaseAnimation = false
    
    var body: some View {
        VStack(spacing: 15) {
            HStack(spacing: 16) {
                // Icon
                ZStack {
                    Circle()
                        .fill(.ultraThinMaterial)
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: icon)
                        .font(.system(size: 28, weight: .medium))
                        .foregroundColor(.orange)
                        .shadow(color: .orange.opacity(0.5), radius: 3, x: 0, y: 1)
                }
                
                // Item Info
                VStack(alignment: .leading, spacing: 6) {
                    Text(item.name)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Text(item.description)
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.7))
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
            }
            
            // Quantity and Purchase
            HStack {
                // Quantity Display
                HStack(spacing: 8) {
                    Text("Besitzt:")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white.opacity(0.7))
                    
                    Text("\(quantity)")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.cyan)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.white.opacity(0.1))
                        )
                }
                
                Spacer()
                
                // Purchase Button
                Button(action: purchaseItem) {
                    HStack(spacing: 6) {
                        Image(systemName: "bitcoinsign.circle.fill")
                            .font(.system(size: 16))
                            .foregroundColor(.black)
                        
                        Text("\(item.price)")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.black)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(canAfford ? .yellow : .gray)
                    )
                    .scaleEffect(purchaseAnimation ? 1.1 : 1.0)
                    .animation(.easeInOut(duration: 0.1), value: purchaseAnimation)
                }
                .disabled(!canAfford)
                .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
                    withAnimation(.easeInOut(duration: 0.1)) {
                        purchaseAnimation = pressing
                    }
                }, perform: {})
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(.white.opacity(0.3), lineWidth: 1)
                )
        )
        .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
        .alert("Gekauft!", isPresented: $showingPurchase) {
            Button("OK") { }
        } message: {
            Text("\(item.name) wurde zu deinem Inventar hinzugefügt!")
        }
    }
    
    private var canAfford: Bool {
        userManager.coins >= item.price
    }
    
    private func purchaseItem() {
        if userManager.spendCoins(item.price) {
            userManager.addJoker(item.id)
            showingPurchase = true
            
            // Haptic Feedback
            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
            impactFeedback.impactOccurred()
        }
    }
}

// MARK: - Coming Soon Card
struct ComingSoonCard: View {
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(.gray.opacity(0.3))
                    .frame(width: 60, height: 60)
                
                Image(systemName: "clock.fill")
                    .font(.system(size: 28))
                    .foregroundColor(.gray)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white.opacity(0.6))
                
                Text(description)
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.4))
            }
            
            Spacer()
            
            Text("Bald verfügbar")
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.gray)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.gray.opacity(0.2))
                )
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.gray.opacity(0.1))
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(.gray.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

// MARK: - Shop Section
struct ShopSection<Content: View>: View {
    let title: String
    @ViewBuilder let content: Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text(title)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
                .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
            
            content
        }
    }
}
