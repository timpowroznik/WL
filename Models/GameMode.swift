import SwiftUI

enum GameMode: String, CaseIterable {
    case endless
    case hardcore
    case blitz
    case classic1v1
    
    var displayName: String {
        switch self {
        case .endless: return "Endless"
        case .hardcore: return "Hardcore"
        case .blitz: return "Blitz"
        case .classic1v1: return "Classic 1v1"
        }
    }
    
    var description: String {
        switch self {
        case .endless: return "Spiele ohne Zeitlimit"
        case .hardcore: return "Ein Fehler = Game Over"
        case .blitz: return "5 Minuten Challenge"
        case .classic1v1: return "Spiele gegen einen Freund"
        }
    }
    
    var icon: String {
        switch self {
        case .endless: return "infinity"
        case .hardcore: return "flame.fill"
        case .blitz: return "bolt.fill"
        case .classic1v1: return "person.2.fill"
        }
    }
    
    var gradient: [Color] {
        switch self {
        case .endless:
            return [Color(hex: "FF6B6B"), Color(hex: "FF8E8E")]
        case .hardcore:
            return [Color(hex: "FF9F43"), Color(hex: "FFB976")]
        case .blitz:
            return [Color(hex: "4ECDC4"), Color(hex: "6ED7D0")]
        case .classic1v1:
            return [Color(hex: "A8E6CF"), Color(hex: "C5E8D5")]
        }
    }
} 