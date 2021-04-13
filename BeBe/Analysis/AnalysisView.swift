//
//  AnalysisView.swift
//
//  Created by Den Jo on 2021/03/28.
//  Copyright © nilotic. All rights reserved.
//

import SwiftUI

struct AnalysisView: View {
    
    // MARK: - Value
    // MARK: Public
    @StateObject var data = AnalysisData()
    
    // MARK: Private
    @State private var power: CGFloat = 0
    private let style1 = ButtonStyle1()
    
    // MARK: - View
    // MARK: Public
    var body: some View {
        VStack {
            analysisView
            siriWave
            recordButton
        }
        .padding(EdgeInsets(top: 80, leading: 0, bottom: 30, trailing: 0))
        .alert(isPresented: $data.isPermissionAlertPresented) {
            data.alert ?? Alert(title: Text(""))
        }
        .onChange(of: data.power) {
            power = $0
        }
    }
    
    // MARK: Private
    private var analysisView: some View {
        VStack(spacing: 20) {
            Image(uiImage: data.soundType.image)
                .resizable()
                .frame(width: 150, height: 150)
                .cornerRadius(30)
        
            if data.soundType != .none {
                Text(data.soundType.localizedStringKey)
                    .font(.title)
            }
        }
        .animation(.easeInOut)
    }
    
    private var siriWave: some View {
        VStack(spacing: 0) {
            WaveView(data: $power)
                .frame(height: 150)
            
            if data.isAnalyzing {
                WaveText(text: NSLocalizedString("analysis_view_analyzing", comment: ""))
            }
        }
        .frame(maxHeight: .infinity)
    }
    
    private var recordButton: some View {
        Button(action: {
            switch data.isAnalyzing {
            case true:      data.stopAnalyze()
            case false:     data.startAnalyze()
            }
            
        }) {
            switch data.isAnalyzing {
            case true:
                Image(systemName: "stop.fill")
                    .resizable()
                    .foregroundColor(.white)
                    .frame(width: 36, height: 36)
                    .padding(39)
                    .background(Color(#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)))
                    .cornerRadius(66)
                
            case false:
                Image(systemName: "mic")
                    .resizable()
                    .foregroundColor(.white)
                    .frame(width: 36, height: 54)
                    .padding(EdgeInsets(top: 30, leading: 40, bottom: 30, trailing: 40))
                    .background(Color(#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)))
                    .cornerRadius(66)
            }
        }
        .buttonStyle(style1)
    }
}

#if DEBUG
struct AnalysisView_Previews: PreviewProvider {
        
    static var previews: some View {
        let view = AnalysisView()
        
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
