//
//  Themes.swift
//  TinkoffChat
//
//  Created by Андрей Самаренко on 10.03.2021.
//

import UIKit

enum Theme: Int {
    case classic
    case day
    case night
    
    var getTextColor: UIColor {
        switch self {
        case .classic, .day:
            return .black
        case .night:
            return .white
        }
    }
    
    var getBackGroundColor: UIColor {
        switch self {
        case .classic, .day:
            return .white
        case .night:
            return UIColor(red: 30 / 255.0, green: 31 / 255.0, blue: 32 / 255.0, alpha: 1)
        }
    }
    
    var getNavigationBarColor: UIColor {
        switch self {
        case .night:
            return UIColor(red: 47 / 255.0, green: 47 / 255.0, blue: 48 / 255.0, alpha: 1)
        case .classic, .day:
            return UIColor(red: 245 / 255.0, green: 245 / 255.0, blue: 245 / 255.0, alpha: 1)
        }
    }
    
    var getMessageTextColor: UIColor {
        switch self {
        case .day, .classic:
            return UIColor(red: 60 / 255.0, green: 60 / 255.0, blue: 67 / 255.0, alpha: 1)
        case .night:
            return UIColor(red: 141 / 255.0, green: 141 / 255.0, blue: 147 / 255.0, alpha: 1)
        }
    }
    
    var getInputMessageColor: UIColor {
        switch self {
        case .classic:
            return UIColor(red: 223 / 255.0, green: 223 / 255.0, blue: 223 / 255.0, alpha: 1)
        case .day:
            return UIColor(red: 234 / 255.0, green: 235 / 255.0, blue: 237 / 255.0, alpha: 1)
        case .night:
            return UIColor(red: 46 / 255.0, green: 46 / 255.0, blue: 46 / 255.0, alpha: 1)
        }
    }
    
    var getInputMessageTextColor: UIColor {
        switch self {
        case .classic, .day:
            return .black
        case .night:
            return .white
        }
    }
    
    var getOutputMessageTextColor: UIColor {
        switch  self {
        case .classic:
            return .black
        case .night, .day:
            return .white
        }
    }
    
    var getOutPutMessageColor: UIColor {
        switch self {
        case .classic:
            return UIColor(red: 220 / 255.0, green: 247 / 255.0, blue: 197 / 255.0, alpha: 1)
        case .day:
            return UIColor(red: 67 / 255.0, green: 137 / 255.0, blue: 249 / 255.0, alpha: 1)
        case .night:
            return UIColor(red: 92 / 255.0, green: 92 / 255.0, blue: 92 / 255.0, alpha: 1)
        }
    }
}
