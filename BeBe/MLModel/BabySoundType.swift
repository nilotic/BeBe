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
    case other
}

extension BabySoundType {
    
    init(string: String) {
        switch string {
        case "Burp":        self = .burp
        case "Discomfort":  self = .discomfort
        case "Hungry":      self = .hungry
        case "LowerGas":    self = .lowerGas
        case "Sleepy":      self = .sleepy
        case "Other":       self = .other
        default:            self = .none
        }
    }
}

extension BabySoundType {
    
    static var allCases: [BabySoundType] {
        [.burp, .discomfort, .hungry, .lowerGas, .sleepy, .other]
    }
    
    var localizedStringKey: LocalizedStringKey {
        switch self {
        case .none:         return LocalizedStringKey("")
        case .burp:         return LocalizedStringKey("Burp")
        case .discomfort:   return LocalizedStringKey("Discomfort")
        case .hungry:       return LocalizedStringKey("Hungry")
        case .lowerGas:     return LocalizedStringKey("LowerGas")
        case .sleepy:       return LocalizedStringKey("Sleepy")
        case .other:        return LocalizedStringKey("Other")
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
        case .other:        return UIImage()
        }
    }
    
    var description: String {
        switch self {
        case .none:         return ""
        case .burp:         return "Burp ( Eh )"
        case .discomfort:   return "Discomfort ( Heh )"
        case .hungry:       return "Hungry ( Neh )"
        case .lowerGas:     return "LowerGas ( Eair )"
        case .sleepy:       return "Sleepy ( Owh )"
        case .other:        return "Other"
        }
    }
}

extension BabySoundType: Identifiable {
    
    var id: String {
        description
    }
}

extension BabySoundType: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension BabySoundType: Equatable {
    
    static func ==(lhs: BabySoundType, rhs: BabySoundType) -> Bool {
        lhs.id == rhs.id
    }
}

