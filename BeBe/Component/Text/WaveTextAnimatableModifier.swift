// 
//  WaveTextAnimatableModifier.swift
//
//  Created by Den Jo on 2021/04/07.
//  Copyright © nilotic. All rights reserved.
//

import SwiftUI

struct WaveTextModifier {
    let text: String
    var scale: CGFloat
}

extension WaveTextModifier: AnimatableModifier {
    
    var animatableData: CGFloat {
        get { scale }
        set { scale = newValue }
    }
    
    func body(content: Content) -> some View {
        HStack(spacing: 0) {
            ForEach(Array(text.enumerated()), id: \.0) { index, character in
                Text(String(character))
                    .font(.system(size: 20, weight: .bold))
                    .scaleEffect(magnify(scale: scale, index: CGFloat(index)))
            }
        }
    }
    
    func magnify(scale: CGFloat, index: CGFloat) -> CGFloat {
        var offset: CGFloat {
            let count = CGFloat(text.count)
            let waveWidth: CGFloat = 5
            
            let chunk = waveWidth / count
            let m = 1 / chunk
            let offset = (chunk - (1 / count)) * scale

            let lower = scale - chunk + offset
            let upper = scale + offset
            let x = index / count

            guard lower..<upper ~= x else { return 0 }
            let angle = ((x - scale - offset) * m) * 360 - 90
            
            return (sin(angle * .pi / 180) + 1) / 2
        }
       
        return 1 + offset
    }
}
