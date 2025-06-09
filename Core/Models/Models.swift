import Foundation

// MARK: - Shop Item Model
struct ShopItem: Identifiable, Codable {
    let id: String             // z.B. "double_time", "skip_word"
    let name: String           // Anzeige-Name
    let description: String    // Kurztext
    let price: Int             // Kosten in Coins
    var unlocked: Bool = false // gekauft?
    
    // Convenience initializer ohne unlocked (default false)
    init(id: String, name: String, description: String, price: Int) {
        self.id = id
        self.name = name
        self.description = description
        self.price = price
        self.unlocked = false
    }
}

// MARK: - Alternative: Add this to your existing Models.swift
// Falls du es lieber in Models.swift haben willst, kopiere nur den ShopItem struct dorthin
