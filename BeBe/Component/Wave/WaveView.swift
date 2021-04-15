// 
//  WaveView.swift
//
//  Created by Den Jo on 2021/04/13.
//  Copyright © nilotic. All rights reserved.
//

import SwiftUI

struct WaveView: View {
    
    // MARK: - Value
    // MARK: Public
    @EnvironmentObject var recordData: RecordData
    
    // MARK: Private
    @ObservedObject private var data = WaveData()

    
    // MARK: - View
    // MARK: Public
    var body: some View {
        GeometryReader { proxy in
            ForEach(data.waves) {
                WaveShape(data: $0)
                    .stroke(lineWidth: $0.lineWidth)
                    .stroke(Color.white)
                    .opacity($0.opacity)
            }
            .animation(.easeInOut)
            .drawingGroup()
        }
        .onChange(of: recordData.isRecording) {
            data.updateTimer(isRecording: $0)
        }
        .onChange(of: recordData.power) {
            data.update(power: $0)
        }
    }
}

#if DEBUG
struct WaveView_Previews: PreviewProvider {

    static var previews: some View {
        let view = WaveView()

        Group {
            view
                .previewDevice("iPhone8")
                .preferredColorScheme(.light)

            view
                .previewDevice("iPhone 12")
                .preferredColorScheme(.dark)
        }
    }
}
#endif
