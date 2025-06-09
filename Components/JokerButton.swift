//
//  JokerButton.swift
//  WordLoop
//
//  Created by Tim on 08.06.25.
//


import SwiftUI

struct JokerButton: View {
    let icon: String
    let title: String
    let cost: Int
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 5) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(.yellow)
                
                Text("\(cost) 💰")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.white)
            }
            .frame(width: 80, height: 60)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(.ultraThinMaterial)
            )
        }
    }
}