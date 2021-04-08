// 
//  TabbarItem.swift
//
//  Created by Den Jo on 2021/04/07.
//  Copyright © nilotic. All rights reserved.
//

import SwiftUI

struct TabbarItem: View {
    
    // MARK: - Value
    // MARK: Pubilc
    let type: TabbarType
    @Binding var selection: TabbarType

    
    // MARK: - View
    // MARK: Public
    var body: some View {
        VStack {
            Image(systemName: type.iconName)
            Text(type.title)
        }
    }
}

#if DEBUG
struct TabbarButton_Previews: PreviewProvider {
            
    static var previews: some View {
        let view = TabbarItem(type: .analysis, selection: .constant(.analysis))
        
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
