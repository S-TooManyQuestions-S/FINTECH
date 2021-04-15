//
//  ThemesHandler.swift
//  TinkoffChat
//
//  Created by Андрей Самаренко on 10.03.2021.
//

import UIKit

struct ThemesHandler: ThemesHandlerProtocol {
    private let selectedThemeKey = "selectedThemeKey"
    private static var currentTheme: Theme?
    
    private func loadTheme() {
//        if let storedTheme = UserDefaults.standard.value(forKey: selectedThemeKey) as? Int{
//            return Theme(rawValue: storedTheme) ?? .classic
//      } else {
//        return .classic
//      }
        ThemesHandler.currentTheme = RootAssembly.coreLayerAssembly.themeSaveHandler.readTheme(from: selectedThemeKey + ".txt")
    }
    
    func applyTheme(theme: Theme) {
//        UserDefaults.standard.setValue(theme.rawValue, forKey: selectedThemeKey)
//        UserDefaults.standard.synchronize()
        ThemesHandler.currentTheme = theme
        RootAssembly.coreLayerAssembly.themeSaveHandler.writeTheme(to: selectedThemeKey + ".txt", rawTheme: theme.rawValue)
    }
    
    func getTheme() -> Theme {
        if let theme = ThemesHandler.currentTheme {
            return theme
        }
        
        loadTheme()
        
        guard let probablyLoadedTheme = ThemesHandler.currentTheme else {
            return .classic
        }
        return probablyLoadedTheme
    }
}
