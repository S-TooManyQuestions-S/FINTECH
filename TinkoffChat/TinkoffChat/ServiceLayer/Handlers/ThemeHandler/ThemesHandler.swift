//
//  ThemesHandler.swift
//  TinkoffChat
//
//  Created by Андрей Самаренко on 10.03.2021.
//

import UIKit

class ThemesHandler: ThemesHandlerProtocol {
    private let selectedThemeKey = "selectedThemeKey"
    private var currentTheme: Theme?
    
    private var themeSaveHandler: ThemeSaveHandlerProtocol?
    init(themeSaveHandler: ThemeSaveHandlerProtocol) {
        self.themeSaveHandler = themeSaveHandler
    }
    
    private func loadTheme() {
//        if let storedTheme = UserDefaults.standard.value(forKey: selectedThemeKey) as? Int{
//            return Theme(rawValue: storedTheme) ?? .classic
//      } else {
//        return .classic
//      }
        currentTheme = self.themeSaveHandler?.readTheme(from: selectedThemeKey + ".txt")
    }
    
    func applyTheme(theme: Theme) {
//        UserDefaults.standard.setValue(theme.rawValue, forKey: selectedThemeKey)
//        UserDefaults.standard.synchronize()
        currentTheme = theme
        self.themeSaveHandler?.writeTheme(to: selectedThemeKey + ".txt", rawTheme: theme.rawValue)
    }
    
    func getTheme() -> Theme {
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
