//
//  ThemeSaveHandlerMock.swift
//  TinkoffChatTests
//
//  Created by Андрей Самаренко on 06.05.2021.
//

@testable import TinkoffChat
import Foundation

class ThemeSaveHandlerMock: ThemeSaveHandlerProtocol {
    var readCallsCount: Int = 0
    var writeCallsCount: Int = 0
    var path: String?
    var currentTheme: Theme = .classic
    var receviedThemes: [Theme] = []
    
    func readTheme(from path: String) -> Theme {
        if self.path == nil {
            self.path = path
        }
        
        readCallsCount += 1
        return self.currentTheme
    }
    
    func writeTheme(to path: String, rawTheme: Int) {
        
        receviedThemes.append(Theme(rawValue: rawTheme) ?? .classic)
        
        if self.path == nil {
            self.path = path
        }
        
        writeCallsCount += 1
        self.currentTheme = Theme(rawValue: rawTheme) ?? .classic
    }
}
