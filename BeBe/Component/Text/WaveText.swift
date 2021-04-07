// 
//  WaveText.swift
//
//  Created by Den Jo on 2021/04/07.
//  Copyright © nilotic. All rights reserved.
//

import SwiftUI

struct WaveText: View {
    
    // MARK: - Value
    // MARK: Public
    let text: String
    
    // MARK: Private
    @State private var isAnimating = false
    
    private var animation: Animation {
        Animation
            .easeInOut(duration: 2.0)
            .repeatForever(autoreverses: false)
    }
    
    
    // MARK: - View
    // MARK: Public
    var body: some View {
        Text(text)
            .modifier(WaveTextModifier(text: text, scale: isAnimating ? 1 : 0))
            .onAppear {
                withAnimation(animation) {
                    isAnimating.toggle()
                }
            }
    }
}
