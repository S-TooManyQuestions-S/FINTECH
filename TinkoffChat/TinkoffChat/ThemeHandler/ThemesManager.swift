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
        guard let storedThemeID = UserDefaults.standard.value(forKey: selectedThemeKey) as? Int,
              let theme = Theme(rawValue: storedThemeID)
        else { return .classic }
         
        return theme
    }
    
    static func applyTheme(theme: Theme) {
        UserDefaults.standard.setValue(theme.rawValue, forKey: selectedThemeKey)
        UserDefaults.standard.synchronize()
    }
}
