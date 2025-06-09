//
//  SettingsView.swift
//  WordLoop
//
//  Created by Tim on 08.06.25.
//


import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    @AppStorage("soundEnabled") var soundEnabled = true
    @AppStorage("hapticEnabled") var hapticEnabled = true
    @AppStorage("darkMode") var darkMode = true
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                
                Form {
                    Section {
                        Toggle("Sound", isOn: $soundEnabled)
                        Toggle("Vibration", isOn: $hapticEnabled)
                        Toggle("Dark Mode", isOn: $darkMode)
                    }
                    .listRowBackground(Color.white.opacity(0.1))
                    
                    Section {
                        Link("Datenschutz", destination: URL(string: "https://wordloop.app/privacy")!)
                        Link("Nutzungsbedingungen", destination: URL(string: "https://wordloop.app/terms")!)
                        Link("Support", destination: URL(string: "mailto:support@wordloop.app")!)
                    }
                    .listRowBackground(Color.white.opacity(0.1))
                    
                    Section {
                        HStack {
                            Text("Version")
                            Spacer()
                            Text("1.0.0")
                                .foregroundColor(.secondary)
                        }
                    }
                    .listRowBackground(Color.white.opacity(0.1))
                }
                .scrollContentBackground(.hidden)
                .navigationTitle("Einstellungen")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Fertig") {
                            dismiss()
                        }
                        .foregroundColor(.white)
                    }
                }
            }
        }
    }
}
