// 
//  SiriWaveView.swift
//
//  Created by Den Jo on 2021/04/05.
//  Copyright © nilotic. All rights reserved.
//

import SwiftUI

struct SiriWaveView: View {
    
    // MARK: - Value
    // MARK: Private
    @ObservedObject private var data = SiriWaveData()
    @Binding private var power: CGFloat
    
    
    // MARK: - Initiazlier
    init(data: Binding<CGFloat>) {
        _power = data
    }
    
    
    // MARK: - View
    // MARK: Public
    var body: some View {
        ZStack {
            ForEach(Array(data.colors.enumerated()), id: \.element) { i, color in
                SiriWaveShape(wave: data.waves[i])
                    .fill(color)
            }
        }
        .animation(.easeInOut)
        .blendMode(.lighten)
        .drawingGroup()
        .onChange(of: power) {
            data.update(power: $0)
        }
    }
}

#if DEBUG
struct SiriWaveView_Previews: PreviewProvider {
    
    static var previews: some View {
        let view = SiriWaveView(data: .constant(0.5))
        
        Group {
            view
                .previewDevice("iPhone 8")
                .preferredColorScheme(.light)
            
            view
                .previewDevice("iPhone 12")
                .preferredColorScheme(.dark)
        }
    }
}
#endif
