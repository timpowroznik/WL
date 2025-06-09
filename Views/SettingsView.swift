import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    @AppStorage("soundEnabled") private var soundEnabled = true
    @AppStorage("vibrationEnabled") private var vibrationEnabled = true
    @AppStorage("darkMode") private var darkMode = true
    
    var body: some View {
        NavigationView {
            ZStack {
                SimpleEnhancedBackground()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Sound Settings
                        SimpleGlassCard {
                            Toggle("Sound", isOn: $soundEnabled)
                                .foregroundColor(.white)
                        }
                        
                        // Vibration Settings
                        SimpleGlassCard {
                            Toggle("Vibration", isOn: $vibrationEnabled)
                                .foregroundColor(.white)
                        }
                        
                        // Dark Mode Settings
                        SimpleGlassCard {
                            Toggle("Dark Mode", isOn: $darkMode)
                                .foregroundColor(.white)
                        }
                        
                        // Version Info
                        SimpleGlassCard {
                            VStack(spacing: 8) {
                                Text("Version")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                
                                Text("1.0.0")
                                    .font(.subheadline)
                                    .foregroundColor(.white.opacity(0.7))
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Einstellungen")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                }
            }
        }
    }
} 