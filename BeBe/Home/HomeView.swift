//
//  HomeView.swift
//
//  Created by Den Jo on 2021/03/28.
//  Copyright © nilotic. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    
    // MARK: - Value
    // MARK: Public
    @StateObject var data = HomeData()
    @State var power: CGFloat = 0
    
    
    // MARK: - View
    // MARK: Public
    var body: some View {
        VStack {
            HStack {
                WaveView(data: $power)
                    .frame(height: 150)
            }
            .frame(maxHeight: .infinity)
        
            recordButton
        }
        .padding(.vertical, 30)
        .alert(isPresented: $data.isPermissionAlertPresented) {
            data.alert ?? Alert(title: Text(""))
        }
        .onChange(of: data.power) {
            power = $0
        }
    }
    
    // MARK: Private
    private var recordButton: some View {
        Button(action: {
            switch data.isRecoding {
            case true:      data.stopAnalyze()
            case false:     data.requestAnalyze()
            }
            
        }) {
            switch data.isRecoding {
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
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
        
    static var previews: some View {
        let view = HomeView()
        
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
