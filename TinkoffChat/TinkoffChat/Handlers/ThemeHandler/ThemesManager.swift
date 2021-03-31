//
//  ThemesHandler.swift
//  TinkoffChat
//
//  Created by Андрей Самаренко on 10.03.2021.
//

import UIKit

struct ThemesManager {
    static let selectedThemeKey = "selectedThemeKey"
    static let saveHandler = GCDSaveHandler()
    static var currentTheme: Theme?
    
    private static func loadTheme() {
//        if let storedTheme = UserDefaults.standard.value(forKey: selectedThemeKey) as? Int{
//            return Theme(rawValue: storedTheme) ?? .classic
//      } else {
//        return .classic
//      }
        currentTheme = saveHandler.readTheme(from: selectedThemeKey + ".txt")
    }
    
    static func applyTheme(theme: Theme) {
//        UserDefaults.standard.setValue(theme.rawValue, forKey: selectedThemeKey)
//        UserDefaults.standard.synchronize()
        currentTheme = theme
        saveHandler.writeTheme(to: selectedThemeKey + ".txt", rawTheme: theme.rawValue)
    }
    
    static func getTheme() -> Theme {
        if let theme = currentTheme {
            return theme
        }
        
        loadTheme()
        
        guard let probablyLoadedTheme = currentTheme else {
            return .classic
        }
        return probablyLoadedTheme
    }
}
