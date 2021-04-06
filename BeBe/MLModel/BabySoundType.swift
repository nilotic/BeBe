// 
//  BabySoundType.swift
//
//  Created by Den Jo on 2021/04/06.
//  Copyright © nilotic. All rights reserved.
//

import SwiftUI

enum BabySoundType {
    case none
    case burp
    case discomfort
    case hungry
    case lowerGas
    case sleepy
}

extension BabySoundType {
    
    init(string: String) {
        switch string {
        case "Burp":        self = .burp
        case "Discomfort":  self = .discomfort
        case "Hungry":      self = .hungry
        case "LowerGas":    self = .lowerGas
        case "Sleepy":      self = .sleepy
        default:            self = .none
        }
    }
}

extension BabySoundType {
    
    var localizedStringKey: LocalizedStringKey {
        switch self {
        case .none:         return LocalizedStringKey("")
        case .burp:         return LocalizedStringKey("Burp")
        case .discomfort:   return LocalizedStringKey("Discomfort")
        case .hungry:       return LocalizedStringKey("Hungry")
        case .lowerGas:     return LocalizedStringKey("LowerGas")
        case .sleepy:       return LocalizedStringKey("Sleepy")
        }
    }
    
    var image: UIImage {
        switch self {
        case .none:         return UIImage()
        case .burp:         return #imageLiteral(resourceName: "burp")
        case .discomfort:   return #imageLiteral(resourceName: "discomfort")
        case .hungry:       return #imageLiteral(resourceName: "hungry")
        case .lowerGas:     return #imageLiteral(resourceName: "lowerGas")
        case .sleepy:       return #imageLiteral(resourceName: "sleepy")
        }
    }
}
