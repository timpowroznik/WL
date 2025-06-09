import SwiftUI

@main
struct WordLoopApp: App {
    @StateObject private var gameManager = GameManager()
    @StateObject private var userManager = UserManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(gameManager)
                .environmentObject(userManager)
                .preferredColorScheme(.dark) // Start with dark mode
        }
    }
}
