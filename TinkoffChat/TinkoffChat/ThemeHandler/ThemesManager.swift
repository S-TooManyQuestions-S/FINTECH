//
//  ThemesHandler.swift
//  TinkoffChat
//
//  Created by Андрей Самаренко on 10.03.2021.
//

import UIKit

struct ThemesManager{
    static let selectedThemeKey = "selectedThemeKey"
    
    static func currentTheme() -> Theme {
        if let storedTheme = UserDefaults.standard.value(forKey: selectedThemeKey) as? Int{
            return Theme(rawValue: storedTheme) ?? .classic
      } else {
        return .classic
      }
    }
    
    static func applyTheme(theme: Theme) {
        UserDefaults.standard.setValue(theme.rawValue, forKey: selectedThemeKey)
        UserDefaults.standard.synchronize()
    }
}
