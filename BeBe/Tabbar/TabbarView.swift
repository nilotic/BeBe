// 
//  TabbarView.swift
//
//  Created by Den Jo on 2021/04/07.
//  Copyright © nilotic. All rights reserved.
//

import SwiftUI

struct TabbarView: View {
   
    // MARK: - Value
    // MARK: Private
    @State private var selection: TabbarType = .analysis
    
    
    // MARK: - View
    // MARK: Public
    var body: some View {
        TabView(selection: $selection) {
            AnalysisView()
                .tabItem {
                    TabbarItem(type: .analysis, selection: $selection)
                }
                .tag(TabbarType.analysis)
            
            RecordView()
                .tabItem {
                    TabbarItem(type: .record, selection: $selection)
                }
                .tag(TabbarType.record)
        }
    }
}

#if DEBUG
struct TabbarView_Previews: PreviewProvider {
    
    static var previews: some View {
        let view = TabbarView()
        
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
