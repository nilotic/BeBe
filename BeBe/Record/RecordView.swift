// 
//  RecordView.swift
//
//  Created by Den Jo on 2021/04/07.
//  Copyright © nilotic. All rights reserved.
//

import SwiftUI

struct RecordView: View {
    
    // MARK: - Value
    // MARK: Public
    @StateObject var data = RecordData()
    @State var power: CGFloat = 0
    
    
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
        
            Text(data.soundType.localizedStringKey)
                .font(.title)
        }
        .animation(.easeInOut)
    }
    
    private var siriWave: some View {
        VStack(spacing: 0) {
            WaveView(data: $power)
                .frame(height: 150)
            
            if data.isAnalyzing {
                Text("Anayzing...")
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
                Color(#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1))
                    .frame(width: 38, height: 38)
                    .cornerRadius(6)
                    .padding(34)
                    .overlay(Circle().stroke(Color(#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)), lineWidth: 8))
                
            case false:
                Circle()
                    .frame(width: 42, height: 42)
                    .foregroundColor(Color(#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)))
                    .padding(32)
                    .overlay(Circle().stroke(Color("border"), lineWidth: 8))
            }
        }
    }
}

#if DEBUG
struct RecordView_Previews: PreviewProvider {
        
    static var previews: some View {
        let view = RecordView()
        
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
