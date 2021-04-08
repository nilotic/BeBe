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
    
    // MARK: Private
    @State private var power: CGFloat = 0
    @State private var soundType: BabySoundType = .none
    
    
    // MARK: - View
    // MARK: Public
    var body: some View {
        NavigationView {
            VStack {
                switch data.isPickerPresented {
                case true:
                    soundTypePicker
                    
                case false:
                    siriWave
                    recordButton
                }
            }
            .padding(EdgeInsets(top: 80, leading: 0, bottom: 34, trailing: 0))
            .navigationBarItems(trailing: barButtonItems)
            .alert(isPresented: $data.isPermissionAlertPresented) {
                data.alert ?? Alert(title: Text(""))
            }
            .sheet(isPresented: $data.isShareViewPresented) {
                ActivityViewController(activityItems: data.activityItems)
            }
            .onChange(of: data.power) {
                power = $0
            }
        }
    }
    
    // MARK: Private
    private var soundTypePicker: some View {
        VStack(spacing: 20) {
            // Done button
            HStack {
                Button(action:{ data.isPickerPresented = false }) {
                    Text("Cancel")
                }
                
                Spacer()
                
                Button(action:{ data.save() }) {
                    Text("Done")
                        .bold()
                }
            }
            .padding(.horizontal, 20)

            
            // Picker
            Picker("Please choose a sound type", selection: $data.soundType) {
                ForEach(BabySoundType.allCases) {
                    Text($0.description)
                        .tag($0)
                }
            }
            .border(Color.gray, width: 1)
        }
    }
    
    private var siriWave: some View {
        VStack(spacing: 0) {
            WaveView(data: $power)
                .frame(height: 150)
            
            if data.isRecording {
                WaveText(text: "Recording...")
            }
        }
        .frame(maxHeight: .infinity)
    }
    
    private var recordButton: some View {
        Button(action: {
            switch data.isRecording {
            case true:      data.stopRecord()
            case false:     data.startRecord()
            }
            
        }) {
            switch data.isRecording {
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
    
    private var barButtonItems: some View {
        Button(action: { data.isShareViewPresented = true }) {
            Image(systemName: "square.and.arrow.up")
                .resizable()
                .frame(width: 24, height: 30)
                .padding(EdgeInsets(top: 20, leading: 10, bottom: 0, trailing: 15))
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
