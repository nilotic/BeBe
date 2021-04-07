// 
//  TabbarType.swift
//
//  Created by Den Jo on 2021/04/07.
//  Copyright © nilotic. All rights reserved.
//

import UIKit
import SwiftUI

enum TabbarType {
    case analysis
    case record
}

extension TabbarType {
    
    var title: LocalizedStringKey {
        switch self {
        case .analysis:    return LocalizedStringKey("Analysis")
        case .record:      return LocalizedStringKey("Record")
        }
    }
    
    var iconName: String {
        switch self {
        case .analysis:    return "waveform.circle"
        case .record:      return "record.circle"
        }
    }
    
    var rawValue: Int {
        switch self {
        case .analysis:    return 0
        case .record:      return 1
        }
    }
}

extension TabbarType: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue)
    }
}

extension TabbarType: Equatable {
    
    static func ==(lhs: TabbarType, rhs: TabbarType) -> Bool {
        lhs.rawValue == rhs.rawValue
    }
}

