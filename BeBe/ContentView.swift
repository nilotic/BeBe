//
//  ContentView.swift
//  BeBe
//
//  Created by Den Jo on 2021/03/28.
//

import SwiftUI

struct ContentView: View {
    
    // MARK: - View
    // MARK: Public
    var body: some View {
        Text("Hello, world!")
            .padding()
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
        
    static var previews: some View {
        let view = ContentView()
        
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
