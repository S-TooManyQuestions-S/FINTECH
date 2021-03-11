//
//  Themes.swift
//  TinkoffChat
//
//  Created by Андрей Самаренко on 10.03.2021.
//

import UIKit

enum Theme:Int{
    case classic
    case day
    case night
    
    var getTextColor: UIColor{
        switch self {
        case .classic, .day:
            return .black
        case .night:
            return .white
        }
    }
    
    var getBackGroundColor : UIColor{
        switch self{
        case .classic:
            return .white
        case .day:
            return .lightGray
        case .night:
            return .black
        }
    }
    
    var getInputMessageColor : UIColor{
        switch self {
        case .classic:
            return UIColor(red: 223/255.0, green: 223/255.0, blue: 223/255.0, alpha:1)
        case .day:
            return UIColor(red: 234/255.0, green: 235/255.0, blue: 237/255.0, alpha:1)
        case .night:
            return UIColor(red: 46/255.0, green: 46/255.0, blue: 46/255.0, alpha:1)
        }
    }
    
    var getOutPutMessageColor : UIColor{
        switch self {
        case .classic:
            return UIColor(red: 220/255.0, green: 247/255.0, blue: 197/255.0, alpha: 1)
        case .day:
            return UIColor(red: 67/255.0, green: 137/255.0, blue: 249/255.0, alpha: 1)
        case .night:
            return UIColor(red: 92/255.0, green: 92/255.0, blue: 92/255.0, alpha: 1)
        }
    }
}
