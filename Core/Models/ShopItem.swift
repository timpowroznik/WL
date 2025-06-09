import Foundation

struct ShopItem: Identifiable, Codable {
    let id: String             // z.B. "double_time", "skip_word"
    let name: String           // Anzeige-Name
    let description: String    // Kurztext
    let price: Int             // Kosten in Coins
    var unlocked: Bool = false // gekauft?
    
    // Convenience initializer für einfache Erstellung
    init(id: String, name: String, description: String, price: Int) {
        self.id = id
        self.name = name
        self.description = description
        self.price = price
        self.unlocked = false
    }
    
    // Full initializer mit unlocked parameter
    init(id: String, name: String, description: String, price: Int, unlocked: Bool) {
        self.id = id
        self.name = name
        self.description = description
        self.price = price
        self.unlocked = unlocked
    }
}
