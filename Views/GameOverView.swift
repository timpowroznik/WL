//
//  GameOverView.swift
//  WordLoop
//
//  Created by Tim on 08.06.25.
//


import SwiftUI

struct GameOverView: View {
    let score: Int
    let wordsFound: Int
    let longestWord: String
    let coinsEarned: Int
    let onDismiss: () -> Void
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 30) {
                Text("Game Over")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(.white)
                
                VStack(spacing: 20) {
                    StatRow(label: "Punkte", value: "\(score)")
                    StatRow(label: "Wörter gefunden", value: "\(wordsFound)")
                    StatRow(label: "Längstes Wort", value: longestWord)
                    
                    Divider()
                        .background(Color.white.opacity(0.3))
                    
                    HStack {
                        Image(systemName: "bitcoinsign.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.yellow)
                        
                        Text("+\(coinsEarned) Münzen")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                    }
                }
                .padding(30)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.ultraThinMaterial)
                )
                
                Button(action: onDismiss) {
                    Text("Zurück zum Menü")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 30)
                        .padding(.vertical, 15)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.blue)
                        )
                }
            }
            .padding(30)
        }
    }
}