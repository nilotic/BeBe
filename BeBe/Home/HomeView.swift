//
//  HomeView.swift
//
//  Created by Den Jo on 2021/03/28.
//  Copyright © nilotic. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    
    // MARK: - View
    // MARK: Public
    var body: some View {
        GeometryReader { proxy in
            WaveView()
                .frame(width: proxy.size.width, height: proxy.size.height - 100)
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
