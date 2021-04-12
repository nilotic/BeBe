// 
//  ButtonStyle1.swift
//
//  Created by Den Jo on 2021/04/10.
//  Copyright © nilotic. All rights reserved.
//

import SwiftUI

struct ButtonStyle1: ButtonStyle {
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed ? 0.5 : 1)
            .scaleEffect(configuration.isPressed ? 0.92 : 1)
            .animation(.easeInOut(duration: 0.18))
    }
}
